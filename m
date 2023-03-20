Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B1C1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DBEC433EF;
	Mon, 20 Mar 2023 15:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325061;
	bh=0F/Q+SMEWFXuaBlr+iU1Saimzq5MFwcZETJcObmyn3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE3vTg3tAC0t6g8eXp5KcoNxMrp3b1YGDlcuNHnzRNl0o9LjbR4xoO+jHacGDxcIp
	 jcUzNUqo+Er41mjURXWbELvlzcKHdySUVGDCp2Q2NbCWjWQFLvfiTpHhfxmEFQGfth
	 C7mhFKKby5/pA1/VuXtdEjT4FFj5c5KU8qUhhbmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 003/211] drm/msm/gem: Prevent blocking within shrinker loop
Date: Mon, 20 Mar 2023 15:52:18 +0100
Message-Id: <20230320145513.441904224@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 9630b585b607bd26f505d34620b14d75b9a5af7d ]

Consider this scenario:

1. APP1 continuously creates lots of small GEMs
2. APP2 triggers `drop_caches`
3. Shrinker starts to evict APP1 GEMs, while APP1 produces new purgeable
   GEMs
4. msm_gem_shrinker_scan() returns non-zero number of freed pages
   and causes shrinker to try shrink more
5. msm_gem_shrinker_scan() returns non-zero number of freed pages again,
   goto 4
6. The APP2 is blocked in `drop_caches` until APP1 stops producing
   purgeable GEMs

To prevent this blocking scenario, check number of remaining pages
that GPU shrinker couldn't release due to a GEM locking contention
or shrinking rejection. If there are no remaining pages left to shrink,
then there is no need to free up more pages and shrinker may break out
from the loop.

This problem was found during shrinker/madvise IOCTL testing of
virtio-gpu driver. The MSM driver is affected in the same way.

Reviewed-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b352ba54a820 ("drm/msm/gem: Convert to using drm_gem_lru")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://lore.kernel.org/all/20230108210445.3948344-2-dmitry.osipenko@collabora.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem.c              |  9 +++++++--
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 11 +++++++++--
 include/drm/drm_gem.h                  |  4 +++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index b8db675e7fb5e..b0246a8480068 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1375,10 +1375,13 @@ EXPORT_SYMBOL(drm_gem_lru_move_tail);
  *
  * @lru: The LRU to scan
  * @nr_to_scan: The number of pages to try to reclaim
+ * @remaining: The number of pages left to reclaim, should be initialized by caller
  * @shrink: Callback to try to shrink/reclaim the object.
  */
 unsigned long
-drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
+drm_gem_lru_scan(struct drm_gem_lru *lru,
+		 unsigned int nr_to_scan,
+		 unsigned long *remaining,
 		 bool (*shrink)(struct drm_gem_object *obj))
 {
 	struct drm_gem_lru still_in_lru;
@@ -1417,8 +1420,10 @@ drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
 		 * hit shrinker in response to trying to get backing pages
 		 * for this obj (ie. while it's lock is already held)
 		 */
-		if (!dma_resv_trylock(obj->resv))
+		if (!dma_resv_trylock(obj->resv)) {
+			*remaining += obj->size >> PAGE_SHIFT;
 			goto tail;
+		}
 
 		if (shrink(obj)) {
 			freed += obj->size >> PAGE_SHIFT;
diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 051bdbc093cf9..f38296ad87434 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -107,6 +107,7 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 		bool (*shrink)(struct drm_gem_object *obj);
 		bool cond;
 		unsigned long freed;
+		unsigned long remaining;
 	} stages[] = {
 		/* Stages of progressively more aggressive/expensive reclaim: */
 		{ &priv->lru.dontneed, purge,        true },
@@ -116,14 +117,18 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 	};
 	long nr = sc->nr_to_scan;
 	unsigned long freed = 0;
+	unsigned long remaining = 0;
 
 	for (unsigned i = 0; (nr > 0) && (i < ARRAY_SIZE(stages)); i++) {
 		if (!stages[i].cond)
 			continue;
 		stages[i].freed =
-			drm_gem_lru_scan(stages[i].lru, nr, stages[i].shrink);
+			drm_gem_lru_scan(stages[i].lru, nr,
+					&stages[i].remaining,
+					 stages[i].shrink);
 		nr -= stages[i].freed;
 		freed += stages[i].freed;
+		remaining += stages[i].remaining;
 	}
 
 	if (freed) {
@@ -132,7 +137,7 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 				     stages[3].freed);
 	}
 
-	return (freed > 0) ? freed : SHRINK_STOP;
+	return (freed > 0 && remaining > 0) ? freed : SHRINK_STOP;
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -182,10 +187,12 @@ msm_gem_shrinker_vmap(struct notifier_block *nb, unsigned long event, void *ptr)
 		NULL,
 	};
 	unsigned idx, unmapped = 0;
+	unsigned long remaining = 0;
 
 	for (idx = 0; lrus[idx] && unmapped < vmap_shrink_limit; idx++) {
 		unmapped += drm_gem_lru_scan(lrus[idx],
 					     vmap_shrink_limit - unmapped,
+					     &remaining,
 					     vmap_shrink);
 	}
 
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index a17c2f903f81e..b46ade8124436 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -475,7 +475,9 @@ int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 void drm_gem_lru_init(struct drm_gem_lru *lru, struct mutex *lock);
 void drm_gem_lru_remove(struct drm_gem_object *obj);
 void drm_gem_lru_move_tail(struct drm_gem_lru *lru, struct drm_gem_object *obj);
-unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru, unsigned nr_to_scan,
+unsigned long drm_gem_lru_scan(struct drm_gem_lru *lru,
+			       unsigned int nr_to_scan,
+			       unsigned long *remaining,
 			       bool (*shrink)(struct drm_gem_object *obj));
 
 #endif /* __DRM_GEM_H__ */
-- 
2.39.2



