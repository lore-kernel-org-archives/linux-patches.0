Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8831E0F9;
	Mon, 18 Aug 2025 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522250; cv=none; b=AlRl0G6x03uPjyy7HwsWpPC+wy+df2CfWD0VG7dxBRuB3rzqUeWvVErE4f3bglfY3VpETl0ATiTvFFiCOU/SdzT1FMOxcLhNQzEA/c8DwzJohqX1JeSAbJxb24atyvJ6AsbIolj7hwihwSdaVPg0n050XWPX0sQN3h9Orj2mvgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522250; c=relaxed/simple;
	bh=wTaJeD0bIWeJ/ly0CeiOukIsK1l8Zc+5TcjsVLKItkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/19WJE2bEbUANyoInQ7BWXh2N9q4EAKnFkbvuHhciRKgYZMmLgOvdJ/KlLY7GvcdME/uOo6UnpbV7RAOnl+igvqwU6yS+YoL5l3rjJ7RQszXFo9CDbg3N5MO/ceZYrta/sGE+s6aCGpLmrv0aN5ce3nTqHTbi9le9p7mSTa/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW6RxYB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW6RxYB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE98AC4CEEB;
	Mon, 18 Aug 2025 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522250;
	bh=wTaJeD0bIWeJ/ly0CeiOukIsK1l8Zc+5TcjsVLKItkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vW6RxYB2B/YG7ktzdA9+T4vmwNCRVwFQSAa2581xGFT7cT0jcx8qLgzyDO/SlS30d
	 Ehk4AWm0cgnOSZpIwokxiQhI6p0qODGbrfSdm/Ze3hlqtFEH+meK3sHhnlpEltz+V6
	 WDlndW1bNbP+Nwq7Hc3Cvii+5cquDPHNpKUrJPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/444] drm/xe/xe_query: Use separate iterator while filling GT list
Date: Mon, 18 Aug 2025 14:44:03 +0200
Message-ID: <20250818124456.982468739@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit d4eb4a010262ea7801e576d1033b355910f2f7d4 ]

The 'id' value updated by for_each_gt() is the uapi GT ID of the GTs
being iterated over, and may skip over values if a GT is not present on
the device.  Use a separate iterator for GT list array assignments to
ensure that the array will be filled properly on future platforms where
index in the GT query list may not match the uapi ID.

v2:
 - Include the missing increment of the iterator.  (Jonathan)

Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250701201320.2514369-16-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_query.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 6fec5d1a1eb4..6e7c940d7e22 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -366,6 +366,7 @@ static int query_gt_list(struct xe_device *xe, struct drm_xe_device_query *query
 	struct drm_xe_query_gt_list __user *query_ptr =
 		u64_to_user_ptr(query->data);
 	struct drm_xe_query_gt_list *gt_list;
+	int iter = 0;
 	u8 id;
 
 	if (query->size == 0) {
@@ -383,12 +384,12 @@ static int query_gt_list(struct xe_device *xe, struct drm_xe_device_query *query
 
 	for_each_gt(gt, xe, id) {
 		if (xe_gt_is_media_type(gt))
-			gt_list->gt_list[id].type = DRM_XE_QUERY_GT_TYPE_MEDIA;
+			gt_list->gt_list[iter].type = DRM_XE_QUERY_GT_TYPE_MEDIA;
 		else
-			gt_list->gt_list[id].type = DRM_XE_QUERY_GT_TYPE_MAIN;
-		gt_list->gt_list[id].tile_id = gt_to_tile(gt)->id;
-		gt_list->gt_list[id].gt_id = gt->info.id;
-		gt_list->gt_list[id].reference_clock = gt->info.reference_clock;
+			gt_list->gt_list[iter].type = DRM_XE_QUERY_GT_TYPE_MAIN;
+		gt_list->gt_list[iter].tile_id = gt_to_tile(gt)->id;
+		gt_list->gt_list[iter].gt_id = gt->info.id;
+		gt_list->gt_list[iter].reference_clock = gt->info.reference_clock;
 		/*
 		 * The mem_regions indexes in the mask below need to
 		 * directly identify the struct
@@ -404,19 +405,21 @@ static int query_gt_list(struct xe_device *xe, struct drm_xe_device_query *query
 		 * assumption.
 		 */
 		if (!IS_DGFX(xe))
-			gt_list->gt_list[id].near_mem_regions = 0x1;
+			gt_list->gt_list[iter].near_mem_regions = 0x1;
 		else
-			gt_list->gt_list[id].near_mem_regions =
+			gt_list->gt_list[iter].near_mem_regions =
 				BIT(gt_to_tile(gt)->id) << 1;
-		gt_list->gt_list[id].far_mem_regions = xe->info.mem_region_mask ^
-			gt_list->gt_list[id].near_mem_regions;
+		gt_list->gt_list[iter].far_mem_regions = xe->info.mem_region_mask ^
+			gt_list->gt_list[iter].near_mem_regions;
 
-		gt_list->gt_list[id].ip_ver_major =
+		gt_list->gt_list[iter].ip_ver_major =
 			REG_FIELD_GET(GMD_ID_ARCH_MASK, gt->info.gmdid);
-		gt_list->gt_list[id].ip_ver_minor =
+		gt_list->gt_list[iter].ip_ver_minor =
 			REG_FIELD_GET(GMD_ID_RELEASE_MASK, gt->info.gmdid);
-		gt_list->gt_list[id].ip_ver_rev =
+		gt_list->gt_list[iter].ip_ver_rev =
 			REG_FIELD_GET(GMD_ID_REVID, gt->info.gmdid);
+
+		iter++;
 	}
 
 	if (copy_to_user(query_ptr, gt_list, size)) {
-- 
2.39.5



