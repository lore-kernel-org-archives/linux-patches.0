Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3E283687;
	Wed, 23 Apr 2025 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421636; cv=none; b=rifhtq3ANBrv87xD1gyfZrz+2NE+JkfJ+ukNQEXv/43AHX26NE2iGDJsRzytGtc2TzIqK7MYCuDthuGcCSGzRICKtujvNWT19hM+wiYN4f/VyT7anxkRSMJND29g7zu1+hXnmOtvwNWT24EmB68yvxUrm+aSRQnEhj5mp8zCPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421636; c=relaxed/simple;
	bh=GLE/qZt/G6FW06lpenBx4ulj4DKS5Es4iv+G++XsHwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIUgbkV1b9qyY7WdOFMqYMvWyEqEBPYgwGeA7gT1Y6L70YDkr8qpBrgkegsp69iIUmeYjSx7G0EZVmzSkfRmT23/LVVTH6rCrLpCBtU5b8fMb09KA7J5NQqUfs4RuyaAK+s97MHFY7snste5xBmB+q7xpeKniqYxdmglzlCzSq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMg5n69I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMg5n69I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA3EC4CEE2;
	Wed, 23 Apr 2025 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421636;
	bh=GLE/qZt/G6FW06lpenBx4ulj4DKS5Es4iv+G++XsHwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMg5n69Ian5rx4BY8OpghLkXtE759cc85PA07PbIMDiNXaNSW6Mop2l35fWos4FW7
	 ryUyY5Vsu7LIga5ns1/sOLvBjztj+KcUpdq5zWO/pcz/JA/PL56s+XM/6wqWg2p3d+
	 4CBrA6H5Z75nwFuNx6R7LTfsDbqQc7KrdZWdGRNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chee Yin Wong <chee.yin.wong@intel.com>,
	John Harrison <john.c.harrison@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.14 214/241] drm/xe: Set LRC addresses before guc load
Date: Wed, 23 Apr 2025 16:44:38 +0200
Message-ID: <20250423142629.303583339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 6405f5b70b1c240ffddef01c7a140498f47d4fe7 upstream.

The metadata saved in the ADS is read by GuC when it's initialized.
Saving the addresses to the LRCs when they are populated is too late as
GuC will keep using the old ones.

This was causing GuC to use the RCS LRC for any engine class. It's not a
big problem on a Linux-only scenario since the they are used by GuC only
on media engines when the watchdog is triggered. However, in a
virtualization scenario with Windows as the VF, it causes the wrong LRCs
to be loaded as the watchdog is used for all engines.

Fix it by letting guc_golden_lrc_init() initialize the metadata, like
other *_init() functions, and later guc_golden_lrc_populate() to copy
the LRCs to the right places. The former is called before the second GuC
load, while the latter is called after LRCs have been recorded.

Cc: Chee Yin Wong <chee.yin.wong@intel.com>
Cc: John Harrison <john.c.harrison@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: <stable@vger.kernel.org> # v6.11+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Tested-by: Chee Yin Wong <chee.yin.wong@intel.com>
Link: https://lore.kernel.org/r/20250409-fix-guc-ads-v1-1-494135f7a5d0@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit c31a0b6402d15b530514eee9925adfcb8cfbb1c9)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ads.c |   75 ++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -490,24 +490,52 @@ static void fill_engine_enable_masks(str
 		       engine_enable_mask(gt, XE_ENGINE_CLASS_OTHER));
 }
 
-static void guc_prep_golden_lrc_null(struct xe_guc_ads *ads)
+/*
+ * Write the offsets corresponding to the golden LRCs. The actual data is
+ * populated later by guc_golden_lrc_populate()
+ */
+static void guc_golden_lrc_init(struct xe_guc_ads *ads)
 {
 	struct xe_device *xe = ads_to_xe(ads);
+	struct xe_gt *gt = ads_to_gt(ads);
 	struct iosys_map info_map = IOSYS_MAP_INIT_OFFSET(ads_to_map(ads),
 			offsetof(struct __guc_ads_blob, system_info));
-	u8 guc_class;
+	size_t alloc_size, real_size;
+	u32 addr_ggtt, offset;
+	int class;
+
+	offset = guc_ads_golden_lrc_offset(ads);
+	addr_ggtt = xe_bo_ggtt_addr(ads->bo) + offset;
+
+	for (class = 0; class < XE_ENGINE_CLASS_MAX; ++class) {
+		u8 guc_class;
+
+		guc_class = xe_engine_class_to_guc_class(class);
 
-	for (guc_class = 0; guc_class <= GUC_MAX_ENGINE_CLASSES; ++guc_class) {
 		if (!info_map_read(xe, &info_map,
 				   engine_enabled_masks[guc_class]))
 			continue;
 
+		real_size = xe_gt_lrc_size(gt, class);
+		alloc_size = PAGE_ALIGN(real_size);
+
+		/*
+		 * This interface is slightly confusing. We need to pass the
+		 * base address of the full golden context and the size of just
+		 * the engine state, which is the section of the context image
+		 * that starts after the execlists LRC registers. This is
+		 * required to allow the GuC to restore just the engine state
+		 * when a watchdog reset occurs.
+		 * We calculate the engine state size by removing the size of
+		 * what comes before it in the context image (which is identical
+		 * on all engines).
+		 */
 		ads_blob_write(ads, ads.eng_state_size[guc_class],
-			       guc_ads_golden_lrc_size(ads) -
-			       xe_lrc_skip_size(xe));
+			       real_size - xe_lrc_skip_size(xe));
 		ads_blob_write(ads, ads.golden_context_lrca[guc_class],
-			       xe_bo_ggtt_addr(ads->bo) +
-			       guc_ads_golden_lrc_offset(ads));
+			       addr_ggtt);
+
+		addr_ggtt += alloc_size;
 	}
 }
 
