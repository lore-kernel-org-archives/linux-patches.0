Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516BE35A931;
	Tue, 16 Dec 2025 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886711; cv=none; b=iCZkUsT9qwBVevCl7MCQLTptebap+4UYHKWdCuqcAM/mfTPq0S5sEDhFoikP3HK85Z4Jb4e+/a1pNjxvFMmpyghy9Ea7pFM2RM2bMzRLF/j54bLA8qqcKgNog0R6UFcbbJfGjKW5EjZuuE7NLF2cF24J332NOtn3NRYgws76rMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886711; c=relaxed/simple;
	bh=XJOIUgmg+g5J5JvlnrNnHGpCWRJG4zzgYXMzXKeeXCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2x9uXNWtZlNNrSKmmsg2fuYvR/QDzJKK3/zpoRV/zzZPRE8BMj8FTcM77dHMSsCXfFBmAYSO6TdKBWes1h3vh6XHQ2X5q03YYGbfcPflmfjOoqTe7T4eXE1QYlMLa8/aJZzA+GJB2pyXLnaBjn64ATPALgiFe0BfbB5Tdc9zac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BglgWyJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BglgWyJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB22C4CEF1;
	Tue, 16 Dec 2025 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886710;
	bh=XJOIUgmg+g5J5JvlnrNnHGpCWRJG4zzgYXMzXKeeXCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BglgWyJgcz+Sjr91xNWuq8yoknNRkE1LAViaSQEv1HyKJd/B8mdZ03XY44hFq6HLL
	 RhQvvS/2pDqAXKjjlxU8fAS7pHxngxo84bkucx4gDgMOorTfo9kXqM3YqRwyuvHJTJ
	 oUfyN0Bh5eZAIX2uveWhp+FNLbHz6CriIU1VYZVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/614] accel/amdxdna: Call dma_buf_vmap_unlocked() for imported object
Date: Tue, 16 Dec 2025 12:06:17 +0100
Message-ID: <20251216111401.670134142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 457f4393d02fdb612a93912fb09cef70e6e545c9 ]

In amdxdna_gem_obj_vmap(), calling dma_buf_vmap() triggers a kernel
warning if LOCKDEP is enabled. So for imported object, use
dma_buf_vmap_unlocked(). Then, use drm_gem_vmap() for other objects.
The similar change applies to vunmap code.

Fixes: bd72d4acda10 ("accel/amdxdna: Support user space allocated buffer")
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250916174842.234709-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 47 ++++++++++++-----------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index d407a36eb4126..7f91863c3f24c 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -392,35 +392,33 @@ static const struct dma_buf_ops amdxdna_dmabuf_ops = {
 	.vunmap = drm_gem_dmabuf_vunmap,
 };
 
-static int amdxdna_gem_obj_vmap(struct drm_gem_object *obj, struct iosys_map *map)
+static int amdxdna_gem_obj_vmap(struct amdxdna_gem_obj *abo, void **vaddr)
 {
-	struct amdxdna_gem_obj *abo = to_xdna_obj(obj);
-
-	iosys_map_clear(map);
-
-	dma_resv_assert_held(obj->resv);
+	struct iosys_map map = IOSYS_MAP_INIT_VADDR(NULL);
+	int ret;
 
 	if (is_import_bo(abo))
-		dma_buf_vmap(abo->dma_buf, map);
+		ret = dma_buf_vmap_unlocked(abo->dma_buf, &map);
 	else
-		drm_gem_shmem_object_vmap(obj, map);
-
-	if (!map->vaddr)
-		return -ENOMEM;
+		ret = drm_gem_vmap(to_gobj(abo), &map);
 
-	return 0;
+	*vaddr = map.vaddr;
+	return ret;
 }
 
-static void amdxdna_gem_obj_vunmap(struct drm_gem_object *obj, struct iosys_map *map)
+static void amdxdna_gem_obj_vunmap(struct amdxdna_gem_obj *abo)
 {
-	struct amdxdna_gem_obj *abo = to_xdna_obj(obj);
+	struct iosys_map map;
+
+	if (!abo->mem.kva)
+		return;
 
-	dma_resv_assert_held(obj->resv);
+	iosys_map_set_vaddr(&map, abo->mem.kva);
 
 	if (is_import_bo(abo))
-		dma_buf_vunmap(abo->dma_buf, map);
+		dma_buf_vunmap_unlocked(abo->dma_buf, &map);
 	else
-		drm_gem_shmem_object_vunmap(obj, map);
+		drm_gem_vunmap(to_gobj(abo), &map);
 }
 
 static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int flags)
