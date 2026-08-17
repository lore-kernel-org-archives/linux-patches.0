Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE723C51D;
	Mon, 17 Aug 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977852; cv=none; b=Ha1YNcK923lISMikcnhNmb2SznTx9KXRqvtYArjiAVitFibVrL8gr2qtk64Dopm0A0cQNmzaVDBEjdNrUAmJYq9613TCiiC77WKV9sYMBdcHJHxpdyKjTY306kyZB0E7vE/z+qWTm2NwOZWMYYeWFBIIYyvlF8dtY21KlwzkJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977852; c=relaxed/simple;
	bh=9VWEeuTn/E9wpXa2coFnoIVLfDtJMh6MFz+Y1NE7Txo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsWS8ZU6I2IoIcT6Vn2sKgULg3XebV5rwz9RUX4W9qtviXqIYB3GSQv2cHIWOix+rYgWVqhK6zMyxESuBs1Vllk+u0z2RoR5FEe04JgJJ5G4CQQKRjbC2vS+3uUOs7y4aUFHhfUZSTsILPYsmsXfsmfqy8ZG/nhnjtuUoKO8th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+Ej6zKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+Ej6zKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647A91F000E9;
	Mon, 17 Aug 2026 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977850;
	bh=bunb6+USfB8E91zt+0kYK3UOTfKifoJ6S41YPAdhziI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+Ej6zKv3O40IJy8COacg3twFZlbR0ocekApIgqdDwSBMOyvHTlnUjcByPIczSoHs
	 4R4ULoV4HA7ddm5n7oabGUaqNB9g4WePFprlSG2GRT8u/E2Vy9RtgufV8rWpvbNs6U
	 ck0u5QkhEamli+etn618rcxOnlROM8Us8I06sVxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/181] pds_core: keep the health thread stopped during reset
Date: Mon, 17 Aug 2026 15:31:50 +0200
Message-ID: <20260817132536.033031207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit cd09971dcc1c499ae0879010a00e9dba87abdc4f ]

Commit d9407ff11809 ("pds_core: Prevent health thread from running
during reset/remove") stops the health thread with cancel_work_sync()
before a reset, but a devcmd timeout during pdsc_fw_down() re-queues
health_work, so pdsc_health_thread() runs again mid-reset and double
allocates the core DMA queues via pdsc_fw_up().

Only the reset path is affected: on remove PDSC_S_STOPPING_DRIVER gates
the health thread and the workqueue is destroyed.

Use disable_work_sync() to cancel health_work and block further
queue_work() on it, and enable_work() in pdsc_restart_health_thread() to
re-allow it after the reset.

disable_work_sync() keeps a disable depth, so every disable must be
matched by one enable. pdsc_reset_prepare() stops the health thread and
pdsc_reset_done() restarts it. On the AER path pdsc_pci_error_detected()
calls pdsc_reset_prepare(), then pdsc_pci_error_resume() re-inits via
pci_reset_function_locked() (pds_core has no .slot_reset handler), which
runs the pair again - stopping the thread twice but restarting it once.
Gate the disable and enable on a health_stopped flag so each fires at
most once per stopped/running transition.

Fixes: d9407ff11809 ("pds_core: Prevent health thread from running during reset/remove")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260629200358.2626129-1-nikhil.rao%40amd.com?part=2
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260727164548.359562-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.h |  1 +
 drivers/net/ethernet/amd/pds_core/main.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index becd3104473c2..4dbfe2373b3ac 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -170,6 +170,7 @@ struct pdsc {
 	struct timer_list wdtimer;
 	unsigned int wdtimer_period;
 	struct work_struct health_work;
+	bool health_stopped;
 	struct devlink_health_reporter *fw_reporter;
 	u32 fw_recoveries;
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index c78b17d230a84..2329396ec3e25 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -464,8 +464,10 @@ static void pdsc_stop_health_thread(struct pdsc *pdsc)
 		return;
 
 	timer_shutdown_sync(&pdsc->wdtimer);
-	if (pdsc->health_work.func)
-		cancel_work_sync(&pdsc->health_work);
+	if (pdsc->health_work.func && !pdsc->health_stopped) {
+		disable_work_sync(&pdsc->health_work);
+		pdsc->health_stopped = true;
+	}
 }
 
 static void pdsc_restart_health_thread(struct pdsc *pdsc)
@@ -473,6 +475,10 @@ static void pdsc_restart_health_thread(struct pdsc *pdsc)
 	if (pdsc->pdev->is_virtfn)
 		return;
 
+	if (pdsc->health_stopped) {
+		enable_work(&pdsc->health_work);
+		pdsc->health_stopped = false;
+	}
 	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
 	mod_timer(&pdsc->wdtimer, jiffies + 1);
 }
-- 
2.53.0



