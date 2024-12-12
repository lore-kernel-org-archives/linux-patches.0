Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A1E21660C;
	Thu, 12 Dec 2024 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023545; cv=none; b=ZuLPTLQDS+txUFIFmjx2zyI1NzYMw1jboNQQVuUqLgaY8WQn7fXDHNSdAOApI0GxhGlcx137xm7Mebi3E1b4U8bcnL93y1rKaKSsslrk7ZXRBLjFnc/ckeozTnkAc+BV9p6UZBwm2FqaPdUTB9OrCzggh0iW8wFNBIsjS6rP4qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023545; c=relaxed/simple;
	bh=29BQ+L2cp1U7p4CrujCp26fje9SjKwTr2+Jgb9M4wHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS+b+CO8dIIIEBmzqZqFqkPN0m4+hPMaPjmxUHYJ2ycpGDhuhr54y+GVOGDtHI58csg5EDNTpyMkXOzSog/yRP67Iaeoqf5+s/5c8QJ9jRuSbARZbGWtM98sJJDtUmeyZ2VuIdtcDA00XuQcKgfVRfh3UgSpPq4Flr6BFPMK2AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pk0w9bvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pk0w9bvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7A5C4CED0;
	Thu, 12 Dec 2024 17:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023545;
	bh=29BQ+L2cp1U7p4CrujCp26fje9SjKwTr2+Jgb9M4wHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk0w9bvVFW125ibquJbOzN9z2fD4Yhp7XOzh9gZuVRKw0UDl1MpsrrofFAi5/Ydus
	 0aYhqjJdMyrlqP0TlKMZkej26gEgGIBgqA4oUZMhLY546+CuZD3QR8BwoJdqDCkWzS
	 b/OhRFwSj5NiGZWzHWuCfyp9wqPxk5tzMVE3lOUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Libo Chen <libo.chen.cn@windriver.com>
Subject: [PATCH 5.15 550/565] crypto: hisilicon/qm - inject error before stopping queue
Date: Thu, 12 Dec 2024 16:02:25 +0100
Message-ID: <20241212144333.597529158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Libo Chen <libo.chen.cn@windriver.com>
---
 drivers/crypto/hisilicon/qm.c |   51 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4638,6 +4638,28 @@ static int qm_set_vf_mse(struct hisi_qm
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
@@ -4742,6 +4764,8 @@ static int qm_controller_reset_prepare(s
 		return ret;
 	}
 
+	qm_dev_ecc_mbit_handle(qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	qm_cmd_uninit(qm);
 
@@ -4766,31 +4790,6 @@ static int qm_controller_reset_prepare(s
 	return 0;
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
@@ -4816,8 +4815,6 @@ static int qm_soft_reset(struct hisi_qm
 		return ret;
 	}
 
-	qm_dev_ecc_mbit_handle(qm);
-
 	/* OOO register set and check */
 	writel(ACC_MASTER_GLOBAL_CTRL_SHUTDOWN,
 	       qm->io_base + ACC_MASTER_GLOBAL_CTRL);


