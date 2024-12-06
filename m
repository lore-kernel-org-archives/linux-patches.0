Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B24F2066EE;
	Fri,  6 Dec 2024 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497977; cv=none; b=XyCbmUm9FhxjgSHu1INAtBYZ8/kVgr4zyrfS+n5YxgVWSdyGV6HdRY2/+5BPieXYKsB/VPAP8dF0W01I1tip6naVAcJPagwo0A39FTl4t2XpsnI6+jrP5MQLO0gZK3FS+/GBUDFa0tZbqNr8XI7BzKzfHDAVMLUff+b+4AhJTJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497977; c=relaxed/simple;
	bh=uGPkrlajw+VtYhVWahBC0EXFMZEETtOq8dQP15+0wx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYlDgk9qRVWF00K+EcW8AcYD+nr1I65m8aKaGrImzcLR1WiyJN6Grhyp6dA9vS0VEgha47KeHgVQxyh8EgbH42bMVs5T+7GtRA16WeY2xsqSaXteMFf0kERJ/Ixl3rKBR/C62ouMnozsKYkQ0i6Wwu7LESxwrulmSiNYuw4IPqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5Z9/pLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5Z9/pLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8647C4CED1;
	Fri,  6 Dec 2024 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497977;
	bh=uGPkrlajw+VtYhVWahBC0EXFMZEETtOq8dQP15+0wx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5Z9/pLXZzgDokq4TS3O4fbej8M0nVCsE86odmlimt+1+C30OLzyQfDRM8MswGvOE
	 3ZV3Q69XUCd4OcMWmdId+CLD3mt4t6P/uWN87UpSt1VhhUtu8urjvx8z5xB4LXrqSt
	 ip0pT2eeZSy5II7I7O4hrwLblRVSFclawmq/w/1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 418/676] bnxt_en: Unregister PTP during PCI shutdown and suspend
Date: Fri,  6 Dec 2024 15:33:57 +0100
Message-ID: <20241206143709.676566794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3661c05c54e8db7064aa96a0774654740974dffc ]

If we go through the PCI shutdown or suspend path, we shutdown the
NIC but PTP remains registered.  If the kernel continues to run for
a little bit, the periodic PTP .do_aux_work() function may be called
and it will read the PHC from the BAR register.  Since the device
has already been disabled, it will cause a PCIe completion timeout.
Fix it by calling bnxt_ptp_clear() in the PCI shutdown/suspend
handlers.  bnxt_ptp_clear() will unregister from PTP and
.do_aux_work() will be canceled.

In bnxt_resume(), we need to re-initialize PTP.

Fixes: a521c8a01d26 ("bnxt_en: Move bnxt_ptp_init() from bnxt_open() back to bnxt_init_one()")
Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c216d95809282..c440f4d8d43a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13857,6 +13857,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
+	bnxt_ptp_clear(bp);
 	bnxt_clear_int_mode(bp);
 	pci_disable_device(pdev);
 
@@ -13883,6 +13884,7 @@ static int bnxt_suspend(struct device *device)
 		rc = bnxt_close(dev);
 	}
 	bnxt_hwrm_func_drv_unrgtr(bp);
+	bnxt_ptp_clear(bp);
 	pci_disable_device(bp->pdev);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
@@ -13926,6 +13928,10 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 
+	if (bnxt_ptp_init(bp)) {
+		kfree(bp->ptp_cfg);
+		bp->ptp_cfg = NULL;
+	}
 	bnxt_get_wol_settings(bp);
 	if (netif_running(dev)) {
 		rc = bnxt_open(dev);
-- 
2.43.0



