Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBBD341653;
	Tue, 26 Aug 2025 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208013; cv=none; b=BMllb2KdpN2KC79mo8Fe+iikSHLy0bK1TuOVzXDgBH6DDxWBluf9pwAaeM7DCEaDAUpPYwF0ge4KFroC75IQLm5ANwbr0Epq83PH643/gwPEMy6+kKQvVIqljbo8NsRrDOBXzfKH9lnbj9faypleuJSC86wyvp8dCYqDX9Fy260=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208013; c=relaxed/simple;
	bh=uJC0/8nm8gECnu5VgCRXG1dLn7sg6ZQdt5M0OYabdns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBkd2lWa5ozB4peyM3FAdIVJjZeUOmf41o2JuE7nKEW9C86VCnr5hsSd94MA4VkdqHT7nltyQwBWTyJ0ByO1e+eKYr0SUw8tHXQnflBUJX4mFK8SEB1FubfLM5Rp0gRIQA0gzWwYd7jqse4j7GsqCsiLuFEm1d+GuR7ISPCJrbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXJqZt5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXJqZt5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6BDC4CEF1;
	Tue, 26 Aug 2025 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208013;
	bh=uJC0/8nm8gECnu5VgCRXG1dLn7sg6ZQdt5M0OYabdns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXJqZt5JTx+YfxSSkhpP8BZMXwJzu5EuyHlgheckncq40ShWAJu07xyL8t3fntdUE
	 43SbPNP7hWxeAIfkASUjmL4A2DUVCDUTJeMho0mvHBf77aFV84/4T8kIWmJ3I7y3XP
	 7a4JFawylkn0CqXH2/Nv7abpkgOlt11461doUCTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 404/457] scsi: ufs: ufs-qcom: Fix ESI null pointer dereference
Date: Tue, 26 Aug 2025 13:11:28 +0200
Message-ID: <20250826110947.278931100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Rawat <quic_nitirawa@quicinc.com>

[ Upstream commit 6300d5c5438724c0876828da2f6e2c1a661871fc ]

ESI/MSI is a performance optimization feature that provides dedicated
interrupts per MCQ hardware queue. This is optional feature and UFS MCQ
should work with and without ESI feature.

Commit e46a28cea29a ("scsi: ufs: qcom: Remove the MSI descriptor abuse")
brings a regression in ESI (Enhanced System Interrupt) configuration that
causes a null pointer dereference when Platform MSI allocation fails.

The issue occurs in when platform_device_msi_init_and_alloc_irqs() in
ufs_qcom_config_esi() fails (returns -EINVAL) but the current code uses
__free() macro for automatic cleanup free MSI resources that were never
successfully allocated.

Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000008

  Call trace:
  mutex_lock+0xc/0x54 (P)
  platform_device_msi_free_irqs_all+0x1c/0x40
  ufs_qcom_config_esi+0x1d0/0x220 [ufs_qcom]
  ufshcd_config_mcq+0x28/0x104
  ufshcd_init+0xa3c/0xf40
  ufshcd_pltfrm_init+0x504/0x7d4
  ufs_qcom_probe+0x20/0x58 [ufs_qcom]

Fix by restructuring the ESI configuration to try MSI allocation first,
before any other resource allocation and instead use explicit cleanup
instead of __free() macro to avoid cleanup of unallocated resources.

Tested on SM8750 platform with MCQ enabled, both with and without
Platform ESI support.

Fixes: e46a28cea29a ("scsi: ufs: qcom: Remove the MSI descriptor abuse")
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Link: https://lore.kernel.org/r/20250811073330.20230-1-quic_nitirawa@quicinc.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 39 ++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 53301a2c27be..2e4edc192e8e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2053,17 +2053,6 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void ufs_qcom_irq_free(struct ufs_qcom_irq *uqi)
-{
-	for (struct ufs_qcom_irq *q = uqi; q->irq; q++)
-		devm_free_irq(q->hba->dev, q->irq, q->hba);
-
-	platform_device_msi_free_irqs_all(uqi->hba->dev);
-	devm_kfree(uqi->hba->dev, uqi);
-}
-
-DEFINE_FREE(ufs_qcom_irq, struct ufs_qcom_irq *, if (_T) ufs_qcom_irq_free(_T))
-
 static int ufs_qcom_config_esi(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
@@ -2078,18 +2067,18 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	 */
 	nr_irqs = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
 
-	struct ufs_qcom_irq *qi __free(ufs_qcom_irq) =
-		devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
-	if (!qi)
-		return -ENOMEM;
-	/* Preset so __free() has a pointer to hba in all error paths */
-	qi[0].hba = hba;
-
 	ret = platform_device_msi_init_and_alloc_irqs(hba->dev, nr_irqs,
 						      ufs_qcom_write_msi_msg);
 	if (ret) {
-		dev_err(hba->dev, "Failed to request Platform MSI %d\n", ret);
-		return ret;
+		dev_warn(hba->dev, "Platform MSI not supported or failed, continuing without ESI\n");
+		return ret; /* Continue without ESI */
+	}
+
+	struct ufs_qcom_irq *qi = devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
+
+	if (!qi) {
+		platform_device_msi_free_irqs_all(hba->dev);
+		return -ENOMEM;
 	}
 
 	for (int idx = 0; idx < nr_irqs; idx++) {
@@ -2100,15 +2089,17 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		ret = devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handler,
 				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
 		if (ret) {
-			dev_err(hba->dev, "%s: Fail to request IRQ for %d, err = %d\n",
+			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err = %d\n",
 				__func__, qi[idx].irq, ret);
-			qi[idx].irq = 0;
+			/* Free previously allocated IRQs */
+			for (int j = 0; j < idx; j++)
+				devm_free_irq(hba->dev, qi[j].irq, qi + j);
+			platform_device_msi_free_irqs_all(hba->dev);
+			devm_kfree(hba->dev, qi);
 			return ret;
 		}
 	}
 
-	retain_and_null_ptr(qi);
-
 	if (host->hw_ver.major >= 6) {
 		ufshcd_rmwl(hba, ESI_VEC_MASK, FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1),
 			    REG_UFS_CFG3);
-- 
2.50.1



