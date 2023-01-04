Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B7BAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AF0C433D2;
	Wed,  4 Jan 2023 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849464;
	bh=XNZWPYJyc+yWIJvYZAiy8/k+e7AwoHMIXYf67Uu5NvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiDdq6w2VN+PtFRN3ACNyiriUED0LI0FtRSbFRpoGWdKfuoR8XQfy7LtDv+ToNvxC
	 1z5zI5nGpWH4n/tIPXGYVOJnef6pfgQG/IY4wsD0OcCM7mhv94H3N92qQNwDgmhpJj
	 /Jkm46QpcgF0dmyJuBAVshEZ4cJAqFHtACbmdSRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.0 127/177] drm/etnaviv: move idle mapping reaping into separate function
Date: Wed,  4 Jan 2023 17:06:58 +0100
Message-Id: <20230104160511.496129973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Stach <l.stach@pengutronix.de>

commit 5a40837debaa9dcc71765d32ce1a15be068b6cc2 upstream.

The same logic is already used in two different places and now
it will also be needed outside of the compilation unit, so split
it into a separate function.

Cc: stable@vger.kernel.org # 5.19
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c | 23 +++++++++++++++--------
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h |  1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index dc1aa738c4f1..55479cb8b1ac 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -135,6 +135,19 @@ static void etnaviv_iommu_remove_mapping(struct etnaviv_iommu_context *context,
 	drm_mm_remove_node(&mapping->vram_node);
 }
 
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping)
+{
+	struct etnaviv_iommu_context *context = mapping->context;
+
+	lockdep_assert_held(&context->lock);
+	WARN_ON(mapping->use);
+
+	etnaviv_iommu_remove_mapping(context, mapping);
+	etnaviv_iommu_context_put(mapping->context);
+	mapping->context = NULL;
+	list_del_init(&mapping->mmu_node);
+}
+
 static int etnaviv_iommu_find_iova(struct etnaviv_iommu_context *context,
 				   struct drm_mm_node *node, size_t size)
 {
@@ -202,10 +215,7 @@ static int etnaviv_iommu_find_iova(struct etnaviv_iommu_context *context,
 		 * this mapping.
 		 */
 		list_for_each_entry_safe(m, n, &list, scan_node) {
-			etnaviv_iommu_remove_mapping(context, m);
-			etnaviv_iommu_context_put(m->context);
-			m->context = NULL;
-			list_del_init(&m->mmu_node);
+			etnaviv_iommu_reap_mapping(m);
 			list_del_init(&m->scan_node);
 		}
 
@@ -257,10 +267,7 @@ static int etnaviv_iommu_insert_exact(struct etnaviv_iommu_context *context,
 	}
 
 	list_for_each_entry_safe(m, n, &scan_list, scan_node) {
-		etnaviv_iommu_remove_mapping(context, m);
-		etnaviv_iommu_context_put(m->context);
-		m->context = NULL;
-		list_del_init(&m->mmu_node);
+		etnaviv_iommu_reap_mapping(m);
 		list_del_init(&m->scan_node);
 	}
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
index e4a0b7d09c2e..c01a147f0dfd 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -91,6 +91,7 @@ int etnaviv_iommu_map_gem(struct etnaviv_iommu_context *context,
 	struct etnaviv_vram_mapping *mapping, u64 va);
 void etnaviv_iommu_unmap_gem(struct etnaviv_iommu_context *context,
 	struct etnaviv_vram_mapping *mapping);
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping);
 
 int etnaviv_iommu_get_suballoc_va(struct etnaviv_iommu_context *ctx,
 				  struct etnaviv_vram_mapping *mapping,
-- 
2.39.0



