Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AA32D3225;
	Sat, 17 Oct 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258314; cv=none; b=rGFuAZYrIbXGp6ZKFKmEtmO0iMV+C244SvLN/eWGIy+T7rWUeFlJ/mkv278A9vb34Ltne9rUVXc6QJVTaiGgzhNciKrg0AHvV4K0kmUBpbCHVg6rnPRejI2H6dTXOVbOCrI9YKXEQjENYRCsSUxdUGlsSmJzy1sfReTo3uXaqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258314; c=relaxed/simple;
	bh=3bBNzTr8lDdqTiIcSzlO626VTU2wiintuaLYs2ovTkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJBtLC3B6mpoFEi790NN/PDpm2Vlpwu06gI7iWmkT9j3BKUUkfDOz/cJSIssqsPjLg8M8b8AG23anafUQkbwn2sxGnrpGyeCrcXnphs20KWvBKpLcMhPy/7CedWLOQtLsfLJlMDb+BqGSa4rlMxPo+ZKoBIk16YhuG207GS9ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4mqOD4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4mqOD4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CBB1F000C4;
	Sat, 17 Oct 2026 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258313;
	bh=Ilv31+SHS8vWCJQwd4xQPzklsdh612+rtlaEZiCm6HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4mqOD4eHdSIKp/1wnHTYkiXmCGaulEDbf8chS8ToUAeEmObsVtymUHe0LF9t+E0m
	 noA77GP867jhj88TQen4nLQy5YM6Fw6fNWaynrVZEtO8Mh5qia+MSLwNJI/QevxTDF
	 djMfv8OEfa2RStNwLe2JHm97VRzCtNXmdylH6NoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0802/1674] crypto: hisilicon/qm - request reserved interrupt for virtual function
Date: Sat, 17 Oct 2026 17:51:14 +0200
Message-ID: <20261017160451.699250848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 9228facb308157ac0bdd264b873187896f7a9c7a ]

The device interrupt vector 3 is an error interrupt for
physical function and a reserved interrupt for virtual function.
However, the driver has not registered the reserved interrupt for
virtual function. When allocating interrupts, the number of interrupts
is allocated based on powers of two, which includes this interrupt.
When the system enables GICv4 and the virtual function passthrough
to the virtual machine, releasing the interrupt in the driver
triggers a warning.

The WARNING report is:
WARNING: CPU: 62 PID: 14889 at arch/arm64/kvm/vgic/vgic-its.c:852 its_free_ite+0x94/0xb4

Therefore, register a reserved interrupt for VF and set the
IRQF_NO_AUTOEN flag to avoid that warning.

Fixes: 3536cc55cada ("crypto: hisilicon/qm - support get device irq information from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 38 +++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c7f8745703834..b7d918b3f7cfb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4666,6 +4666,15 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_done);
 
+static irqreturn_t qm_rsvd_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = data;
+
+	dev_info(&qm->pdev->dev, "Reserved interrupt, ignore!\n");
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t qm_abnormal_irq(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
@@ -4967,7 +4976,7 @@ static void qm_unregister_abnormal_irq(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	u32 irq_vector, val;
 
-	if (qm->fun_type == QM_HW_VF)
+	if (qm->fun_type == QM_HW_VF && qm->ver < QM_HW_V3)
 		return;
 
 	val = qm->cap_tables.qm_cap_table[QM_ABN_IRQ_TYPE_CAP_IDX].cap_val;
@@ -4984,17 +4993,28 @@ static int qm_register_abnormal_irq(struct hisi_qm *qm)
 	u32 irq_vector, val;
 	int ret;
 
-	if (qm->fun_type == QM_HW_VF)
-		return 0;
-
 	val = qm->cap_tables.qm_cap_table[QM_ABN_IRQ_TYPE_CAP_IDX].cap_val;
 	if (!((val >> QM_IRQ_TYPE_SHIFT) & QM_ABN_IRQ_TYPE_MASK))
 		return 0;
-
 	irq_vector = val & QM_IRQ_VECTOR_MASK;
+
+	/* For VF, this is a reserved interrupt in V3 version. */
+	if (qm->fun_type == QM_HW_VF) {
+		if (qm->ver < QM_HW_V3)
+			return 0;
+
+		ret = request_irq(pci_irq_vector(pdev, irq_vector), qm_rsvd_irq,
+				  IRQF_NO_AUTOEN, qm->dev_name, qm);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to request reserved irq, ret = %d!\n", ret);
+			return ret;
+		}
+		return 0;
+	}
+
 	ret = request_irq(pci_irq_vector(pdev, irq_vector), qm_abnormal_irq, 0, qm->dev_name, qm);
 	if (ret)
-		dev_err(&qm->pdev->dev, "failed to request abnormal irq, ret = %d", ret);
+		dev_err(&qm->pdev->dev, "failed to request abnormal irq, ret = %d!\n", ret);
 
 	return ret;
 }
@@ -5333,6 +5353,12 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 	pci_set_master(pdev);
 
 	num_vec = qm_get_irq_num(qm);
+	if (!num_vec) {
+		dev_err(dev, "Device irq num is zero!\n");
+		ret = -EINVAL;
+		goto err_get_pci_res;
+	}
+	num_vec = roundup_pow_of_two(num_vec);
 	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
 	if (ret < 0) {
 		dev_err(dev, "Failed to enable MSI vectors!\n");
-- 
2.53.0



