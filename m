Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE623064B7;
	Mon, 13 Oct 2025 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368395; cv=none; b=lj1DV1nECPUINWz6QG61Ba3feb9bYVPg5SvZDR7LWklAf8m/XjINaSaOHJMzfvjZ7Imw+M/QGLB9VQ2OI28E/QUDjlYipGm7TYkQJwobAYPVrc/b2Zchw6IP6VkR59+DFP7y7RZAFQ7fVXBYbwJut8xalHyYNt11G4ZVfSG2Re4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368395; c=relaxed/simple;
	bh=go8FWlrZk6OPQaU4F1+ABBOjvl5EEzFh9sGaYwkXBsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJo6RoRPzQerndqExyeN53wO8Kmb3PtC4bxL2ibbLR77HaMf6I2E9dyjALqUUl/z8RRPxYldVk0Y1rpZSRFayt3cw+EntAfNErMQhXLvBPj2apkewyoKiDyI86sPNvP+s15/espx/myy2bKhCEvGzbYLuE6IPapOvkcJvgZV9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzivOMhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzivOMhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C22C4CEE7;
	Mon, 13 Oct 2025 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368394;
	bh=go8FWlrZk6OPQaU4F1+ABBOjvl5EEzFh9sGaYwkXBsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzivOMhf1kiNbkegWKyX+osmcOtXpbnv1H9EqNGYseNGO7+yJPooc0CtQfekusUFt
	 +vpXmvvulANOkM9LJsphvg04Il9m4wzAkCpTZHcJ6j5CzQ5Y9eyEYUMaOImGdwaKBB
	 NDMZtKtCPHIgLmIELpAneu65SxMXnmTdqo2/JtT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/262] crypto: hisilicon - re-enable address prefetch after device resuming
Date: Mon, 13 Oct 2025 16:44:14 +0200
Message-ID: <20251013144330.158934079@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 0dcd21443d9308ed88909d35aa0490c3fc680a47 ]

When the device resumes from a suspended state, it will revert to its
initial state and requires re-enabling. Currently, the address prefetch
function is not re-enabled after device resuming. Move the address prefetch
enable to the initialization process. In this way, the address prefetch
can be enabled when the device resumes by calling the initialization
process.

Fixes: 607c191b371d ("crypto: hisilicon - support runtime PM for accelerator device")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  3 +-
 drivers/crypto/hisilicon/qm.c             |  3 -
 drivers/crypto/hisilicon/sec2/sec_main.c  | 80 +++++++++++------------
 drivers/crypto/hisilicon/zip/zip_main.c   |  5 +-
 4 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 34d30b7838134..a11fe5e276773 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -690,6 +690,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 	/* Config data buffer pasid needed by Kunpeng 920 */
 	hpre_config_pasid(qm);
+	hpre_open_sva_prefetch(qm);
 
 	hpre_enable_clock_gate(qm);
 
@@ -1366,8 +1367,6 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 	if (ret)
 		return ret;
 
-	hpre_open_sva_prefetch(qm);
-
 	hisi_qm_dev_err_init(qm);
 	ret = hpre_show_last_regs_init(qm);
 	if (ret)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b18692ee7fd56..5bbb2759a6691 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4272,9 +4272,6 @@ static void qm_restart_prepare(struct hisi_qm *qm)
 {
 	u32 value;
 
-	if (qm->err_ini->open_sva_prefetch)
-		qm->err_ini->open_sva_prefetch(qm);
-
 	if (qm->ver >= QM_HW_V3)
 		return;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 75c25f0d5f2b8..9014cc36705ff 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -441,6 +441,45 @@ static void sec_set_endian(struct hisi_qm *qm)
 	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
+static void sec_close_sva_prefetch(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
+		return;
+
+	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
+	val |= SEC_PREFETCH_DISABLE;
+	writel(val, qm->io_base + SEC_PREFETCH_CFG);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
+					 val, !(val & SEC_SVA_DISABLE_READY),
+					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to close sva prefetch\n");
+}
+
+static void sec_open_sva_prefetch(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
+		return;
+
+	/* Enable prefetch */
+	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
+	val &= SEC_PREFETCH_ENABLE;
+	writel(val, qm->io_base + SEC_PREFETCH_CFG);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
+					 val, !(val & SEC_PREFETCH_DISABLE),
+					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to open sva prefetch\n");
+}
+
 static void sec_engine_sva_config(struct hisi_qm *qm)
 {
 	u32 reg;
@@ -474,45 +513,7 @@ static void sec_engine_sva_config(struct hisi_qm *qm)
 		writel_relaxed(reg, qm->io_base +
 				SEC_INTERFACE_USER_CTRL1_REG);
 	}
-}
-
-static void sec_open_sva_prefetch(struct hisi_qm *qm)
-{
-	u32 val;
-	int ret;
-
-	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
-		return;
-
-	/* Enable prefetch */
-	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
-	val &= SEC_PREFETCH_ENABLE;
-	writel(val, qm->io_base + SEC_PREFETCH_CFG);
-
-	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
-					 val, !(val & SEC_PREFETCH_DISABLE),
-					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
-	if (ret)
-		pci_err(qm->pdev, "failed to open sva prefetch\n");
-}
-
-static void sec_close_sva_prefetch(struct hisi_qm *qm)
-{
-	u32 val;
-	int ret;
-
-	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
-		return;
-
-	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
-	val |= SEC_PREFETCH_DISABLE;
-	writel(val, qm->io_base + SEC_PREFETCH_CFG);
-
-	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
-					 val, !(val & SEC_SVA_DISABLE_READY),
-					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
-	if (ret)
-		pci_err(qm->pdev, "failed to close sva prefetch\n");
+	sec_open_sva_prefetch(qm);
 }
 
 static void sec_enable_clock_gate(struct hisi_qm *qm)
@@ -1094,7 +1095,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	if (ret)
 		return ret;
 
-	sec_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	sec_debug_regs_clear(qm);
 	ret = sec_show_last_regs_init(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 18177aba3d3a6..323f53217f0c0 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -557,6 +557,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
 		writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	}
+	hisi_zip_open_sva_prefetch(qm);
 
 	/* let's open all compression/decompression cores */
 	dcomp_bm = qm->cap_tables.dev_cap_table[ZIP_DECOMP_ENABLE_BITMAP_IDX].cap_val;
@@ -568,6 +569,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
+	hisi_zip_set_high_perf(qm);
 	hisi_zip_enable_clock_gate(qm);
 
 	return 0;
@@ -1163,9 +1165,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
-	hisi_zip_set_high_perf(qm);
-
-	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(qm);
 
-- 
2.51.0



