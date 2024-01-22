Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C285FDDF;
	Tue, 23 Jan 2024 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970533; cv=none; b=KahZFxW4DdOf2I3keuet0I4F3RLNB2k4J4le9uzgbY24m5qs0y7OUjkQM+gREwbvwbgRJenYCyKwUyqwN7ITMiZwA53s243vZ9kdihdaWmhSNFsTEbu+ov0kwGL3R/jZVi5g74lxzeN/por/HiMLcrHP+4lp0D/YycDc6/3g/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970533; c=relaxed/simple;
	bh=Jn7oto7w1aG2MX+YbD8rklEHJC8eQKBbT3/IevpKJ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExcqatvFrxppoKAVyYSe1IRk2sN13SM/1szPJBErCd976mG7jFtxxtviTIRWCqvbhw08Fo5qvwRx2zOJSlHr5d4/UqXHcQsEGni/tfHfnTToiWSXUOCsRClTACGI3Z2LYcCgTqncFRNH8BJJGYngthpBfUkvvV9l7xEVw5SNNAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/gXsPi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/gXsPi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427F5C43394;
	Tue, 23 Jan 2024 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970532;
	bh=Jn7oto7w1aG2MX+YbD8rklEHJC8eQKBbT3/IevpKJ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/gXsPi5CO54uqt56nTbrfbDjvfMioI27ag9Jrvu9tEIOQodYtOGbqSoUYnJ3CrYi
	 e/EWE8vWDK96X8uckZztnjCVNXULUCZ9Ut2fK+EwT8mIRKKbewPwY0c/NIKtD3/iBB
	 GcqJ4nIUozm78vpLjEayKKkTYXKCVDGRFhNGh8f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/417] crypto: hisilicon/zip - add zip comp high perf mode configuration
Date: Mon, 22 Jan 2024 15:53:33 -0800
Message-ID: <20240122235753.225692031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit a9864bae1806499ebf3757a9e71dddde5b9c48c6 ]

To meet specific application scenarios, the function of switching between
the high performance mode and the high compression mode is added.

Use the perf_mode=0/1 configuration to set the compression high perf mode,
0(default, high compression mode), 1(high performance mode). These two
modes only apply to the compression direction and are compatible with
software algorithm in both directions.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: cf8b5156bbc8 ("crypto: hisilicon/hpre - save capability registers in probe process")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 190b4fecfc74..2c5e805ffdc3 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -107,6 +107,14 @@
 #define HZIP_CLOCK_GATED_EN		(HZIP_CORE_GATED_EN | \
 					 HZIP_CORE_GATED_OOO_EN)
 
+/* zip comp high performance */
+#define HZIP_HIGH_PERF_OFFSET		0x301208
+
+enum {
+	HZIP_HIGH_COMP_RATE,
+	HZIP_HIGH_COMP_PERF,
+};
+
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
 
@@ -352,6 +360,37 @@ static int hzip_diff_regs_show(struct seq_file *s, void *unused)
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(hzip_diff_regs);
+
+static int perf_mode_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	u32 n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret != 0 || (n != HZIP_HIGH_COMP_PERF &&
+			 n != HZIP_HIGH_COMP_RATE))
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops zip_com_perf_ops = {
+	.set = perf_mode_set,
+	.get = param_get_int,
+};
+
+/*
+ * perf_mode = 0 means enable high compression rate mode,
+ * perf_mode = 1 means enable high compression performance mode.
+ * These two modes only apply to the compression direction.
+ */
+static u32 perf_mode = HZIP_HIGH_COMP_RATE;
+module_param_cb(perf_mode, &zip_com_perf_ops, &perf_mode, 0444);
+MODULE_PARM_DESC(perf_mode, "ZIP high perf mode 0(default), 1(enable)");
+
 static const struct kernel_param_ops zip_uacce_mode_ops = {
 	.set = uacce_mode_set,
 	.get = param_get_int,
@@ -417,6 +456,28 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
+static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
+	if (perf_mode == HZIP_HIGH_COMP_PERF)
+		val |= HZIP_HIGH_COMP_PERF;
+	else
+		val &= ~HZIP_HIGH_COMP_PERF;
+
+	/* Set perf mode */
+	writel(val, qm->io_base + HZIP_HIGH_PERF_OFFSET);
+	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_HIGH_PERF_OFFSET,
+					 val, val == perf_mode, HZIP_DELAY_1_US,
+					 HZIP_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to set perf mode\n");
+
+	return ret;
+}
+
 static int hisi_zip_set_qm_algs(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -1115,6 +1176,10 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
+	ret = hisi_zip_set_high_perf(qm);
+	if (ret)
+		return ret;
+
 	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(qm);
-- 
2.43.0



