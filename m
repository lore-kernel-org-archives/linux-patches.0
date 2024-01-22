Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203CA5BAD4;
	Tue, 23 Jan 2024 01:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974348; cv=none; b=WYastIOoZ1PS5WCyVpTf1OZYg8/DztA9TkhogPWSTCPJB7vtmKN7VbGQsiIZnrnlFNcVsYUaCeliZEdGsbObBdN9EicZx+1wfipxPhZqgxAPVIz7R2ND363vyng7ANgWffhhAfEeW6S4K/RMqKVCHs6TsCuIwpCCN/rWaSpfjf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974348; c=relaxed/simple;
	bh=/tNzrbVTp+k+Eqx9OkYVLUYvsRzdp0jwb4vfNvUprS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsWbvLvLZddtgc6jPw4mzB+x7TiayC7sC6ywU6uAEZ5wj0mhVzmq9v1EcEFv9xPA/7UiHmFmj2Q7QSnvFz9up0XYfbvUn19/6yMtpHv8ZCKWETGb3GtX3g1u9XdXrisaAK+UWmjXflY86GF7XWGeH1Ti65qFbBX1OcYTW6rhJIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Yri2H1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Yri2H1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29D4C433F1;
	Tue, 23 Jan 2024 01:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974348;
	bh=/tNzrbVTp+k+Eqx9OkYVLUYvsRzdp0jwb4vfNvUprS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Yri2H1DGhnLf6PdAteE7GscyUlK/VaETbWiweEl2E7bkAE7uzCWcFkYtBsnQL27y
	 Sb+d5gH20H4KSZp7NOzelc1Qx6ZeFG6ll072E1x3Q8yklrZ9vBVfvXipW11VUWy4Ah
	 G9+RVvUdPw2ecjvlCBdopVI2X7/h5yIHUTSmUZXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/583] crypto: hisilicon/zip - save capability registers in probe process
Date: Mon, 22 Jan 2024 15:51:50 -0800
Message-ID: <20240122235813.929001085@linuxfoundation.org>
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

[ Upstream commit 2ff0ad847951d61c2d8b309e1ccefb26c57dcc7b ]

Pre-store the valid value of the zip alg support related capability
register in hisi_zip_qm_init(), which will be called by hisi_zip_probe().
It can reduce the number of capability register queries and avoid
obtaining incorrect values in abnormal scenarios, such as reset failed
and the memory space disabled.

Fixes: db700974b69d ("crypto: hisilicon/zip - support zip capability")
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 73 ++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4d64a43515a9..cd7ecb2180bf 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -248,6 +248,26 @@ static struct hisi_qm_cap_info zip_basic_cap_info[] = {
 	{ZIP_CAP_MAX, 0x317c, 0, GENMASK(0, 0), 0x0, 0x0, 0x0}
 };
 
+enum zip_pre_store_cap_idx {
+	ZIP_CORE_NUM_CAP_IDX = 0x0,
+	ZIP_CLUSTER_COMP_NUM_CAP_IDX,
+	ZIP_CLUSTER_DECOMP_NUM_CAP_IDX,
+	ZIP_DECOMP_ENABLE_BITMAP_IDX,
+	ZIP_COMP_ENABLE_BITMAP_IDX,
+	ZIP_DRV_ALG_BITMAP_IDX,
+	ZIP_DEV_ALG_BITMAP_IDX,
+};
+
+static const u32 zip_pre_store_caps[] = {
+	ZIP_CORE_NUM_CAP,
+	ZIP_CLUSTER_COMP_NUM_CAP,
+	ZIP_CLUSTER_DECOMP_NUM_CAP,
+	ZIP_DECOMP_ENABLE_BITMAP,
+	ZIP_COMP_ENABLE_BITMAP,
+	ZIP_DRV_ALG_BITMAP,
+	ZIP_DEV_ALG_BITMAP,
+};
+
 enum {
 	HZIP_COMP_CORE0,
 	HZIP_COMP_CORE1,
@@ -442,7 +462,7 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
 
-	cap_val = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_DRV_ALG_BITMAP, qm->cap_ver);
+	cap_val = qm->cap_tables.dev_cap_table[ZIP_DRV_ALG_BITMAP_IDX].cap_val;
 	if ((alg & cap_val) == alg)
 		return true;
 
