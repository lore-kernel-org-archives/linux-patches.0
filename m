Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0F1F76C3;
	Tue,  3 Dec 2024 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239364; cv=none; b=sqqLddWUyh+B8VZY/94ZL/VseOzJ3+Az2TF1gu1D5WHODRBxF4pgwbKByW/CUcnD7nrVhDM2Tyvo29RxAvBeWztjuMsYcvedYk+r0u6BNm5gi6lf4xLtVdeUQdZ6tYJJwhBYBWtB4U70seRcUUx6K0smTfTS2AijhMgihQ9Proc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239364; c=relaxed/simple;
	bh=oXz2z6kHde0i2dqXrYN+2XTX+i3Naqajqlhe67oALLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Prp9Lo2qjkZScNdzMzwQkE6wm5J1v6uCnotAL89xYEJSBSj8GfWJ9sLg/istwNcPB8dq/oUuUolqpVJRjosqWnv/fCGGythZMy7C/YCGKPUSsUMDLrM8oIl4iu9ITbVIUyPXHJmk+ZG6HWtdFCOtLqIuHNWk5ospR05yZfbUg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtMgupua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtMgupua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9891C4CED6;
	Tue,  3 Dec 2024 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239364;
	bh=oXz2z6kHde0i2dqXrYN+2XTX+i3Naqajqlhe67oALLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtMgupuaEGMQP7entkcRuL7Pi/iAhFfhj5kj6N5d6CnsVI6VKnI/tg5FNJuUBZXly
	 +OMVw8TDgNfTI67dLxx9Ir9GXKh/jWEyjQ1F2gXaW7YM8ZTNvumnuXbZDix8r70y+G
	 iRjVeVBOcAkZoFBIsF9musitfqkDHyE6VL9wFMoI=
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
Subject: [PATCH 6.11 589/817] bnxt_en: Unregister PTP during PCI shutdown and suspend
Date: Tue,  3 Dec 2024 15:42:41 +0100
Message-ID: <20241203144018.915926727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f999c10cefac6..68e6e202d4ecd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15933,6 +15933,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
+	bnxt_ptp_clear(bp);
 	bnxt_clear_int_mode(bp);
 	pci_disable_device(pdev);
 
@@ -15960,6 +15961,7 @@ static int bnxt_suspend(struct device *device)
 		rc = bnxt_close(dev);
 	}
 	bnxt_hwrm_func_drv_unrgtr(bp);
+	bnxt_ptp_clear(bp);
 	pci_disable_device(bp->pdev);
 	bnxt_free_ctx_mem(bp);
 	rtnl_unlock();
@@ -16001,6 +16003,10 @@ static int bnxt_resume(struct device *device)
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



