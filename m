Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FB91487E0;
	Tue, 23 Jan 2024 00:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969163; cv=none; b=q6oDwXAx5GEpSb9wyqFA3h9kMwaKVtJIxC0SqA7wOEE0FTWMsLBJMa7zxAvUQbVRlWrF/N6QdQgYAKaAPtueSqABIf/Gs6xuJSt6v5KbchtZ0vpv/zGc7ZhkagiWhFJe+E/EBWtOnOpoGZUESYO7ZWzQSL9bGOH+HVm+Wl8a50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969163; c=relaxed/simple;
	bh=o3pPUUUOBV5AUkUAsV6A0YBNdWk/oz5EN8ThbmH7jA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+wVxX1/2mW3GLp6Lz3p1D+4+hBkHLpRjfIwX6dIjWb2F8BGC5KYkWuWp+xVfiTDa4s6L6OntU+6fLHcxUE11/9lRB31nRHKc2eW97qOnpehUsPM0TDjkUtyFsXMOr+wgUh/ary7g+Il7u1LG2MZBUSy5a8VTQxnTCqI9VKZZeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0SJdZ1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0SJdZ1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF510C433C7;
	Tue, 23 Jan 2024 00:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969162;
	bh=o3pPUUUOBV5AUkUAsV6A0YBNdWk/oz5EN8ThbmH7jA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0SJdZ1aec5e5zCHHeAMsX/eLCpr3YnAJihkHVV0tgsCvsgtk1T+0CZBTHKFwjMLu
	 hzC9UCxmTs0uQrc0lyDbTdlZLccHCQnZM/2HDfq1gJHwRVd0BKzbrRorft4eyRtl2/
	 L1YH2FuH2Iz2X9Uik8hA5qhQe7VlN72vBaP45d4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/641] crypto: hisilicon/sec2 - save capability registers in probe process
Date: Mon, 22 Jan 2024 15:49:30 -0800
Message-ID: <20240122235820.113381204@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit f1115b0096c3163592e04e74f5a7548c25bda957 ]

Pre-store the valid value of the sec alg support related capability
register in sec_qm_init(), which will be called by probe process.
It can reduce the number of capability register queries and avoid
obtaining incorrect values in abnormal scenarios, such as reset
failed and the memory space disabled.

Fixes: 921715b6b782 ("crypto: hisilicon/sec - get algorithm bitmap from registers")
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  7 ++++
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 10 ++++-
 drivers/crypto/hisilicon/sec2/sec_main.c   | 43 ++++++++++++++++++++--
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 3e57fc04b377..410c83712e28 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -220,6 +220,13 @@ enum sec_cap_type {
 	SEC_CORE4_ALG_BITMAP_HIGH,
 };
 
+enum sec_cap_reg_record_idx {
+	SEC_DRV_ALG_BITMAP_LOW_IDX = 0x0,
+	SEC_DRV_ALG_BITMAP_HIGH_IDX,
+	SEC_DEV_ALG_BITMAP_LOW_IDX,
+	SEC_DEV_ALG_BITMAP_HIGH_IDX,
+};
+
 void sec_destroy_qps(struct hisi_qp **qps, int qp_num);
 struct hisi_qp **sec_create_qps(void);
 int sec_register_to_crypto(struct hisi_qm *qm);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 6fcabbc87860..ba7f305d43c1 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2547,9 +2547,12 @@ static int sec_register_aead(u64 alg_mask)
 
 int sec_register_to_crypto(struct hisi_qm *qm)
 {
-	u64 alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH, SEC_DRV_ALG_BITMAP_LOW);
+	u64 alg_mask;
 	int ret = 0;
 
+	alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH_IDX,
+				      SEC_DRV_ALG_BITMAP_LOW_IDX);
+
 	mutex_lock(&sec_algs_lock);
 	if (sec_available_devs) {
 		sec_available_devs++;
@@ -2578,7 +2581,10 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
-	u64 alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH, SEC_DRV_ALG_BITMAP_LOW);
+	u64 alg_mask;
+
+	alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH_IDX,
+				      SEC_DRV_ALG_BITMAP_LOW_IDX);
 
 	mutex_lock(&sec_algs_lock);
 	if (--sec_available_devs)
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 2eceab7600ca..878d94ab5d6d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -167,6 +167,13 @@ static const struct hisi_qm_cap_info sec_basic_info[] = {
 	{SEC_CORE4_ALG_BITMAP_HIGH, 0x3170, 0, GENMASK(31, 0), 0x3FFF, 0x3FFF, 0x3FFF},
 };
 
+static const u32 sec_pre_store_caps[] = {
+	SEC_DRV_ALG_BITMAP_LOW,
+	SEC_DRV_ALG_BITMAP_HIGH,
+	SEC_DEV_ALG_BITMAP_LOW,
+	SEC_DEV_ALG_BITMAP_HIGH,
+};
+
 static const struct qm_dev_alg sec_dev_algs[] = { {
 		.alg_msk = SEC_CIPHER_BITMAP,
 		.alg = "cipher\n",
@@ -388,8 +395,8 @@ u64 sec_get_alg_bitmap(struct hisi_qm *qm, u32 high, u32 low)
 {
 	u32 cap_val_h, cap_val_l;
 
-	cap_val_h = hisi_qm_get_hw_info(qm, sec_basic_info, high, qm->cap_ver);
-	cap_val_l = hisi_qm_get_hw_info(qm, sec_basic_info, low, qm->cap_ver);
+	cap_val_h = qm->cap_tables.dev_cap_table[high].cap_val;
+	cap_val_l = qm->cap_tables.dev_cap_table[low].cap_val;
 
 	return ((u64)cap_val_h << SEC_ALG_BITMAP_SHIFT) | (u64)cap_val_l;
 }
@@ -1071,6 +1078,28 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	return ret;
 }
 
+static int sec_pre_store_cap_reg(struct hisi_qm *qm)
+{
+	struct hisi_qm_cap_record *sec_cap;
+	struct pci_dev *pdev = qm->pdev;
+	size_t i, size;
+
+	size = ARRAY_SIZE(sec_pre_store_caps);
+	sec_cap = devm_kzalloc(&pdev->dev, sizeof(*sec_cap) * size, GFP_KERNEL);
+	if (!sec_cap)
+		return -ENOMEM;
+
+	for (i = 0; i < size; i++) {
+		sec_cap[i].type = sec_pre_store_caps[i];
+		sec_cap[i].cap_val = hisi_qm_get_hw_info(qm, sec_basic_info,
+				     sec_pre_store_caps[i], qm->cap_ver);
+	}
+
+	qm->cap_tables.dev_cap_table = sec_cap;
+
+	return 0;
+}
+
 static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1108,7 +1137,15 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
-	alg_msk = sec_get_alg_bitmap(qm, SEC_DEV_ALG_BITMAP_HIGH, SEC_DEV_ALG_BITMAP_LOW);
+	/* Fetch and save the value of capability registers */
+	ret = sec_pre_store_cap_reg(qm);
+	if (ret) {
+		pci_err(qm->pdev, "Failed to pre-store capability registers!\n");
+		hisi_qm_uninit(qm);
+		return ret;
+	}
+
+	alg_msk = sec_get_alg_bitmap(qm, SEC_DEV_ALG_BITMAP_HIGH_IDX, SEC_DEV_ALG_BITMAP_LOW_IDX);
 	ret = hisi_qm_set_algs(qm, alg_msk, sec_dev_algs, ARRAY_SIZE(sec_dev_algs));
 	if (ret) {
 		pci_err(qm->pdev, "Failed to set sec algs!\n");
-- 
2.43.0



