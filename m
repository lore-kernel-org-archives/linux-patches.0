Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E14138C433;
	Mon, 17 Aug 2026 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974741; cv=none; b=lR3Rz/10WdSG+HAGzcCk1tVsrNkZBRwG+WlJRDs1v5mw84SOoK95ihg3g+qUUOv2Arp0bA7kTywglj43h4gEJoBcLfzMmzqB8mu9sYmyPII5Q6sNzr52GYuCPly3UBvMpcQvq473stIXcWEgSOeFQjrQ00XP3MPPfpIjG43eM5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974741; c=relaxed/simple;
	bh=5xbDP3HdnVMRGO3fhfgC8sQU67ax82/FHI8Z8jEswpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A87fsxwGkNk7bwzawf20qe1aEDfyMqjI58pCaeyjzhnz6MNmnDObXLkNC7EbEwZhV/IKjh6pJtDEDYbMQpz24erpECSC8RzV7TPINhGdfVljUNOwAs3pZbMK0C4Swg1MdxojM6Fxl3+I/t8+yn+cM5Bt+8OuRxUEnEWqWC1YjRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWgBRWzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWgBRWzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195951F00A3D;
	Mon, 17 Aug 2026 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974732;
	bh=zgeZfl925sddHAHtSED4Wz+zk/4DrMRN9cTaP7R+Qng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWgBRWzirWBAHnNHuiMOjGL+sInyFQKv99qoS2Pl8LaEe2nO88JmJgCaD3lu7Cyqp
	 VJ0IDsQP7hTLrwf8xIVRhNepfBnlZwl9yvzTP+rYxDnxGF62fOxpCPj0ENh7jcBwff
	 Mlxnnca+Vfg68gwuO/9543GVRzRN4iz1RzH+fUd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/250] pds_core: keep the health thread stopped during reset
Date: Mon, 17 Aug 2026 15:29:57 +0200
Message-ID: <20260817132537.931755505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0b53a1fab46d0..e2a86ef581dfc 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -171,6 +171,7 @@ struct pdsc {
 	struct timer_list wdtimer;
 	unsigned int wdtimer_period;
 	struct work_struct health_work;
+	bool health_stopped;
 	struct devlink_health_reporter *fw_reporter;
 	u32 fw_recoveries;
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index a4962dba3140b..dad7fd03287db 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -471,8 +471,10 @@ static void pdsc_stop_health_thread(struct pdsc *pdsc)
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
@@ -480,6 +482,10 @@ static void pdsc_restart_health_thread(struct pdsc *pdsc)
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



