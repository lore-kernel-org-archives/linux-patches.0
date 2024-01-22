Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF045BAC0;
	Tue, 23 Jan 2024 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974338; cv=none; b=baU/dIgs60Yc7vprGcJen1lGVv2XH/JVk1z6ZOc+X/QgwVVuv14vVCCH5Zhhwwpkn5td8IU1tMBjcPCJKRiHcAjLlFZp+RRrFDU83bm6Z3807jFg8oZon8ytbyu9LrWM6wvA6lbuxvEC1O1ra9u5JA8/TEEuOt2UcQcX5nO1Bnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974338; c=relaxed/simple;
	bh=qQzW/E+MtUOKadp3lYCCEGH0IKvQvXIuhU/JkmauOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rueQjbp1fTrMakjAIGMOXrdmntuKHtNVZWXGX8IU9mEZ4Ab+IVUhXtwAVNGzaS/Px2jKl8wn4cBNj5V3uQQO04a5vSd6fnEsP16afhaaFBi/0BtE3VsQqy4/V3OTKguo7HfF0AXgJJGH8Y689sZMRecK0Vb1FVtxSb20hlZKK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybGSDggC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybGSDggC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E35C433C7;
	Tue, 23 Jan 2024 01:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974337;
	bh=qQzW/E+MtUOKadp3lYCCEGH0IKvQvXIuhU/JkmauOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybGSDggCDwmnbimOEXl24/mNyNnfbvBp9es2GDNuH+nkQIGQWjxF422LvK0J/rmy2
	 QjN/Ahtau0OiEjYboUdR5YUDMRh5TJ2Tsua060pN6Q+7fT4Qxk2rtTBaAiSMxeOunb
	 Vboi+9UfPAl21rO2T/NRznXna0UuT2PnLmrYxSQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/583] crypto: hisilicon/zip - add zip comp high perf mode configuration
Date: Mon, 22 Jan 2024 15:51:46 -0800
Message-ID: <20240122235813.812793800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 84dbaeb07ea8..0dfd6e240e1c 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -106,6 +106,14 @@
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
 
@@ -351,6 +359,37 @@ static int hzip_diff_regs_show(struct seq_file *s, void *unused)
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
@@ -416,6 +455,28 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
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
@@ -1114,6 +1175,10 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
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



