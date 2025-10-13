Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0735C27A477;
	Mon, 13 Oct 2025 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367636; cv=none; b=dK81++/Oji8Pdwf2W1/8iU1iImLUTTlX7X2+PQ+sSwLAcnGrIzNadFeYGJXSN/uypefIm0Ml9R0HDf+A9OGhmcFy/OVHSR5xEZuimzvIacekQJL3e03/fWO0RdPVUMRviErOPwI6AWC1T/vRu7LNgdplPd5xLs7m8DGK65FYyTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367636; c=relaxed/simple;
	bh=we3SVKs0k+edK3JWQ4+4fknKuiZNleTxoALk8wQXEfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHj+IMWTlFJU0uCaGN10HBtQ95ZJJnbNCSeybFGepGGZGQAlECGTTm4+oBNDQKdXSv9MiCSg7KO4YT8iHGlYA73MDtcYdZs+K4vpV6aXXDzua5AEEChbVzVuMKFEp/lh34gvwaCAA2zhxsp80BuK6Mvhr6tXLJMVbZf6S+QjYcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NToomgBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NToomgBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32776C4CEE7;
	Mon, 13 Oct 2025 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367635;
	bh=we3SVKs0k+edK3JWQ4+4fknKuiZNleTxoALk8wQXEfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NToomgBB7ck6PNvK9hRstdClmUCVz71GoV7SVtYz70jd3Wh8LCQDRkpjWBKdlPT4G
	 xRRbUivnjPkXYs0vPoHDZSDxv6eHFHC3Yq9l7G+P7WqphSPZMUN4NIRyWZhWHy1ZFx
	 RH7OGQb2KHWgK/SlVru/J+yqgcNBWEPdF9kM+dGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/196] crypto: hisilicon - re-enable address prefetch after device resuming
Date: Mon, 13 Oct 2025 16:44:32 +0200
Message-ID: <20251013144318.246134297@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 762a2a54ca821..e3d113334d4e4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -689,6 +689,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
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
index 7921409791fb0..183885619eb8b 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4363,9 +4363,6 @@ static void qm_restart_prepare(struct hisi_qm *qm)
 {
 	u32 value;
 
-	if (qm->err_ini->open_sva_prefetch)
-		qm->err_ini->open_sva_prefetch(qm);
-
 	if (qm->ver >= QM_HW_V3)
 		return;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 6aaaaf784ddc0..064fbc8db16fc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -436,6 +436,45 @@ static void sec_set_endian(struct hisi_qm *qm)
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
@@ -469,45 +508,7 @@ static void sec_engine_sva_config(struct hisi_qm *qm)
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
@@ -1090,7 +1091,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	if (ret)
 		return ret;
 
-	sec_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	sec_debug_regs_clear(qm);
 	ret = sec_show_last_regs_init(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 6e419c5165cb4..b70aa6032874e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -577,6 +577,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
 		writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	}
+	hisi_zip_open_sva_prefetch(qm);
 
 	/* let's open all compression/decompression cores */
 	dcomp_bm = qm->cap_tables.dev_cap_table[ZIP_DECOMP_ENABLE_BITMAP_IDX].cap_val;
@@ -588,6 +589,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
+	hisi_zip_set_high_perf(qm);
 	hisi_zip_enable_clock_gate(qm);
 
 	return 0;
@@ -1172,9 +1174,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
-	hisi_zip_set_high_perf(qm);
-
-	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(qm);
 
-- 
2.51.0



