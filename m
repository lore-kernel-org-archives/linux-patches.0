Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6B125EFB6;
	Tue, 11 Mar 2025 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707636; cv=none; b=jdFzQmnkOw3F8tPcaxr8xSugHw9GvvgtcqJElcA7PEC7xfEIPfdDT8Ricp5GT86hOIVjkO1xK9b1GG9QnVn4zZXCxvcyJFyUYoVftv2BLUVsIz7vRUITqohYUZcUfDZJY7Sb60+gmNDrdCiTIzg4W4Ly0ONpmDKcyJ0TkTGHmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707636; c=relaxed/simple;
	bh=bFzg5Zp4OVx6l0QR7ndAO4D5CKLFJFZXW1GWnws1Je0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZH7f18JKtbp/BRSVT/uJ/yv3A+yT91a6FqZPL6d1KSU75fcWSpYYx4DUMlH8gOViP62YWGkntkePpqc4yJ4cc31GlvbnpEXUVWMq76DdWo04PQvh+L2KTzpXN/LSiFfCbwaqv3H7M5jkfccR/yAVA5FbhNsvEgGLTcPSd8w04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOtKZbfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOtKZbfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73D9C4CEE9;
	Tue, 11 Mar 2025 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707636;
	bh=bFzg5Zp4OVx6l0QR7ndAO4D5CKLFJFZXW1GWnws1Je0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOtKZbfMMj7L9yOpx0YgOaVDKlLxX7Ph9nuqPp8qjlHXCRzxCgJ2J53r++HtFc10x
	 ukJ6HhVDZm/TrUSUcEJG1iImDdo86f+iM05ahX/RXZfflS7oGcybmmRJTpcX9MtzxY
	 LSW30kmhMZmS7i+8/ihD4SIVv+/Ip626ipV/128g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 457/462] crypto: hisilicon/qm - inject error before stopping queue
Date: Tue, 11 Mar 2025 16:02:03 +0100
Message-ID: <20250311145816.379184930@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

commit b04f06fc0243600665b3b50253869533b7938468 upstream.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/qm.c |   46 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3354,6 +3354,27 @@ static int qm_set_vf_mse(struct hisi_qm
 	return -ETIMEDOUT;
 }
 
+static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
+{
+	u32 nfe_enb = 0;
+
+	if (!qm->err_status.is_dev_ecc_mbit &&
+	    qm->err_status.is_qm_ecc_mbit &&
+	    qm->err_ini->close_axi_master_ooo) {
+
+		qm->err_ini->close_axi_master_ooo(qm);
+
+	} else if (qm->err_status.is_dev_ecc_mbit &&
+		   !qm->err_status.is_qm_ecc_mbit &&
+		   !qm->err_ini->close_axi_master_ooo) {
+
+		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
+		       qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
+	}
+}
+
 static int qm_set_msi(struct hisi_qm *qm, bool set)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -3433,6 +3454,8 @@ static int qm_controller_reset_prepare(s
 		return ret;
 	}
 
+	qm_dev_ecc_mbit_handle(qm);
+
 	if (qm->vfs_num) {
 		ret = qm_vf_reset_prepare(qm, QM_SOFT_RESET);
 		if (ret) {
@@ -3450,27 +3473,6 @@ static int qm_controller_reset_prepare(s
 	return 0;
 }
 
-static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
-{
-	u32 nfe_enb = 0;
-
-	if (!qm->err_status.is_dev_ecc_mbit &&
-	    qm->err_status.is_qm_ecc_mbit &&
-	    qm->err_ini->close_axi_master_ooo) {
-
-		qm->err_ini->close_axi_master_ooo(qm);
-
-	} else if (qm->err_status.is_dev_ecc_mbit &&
-		   !qm->err_status.is_qm_ecc_mbit &&
-		   !qm->err_ini->close_axi_master_ooo) {
-
-		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
-		       qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
-	}
-}
-
 static int qm_soft_reset(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -3496,8 +3498,6 @@ static int qm_soft_reset(struct hisi_qm
 		return ret;
 	}
 
-	qm_dev_ecc_mbit_handle(qm);
-
 	/* OOO register set and check */
 	writel(ACC_MASTER_GLOBAL_CTRL_SHUTDOWN,
 	       qm->io_base + ACC_MASTER_GLOBAL_CTRL);


