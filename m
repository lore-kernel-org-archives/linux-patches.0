Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCBF35C69B;
	Tue, 21 Jul 2026 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668875; cv=none; b=u+bw262IWiKLH1X3zrS5e+lud4hLeRQlZZ9/fhiBfk9Qt1MZX2bNHQ8eeRF5vtKBVnSbQuEGdY2HcqIYOCA7FJ+PSWF3WdQbOTKTXa3Zdcs+FL/48wIh2HI1bD9CiMo7QW1Dj0cJpu08NqCBiVpYG6GimHmKNO//+uME0b3/Fzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668875; c=relaxed/simple;
	bh=3Bf3Ty/MPcWC7IdiCXwmGD0dE0qmgmk9C+pGmEF+YUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj20FBvrzFU4HD45bTClJQGKitO6xZEvDpIjdZzavfKQ9z+TWgCqr84Yg64AGShDBBmnd5FZu5pgBzKozPxvwobfy4EkUXO7pgt7XIrLw4tGfVmHLGjyXtwKBOQsUmqOVt+YILlFxg/MqGnkzNQwFlWK0qET7IeuKlw3fD5jlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oA6kL5ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oA6kL5ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E651F000E9;
	Tue, 21 Jul 2026 21:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668874;
	bh=yO872LX+exN1p8XfigmZwfeBLy5BeA6A/NmyJsI42JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA6kL5uty20fgivqzrgHzM8zNIV6waJVxLZeN2Eao2E2bfNLXXnGOgmEed6tItXIT
	 n0TTzgSfnKP1r5LoKJ/bDXAhaLbGqQni5gYmUWWOMFw9t7Jv8U0vGc1hNjWxYjJVgA
	 ADKx1hJTNDeryH0KlJQOhQV0X15hYTvJTUex2YJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0342/1067] gpu: host1x: Allow entries in BO caches to be freed
Date: Tue, 21 Jul 2026 17:15:43 +0200
Message-ID: <20260721152432.244860138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 3cbf5e3c46e66d9b3b6b91099bb720c6cb1be3bc ]

When a buffer object is pinned via host1x_bo_pin() with a cache, the
resulting mapping is kept in the cache so it can be reused on subsequent
pins. Each mapping held a reference to the underlying host1x_bo (taken
in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
the bo itself could not be freed.

However, the only way to remove the cached mapping was through the free
path of the buffer object. This meant that if a bo got cached, it could
never get freed again.

Resolve the circularity by holding a weak reference to the bo from the
cache side. This is done by having the .pin callbacks not bump the bo's
refcount -- instead the common Host1x bo code does so, except for the
cache reference.

Also move the remove-cache-mapping-on-free code into a common function
inside Host1x code. This is only called from the TegraDRM GEM buffers
since those are the only ones that can be cached at the moment.

Reported-by: Aaron Kling <webgeek1234@gmail.com>
Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Tested-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c    | 13 ++------
 drivers/gpu/drm/tegra/submit.c |  3 +-
 drivers/gpu/host1x/bus.c       | 60 +++++++++++++++++++++++++++++++++-
 include/linux/host1x.h         |  7 ++++
 4 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index cd06f25499549f..65b4e4617956c2 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -68,7 +68,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -168,7 +168,6 @@ static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 		kfree(map->sgt);
 	}
 
-	host1x_bo_put(map->bo);
 	kfree(map);
 }
 
@@ -492,17 +491,9 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 void tegra_bo_free_object(struct drm_gem_object *gem)
 {
 	struct tegra_drm *tegra = gem->dev->dev_private;
-	struct host1x_bo_mapping *mapping, *tmp;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 
-	/* remove all mappings of this buffer object from any caches */
-	list_for_each_entry_safe(mapping, tmp, &bo->base.mappings, list) {
-		if (mapping->cache)
-			host1x_bo_unpin(mapping);
-		else
-			dev_err(gem->dev->dev, "mapping %p stale for device %s\n", mapping,
-				dev_name(mapping->dev));
-	}
+	host1x_bo_clear_cached_mappings(&bo->base);
 
 	if (tegra->domain)
 		tegra_bo_iommu_unmap(tegra, bo);
diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index b24738bdf3df84..12af6560ba5cdd 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -76,7 +76,7 @@ gather_bo_pin(struct device *dev, struct host1x_bo *bo, enum dma_data_direction
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -117,7 +117,6 @@ static void gather_bo_unpin(struct host1x_bo_mapping *map)
 	dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
 	sg_free_table(map->sgt);
 	kfree(map->sgt);
-	host1x_bo_put(map->bo);
 
 	kfree(map);
 }
diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index ba622fb5e48225..b88d4f14be1bca 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -900,6 +900,20 @@ int host1x_client_resume(struct host1x_client *client)
 }
 EXPORT_SYMBOL(host1x_client_resume);
 