@@ -857,7 +885,7 @@ void xe_guc_ads_populate_minimal(struct
 
 	xe_map_memset(ads_to_xe(ads), ads_to_map(ads), 0, 0, ads->bo->size);
 	guc_policies_init(ads);
-	guc_prep_golden_lrc_null(ads);
+	guc_golden_lrc_init(ads);
 	guc_mapping_table_init_invalid(gt, &info_map);
 	guc_doorbell_init(ads);
 
@@ -883,7 +911,7 @@ void xe_guc_ads_populate(struct xe_guc_a
 	guc_policies_init(ads);
 	fill_engine_enable_masks(gt, &info_map);
 	guc_mmio_reg_state_init(ads);
-	guc_prep_golden_lrc_null(ads);
+	guc_golden_lrc_init(ads);
 	guc_mapping_table_init(gt, &info_map);
 	guc_capture_prep_lists(ads);
 	guc_doorbell_init(ads);
@@ -903,18 +931,22 @@ void xe_guc_ads_populate(struct xe_guc_a
 		       guc_ads_private_data_offset(ads));
 }
 
-static void guc_populate_golden_lrc(struct xe_guc_ads *ads)
+/*
+ * After the golden LRC's are recorded for each engine class by the first
+ * submission, copy them to the ADS, as initialized earlier by
+ * guc_golden_lrc_init().
+ */
+static void guc_golden_lrc_populate(struct xe_guc_ads *ads)
 {
 	struct xe_device *xe = ads_to_xe(ads);
 	struct xe_gt *gt = ads_to_gt(ads);
 	struct iosys_map info_map = IOSYS_MAP_INIT_OFFSET(ads_to_map(ads),
 			offsetof(struct __guc_ads_blob, system_info));
 	size_t total_size = 0, alloc_size, real_size;
-	u32 addr_ggtt, offset;
+	u32 offset;
 	int class;
 
 	offset = guc_ads_golden_lrc_offset(ads);
-	addr_ggtt = xe_bo_ggtt_addr(ads->bo) + offset;
 
 	for (class = 0; class < XE_ENGINE_CLASS_MAX; ++class) {
 		u8 guc_class;
@@ -931,26 +963,9 @@ static void guc_populate_golden_lrc(stru
 		alloc_size = PAGE_ALIGN(real_size);
 		total_size += alloc_size;
 
-		/*
-		 * This interface is slightly confusing. We need to pass the
-		 * base address of the full golden context and the size of just
-		 * the engine state, which is the section of the context image
-		 * that starts after the execlists LRC registers. This is
-		 * required to allow the GuC to restore just the engine state
-		 * when a watchdog reset occurs.
-		 * We calculate the engine state size by removing the size of
-		 * what comes before it in the context image (which is identical
-		 * on all engines).
-		 */
-		ads_blob_write(ads, ads.eng_state_size[guc_class],
-			       real_size - xe_lrc_skip_size(xe));
-		ads_blob_write(ads, ads.golden_context_lrca[guc_class],
-			       addr_ggtt);
-
 		xe_map_memcpy_to(xe, ads_to_map(ads), offset,
 				 gt->default_lrc[class], real_size);
 
-		addr_ggtt += alloc_size;
 		offset += alloc_size;
 	}
 
@@ -959,7 +974,7 @@ static void guc_populate_golden_lrc(stru
 
 void xe_guc_ads_populate_post_load(struct xe_guc_ads *ads)
 {
-	guc_populate_golden_lrc(ads);
+	guc_golden_lrc_populate(ads);
 }
 
 static int guc_ads_action_update_policies(struct xe_guc_ads *ads, u32 policy_offset)


