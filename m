Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867D2BB18;
	Sat,  3 Feb 2024 04:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933961; cv=none; b=ldfRcacuTBINIW3nTtiCJOCu8S49ypRY2qfyfQcFx1ZiBEG/CM9iUCojQ4zd77LUTZ+SabbKb84miBbvOvAp8btrXs4YHk29/l1WFV25B4z9Qvva69fNvfnrcss0K6pjb4/mPe77sTaQ0k6IyGQjdOkxBHg6s57ARNdrmNV09oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933961; c=relaxed/simple;
	bh=v8Qbh1LSmVFogiJ05FvA/QGAwQD6zDyOVXUmAIzupSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8R+KHLoruFbqGfCcehZSzuIMIdozWxckLXHHRvXuE1kYNNevWSs5MBy/xLL1A+7a+DKb5oibPg5ye+N0CqAGQ+cftE72OoadoqBF8nqtIbTkcrMx2hkDc+q2jxT6lR0R3EA9HrnaeKqtRY1XLlqVXoaQzSrfxMxaxHsGa1y5hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyZJco0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyZJco0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D62C43394;
	Sat,  3 Feb 2024 04:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933961;
	bh=v8Qbh1LSmVFogiJ05FvA/QGAwQD6zDyOVXUmAIzupSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyZJco0rVugjCYV9IGQdNN9Vm2JPLg3SJg7+npgGC8tkg3mjaEIhcQK3oqZt33JPr
	 97K5rV75T9D2XpotZVnQ0X8Owr+gVc6NLU2hRi35hMsesH/jbcGklHxd1NN8CRGyI3
	 SlqvrbobmR3hpNZ0UrNDxI2DupHqVzemYKW7jWd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 331/353] pds_core: Prevent health thread from running during reset/remove
Date: Fri,  2 Feb 2024 20:07:29 -0800
Message-ID: <20240203035414.263629164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit d9407ff11809c6812bb84fe7be9c1367d758e5c8 ]

The PCIe reset handlers can run at the same time as the
health thread. This can cause the health thread to
stomp on the PCIe reset. Fix this by preventing the
health thread from running while a PCIe reset is happening.

As part of this use timer_shutdown_sync() during reset and
remove to make sure the timer doesn't ever get rearmed.

Fixes: ffa55858330f ("pds_core: implement pci reset handlers")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240129234035.69802-2-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 3080898d7b95..5172a5ad8ec6 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -293,7 +293,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
-	del_timer_sync(&pdsc->wdtimer);
+	timer_shutdown_sync(&pdsc->wdtimer);
 	if (pdsc->wq)
 		destroy_workqueue(pdsc->wq);
 	mutex_destroy(&pdsc->config_lock);
@@ -420,7 +420,7 @@ static void pdsc_remove(struct pci_dev *pdev)
 		 */
 		pdsc_sriov_configure(pdev, 0);
 
-		del_timer_sync(&pdsc->wdtimer);
+		timer_shutdown_sync(&pdsc->wdtimer);
 		if (pdsc->wq)
 			destroy_workqueue(pdsc->wq);
 
@@ -445,10 +445,24 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devlink_free(dl);
 }
 
+static void pdsc_stop_health_thread(struct pdsc *pdsc)
+{
+	timer_shutdown_sync(&pdsc->wdtimer);
+	if (pdsc->health_work.func)
+		cancel_work_sync(&pdsc->health_work);
+}
+
+static void pdsc_restart_health_thread(struct pdsc *pdsc)
+{
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	mod_timer(&pdsc->wdtimer, jiffies + 1);
+}
+
 void pdsc_reset_prepare(struct pci_dev *pdev)
 {
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 
+	pdsc_stop_health_thread(pdsc);
 	pdsc_fw_down(pdsc);
 
 	pci_free_irq_vectors(pdev);
@@ -486,6 +500,7 @@ void pdsc_reset_done(struct pci_dev *pdev)
 	}
 
 	pdsc_fw_up(pdsc);
+	pdsc_restart_health_thread(pdsc);
 }
 
 static const struct pci_error_handlers pdsc_err_handler = {
-- 
2.43.0



