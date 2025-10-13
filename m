Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A282BE7BA;
	Mon, 13 Oct 2025 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369574; cv=none; b=b83R6tEkJl5VKr2luVcWfUTjUyOPZlJ2W9jJy/+NtfilY6IJx6lux/ewiVJisBNxjeNrRCt3Wxp+p4iE/oZ/NjTbEwZYiR0985NBaNtPNVm4wKUHdrqGF4aqBqwpOpmPSFmxtlWZrsTca3p9ZafS5cjb4a0BJswHJV/VuOnFKJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369574; c=relaxed/simple;
	bh=NsrJtyFDWtGdeIqikLvpV9KPDEiS92xha+9n27/TNKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euBIcjVhSgMk7Rwzrw2QZggm8AbaLHSUPUQAVVTX85IZ3Dmp4YYetJeb14Zvf9cqoywblJC1Ujli5fdAvt7oX14hpff/tv70w/y0uSK7pdLM/VBS294evjSqUxJiJqJmKIznQotXgCeX2XE39RHc1qiVV3hY6JNUZFFUKbPK/vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdS5xtD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdS5xtD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB1C4CEE7;
	Mon, 13 Oct 2025 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369574;
	bh=NsrJtyFDWtGdeIqikLvpV9KPDEiS92xha+9n27/TNKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdS5xtD1OMP0/szqzT5T+qH/Tf58vwoqfRwxXe0QuwQ7noP5f3Ck0bBCgoxb89ES8
	 DREY+hEb6ZbPaEDRJou2Zeocv4uHXWcWL2ECmH4ISzOhYxj6Ta5CRVselYjLcJQWUf
	 M6ufcrCM7Wbr4iIJJp0Zw3eklVbhThnRuJ4imWUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 294/563] crypto: hisilicon - check the sva module status while enabling or disabling address prefetch
Date: Mon, 13 Oct 2025 16:42:35 +0200
Message-ID: <20251013144421.920707751@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 1f9128f121a872f27251be60ccccfd98c136d72e ]

After enabling address prefetch, check the sva module status. If all
previous prefetch requests from the sva module are not completed, then
disable the address prefetch to ensure normal execution of new task
operations. After disabling address prefetch, check if all requests
from the sva module have been completed.

Fixes: a5c164b195a8 ("crypto: hisilicon/qm - support address prefetching")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 63 ++++++++++++++----
 drivers/crypto/hisilicon/sec2/sec_main.c  | 48 +++++++++++++-
 drivers/crypto/hisilicon/zip/zip_main.c   | 79 +++++++++++++++++++----
 3 files changed, 164 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 34f84978180f0..7b60e89015bdf 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -78,6 +78,11 @@
 #define HPRE_PREFETCH_ENABLE		(~(BIT(0) | BIT(30)))
 #define HPRE_PREFETCH_DISABLE		BIT(30)
 #define HPRE_SVA_DISABLE_READY		(BIT(4) | BIT(8))
+#define HPRE_SVA_PREFTCH_DFX4		0x301144
+#define HPRE_WAIT_SVA_READY		500000
+#define HPRE_READ_SVA_STATUS_TIMES	3
+#define HPRE_WAIT_US_MIN		10
+#define HPRE_WAIT_US_MAX		20
 
 /* clock gate */
 #define HPRE_CLKGATE_CTL		0x301a10
@@ -466,6 +471,33 @@ struct hisi_qp *hpre_create_qp(u8 type)
 	return NULL;
 }
 
