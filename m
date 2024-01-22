Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE655BAC5;
	Tue, 23 Jan 2024 00:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970539; cv=none; b=UtVRo+YJCsOo7Wt61GHAsd0JiwesG7t9xFCPa6BDCAEWj/i6o3kOhDbUSqvD7yFTqk6SvTQLmbTNlBUyvLBk9KsO4kj8DfSXuz7VL51wDQfruLX7bcy0pHC0Xn61W9LPhpSTcEtKpVBBlM9wm7InI+gO7r2Fp05Q8NRwfYn4TJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970539; c=relaxed/simple;
	bh=u/XFrYXs/zuQIIAPcOfwWirp1jbcUmVd//un7jtDH8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyXF+bVzmoPre4HOpLPUpOFGsiVfYEFmr2p8+NuntmGteNYf9xgEQJKY6ov2A1ZCfgRy6k2HIeB/O1LuOj3Pu1P/ubTi7k1ouQNdn1osJ3Dluy95huqJaaubLPcHUh0E6XKbcx89mvn/GzcCNMSEKoh4ONFMVjmy9QsTdPPJx0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JotyhyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JotyhyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47193C433F1;
	Tue, 23 Jan 2024 00:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970538;
	bh=u/XFrYXs/zuQIIAPcOfwWirp1jbcUmVd//un7jtDH8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JotyhyNoBQzvgSYcQOvgtk2BCtYKC0u07zM5XUuLyXfEdmMa4sTexHcVbpj2jOPK
	 dSO4EAH+0WDRmH59RR1jsUDY3kwb7a+LMt9EVhuNdJNHttQWNJDkBLBFUUgyavRqyR
	 yJF8YSpPAQAhALTbLlDx08D99MRHn/rNCmeVXroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/417] crypto: hisilicon/hpre - save capability registers in probe process
Date: Mon, 22 Jan 2024 15:53:35 -0800
Message-ID: <20240122235753.294375108@linuxfoundation.org>
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

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit cf8b5156bbc8c9376f699e8d35e9464b739e33ff ]

Pre-store the valid value of hpre alg support related capability
register in hpre_qm_init(), which will be called by hpre_probe().
It can reduce the number of capability register queries and avoid
obtaining incorrect values in abnormal scenarios, such as reset
failed and the memory space disabled.

Fixes: f214d59a0603 ("crypto: hisilicon/hpre - support hpre capability")
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 82 ++++++++++++++++++-----
 1 file changed, 64 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index cf02c9cde85a..269df4ec148b 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -226,6 +226,20 @@ static const struct hisi_qm_cap_info hpre_basic_info[] = {
 	{HPRE_CORE10_ALG_BITMAP_CAP, 0x3170, 0, GENMASK(31, 0), 0x0, 0x10, 0x10}
 };
 
