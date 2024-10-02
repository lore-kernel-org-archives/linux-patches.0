Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344701D0F55;
	Wed,  2 Oct 2024 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879247; cv=none; b=PF2eAQwPrrGyQl8tnu1Wfo09pFGBXNJnNvbkfUnz3wzRwDJ1gU56nNTxd1WKImc1JDtM7eH2Cf5+VICoElplmRee8zVMVFLAVsl6ixfjjua02bcaxiZl9EfXTqrgWVHZQSMrOB3yeC9hn+I2zBcGoc6PwS43hegdjMSKnUKs5/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879247; c=relaxed/simple;
	bh=Hp5sbPYAO02Iom9S98S9RSuIROo2q3yJARGD8klVjAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XENkfY8ZPKJIAALc7DCXV1sRan0UcRRiAqvqD74ltnYxTUpdzPFcMKQDaN0W51DgHcgdqxlPEkTiB6OrGXAS1lGOGvzqIJhlg2pOtoU1D8n4pGx9YCQYQuRMJSv3WGro2xGGdVXxH0ZCMliK6YKo/HSeLgFQTYJwLa4CND/0YeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A74iBM5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A74iBM5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2230C4CEC2;
	Wed,  2 Oct 2024 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879247;
	bh=Hp5sbPYAO02Iom9S98S9RSuIROo2q3yJARGD8klVjAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A74iBM5B8UdR7RASplbIOmF+BatR7v9SlRlwtVGL0ie+md/XNrPyvq+DomquRQYlG
	 nc8bkeJK0nNx91T4Rn+zM87s5FSqQWl9mqtRs3x8+9Ix+ZtDmaRMmHiDe1cxbdrHor
	 S5KGDeYFl1DOgEHfSONuZVbLZjrTJ6HlhRly0YWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/538] crypto: hisilicon/qm - inject error before stopping queue
Date: Wed,  2 Oct 2024 14:54:52 +0200
Message-ID: <20241002125754.294239674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit b04f06fc0243600665b3b50253869533b7938468 ]

The master ooo cannot be completely closed when the
accelerator core reports memory error. Therefore, the driver
needs to inject the qm error to close the master ooo. Currently,
the qm error is injected after stopping queue, memory may be
released immediately after stopping queue, causing the device to
access the released memory. Therefore, error is injected to close master
ooo before stopping queue to ensure that the device does not access
the released memory.

Fixes: 6c6dd5802c2d ("crypto: hisilicon/qm - add controller reset interface")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 47 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2a6ea3815cfb7..1b00edbbfe26a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4106,6 +4106,28 @@ static int qm_set_vf_mse(struct hisi_qm *qm, bool set)
 	return -ETIMEDOUT;
 }
 
+static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
+{
+	u32 nfe_enb = 0;
+
+	/* Kunpeng930 hardware automatically close master ooo when NFE occurs */
+	if (qm->ver >= QM_HW_V3)
+		return;
+
+	if (!qm->err_status.is_dev_ecc_mbit &&
+	    qm->err_status.is_qm_ecc_mbit &&
+	    qm->err_ini->close_axi_master_ooo) {
+		qm->err_ini->close_axi_master_ooo(qm);
+	} else if (qm->err_status.is_dev_ecc_mbit &&
+		   !qm->err_status.is_qm_ecc_mbit &&
+		   !qm->err_ini->close_axi_master_ooo) {
+		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
+		       qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
+	}
+}
+
 static int qm_vf_reset_prepare(struct hisi_qm *qm,
 			       enum qm_stop_reason stop_reason)
 {
@@ -4170,6 +4192,8 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
+	qm_dev_ecc_mbit_handle(qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	qm_cmd_uninit(qm);
 
@@ -4216,28 +4240,6 @@ static int qm_master_ooo_check(struct hisi_qm *qm)
 	return ret;
 }
 
-static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
-{
-	u32 nfe_enb = 0;
-
-	/* Kunpeng930 hardware automatically close master ooo when NFE occurs */
-	if (qm->ver >= QM_HW_V3)
-		return;
-
-	if (!qm->err_status.is_dev_ecc_mbit &&
-	    qm->err_status.is_qm_ecc_mbit &&
-	    qm->err_ini->close_axi_master_ooo) {
-		qm->err_ini->close_axi_master_ooo(qm);
-	} else if (qm->err_status.is_dev_ecc_mbit &&
-		   !qm->err_status.is_qm_ecc_mbit &&
-		   !qm->err_ini->close_axi_master_ooo) {
-		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
-		       qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
-	}
-}
-
 static int qm_soft_reset_prepare(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -4262,7 +4264,6 @@ static int qm_soft_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
-	qm_dev_ecc_mbit_handle(qm);
 	ret = qm_master_ooo_check(qm);
 	if (ret)
 		return ret;
-- 
2.43.0