+static int hpre_wait_sva_ready(struct hisi_qm *qm)
+{
+	u32 val, try_times = 0;
+	u8 count = 0;
+
+	/*
+	 * Read the register value every 10-20us. If the value is 0 for three
+	 * consecutive times, the SVA module is ready.
+	 */
+	do {
+		val = readl(qm->io_base + HPRE_SVA_PREFTCH_DFX4);
+		if (val)
+			count = 0;
+		else if (++count == HPRE_READ_SVA_STATUS_TIMES)
+			break;
+
+		usleep_range(HPRE_WAIT_US_MIN, HPRE_WAIT_US_MAX);
+	} while (++try_times < HPRE_WAIT_SVA_READY);
+
+	if (try_times == HPRE_WAIT_SVA_READY) {
+		pci_err(qm->pdev, "failed to wait sva prefetch ready\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static void hpre_config_pasid(struct hisi_qm *qm)
 {
 	u32 val1, val2;
@@ -563,7 +595,7 @@ static void disable_flr_of_bme(struct hisi_qm *qm)
 	writel(PEH_AXUSER_CFG_ENABLE, qm->io_base + QM_PEH_AXUSER_CFG_ENABLE);
 }
 
-static void hpre_open_sva_prefetch(struct hisi_qm *qm)
+static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 {
 	u32 val;
 	int ret;
@@ -571,20 +603,21 @@ static void hpre_open_sva_prefetch(struct hisi_qm *qm)
 	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
-	/* Enable prefetch */
 	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
-	val &= HPRE_PREFETCH_ENABLE;
+	val |= HPRE_PREFETCH_DISABLE;
 	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
 
-	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_PREFETCH_CFG,
-					 val, !(val & HPRE_PREFETCH_DISABLE),
+	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_SVA_PREFTCH_DFX,
+					 val, !(val & HPRE_SVA_DISABLE_READY),
 					 HPRE_REG_RD_INTVRL_US,
 					 HPRE_REG_RD_TMOUT_US);
 	if (ret)
-		pci_err(qm->pdev, "failed to open sva prefetch\n");
+		pci_err(qm->pdev, "failed to close sva prefetch\n");
+
+	(void)hpre_wait_sva_ready(qm);
 }
 
-static void hpre_close_sva_prefetch(struct hisi_qm *qm)
+static void hpre_open_sva_prefetch(struct hisi_qm *qm)
 {
 	u32 val;
 	int ret;
@@ -592,16 +625,24 @@ static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
+	/* Enable prefetch */
 	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
-	val |= HPRE_PREFETCH_DISABLE;
+	val &= HPRE_PREFETCH_ENABLE;
 	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
 
-	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_SVA_PREFTCH_DFX,
-					 val, !(val & HPRE_SVA_DISABLE_READY),
+	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_PREFETCH_CFG,
+					 val, !(val & HPRE_PREFETCH_DISABLE),
 					 HPRE_REG_RD_INTVRL_US,
 					 HPRE_REG_RD_TMOUT_US);
+	if (ret) {
+		pci_err(qm->pdev, "failed to open sva prefetch\n");
+		hpre_close_sva_prefetch(qm);
+		return;
+	}
+
+	ret = hpre_wait_sva_ready(qm);
 	if (ret)
-		pci_err(qm->pdev, "failed to close sva prefetch\n");
+		hpre_close_sva_prefetch(qm);
 }
 
 static void hpre_enable_clock_gate(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ddb20f380b546..348f1f52956dc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -93,6 +93,16 @@
 #define SEC_PREFETCH_ENABLE		(~(BIT(0) | BIT(1) | BIT(11)))
 #define SEC_PREFETCH_DISABLE		BIT(1)
 #define SEC_SVA_DISABLE_READY		(BIT(7) | BIT(11))
+#define SEC_SVA_PREFETCH_INFO		0x301ED4
+#define SEC_SVA_STALL_NUM		GENMASK(23, 8)
+#define SEC_SVA_PREFETCH_NUM		GENMASK(2, 0)
+#define SEC_WAIT_SVA_READY		500000
+#define SEC_READ_SVA_STATUS_TIMES	3
+#define SEC_WAIT_US_MIN			10
+#define SEC_WAIT_US_MAX			20
+#define SEC_WAIT_QP_US_MIN		1000
+#define SEC_WAIT_QP_US_MAX		2000
+#define SEC_MAX_WAIT_TIMES		2000
 
 #define SEC_DELAY_10_US			10
 #define SEC_POLL_TIMEOUT_US		1000
@@ -464,6 +474,33 @@ static void sec_set_endian(struct hisi_qm *qm)
 	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
+static int sec_wait_sva_ready(struct hisi_qm *qm, __u32 offset, __u32 mask)
+{
+	u32 val, try_times = 0;
+	u8 count = 0;
+
+	/*
+	 * Read the register value every 10-20us. If the value is 0 for three
+	 * consecutive times, the SVA module is ready.
+	 */
+	do {
+		val = readl(qm->io_base + offset);
+		if (val & mask)
+			count = 0;
+		else if (++count == SEC_READ_SVA_STATUS_TIMES)
+			break;
+
+		usleep_range(SEC_WAIT_US_MIN, SEC_WAIT_US_MAX);
+	} while (++try_times < SEC_WAIT_SVA_READY);
+
+	if (try_times == SEC_WAIT_SVA_READY) {
+		pci_err(qm->pdev, "failed to wait sva prefetch ready\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static void sec_close_sva_prefetch(struct hisi_qm *qm)
 {
 	u32 val;
@@ -481,6 +518,8 @@ static void sec_close_sva_prefetch(struct hisi_qm *qm)
 					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
 	if (ret)
 		pci_err(qm->pdev, "failed to close sva prefetch\n");
+
+	(void)sec_wait_sva_ready(qm, SEC_SVA_PREFETCH_INFO, SEC_SVA_STALL_NUM);
 }
 
 static void sec_open_sva_prefetch(struct hisi_qm *qm)
@@ -499,8 +538,15 @@ static void sec_open_sva_prefetch(struct hisi_qm *qm)
 	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
 					 val, !(val & SEC_PREFETCH_DISABLE),
 					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
-	if (ret)
+	if (ret) {
 		pci_err(qm->pdev, "failed to open sva prefetch\n");
+		sec_close_sva_prefetch(qm);
+		return;
+	}
+
+	ret = sec_wait_sva_ready(qm, SEC_SVA_TRANS, SEC_SVA_PREFETCH_NUM);
+	if (ret)
+		sec_close_sva_prefetch(qm);
 }
 
 static void sec_engine_sva_config(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 480fa590664a8..341c4564e21aa 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -95,10 +95,16 @@
 #define HZIP_PREFETCH_ENABLE		(~(BIT(26) | BIT(17) | BIT(0)))
 #define HZIP_SVA_PREFETCH_DISABLE	BIT(26)
 #define HZIP_SVA_DISABLE_READY		(BIT(26) | BIT(30))
+#define HZIP_SVA_PREFETCH_NUM		GENMASK(18, 16)
+#define HZIP_SVA_STALL_NUM		GENMASK(15, 0)
 #define HZIP_SHAPER_RATE_COMPRESS	750
 #define HZIP_SHAPER_RATE_DECOMPRESS	140
-#define HZIP_DELAY_1_US		1
-#define HZIP_POLL_TIMEOUT_US	1000
+#define HZIP_DELAY_1_US			1
+#define HZIP_POLL_TIMEOUT_US		1000
+#define HZIP_WAIT_SVA_READY		500000
+#define HZIP_READ_SVA_STATUS_TIMES	3
+#define HZIP_WAIT_US_MIN		10
+#define HZIP_WAIT_US_MAX		20
 
 /* clock gating */
 #define HZIP_PEH_CFG_AUTO_GATE		0x3011A8
@@ -462,7 +468,34 @@ static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 	writel(val, qm->io_base + HZIP_HIGH_PERF_OFFSET);
 }
 
-static void hisi_zip_open_sva_prefetch(struct hisi_qm *qm)
+static int hisi_zip_wait_sva_ready(struct hisi_qm *qm, __u32 offset, __u32 mask)
+{
+	u32 val, try_times = 0;
+	u8 count = 0;
+
+	/*
+	 * Read the register value every 10-20us. If the value is 0 for three
+	 * consecutive times, the SVA module is ready.
+	 */
+	do {
+		val = readl(qm->io_base + offset);
+		if (val & mask)
+			count = 0;
+		else if (++count == HZIP_READ_SVA_STATUS_TIMES)
+			break;
+
+		usleep_range(HZIP_WAIT_US_MIN, HZIP_WAIT_US_MAX);
+	} while (++try_times < HZIP_WAIT_SVA_READY);
+
+	if (try_times == HZIP_WAIT_SVA_READY) {
+		pci_err(qm->pdev, "failed to wait sva prefetch ready\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void hisi_zip_close_sva_prefetch(struct hisi_qm *qm)
 {
 	u32 val;
 	int ret;
@@ -470,19 +503,20 @@ static void hisi_zip_open_sva_prefetch(struct hisi_qm *qm)
 	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
-	/* Enable prefetch */
 	val = readl_relaxed(qm->io_base + HZIP_PREFETCH_CFG);
-	val &= HZIP_PREFETCH_ENABLE;
+	val |= HZIP_SVA_PREFETCH_DISABLE;
 	writel(val, qm->io_base + HZIP_PREFETCH_CFG);
 
-	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_PREFETCH_CFG,
-					 val, !(val & HZIP_SVA_PREFETCH_DISABLE),
+	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_SVA_TRANS,
+					 val, !(val & HZIP_SVA_DISABLE_READY),
 					 HZIP_DELAY_1_US, HZIP_POLL_TIMEOUT_US);
 	if (ret)
-		pci_err(qm->pdev, "failed to open sva prefetch\n");
+		pci_err(qm->pdev, "failed to close sva prefetch\n");
+
+	(void)hisi_zip_wait_sva_ready(qm, HZIP_SVA_TRANS, HZIP_SVA_STALL_NUM);
 }
 
-static void hisi_zip_close_sva_prefetch(struct hisi_qm *qm)
+static void hisi_zip_open_sva_prefetch(struct hisi_qm *qm)
 {
 	u32 val;
 	int ret;
@@ -490,15 +524,23 @@ static void hisi_zip_close_sva_prefetch(struct hisi_qm *qm)
 	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
+	/* Enable prefetch */
 	val = readl_relaxed(qm->io_base + HZIP_PREFETCH_CFG);
-	val |= HZIP_SVA_PREFETCH_DISABLE;
+	val &= HZIP_PREFETCH_ENABLE;
 	writel(val, qm->io_base + HZIP_PREFETCH_CFG);
 
-	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_SVA_TRANS,
-					 val, !(val & HZIP_SVA_DISABLE_READY),
+	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_PREFETCH_CFG,
+					 val, !(val & HZIP_SVA_PREFETCH_DISABLE),
 					 HZIP_DELAY_1_US, HZIP_POLL_TIMEOUT_US);
+	if (ret) {
+		pci_err(qm->pdev, "failed to open sva prefetch\n");
+		hisi_zip_close_sva_prefetch(qm);
+		return;
+	}
+
+	ret = hisi_zip_wait_sva_ready(qm, HZIP_SVA_TRANS, HZIP_SVA_PREFETCH_NUM);
 	if (ret)
-		pci_err(qm->pdev, "failed to close sva prefetch\n");
+		hisi_zip_close_sva_prefetch(qm);
 }
 
 static void hisi_zip_enable_clock_gate(struct hisi_qm *qm)
@@ -522,6 +564,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	void __iomem *base = qm->io_base;
 	u32 dcomp_bm, comp_bm;
 	u32 zip_core_en;
+	int ret;
 
 	/* qm user domain */
 	writel(AXUSER_BASE, base + QM_ARUSER_M_CFG_1);
@@ -576,7 +619,15 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	hisi_zip_set_high_perf(qm);
 	hisi_zip_enable_clock_gate(qm);
 
-	return hisi_dae_set_user_domain(qm);
+	ret = hisi_dae_set_user_domain(qm);
+	if (ret)
+		goto close_sva_prefetch;
+
+	return 0;
+
+close_sva_prefetch:
+	hisi_zip_close_sva_prefetch(qm);
+	return ret;
 }
 
 static void hisi_zip_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
-- 
2.51.0



