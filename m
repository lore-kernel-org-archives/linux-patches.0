Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D744446E4;
	Thu, 30 Jul 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424011; cv=none; b=aoxOOPMgch4aBrBGNchvSwy//GTCC18qAtb1P3xuUwhBo8IWSt4ZQjZ+z/STspnwwmD5dWTxj0TwCMUU6Paq89OjxMHKvvtCrZA/Ql90vUT9faVmPjfOHmRFXK1yr25Ndc2o/JFh8LI2HxQQQiQF1LD5YdFTAJaiCCTaF/N3nBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424011; c=relaxed/simple;
	bh=x5mAcehrSMKl/W0XJ8bYXXH+GmfbzEOf9+/GFkQuHi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbcwFGey2d3qtX0C852NHsipOp10UKiwwb61u2Ma4IrFXaNCWh4CfFcVpsF1ZlS57D9vzJ7xI9uMMLi97F4Jr1rTFOLFJSurAvRDOY6LEjvDlMOeNOroA2Njz5dWxrzrejemhXhqlLLst6TVR83nACqi9BCtTsEj0KCy67u2uho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCCKipWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCCKipWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C9C1F000E9;
	Thu, 30 Jul 2026 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424010;
	bh=Av5UmssyAVKkTYfXjwF5IObFKgY7YRteRR1xvAJz4io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCCKipWaqRkxgXG0lsKuka8dgLgjPqBU2BkMGQ8aF/NfXkzBveNlLoMT4O/4BR052
	 Hti4+ThnqX2n6szUw5UeqjEtA2ASjgSBs+KQzP9+srZaKoyxRKwmExEEwFwbsUIQgS
	 tZW4tqGdtYkHBdwxhU5w1o/2uSWM9/u4m2glLXro=
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
Subject: [PATCH 6.18 244/675] pds_core: check for workqueue allocation failure
Date: Thu, 30 Jul 2026 16:09:34 +0200
Message-ID: <20260730141450.321701206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index accf3a3fe94457..a4962dba3140b8 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -239,6 +239,10 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	/* General workqueue and timer, but don't start timer yet */
 	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->uid);
 	pdsc->wq = create_singlethread_workqueue(wq_name);
+	if (!pdsc->wq) {
+		err = -ENOMEM;
+		goto err_out_unmap_bars;
+	}
 	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
 	INIT_WORK(&pdsc->pci_reset_work, pdsc_pci_reset_thread);
 	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
@@ -254,7 +258,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err) {
 		mutex_unlock(&pdsc->config_lock);
-		goto err_out_unmap_bars;
+		goto err_out_shutdown_timer;
 	}
 
 	err = pdsc_start(pdsc);
@@ -306,13 +310,14 @@ static int pdsc_init_pf(struct pdsc *pdsc)
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



