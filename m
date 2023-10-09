Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00A1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icaMY5o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3BEC433CB;
	Mon,  9 Oct 2023 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857598;
	bh=4Vy+Il+KI/KEktN4eqz8vLLNC8cj3LUOOFnj405H59I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icaMY5o/UmXhRYHe45yCCy5fMqfn0C6ccKXG76zSvUS1YBFzRMuMoJJs8MrzLHJPi
	 qzuj6sQ0NO12uNcBpKE4Z/o39XtccCZQHu4ZfzPfJjx9+YK8swnP1ZnuRReJ/Lt8IF
	 EVC230p/7iQ61KlfTJ/7RkE02XaI1GYefzsyeTZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laura Nao <laura.nao@collabora.com>,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/162] iommu/mediatek: Fix share pgtable for iova over 4GB
Date: Mon,  9 Oct 2023 15:01:17 +0200
Message-ID: <20231009130125.573228273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit b07eba71a512eb196cbcc29765c29c8c29b11b59 ]

In mt8192/mt8186, there is only one MM IOMMU that supports 16GB iova
space, which is shared by display, vcodec and camera. These two SoC use
one pgtable and have not the flag SHARE_PGTABLE, we should also keep
share pgtable for this case.

In mtk_iommu_domain_finalise, MM IOMMU always share pgtable, thus remove
the flag SHARE_PGTABLE checking. Infra IOMMU always uses independent
pgtable.

Fixes: cf69ef46dbd9 ("iommu/mediatek: Fix two IOMMU share pagetable issue")
Reported-by: Laura Nao <laura.nao@collabora.com>
Closes: https://lore.kernel.org/linux-iommu/20230818154156.314742-1-laura.nao@collabora.com/
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Laura Nao <laura.nao@collabora.com>
Link: https://lore.kernel.org/r/20230819081443.8333-1-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 9673cd60c84fc..0ba2a63a9538a 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -223,7 +223,7 @@ struct mtk_iommu_data {
 	struct device			*smicomm_dev;
 
 	struct mtk_iommu_bank_data	*bank;
-	struct mtk_iommu_domain		*share_dom; /* For 2 HWs share pgtable */
+	struct mtk_iommu_domain		*share_dom;
 
 	struct regmap			*pericfg;
 	struct mutex			mutex; /* Protect m4u_group/m4u_dom above */
@@ -579,8 +579,8 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
 	struct mtk_iommu_domain	*share_dom = data->share_dom;
 	const struct mtk_iommu_iova_region *region;
 
-	/* Always use share domain in sharing pgtable case */
-	if (MTK_IOMMU_HAS_FLAG(data->plat_data, SHARE_PGTABLE) && share_dom) {
+	/* Share pgtable when 2 MM IOMMU share the pgtable or one IOMMU use multiple iova ranges */
+	if (share_dom) {
 		dom->iop = share_dom->iop;
 		dom->cfg = share_dom->cfg;
 		dom->domain.pgsize_bitmap = share_dom->cfg.pgsize_bitmap;
@@ -613,8 +613,7 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
 	/* Update our support page sizes bitmap */
 	dom->domain.pgsize_bitmap = dom->cfg.pgsize_bitmap;
 
-	if (MTK_IOMMU_HAS_FLAG(data->plat_data, SHARE_PGTABLE))
-		data->share_dom = dom;
+	data->share_dom = dom;
 
 update_iova_region:
 	/* Update the iova region for this domain */
-- 
2.40.1



