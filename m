Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFE95A7B8;
	Tue, 23 Jan 2024 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974342; cv=none; b=eJ+3+XHiEV9g9kM3CUSBgiv/rkU3rQOwoJZKpsLcEMIj6YmvHa0/XGqI2iJ/MDy7h/KnzkX/O0FgeX1OT+1U2p3U3XO2qHhyAKH9MJmSURpxY16sZi70eDKhvN5RCkLLUTQIVZCfLCGyU5CdvhAGBjjJcJRSvXeUegk7SSVUCe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974342; c=relaxed/simple;
	bh=tSeWJ6liy5rbzJB2CftJSKAAb+Sy9MX61gAcoEM3dnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3Oj61gKE1shJmVzZ7ZecCBTOqHeXF2vIVfW08ISA3eumPoHGGV5RFIjdzlJ7nGPQ5BDJmSIS4owl57Z8G/zKtqfLVnSNE323sPyYhLkXVz8QptZ/SSoIb5aI0GHfnis1C7fTaRwjj7DZF8X93XaotBcgNDotb75Q/WALeQwLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz2dzl8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz2dzl8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E77C433C7;
	Tue, 23 Jan 2024 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974342;
	bh=tSeWJ6liy5rbzJB2CftJSKAAb+Sy9MX61gAcoEM3dnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qz2dzl8sp1Pfldp9a+L72x2nFGrJLQTG2o8t80JgSdX3ERMg4PlTFAK0jrBq8axlT
	 LwwcmSfqhwqlJGbueobevOWCRi3i3ALTen2zBfAc8qwPe87b3YzdFI9n+7ICkE/pRg
	 0LPQCyaWt8/ESRs/SItaykwG4x2enbuFc7sJoZ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/583] crypto: hisilicon/hpre - save capability registers in probe process
Date: Mon, 22 Jan 2024 15:51:48 -0800
Message-ID: <20240122235813.869837660@linuxfoundation.org>
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
index 4b3cba95950b..b97ce0ee7140 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -225,6 +225,20 @@ static const struct hisi_qm_cap_info hpre_basic_info[] = {
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
@@ -347,7 +361,7 @@ bool hpre_check_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
 
-	cap_val = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_DRV_ALG_BITMAP_CAP, qm->cap_ver);
+	cap_val = qm->cap_tables.dev_cap_table[HPRE_DRV_ALG_BITMAP_CAP_IDX].cap_val;
 	if (alg & cap_val)
 		return true;
 
@@ -423,16 +437,6 @@ static u32 vfs_num;
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
@@ -499,13 +503,15 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 
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
 
@@ -700,11 +706,12 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
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
@@ -991,13 +998,14 @@ static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 
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
@@ -1102,6 +1110,34 @@ static void hpre_debugfs_exit(struct hisi_qm *qm)
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
@@ -1135,7 +1171,15 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
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
@@ -1149,11 +1193,12 @@ static int hpre_show_last_regs_init(struct hisi_qm *qm)
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
@@ -1190,10 +1235,10 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
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
 
@@ -1208,6 +1253,7 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
 			  hpre_com_dfx_regs[i].name, debug->last_words[i], val);
 	}
 
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
 	for (i = 0; i < clusters_num; i++) {
 		io_base = qm->io_base + hpre_cluster_offsets[i];
 		for (j = 0; j <  cluster_dfx_regs_num; j++) {
-- 
2.43.0