@@ -567,10 +587,8 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	}
 
 	/* let's open all compression/decompression cores */
-	dcomp_bm = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-				       ZIP_DECOMP_ENABLE_BITMAP, qm->cap_ver);
-	comp_bm = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-				      ZIP_COMP_ENABLE_BITMAP, qm->cap_ver);
+	dcomp_bm = qm->cap_tables.dev_cap_table[ZIP_DECOMP_ENABLE_BITMAP_IDX].cap_val;
+	comp_bm = qm->cap_tables.dev_cap_table[ZIP_COMP_ENABLE_BITMAP_IDX].cap_val;
 	writel(HZIP_DECOMP_CHECK_ENABLE | dcomp_bm | comp_bm, base + HZIP_CLOCK_GATE_CTRL);
 
 	/* enable sqc,cqc writeback */
@@ -797,9 +815,8 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 	char buf[HZIP_BUF_SIZE];
 	int i;
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
-	zip_comp_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CLUSTER_COMP_NUM_CAP,
-						qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
+	zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
 
 	for (i = 0; i < zip_core_num; i++) {
 		if (i < zip_comp_core_num)
@@ -941,7 +958,7 @@ static int hisi_zip_show_last_regs_init(struct hisi_qm *qm)
 	u32 zip_core_num;
 	int i, j, idx;
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
 
 	debug->last_words = kcalloc(core_dfx_regs_num * zip_core_num + com_dfx_regs_num,
 				    sizeof(unsigned int), GFP_KERNEL);
@@ -997,9 +1014,9 @@ static void hisi_zip_show_last_dfx_regs(struct hisi_qm *qm)
 				 hzip_com_dfx_regs[i].name, debug->last_words[i], val);
 	}
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
-	zip_comp_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CLUSTER_COMP_NUM_CAP,
-						qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
+	zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
+
 	for (i = 0; i < zip_core_num; i++) {
 		if (i < zip_comp_core_num)
 			scnprintf(buf, sizeof(buf), "Comp_core-%d", i);
@@ -1155,6 +1172,28 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	return ret;
 }
 
+static int zip_pre_store_cap_reg(struct hisi_qm *qm)
+{
+	struct hisi_qm_cap_record *zip_cap;
+	struct pci_dev *pdev = qm->pdev;
+	size_t i, size;
+
+	size = ARRAY_SIZE(zip_pre_store_caps);
+	zip_cap = devm_kzalloc(&pdev->dev, sizeof(*zip_cap) * size, GFP_KERNEL);
+	if (!zip_cap)
+		return -ENOMEM;
+
+	for (i = 0; i < size; i++) {
+		zip_cap[i].type = zip_pre_store_caps[i];
+		zip_cap[i].cap_val = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+				     zip_pre_store_caps[i], qm->cap_ver);
+	}
+
+	qm->cap_tables.dev_cap_table = zip_cap;
+
+	return 0;
+}
+
 static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1193,7 +1232,15 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
-	alg_msk = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_DEV_ALG_BITMAP, qm->cap_ver);
+	/* Fetch and save the value of capability registers */
+	ret = zip_pre_store_cap_reg(qm);
+	if (ret) {
+		pci_err(qm->pdev, "Failed to pre-store capability registers!\n");
+		hisi_qm_uninit(qm);
+		return ret;
+	}
+
+	alg_msk = qm->cap_tables.dev_cap_table[ZIP_DEV_ALG_BITMAP_IDX].cap_val;
 	ret = hisi_qm_set_algs(qm, alg_msk, zip_dev_algs, ARRAY_SIZE(zip_dev_algs));
 	if (ret) {
 		pci_err(qm->pdev, "Failed to set zip algs!\n");
-- 
2.43.0