@@ -455,7 +453,6 @@ static void amdxdna_gem_obj_free(struct drm_gem_object *gobj)
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(gobj->dev);
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
-	struct iosys_map map = IOSYS_MAP_INIT_VADDR(abo->mem.kva);
 
 	XDNA_DBG(xdna, "BO type %d xdna_addr 0x%llx", abo->type, abo->mem.dev_addr);
 
@@ -468,7 +465,7 @@ static void amdxdna_gem_obj_free(struct drm_gem_object *gobj)
 	if (abo->type == AMDXDNA_BO_DEV_HEAP)
 		drm_mm_takedown(&abo->mm);
 
-	drm_gem_vunmap(gobj, &map);
+	amdxdna_gem_obj_vunmap(abo);
 	mutex_destroy(&abo->lock);
 
 	if (is_import_bo(abo)) {
@@ -489,8 +486,8 @@ static const struct drm_gem_object_funcs amdxdna_gem_shmem_funcs = {
 	.pin = drm_gem_shmem_object_pin,
 	.unpin = drm_gem_shmem_object_unpin,
 	.get_sg_table = drm_gem_shmem_object_get_sg_table,
-	.vmap = amdxdna_gem_obj_vmap,
-	.vunmap = amdxdna_gem_obj_vunmap,
+	.vmap = drm_gem_shmem_object_vmap,
+	.vunmap = drm_gem_shmem_object_vunmap,
 	.mmap = amdxdna_gem_obj_mmap,
 	.vm_ops = &drm_gem_shmem_vm_ops,
 	.export = amdxdna_gem_prime_export,
@@ -663,7 +660,6 @@ amdxdna_drm_create_dev_heap(struct drm_device *dev,
 			    struct drm_file *filp)
 {
 	struct amdxdna_client *client = filp->driver_priv;
-	struct iosys_map map = IOSYS_MAP_INIT_VADDR(NULL);
 	struct amdxdna_dev *xdna = to_xdna_dev(dev);
 	struct amdxdna_gem_obj *abo;
 	int ret;
@@ -692,12 +688,11 @@ amdxdna_drm_create_dev_heap(struct drm_device *dev,
 	abo->mem.dev_addr = client->xdna->dev_info->dev_mem_base;
 	drm_mm_init(&abo->mm, abo->mem.dev_addr, abo->mem.size);
 
-	ret = drm_gem_vmap(to_gobj(abo), &map);
+	ret = amdxdna_gem_obj_vmap(abo, &abo->mem.kva);
 	if (ret) {
 		XDNA_ERR(xdna, "Vmap heap bo failed, ret %d", ret);
 		goto release_obj;
 	}
-	abo->mem.kva = map.vaddr;
 
 	client->dev_heap = abo;
 	drm_gem_object_get(to_gobj(abo));
@@ -748,7 +743,6 @@ amdxdna_drm_create_cmd_bo(struct drm_device *dev,
 			  struct amdxdna_drm_create_bo *args,
 			  struct drm_file *filp)
 {
-	struct iosys_map map = IOSYS_MAP_INIT_VADDR(NULL);
 	struct amdxdna_dev *xdna = to_xdna_dev(dev);
 	struct amdxdna_gem_obj *abo;
 	int ret;
@@ -770,12 +764,11 @@ amdxdna_drm_create_cmd_bo(struct drm_device *dev,
 	abo->type = AMDXDNA_BO_CMD;
 	abo->client = filp->driver_priv;
 
-	ret = drm_gem_vmap(to_gobj(abo), &map);
+	ret = amdxdna_gem_obj_vmap(abo, &abo->mem.kva);
 	if (ret) {
 		XDNA_ERR(xdna, "Vmap cmd bo failed, ret %d", ret);
 		goto release_obj;
 	}
-	abo->mem.kva = map.vaddr;
 
 	return abo;
 
-- 
2.51.0



