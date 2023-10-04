Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E585A210F2
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKbXxK4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65928C433C7;
	Wed,  4 Oct 2023 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444340;
	bh=LJYHAMppZzhhHLbVTcxQaPjF5kpUF47oaxD2UzUOFgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKbXxK4T2BMCTriIlf/xWxbWYoE6r30wjXxv/ujt5kag37ec7dDXTtUDKaU/3svCd
	 BMo1hoTYgwQz947/aB27IekpPAsmMjtWAqt9V/Ew4YkXwR5p3wBfLhHpYMikH30UNe
	 mDjgoG0H0T92Lxw37wvcxaFznHaUOhaJ6DnmUgq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 187/321] drm/amdkfd: Update cache info reporting for GFX v9.4.3
Date: Wed,  4 Oct 2023 19:55:32 +0200
Message-ID: <20231004175237.906042472@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 0752e66e91fa86fa5481b04b22053363833ffb85 ]

Update cache info reporting in sysfs to report the correct
number of CUs and associated cache information based on
different spatial partitioning modes.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h     |  4 ++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 82 +++++++++++++----------
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h |  2 +-
 3 files changed, 51 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
index fc719389b5d65..4684711aa695a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.h
@@ -79,6 +79,10 @@ struct crat_header {
 #define CRAT_SUBTYPE_IOLINK_AFFINITY		5
 #define CRAT_SUBTYPE_MAX			6
 
+/*
+ * Do not change the value of CRAT_SIBLINGMAP_SIZE from 32
+ * as it breaks the ABI.
+ */
 #define CRAT_SIBLINGMAP_SIZE	32
 
 /*
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index ea67a353beb00..5582191022106 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1650,14 +1650,17 @@ static int fill_in_l1_pcache(struct kfd_cache_properties **props_ext,
 static int fill_in_l2_l3_pcache(struct kfd_cache_properties **props_ext,
 				struct kfd_gpu_cache_info *pcache_info,
 				struct kfd_cu_info *cu_info,
-				int cache_type, unsigned int cu_processor_id)
+				int cache_type, unsigned int cu_processor_id,
+				struct kfd_node *knode)
 {
 	unsigned int cu_sibling_map_mask;
 	int first_active_cu;
-	int i, j, k;
+	int i, j, k, xcc, start, end;
 	struct kfd_cache_properties *pcache = NULL;
 
-	cu_sibling_map_mask = cu_info->cu_bitmap[0][0][0];
+	start = ffs(knode->xcc_mask) - 1;
+	end = start + NUM_XCC(knode->xcc_mask);
+	cu_sibling_map_mask = cu_info->cu_bitmap[start][0][0];
 	cu_sibling_map_mask &=
 		((1 << pcache_info[cache_type].num_cu_shared) - 1);
 	first_active_cu = ffs(cu_sibling_map_mask);
@@ -1692,16 +1695,18 @@ static int fill_in_l2_l3_pcache(struct kfd_cache_properties **props_ext,
 		cu_sibling_map_mask = cu_sibling_map_mask >> (first_active_cu - 1);
 		k = 0;
 
-		for (i = 0; i < cu_info->num_shader_engines; i++) {
-			for (j = 0; j < cu_info->num_shader_arrays_per_engine; j++) {
-				pcache->sibling_map[k] = (uint8_t)(cu_sibling_map_mask & 0xFF);
-				pcache->sibling_map[k+1] = (uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
-				pcache->sibling_map[k+2] = (uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
-				pcache->sibling_map[k+3] = (uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
-				k += 4;
-
-				cu_sibling_map_mask = cu_info->cu_bitmap[0][i % 4][j + i / 4];
-				cu_sibling_map_mask &= ((1 << pcache_info[cache_type].num_cu_shared) - 1);
+		for (xcc = start; xcc < end; xcc++) {
+			for (i = 0; i < cu_info->num_shader_engines; i++) {
+				for (j = 0; j < cu_info->num_shader_arrays_per_engine; j++) {
+					pcache->sibling_map[k] = (uint8_t)(cu_sibling_map_mask & 0xFF);
+					pcache->sibling_map[k+1] = (uint8_t)((cu_sibling_map_mask >> 8) & 0xFF);
+					pcache->sibling_map[k+2] = (uint8_t)((cu_sibling_map_mask >> 16) & 0xFF);
+					pcache->sibling_map[k+3] = (uint8_t)((cu_sibling_map_mask >> 24) & 0xFF);
+					k += 4;
+
+					cu_sibling_map_mask = cu_info->cu_bitmap[xcc][i % 4][j + i / 4];
+					cu_sibling_map_mask &= ((1 << pcache_info[cache_type].num_cu_shared) - 1);
+				}
 			}
 		}
 		pcache->sibling_map_size = k;
@@ -1719,7 +1724,7 @@ static int fill_in_l2_l3_pcache(struct kfd_cache_properties **props_ext,
 static void kfd_fill_cache_non_crat_info(struct kfd_topology_device *dev, struct kfd_node *kdev)
 {
 	struct kfd_gpu_cache_info *pcache_info = NULL;
-	int i, j, k;
+	int i, j, k, xcc, start, end;
 	int ct = 0;
 	unsigned int cu_processor_id;
 	int ret;
@@ -1753,37 +1758,42 @@ static void kfd_fill_cache_non_crat_info(struct kfd_topology_device *dev, struct
 	 *			then it will consider only one CU from
 	 *			the shared unit
 	 */
+	start = ffs(kdev->xcc_mask) - 1;
+	end = start + NUM_XCC(kdev->xcc_mask);
+
 	for (ct = 0; ct < num_of_cache_types; ct++) {
 		cu_processor_id = gpu_processor_id;
 		if (pcache_info[ct].cache_level == 1) {
-			for (i = 0; i < pcu_info->num_shader_engines; i++) {
-				for (j = 0; j < pcu_info->num_shader_arrays_per_engine; j++) {
-					for (k = 0; k < pcu_info->num_cu_per_sh; k += pcache_info[ct].num_cu_shared) {
-
-						ret = fill_in_l1_pcache(&props_ext, pcache_info, pcu_info,
-									pcu_info->cu_bitmap[0][i % 4][j + i / 4], ct,
-									cu_processor_id, k);
-
-						if (ret < 0)
-							break;
-
-						if (!ret) {
-							num_of_entries++;
-							list_add_tail(&props_ext->list, &dev->cache_props);
+			for (xcc = start; xcc < end; xcc++) {
+				for (i = 0; i < pcu_info->num_shader_engines; i++) {
+					for (j = 0; j < pcu_info->num_shader_arrays_per_engine; j++) {
+						for (k = 0; k < pcu_info->num_cu_per_sh; k += pcache_info[ct].num_cu_shared) {
+
+							ret = fill_in_l1_pcache(&props_ext, pcache_info, pcu_info,
+										pcu_info->cu_bitmap[xcc][i % 4][j + i / 4], ct,
+										cu_processor_id, k);
+
+							if (ret < 0)
+								break;
+
+							if (!ret) {
+								num_of_entries++;
+								list_add_tail(&props_ext->list, &dev->cache_props);
+							}
+
+							/* Move to next CU block */
+							num_cu_shared = ((k + pcache_info[ct].num_cu_shared) <=
+								pcu_info->num_cu_per_sh) ?
+								pcache_info[ct].num_cu_shared :
+								(pcu_info->num_cu_per_sh - k);
+							cu_processor_id += num_cu_shared;
 						}
-
-						/* Move to next CU block */
-						num_cu_shared = ((k + pcache_info[ct].num_cu_shared) <=
-							pcu_info->num_cu_per_sh) ?
-							pcache_info[ct].num_cu_shared :
-							(pcu_info->num_cu_per_sh - k);
-						cu_processor_id += num_cu_shared;
 					}
 				}
 			}
 		} else {
 			ret = fill_in_l2_l3_pcache(&props_ext, pcache_info,
-								pcu_info, ct, cu_processor_id);
+					pcu_info, ct, cu_processor_id, kdev);
 
 			if (ret < 0)
 				break;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
index cba2cd5ed9d19..46927263e014d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.h
@@ -86,7 +86,7 @@ struct kfd_mem_properties {
 	struct attribute	attr;
 };
 
-#define CACHE_SIBLINGMAP_SIZE 64
+#define CACHE_SIBLINGMAP_SIZE 128
 
 struct kfd_cache_properties {
 	struct list_head	list;
-- 
2.40.1