+/**
+ * host1x_bo_pin() - Create a DMA mapping for the buffer object
+ * @dev: Device onto which DMA map to
+ * @bo: Buffer object to map
+ * @dir: DMA direction
+ * @cache: Cache in which to store mapping, or NULL
+ *
+ * Creates a DMA mapping pointing to @bo for @dev. The refcount of @bo is incremented
+ * until host1x_bo_unpin is called.
+ *
+ * If @cache is specified, the mapping is also stored in the cache and not released
+ * until @bo is freed (refcount drops to zero). This improves performance when a buffer
+ * is pinned and unpinned frequently as in the case of display use.
+ */
 struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo,
 					enum dma_data_direction dir,
 					struct host1x_bo_cache *cache)
@@ -912,6 +926,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 		list_for_each_entry(mapping, &cache->mappings, entry) {
 			if (mapping->bo == bo && mapping->direction == dir) {
 				kref_get(&mapping->ref);
+				host1x_bo_get(bo);
 				goto unlock;
 			}
 		}
@@ -921,6 +936,8 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 	if (IS_ERR(mapping))
 		goto unlock;
 
+	host1x_bo_get(bo);
+
 	spin_lock(&mapping->bo->lock);
 	list_add_tail(&mapping->list, &bo->mappings);
 	spin_unlock(&mapping->bo->lock);
@@ -931,7 +948,12 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 
 		list_add_tail(&mapping->entry, &cache->mappings);
 
-		/* bump reference count to track the copy in the cache */
+		/*
+		 * Bump the mapping reference count to track the mapping in the cache,
+		 * but do not bump the BO's refcount. This allows the BO to still get freed,
+		 * triggering the release of the cache mapping through
+		 * host1x_bo_clear_cached_mappings.
+		 */
 		kref_get(&mapping->ref);
 	}
 
@@ -961,9 +983,17 @@ static void __host1x_bo_unpin(struct kref *ref)
 	mapping->bo->ops->unpin(mapping);
 }
 
+/**
+ * host1x_bo_unpin() - Release an established DMA mapping of a buffer object
+ * @mapping: Mapping to release
+ *
+ * Unmaps the given @mapping, unless it is cached. Decreases the refcount on
+ * the underlying buffer object.
+ */
 void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
 {
 	struct host1x_bo_cache *cache = mapping->cache;
+	struct host1x_bo *bo = mapping->bo;
 
 	if (cache)
 		mutex_lock(&cache->lock);
@@ -972,5 +1002,33 @@ void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
 
 	if (cache)
 		mutex_unlock(&cache->lock);
+
+	host1x_bo_put(bo);
 }
 EXPORT_SYMBOL(host1x_bo_unpin);
+
+/**
+ * host1x_bo_clear_cached_mappings() - Remove all cached mappings pointing at a bo
+ * @bo: Buffer object to release mappings of
+ *
+ * Drops references to any mappings pointing to @bo left in any caches. This must
+ * be called by any host1x_bo implementers that may be pinned with caching enabled
+ * before freeing the bo.
+ */
+void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
+{
+	struct host1x_bo_mapping *mapping, *tmp;
+	struct host1x_bo_cache *cache;
+
+	list_for_each_entry_safe(mapping, tmp, &bo->mappings, list) {
+		cache = mapping->cache;
+		if (WARN_ON(!cache))
+			continue;
+
+		mutex_lock(&mapping->cache->lock);
+		WARN_ON(kref_read(&mapping->ref) != 1);
+		__host1x_bo_unpin(&mapping->ref);
+		mutex_unlock(&mapping->cache->lock);
+	}
+}
+EXPORT_SYMBOL(host1x_bo_clear_cached_mappings);
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index dc55d9d3b94f00..4076d85078cbaf 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -137,6 +137,12 @@ static inline struct host1x_bo_mapping *to_host1x_bo_mapping(struct kref *ref)
 	return container_of(ref, struct host1x_bo_mapping, ref);
 }
 
+/**
+ * struct host1x_bo_ops - operations implemented by a host1x_bo provider
+ *
+ * @pin: create a DMA mapping. Implementation must not touch the bo's refcount.
+ * @unpin: destroy a DMA mapping. Implementation must not touch the bo's refcount.
+ */
 struct host1x_bo_ops {
 	struct host1x_bo *(*get)(struct host1x_bo *bo);
 	void (*put)(struct host1x_bo *bo);
@@ -175,6 +181,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 					enum dma_data_direction dir,
 					struct host1x_bo_cache *cache);
 void host1x_bo_unpin(struct host1x_bo_mapping *map);
+void host1x_bo_clear_cached_mappings(struct host1x_bo *bo);
 
 static inline void *host1x_bo_mmap(struct host1x_bo *bo)
 {
-- 
2.53.0



