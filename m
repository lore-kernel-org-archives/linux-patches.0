Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B262F39B1;
	Tue, 11 Nov 2025 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823247; cv=none; b=svrfJXss5tjVQL050eHN92lRNf2QRTQS1vFPRBRFU4lvKyc8JqS8rgrRmvLic25ysVllLUwiLdZ6BHMVGsugB7VtFEnTawUTAjnmneyPGDBX72jYzYIuB8D7cNR7YdmZ0424zFfIc3ioVzLABRT0InqCn5FObmsHT3DdtKFBDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823247; c=relaxed/simple;
	bh=ch+EWr7evOAitxBZi/ODezADFhtcWOdlf56Pef3m5l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUnQfY8QJ/6CH8VrfAAcFhrA1kM5AWXLewh46SWDa9/YLnuCMiZJ65AFLJkRnvCPG5ZIaI+k9DfftEQioPXzAHfvhsjotlIN4y51ynOXGK7bWA9OVqX/WphhCoWci52NEa8cJGIdaGeTspq9FV53Smv8ngK9ufZc0wDwZWadeFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwhGG6dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwhGG6dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B851C16AAE;
	Tue, 11 Nov 2025 01:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823247;
	bh=ch+EWr7evOAitxBZi/ODezADFhtcWOdlf56Pef3m5l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwhGG6dxcBQ8ongBafXBo7dxisXTBoZUSV69rPxg2JQS5JAlZWWV1kq44MqVmC+pn
	 0O0YK2fneh/Wx4Qlu5u7bOSVHCPHfVxpRmnp9Cv7aVJdnoWzno0miil+PizigYwCvy
	 CfgskadMNLR0r2i5sZsBXAdh6K6McTLKFHzUS4p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 261/849] drm/xe/pf: Program LMTT directory pointer on all GTs within a tile
Date: Tue, 11 Nov 2025 09:37:11 +0900
Message-ID: <20251111004542.743641214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit ad69d62588cd6bf8cddaff5e3e2eb1b8dd876d35 ]

Previously, the LMTT directory pointer was only programmed for primary GT
within a tile. However, to ensure correct Local Memory access by VFs,
the LMTT configuration must be programmed on all GTs within the tile.
Lets program the LMTT directory pointer on every GT of the tile
to guarantee proper LMEM access across all GTs on VFs.

HSD: 18042797646
Bspec: 67468
Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250805091850.1508240-1-piotr.piorkowski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lmtt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lmtt.c b/drivers/gpu/drm/xe/xe_lmtt.c
index a2000307d5bf9..a78c9d474a6ef 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.c
+++ b/drivers/gpu/drm/xe/xe_lmtt.c
@@ -195,14 +195,17 @@ static void lmtt_setup_dir_ptr(struct xe_lmtt *lmtt)
 	struct xe_tile *tile = lmtt_to_tile(lmtt);
 	struct xe_device *xe = tile_to_xe(tile);
 	dma_addr_t offset = xe_bo_main_addr(lmtt->pd->bo, XE_PAGE_SIZE);
+	struct xe_gt *gt;
+	u8 id;
 
 	lmtt_debug(lmtt, "DIR offset %pad\n", &offset);
 	lmtt_assert(lmtt, xe_bo_is_vram(lmtt->pd->bo));
 	lmtt_assert(lmtt, IS_ALIGNED(offset, SZ_64K));
 
-	xe_mmio_write32(&tile->mmio,
-			GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG,
-			LMEM_EN | REG_FIELD_PREP(LMTT_DIR_PTR, offset / SZ_64K));
+	for_each_gt_on_tile(gt, tile, id)
+		xe_mmio_write32(&gt->mmio,
+				GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG,
+				LMEM_EN | REG_FIELD_PREP(LMTT_DIR_PTR, offset / SZ_64K));
 }
 
 /**
-- 
2.51.0



