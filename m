Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC155A7B8;
	Tue, 23 Jan 2024 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974345; cv=none; b=oI5EkEoNjt0MaZk8Oojs1TqWpwbreZUR5AHnb/DhkFWkv1ly39SpKM415/Cn3ipoxhzj0U7QAl6uP940A9xB5GtDrgxisulomuqirXKgffI6YCB3Tpy0qx3+jFt4f2MFyNxgVB35Gbz/Hx2Xf8XmzHVJ0FnNGFR1eYb298D+c7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974345; c=relaxed/simple;
	bh=2YFxGjiVXx1FKEcOj1xx6iUGfXjcDT49tD4HSeq1UvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypt0FaFny5lmUkQIzRj9XQZjMsGOmTcXXbrsT/hdD0/oC+RNuvkNwAGxbRFKBO2BgqEBlaGXtQYSzu3B9N5PU/InHeKb2M9RLHhECf6AAPd5KQgumdbeXHYHlvKAyKU1yIbKAlOYtZNqHIuvo0m0vzBVlhOwmgG1Ppu86Hrlv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpO4sgFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpO4sgFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036C2C43390;
	Tue, 23 Jan 2024 01:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974345;
	bh=2YFxGjiVXx1FKEcOj1xx6iUGfXjcDT49tD4HSeq1UvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpO4sgFSYwiW4kwhmJ7/SrDqDri3qS3px5piyoAOUPmbxB0qskDeQYu6TQmIO62GE
	 1ZWn1qZj4zum22OBQ5tEjfg5Kkvze79S3+5kzNUL9/GSMr2IHgzMgt6ZULH7NtQH3/
	 MD0jvFuGKHJpl2hiksAW/t3pB0yYDd3T+aOXTcX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/583] crypto: hisilicon/sec2 - save capability registers in probe process
Date: Mon, 22 Jan 2024 15:51:49 -0800
Message-ID: <20240122235813.898235543@linuxfoundation.org>
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
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 13 +++++--
 drivers/crypto/hisilicon/sec2/sec_main.c   | 43 ++++++++++++++++++++--
 3 files changed, 57 insertions(+), 6 deletions(-)

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
index 074e50ef512c..c3a630cb27a6 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2543,8 +2543,12 @@ static int sec_register_aead(u64 alg_mask)
 
 int sec_register_to_crypto(struct hisi_qm *qm)
 {
-	u64 alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH, SEC_DRV_ALG_BITMAP_LOW);
-	int ret;
+	u64 alg_mask;
+	int ret = 0;
+
+	alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH_IDX,
+				      SEC_DRV_ALG_BITMAP_LOW_IDX);
+
 
 	ret = sec_register_skcipher(alg_mask);
 	if (ret)
@@ -2559,7 +2563,10 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
-	u64 alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH, SEC_DRV_ALG_BITMAP_LOW);
+	u64 alg_mask;
+
+	alg_mask = sec_get_alg_bitmap(qm, SEC_DRV_ALG_BITMAP_HIGH_IDX,
+				      SEC_DRV_ALG_BITMAP_LOW_IDX);
 
 	sec_unregister_aead(alg_mask, ARRAY_SIZE(sec_aeads));
 	sec_unregister_skcipher(alg_mask, ARRAY_SIZE(sec_skciphers));
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 5c39667507ab..bf02a6b2eed4 100644
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



