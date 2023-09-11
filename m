Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09711706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC836C433C9;
	Mon, 11 Sep 2023 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443884;
	bh=mzL2IYMeLbZ+OBh+qz84XrEEhBd0XLVgCimzSDu/2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+RIJiMY2c8MOk4ZCSSS8pM1OE702yyhwrtqzkBWjTHE9zRbqCJBNse0QNx9xEtQD
	 xHSJwJfHw62QdMAhx60u6M1wA3erkMRZPpe5VQUNnMvUg47dEj497S9g3qZComlaJJ
	 EbqwyOKWfipPODroizaxNSzwhbd1Pgvn/triNf7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chengci.Xu" <chengci.xu@mediatek.com>,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 535/737] iommu/mediatek: Fix two IOMMU share pagetable issue
Date: Mon, 11 Sep 2023 15:46:34 +0200
Message-ID: <20230911134705.512962095@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengci.Xu <chengci.xu@mediatek.com>

[ Upstream commit cf69ef46dbd980a0b1c956d668e066a73e0acd0f ]

Prepare for mt8188 to fix a two IOMMU HWs share pagetable issue.

We have two MM IOMMU HWs in mt8188, one is VPP-IOMMU, the other is
VDO-IOMMU. The 2 MM IOMMU HWs share pagetable don't work in this case:
 a) VPP-IOMMU probe firstly.
 b) VDO-IOMMU probe.
 c) The master for VDO-IOMMU probe (means frstdata is vpp-iommu).
 d) The master in another domain probe. No matter it is vdo or vpp.
Then it still create a new pagetable in step d). The problem is
"frstdata->bank[0]->m4u_dom" was not initialized. Then when d) enter, it
still create a new one.

In this patch, we create a new variable "share_dom" for this share
pgtable case, it should be helpful for readable. and put all the share
pgtable logic in the mtk_iommu_domain_finalise.

In mt8195, the master of VPP-IOMMU probes before than VDO-IOMMU
from its dtsi node sequence, we don't see this issue in it. Prepare for
mt8188.

Fixes: 645b87c190c9 ("iommu/mediatek: Fix 2 HW sharing pgtable issue")
Signed-off-by: Chengci.Xu <chengci.xu@mediatek.com>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://lore.kernel.org/r/20230602090227.7264-3-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index e93906d6e112e..c2764891a779c 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -258,6 +258,8 @@ struct mtk_iommu_data {
 	struct device			*smicomm_dev;
 
 	struct mtk_iommu_bank_data	*bank;
+	struct mtk_iommu_domain		*share_dom; /* For 2 HWs share pgtable */
+
 	struct regmap			*pericfg;
 	struct mutex			mutex; /* Protect m4u_group/m4u_dom above */
 
@@ -620,15 +622,14 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
 				     struct mtk_iommu_data *data,
 				     unsigned int region_id)
 {
+	struct mtk_iommu_domain	*share_dom = data->share_dom;
 	const struct mtk_iommu_iova_region *region;
-	struct mtk_iommu_domain	*m4u_dom;
-
-	/* Always use bank0 in sharing pgtable case */
-	m4u_dom = data->bank[0].m4u_dom;
-	if (m4u_dom) {
-		dom->iop = m4u_dom->iop;
-		dom->cfg = m4u_dom->cfg;
-		dom->domain.pgsize_bitmap = m4u_dom->cfg.pgsize_bitmap;
+
+	/* Always use share domain in sharing pgtable case */
+	if (MTK_IOMMU_HAS_FLAG(data->plat_data, SHARE_PGTABLE) && share_dom) {
+		dom->iop = share_dom->iop;
+		dom->cfg = share_dom->cfg;
+		dom->domain.pgsize_bitmap = share_dom->cfg.pgsize_bitmap;
 		goto update_iova_region;
 	}
 
@@ -658,6 +659,9 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
 	/* Update our support page sizes bitmap */
 	dom->domain.pgsize_bitmap = dom->cfg.pgsize_bitmap;
 
+	if (MTK_IOMMU_HAS_FLAG(data->plat_data, SHARE_PGTABLE))
+		data->share_dom = dom;
+
 update_iova_region:
 	/* Update the iova region for this domain */
 	region = data->plat_data->iova_region + region_id;
@@ -708,7 +712,9 @@ static int mtk_iommu_attach_device(struct iommu_domain *domain,
 		/* Data is in the frstdata in sharing pgtable case. */
 		frstdata = mtk_iommu_get_frst_data(hw_list);
 
+		mutex_lock(&frstdata->mutex);
 		ret = mtk_iommu_domain_finalise(dom, frstdata, region_id);
+		mutex_unlock(&frstdata->mutex);
 		if (ret) {
 			mutex_unlock(&dom->mutex);
 			return ret;
-- 
2.40.1