+enum hpre_pre_store_cap_idx {
+	HPRE_CLUSTER_NUM_CAP_IDX = 0x0,
+	HPRE_CORE_ENABLE_BITMAP_CAP_IDX,
+	HPRE_DRV_ALG_BITMAP_CAP_IDX,
+	HPRE_DEV_ALG_BITMAP_CAP_IDX,
+};
+
+static const u32 hpre_pre_store_caps[] = {
+	HPRE_CLUSTER_NUM_CAP,
+	HPRE_CORE_ENABLE_BITMAP_CAP,
+	HPRE_DRV_ALG_BITMAP_CAP,
+	HPRE_DEV_ALG_BITMAP_CAP,
+};
+
 static const struct hpre_hw_error hpre_hw_errors[] = {
 	{
 		.int_msk = BIT(0),
@@ -345,7 +359,7 @@ bool hpre_check_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
 
-	cap_val = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_DRV_ALG_BITMAP_CAP, qm->cap_ver);
+	cap_val = qm->cap_tables.dev_cap_table[HPRE_DRV_ALG_BITMAP_CAP_IDX].cap_val;
 	if (alg & cap_val)
 		return true;
 
@@ -421,16 +435,6 @@ static u32 vfs_num;
 module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
 
-static inline int hpre_cluster_num(struct hisi_qm *qm)
-{
-	return hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CLUSTER_NUM_CAP, qm->cap_ver);
-}
-
-static inline int hpre_cluster_core_mask(struct hisi_qm *qm)
-{
-	return hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CORE_ENABLE_BITMAP_CAP, qm->cap_ver);
-}
-
 struct hisi_qp *hpre_create_qp(u8 type)
 {
 	int node = cpu_to_node(smp_processor_id());
@@ -497,13 +501,15 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 
 static int hpre_set_cluster(struct hisi_qm *qm)
 {
-	u32 cluster_core_mask = hpre_cluster_core_mask(qm);
-	u8 clusters_num = hpre_cluster_num(qm);
 	struct device *dev = &qm->pdev->dev;
 	unsigned long offset;
+	u32 cluster_core_mask;
+	u8 clusters_num;
 	u32 val = 0;
 	int ret, i;
 
+	cluster_core_mask = qm->cap_tables.dev_cap_table[HPRE_CORE_ENABLE_BITMAP_CAP_IDX].cap_val;
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	for (i = 0; i < clusters_num; i++) {
 		offset = i * HPRE_CLSTR_ADDR_INTRVL;
 
@@ -698,11 +704,12 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 {
-	u8 clusters_num = hpre_cluster_num(qm);
 	unsigned long offset;
+	u8 clusters_num;
 	int i;
 
 	/* clear clusterX/cluster_ctrl */
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	for (i = 0; i < clusters_num; i++) {
 		offset = HPRE_CLSTR_BASE + i * HPRE_CLSTR_ADDR_INTRVL;
 		writel(0x0, qm->io_base + offset + HPRE_CLUSTER_INQURY);
@@ -989,13 +996,14 @@ static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 
 static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 {
-	u8 clusters_num = hpre_cluster_num(qm);
 	struct device *dev = &qm->pdev->dev;
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
 	struct dentry *tmp_d;
+	u8 clusters_num;
 	int i, ret;
 
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	for (i = 0; i < clusters_num; i++) {
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
 		if (ret >= HPRE_DBGFS_VAL_MAX_LEN)
@@ -1100,6 +1108,34 @@ static void hpre_debugfs_exit(struct hisi_qm *qm)
 	debugfs_remove_recursive(qm->debug.debug_root);
 }
 
+static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
+{
+	struct hisi_qm_cap_record *hpre_cap;
+	struct device *dev = &qm->pdev->dev;
+	size_t i, size;
+
+	size = ARRAY_SIZE(hpre_pre_store_caps);
+	hpre_cap = devm_kzalloc(dev, sizeof(*hpre_cap) * size, GFP_KERNEL);
+	if (!hpre_cap)
+		return -ENOMEM;
+
+	for (i = 0; i < size; i++) {
+		hpre_cap[i].type = hpre_pre_store_caps[i];
+		hpre_cap[i].cap_val = hisi_qm_get_hw_info(qm, hpre_basic_info,
+				      hpre_pre_store_caps[i], qm->cap_ver);
+	}
+
+	if (hpre_cap[HPRE_CLUSTER_NUM_CAP_IDX].cap_val > HPRE_CLUSTERS_NUM_MAX) {
+		dev_err(dev, "Device cluster num %u is out of range for driver supports %d!\n",
+			hpre_cap[HPRE_CLUSTER_NUM_CAP_IDX].cap_val, HPRE_CLUSTERS_NUM_MAX);
+		return -EINVAL;
+	}
+
+	qm->cap_tables.dev_cap_table = hpre_cap;
+
+	return 0;
+}
+
 static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1133,7 +1169,15 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
-	alg_msk = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_DEV_ALG_BITMAP_CAP, qm->cap_ver);
+	/* Fetch and save the value of capability registers */
+	ret = hpre_pre_store_cap_reg(qm);
+	if (ret) {
+		pci_err(pdev, "Failed to pre-store capability registers!\n");
+		hisi_qm_uninit(qm);
+		return ret;
+	}
+
+	alg_msk = qm->cap_tables.dev_cap_table[HPRE_DEV_ALG_BITMAP_CAP_IDX].cap_val;
 	ret = hisi_qm_set_algs(qm, alg_msk, hpre_dev_algs, ARRAY_SIZE(hpre_dev_algs));
 	if (ret) {
 		pci_err(pdev, "Failed to set hpre algs!\n");
@@ -1147,11 +1191,12 @@ static int hpre_show_last_regs_init(struct hisi_qm *qm)
 {
 	int cluster_dfx_regs_num =  ARRAY_SIZE(hpre_cluster_dfx_regs);
 	int com_dfx_regs_num = ARRAY_SIZE(hpre_com_dfx_regs);
-	u8 clusters_num = hpre_cluster_num(qm);
 	struct qm_debug *debug = &qm->debug;
 	void __iomem *io_base;
+	u8 clusters_num;
 	int i, j, idx;
 
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	debug->last_words = kcalloc(cluster_dfx_regs_num * clusters_num +
 			com_dfx_regs_num, sizeof(unsigned int), GFP_KERNEL);
 	if (!debug->last_words)
@@ -1188,10 +1233,10 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
 {
 	int cluster_dfx_regs_num =  ARRAY_SIZE(hpre_cluster_dfx_regs);
 	int com_dfx_regs_num = ARRAY_SIZE(hpre_com_dfx_regs);
-	u8 clusters_num = hpre_cluster_num(qm);
 	struct qm_debug *debug = &qm->debug;
 	struct pci_dev *pdev = qm->pdev;
 	void __iomem *io_base;
+	u8 clusters_num;
 	int i, j, idx;
 	u32 val;
 
@@ -1206,6 +1251,7 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
 			  hpre_com_dfx_regs[i].name, debug->last_words[i], val);
 	}
 
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	for (i = 0; i < clusters_num; i++) {
 		io_base = qm->io_base + hpre_cluster_offsets[i];
 		for (j = 0; j <  cluster_dfx_regs_num; j++) {
-- 
2.43.0



