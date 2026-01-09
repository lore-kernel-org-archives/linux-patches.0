Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8DC35BDB3;
	Fri,  9 Jan 2026 12:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963116; cv=none; b=f4gi+LhcW0Am0cu3RE1e5wXVPVO5a/8R30kScnVXMQn5+k6GViTINIIfcmjtxNb2j7TJsHon/md5TrJnZlqLJEDfqL2UmnvmsE7ukSB6SaXKJ5ed1QSww38MAUigQJbdurpKYpoba2hJ7p4viMCpV97hh2s5DJ5Ndsh5W51dB58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963116; c=relaxed/simple;
	bh=+iOCW0Ue3NKHidH1gh6CNUxq6py1UjynQfWOP/2fSY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nANJ0RqI15G5aJgV+BVoghbqf7U4EGRvSTArgPUxavk/VID0rhaoucdEjXtBskUa+Yxrjq5KR8fFBr3bIq/mKFZFFMVrp/6L0KVLIFsMEkLuF9OtSUJ/vwOoybgpQZVbmKQrw9NP8r2zUP32UKPFuO6jLtMLX43CWhexbEfnrIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTMYA8fA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTMYA8fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36E2C4CEF1;
	Fri,  9 Jan 2026 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963116;
	bh=+iOCW0Ue3NKHidH1gh6CNUxq6py1UjynQfWOP/2fSY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTMYA8fAox+4BiigUwC39YHQyGop7pBfMs/Dt8xtpJOUYiBBhGJBT8ErulHB8xa7L
	 fk90Ol6ZjxHpvnVYaQdiqe0oj5L83ttDBaIAgCP/b3kM1uzl2MFuLtKm/ivQkCWfBU
	 GymetRROEBlejRJ1gHRaK340YavBY9pWbBFh6dH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 603/634] iommu/qcom: Index contexts by asid number to allow asid 0
Date: Fri,  9 Jan 2026 12:44:41 +0100
Message-ID: <20260109112140.317604766@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit ec5601661bfcdc206e6ceba1b97837e763dab1ba ]

This driver was indexing the contexts by asid-1, which is probably
done under the assumption that the first ASID is always 1.
Unfortunately this is not always true: at least for MSM8956 and
MSM8976's GPU IOMMU, the gpu_user context's ASID number is zero.
To allow using a zero asid number, index the contexts by `asid`
instead of by `asid - 1`.

While at it, also enhance human readability by renaming the
`num_ctxs` member of struct qcom_iommu_dev to `max_asid`.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230622092742.74819-5-angelogioacchino.delregno@collabora.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 6a3908ce56e6 ("iommu/qcom: fix device leak on of_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -51,8 +51,8 @@ struct qcom_iommu_dev {
 	struct clk_bulk_data clks[CLK_NUM];
 	void __iomem		*local_base;
 	u32			 sec_id;
-	u8			 num_ctxs;
-	struct qcom_iommu_ctx	*ctxs[];   /* indexed by asid-1 */
+	u8			 max_asid;
+	struct qcom_iommu_ctx	*ctxs[];   /* indexed by asid */
 };
 
 struct qcom_iommu_ctx {
@@ -94,7 +94,7 @@ static struct qcom_iommu_ctx * to_ctx(st
 	struct qcom_iommu_dev *qcom_iommu = d->iommu;
 	if (!qcom_iommu)
 		return NULL;
-	return qcom_iommu->ctxs[asid - 1];
+	return qcom_iommu->ctxs[asid];
 }
 
 static inline void
@@ -559,12 +559,10 @@ static int qcom_iommu_of_xlate(struct de
 	qcom_iommu = platform_get_drvdata(iommu_pdev);
 
 	/* make sure the asid specified in dt is valid, so we don't have
-	 * to sanity check this elsewhere, since 'asid - 1' is used to
-	 * index into qcom_iommu->ctxs:
+	 * to sanity check this elsewhere:
 	 */
-	if (WARN_ON(asid < 1) ||
-	    WARN_ON(asid > qcom_iommu->num_ctxs) ||
-	    WARN_ON(qcom_iommu->ctxs[asid - 1] == NULL)) {
+	if (WARN_ON(asid > qcom_iommu->max_asid) ||
+	    WARN_ON(qcom_iommu->ctxs[asid] == NULL)) {
 		put_device(&iommu_pdev->dev);
 		return -EINVAL;
 	}
@@ -722,7 +720,7 @@ static int qcom_iommu_ctx_probe(struct p
 
 	dev_dbg(dev, "found asid %u\n", ctx->asid);
 
-	qcom_iommu->ctxs[ctx->asid - 1] = ctx;
+	qcom_iommu->ctxs[ctx->asid] = ctx;
 
 	return 0;
 }
@@ -734,7 +732,7 @@ static void qcom_iommu_ctx_remove(struct
 
 	platform_set_drvdata(pdev, NULL);
 
-	qcom_iommu->ctxs[ctx->asid - 1] = NULL;
+	qcom_iommu->ctxs[ctx->asid] = NULL;
 }
 
 static const struct of_device_id ctx_of_match[] = {
@@ -781,11 +779,11 @@ static int qcom_iommu_device_probe(struc
 	for_each_child_of_node(dev->of_node, child)
 		max_asid = max(max_asid, get_asid(child));
 
-	qcom_iommu = devm_kzalloc(dev, struct_size(qcom_iommu, ctxs, max_asid),
+	qcom_iommu = devm_kzalloc(dev, struct_size(qcom_iommu, ctxs, max_asid + 1),
 				  GFP_KERNEL);
 	if (!qcom_iommu)
 		return -ENOMEM;
-	qcom_iommu->num_ctxs = max_asid;
+	qcom_iommu->max_asid = max_asid;
 	qcom_iommu->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);


