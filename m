Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781464432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2798C433C8;
	Mon, 11 Sep 2023 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443447;
	bh=KvJBMAsfDScA9E6sWQO69EwOzLrs9oGcu547XJQolcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAdYj2Latnrvo/R/GUM7p382ee/5LzsFbZe2mVnV5tZQuqdTYNIJX0YUzgPaTSza8
	 rYJFX27jW4jYmTxfCbX2telNB89tV70eBTTRGM6dqc5dxT980fMgM7kzacdq1I2Mjm
	 iZ22prXbP+vTcEiuMFEYYGJLqmbQWusP3oQMiVRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	kernel test robot <lkp@intel.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 380/737] drm/mediatek: Fix void-pointer-to-enum-cast warning
Date: Mon, 11 Sep 2023 15:43:59 +0200
Message-ID: <20230911134701.188288395@linuxfoundation.org>
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

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 89cba955f879b1c6a9a71f67c8fb92ea8f5dfdc4 ]

1. Fix build warning message in mtk_disp_ovl_adaptor.c
>> drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c:415:10:
  warning: cast to smaller integer type 'enum mtk_ovl_adaptor_comp_type'
  from 'const void *' [-Wvoid-pointer-to-enum-cast]

  type = (enum mtk_ovl_adaptor_comp_type)of_id->data;

         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         1 warning generated.

2. Also fix the same warning message in mtk_drm_drv.c
>> drivers/gpu/drm/mediatek/mtk_drm_drv.c:832:15:
   warning: cast to smaller integer type 'enum mtk_ddp_comp_type'
   from 'const void *' [-Wvoid-pointer-to-enum-cast]

   comp_type = (enum mtk_ddp_comp_type)of_id->data;

               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
               1 warning generated.

Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Fixes: 453c3364632a ("drm/mediatek: Add ovl_adaptor support for MT8195")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305042054.ZtWME9OU-lkp@intel.com/
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230621075421.1982-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c | 2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
index c0a38f5217eee..f2f6a5c01a6d2 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
@@ -426,7 +426,7 @@ static int ovl_adaptor_comp_init(struct device *dev, struct component_match **ma
 			continue;
 		}
 
-		type = (enum mtk_ovl_adaptor_comp_type)of_id->data;
+		type = (enum mtk_ovl_adaptor_comp_type)(uintptr_t)of_id->data;
 		id = ovl_adaptor_comp_get_id(dev, node, type);
 		if (id < 0) {
 			dev_warn(dev, "Skipping unknown component %pOF\n",
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index fc217e0acd45d..30d10f21562f4 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -832,7 +832,7 @@ static int mtk_drm_probe(struct platform_device *pdev)
 			continue;
 		}
 
-		comp_type = (enum mtk_ddp_comp_type)of_id->data;
+		comp_type = (enum mtk_ddp_comp_type)(uintptr_t)of_id->data;
 
 		if (comp_type == MTK_DISP_MUTEX) {
 			int id;
-- 
2.40.1



