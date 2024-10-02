Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB9D16F84F;
	Wed,  2 Oct 2024 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875405; cv=none; b=iciyDDaAEv5dkPePR/uweiesh7tjRq7si+cOUFx9Uj3txVJ0YF1UrarSsKT661mVMA+wRPzYvTv/jQnBSz94ZCAz7Cw8tsqqHbZyf7Ijmzwc3H8OgNsA0dtOaV0sj3m4WIWIRtllxnzL6JGEexPeBBugDH2Ao7I9nadtHcnXDAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875405; c=relaxed/simple;
	bh=gR2qxOHQHYEg22q9V0/0uUH654bE0rK4B4K9Wcfh3aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4DmUS4ZpfoqGGgB1jvZSJSKo9s0QAR243cd6JhJYCTNtfkSvazwB8/imKuIR9y2VUFjxCSyNS8to543ybidCBaXNnCHA0pn+WwXHjrDTyxJ/ntc/NWXOnE5NMPqsEIVL2Z06oCL4fkkXVgu7BqOt5a7spquyn93yG2i1bPSPBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tztetfty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tztetfty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB96C4CEC5;
	Wed,  2 Oct 2024 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875405;
	bh=gR2qxOHQHYEg22q9V0/0uUH654bE0rK4B4K9Wcfh3aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TztetftyXXKF6tImRo0gHefrVj2GuSGWP4k1EQQ4HpD0sTmXZyU54CbHPAYuyywkT
	 rOCJFqJlme9+cjsRmTA3rh0zISLrTSOr+496xNcbtqsEEqT1AECfVP5dQireuA0nvb
	 lSpPS96Wg2YXc5ri2ir9su28NSnmexmwsFIDCrEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 083/695] crypto: hisilicon/hpre - mask cluster timeout error
Date: Wed,  2 Oct 2024 14:51:21 +0200
Message-ID: <20241002125825.793766014@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 145013f723947c83b1a5f76a0cf6e7237d59e973 ]

The timeout threshold of the hpre cluster is 16ms. When the CPU
and device share virtual address, page fault processing time may
exceed the threshold.

In the current test, there is a high probability that the
cluster times out. However, the cluster is waiting for the
completion of memory access, which is not an error, the device
does not need to be reset. If an error occurs in the cluster,
qm also reports the error. Therefore, the cluster timeout
error of hpre can be masked.

Fixes: d90fab0deb8e ("crypto: hisilicon/qm - get error type from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 10aa4da93323f..f8340d68afe1d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -13,9 +13,7 @@
 #include <linux/uacce.h>
 #include "hpre.h"
 
-#define HPRE_QM_ABNML_INT_MASK		0x100004
 #define HPRE_CTRL_CNT_CLR_CE_BIT	BIT(0)
-#define HPRE_COMM_CNT_CLR_CE		0x0
 #define HPRE_CTRL_CNT_CLR_CE		0x301000
 #define HPRE_FSM_MAX_CNT		0x301008
 #define HPRE_VFG_AXQOS			0x30100c
@@ -42,7 +40,6 @@
 #define HPRE_HAC_INT_SET		0x301500
 #define HPRE_RNG_TIMEOUT_NUM		0x301A34
 #define HPRE_CORE_INT_ENABLE		0
-#define HPRE_CORE_INT_DISABLE		GENMASK(21, 0)
 #define HPRE_RDCHN_INI_ST		0x301a00
 #define HPRE_CLSTR_BASE			0x302000
 #define HPRE_CORE_EN_OFFSET		0x04
@@ -66,7 +63,6 @@
 #define HPRE_CLSTR_ADDR_INTRVL		0x1000
 #define HPRE_CLUSTER_INQURY		0x100
 #define HPRE_CLSTR_ADDR_INQRY_RSLT	0x104
-#define HPRE_TIMEOUT_ABNML_BIT		6
 #define HPRE_PASID_EN_BIT		9
 #define HPRE_REG_RD_INTVRL_US		10
 #define HPRE_REG_RD_TMOUT_US		1000
@@ -203,9 +199,9 @@ static const struct hisi_qm_cap_info hpre_basic_info[] = {
 	{HPRE_QM_RESET_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0xC37, 0x6C37},
 	{HPRE_QM_OOO_SHUTDOWN_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0x4, 0x6C37},
 	{HPRE_QM_CE_MASK_CAP, 0x312C, 0, GENMASK(31, 0), 0x0, 0x8, 0x8},
-	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0x1FFFFFE},
-	{HPRE_RESET_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xBFFFFE},
-	{HPRE_OOO_SHUTDOWN_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x22, 0xBFFFFE},
+	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0x1FFFC3E},
+	{HPRE_RESET_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xBFFC3E},
+	{HPRE_OOO_SHUTDOWN_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x22, 0xBFFC3E},
 	{HPRE_CE_MASK_CAP, 0x3138, 0, GENMASK(31, 0), 0x0, 0x1, 0x1},
 	{HPRE_CLUSTER_NUM_CAP, 0x313c, 20, GENMASK(3, 0), 0x0,  0x4, 0x1},
 	{HPRE_CORE_TYPE_NUM_CAP, 0x313c, 16, GENMASK(3, 0), 0x0, 0x2, 0x2},
@@ -654,11 +650,6 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_AWUSER_M_CFG_ENABLE);
 	writel_relaxed(HPRE_QM_AXI_CFG_MASK, qm->io_base + QM_AXI_M_CFG);
 
-	/* HPRE need more time, we close this interrupt */
-	val = readl_relaxed(qm->io_base + HPRE_QM_ABNML_INT_MASK);
-	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_QM_ABNML_INT_MASK);
-
 	if (qm->ver >= QM_HW_V3)
 		writel(HPRE_RSA_ENB | HPRE_ECC_ENB,
 			qm->io_base + HPRE_TYPES_ENB);
@@ -667,9 +658,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 	writel(HPRE_QM_VFG_AX_MASK, qm->io_base + HPRE_VFG_AXCACHE);
 	writel(0x0, qm->io_base + HPRE_BD_ENDIAN);
-	writel(0x0, qm->io_base + HPRE_INT_MASK);
 	writel(0x0, qm->io_base + HPRE_POISON_BYPASS);
-	writel(0x0, qm->io_base + HPRE_COMM_CNT_CLR_CE);
 	writel(0x0, qm->io_base + HPRE_ECC_BYPASS);
 
 	writel(HPRE_BD_USR_MASK, qm->io_base + HPRE_BD_ARUSR_CFG);
@@ -759,7 +748,7 @@ static void hpre_hw_error_disable(struct hisi_qm *qm)
 
 static void hpre_hw_error_enable(struct hisi_qm *qm)
 {
-	u32 ce, nfe;
+	u32 ce, nfe, err_en;
 
 	ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CE_MASK_CAP, qm->cap_ver);
 	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
@@ -776,7 +765,8 @@ static void hpre_hw_error_enable(struct hisi_qm *qm)
 	hpre_master_ooo_ctrl(qm, true);
 
 	/* enable hpre hw error interrupts */
-	writel(HPRE_CORE_INT_ENABLE, qm->io_base + HPRE_INT_MASK);
+	err_en = ce | nfe | HPRE_HAC_RAS_FE_ENABLE;
+	writel(~err_en, qm->io_base + HPRE_INT_MASK);
 }
 
 static inline struct hisi_qm *hpre_file_to_qm(struct hpre_debugfs_file *file)
-- 
2.43.0



