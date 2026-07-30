Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA974499B3;
	Thu, 30 Jul 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427426; cv=none; b=qNy9gRSvOcYijB2G6p6sdS4oQ/ozHaweDo+dS6tZv5/e1CSpzwkLLjSJggIOR511R4rWCV2bTy9xmQpXE5/4QPmIxEK7x1fZMuV6lw8Cur2z1RdvvopCsdPtVp3QTdpar23vBpGzdbIJPcHIRyqr8JKfe5pi4xH16FhKR6JjvCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427426; c=relaxed/simple;
	bh=yNy1fUsYH3vqPtxTiRihhmzYjmn8fez2K4X+F+kD+is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7abb0mYuM8g7UQZ/0Y0qrC23MzJLAR0HwGaHulUq1CpiV3hyfT7htTvkvuN9XO2Lj3xxjzfoUNmY4AUNKJCNonSGHFrQpOTV+kon+jO1zmyFh2UStqQBDH4y/hxucy/3RJIISat1yVHmEmQUBhgSszb1+/EWSHN+7AXS5tfiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq7x3TTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq7x3TTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C951F000E9;
	Thu, 30 Jul 2026 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427425;
	bh=KvTUgCWuBGj+7d/hik81ZB6AdXxNeimhYNqeYtMePkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kq7x3TTd2gU3Z+EttSmqQ2LLjuq/guyz5vTaCHz1EZU5P4e5x2aBR5p6+mPYhEOvc
	 Eg6ErtlwsGx7KLGSiXQF7/a1K5IhgchD5B2AIzSVSLvXK1107sGW+4tFF25OVpAxE+
	 ESgP2OC6E2/aeSo2Q3M929Kw3S1jtjYE3Da71If4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/484] pds_core: check for workqueue allocation failure
Date: Thu, 30 Jul 2026 16:11:02 +0200
Message-ID: <20260730141427.053812337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 3a660ca49e2c3807bffe0519db3cff677a5906e0 ]

pdsc_init_pf() does not check whether create_singlethread_workqueue()
succeeded.

Fail probe on failure. The workqueue is set up before the timer and
mutexes, so its failure path must unwind only the earlier setup.

Fixes: c2dbb0904310 ("pds_core: health timer and workqueue")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260629200358.2626129-1-nikhil.rao%40amd.com?part=2
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260714212713.1788438-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 76652e0e5b6d9c..93fa7dfd74cbc9 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -238,6 +238,10 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	/* General workqueue and timer, but don't start timer yet */
 	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->uid);
 	pdsc->wq = create_singlethread_workqueue(wq_name);
+	if (!pdsc->wq) {
+		err = -ENOMEM;
+		goto err_out_unmap_bars;
+	}
 	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
 	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
 	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
@@ -252,7 +256,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err) {
 		mutex_unlock(&pdsc->config_lock);
-		goto err_out_unmap_bars;
+		goto err_out_shutdown_timer;
 	}
 
 	err = pdsc_start(pdsc);
@@ -298,13 +302,14 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	pdsc_stop(pdsc);
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
-err_out_unmap_bars:
+err_out_shutdown_timer:
 	timer_shutdown_sync(&pdsc->wdtimer);
 	if (pdsc->wq)
 		destroy_workqueue(pdsc->wq);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
 	pci_free_irq_vectors(pdsc->pdev);
+err_out_unmap_bars:
 	pdsc_unmap_bars(pdsc);
 err_out_release_regions:
 	pci_release_regions(pdsc->pdev);
-- 
2.53.0



