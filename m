Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299844CF37;
	Sat, 28 Feb 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301284; cv=none; b=cGhLzwwb8oIOL+tMdOOPOfZMTY3cuo0yP1/GvjtDt5t4ISE82hZLGqq11g4LmbaJDc7cV9y2H1/rE/BtfrJuZkFgynsspUp6D9MMfblz+wXXCFdWpP0MO6sVbrbmhzotGulLTWy6z79yM4d6euZebsVWhNM7XWL6guGeaeQaGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301284; c=relaxed/simple;
	bh=1mSZrzdXvWMtWFt9bMt3Uhpln1QjAS1Hey4QS/enUxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxJ7izI6vAAngiHIxSWvZ3Lvxtkw2jC3bZOGz4Z2LGpFyg4HJYjskDjpqq+mkD3y0Znpm5yzs0vjpTHIlHohroIERvkTT92a3iQxcJVYfxD7Wi2gH+Ovs1xWRtOUh+wwrbqoFr9gsFB4GyE3Uitz3UfiqxLQC523mhJvwEF+w7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNUVSo36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNUVSo36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C283C116D0;
	Sat, 28 Feb 2026 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301284;
	bh=1mSZrzdXvWMtWFt9bMt3Uhpln1QjAS1Hey4QS/enUxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNUVSo36behckYsz2AimeDfXKuaJbw5Jbimia0EVtV0suQNYqmNuBDTqIRHq/JEHU
	 YEVUbXhRorkY5PxQGbpIG9Z0za7bg/bnBivszeWtOyG9N+HEnbbHi02gGnbJYZxJYJ
	 R9Vvt3HcdBS5V/DVTSmeMgEuMIhc73+SkyCNnkiGC+o3sv8Gfg5LfVscGDTBiS/gSh
	 WPKmRFQCYIG4xMfRpCAWfRd4tObAboSvx9Ursov8ts3kxBpe0CD5cZAotldiNDxu+p
	 XMUdRAkbwCWuOVbm1G6YRhtN96deqhnB6XaNzkuuH9u3CNjj2KK2a7+IHYZT6S0Jv/
	 VpqW/D1I/d8Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/752] drm/tests: shmem: Hold reservation lock around vmap/vunmap
Date: Sat, 28 Feb 2026 12:42:59 -0500
Message-ID: <20260228174750.1542406-468-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit cda83b099f117f2a28a77bf467af934cb39e49cf ]

Acquire and release the GEM object's reservation lock around vmap and
vunmap operations. The tests use vmap_locked, which led to errors such
as show below.

[  122.292030] WARNING: CPU: 3 PID: 1413 at drivers/gpu/drm/drm_gem_shmem_helper.c:390 drm_gem_shmem_vmap_locked+0x3a3/0x6f0

[  122.468066] WARNING: CPU: 3 PID: 1413 at drivers/gpu/drm/drm_gem_shmem_helper.c:293 drm_gem_shmem_pin_locked+0x1fe/0x350

[  122.563504] WARNING: CPU: 3 PID: 1413 at drivers/gpu/drm/drm_gem_shmem_helper.c:234 drm_gem_shmem_get_pages_locked+0x23c/0x370

[  122.662248] WARNING: CPU: 2 PID: 1413 at drivers/gpu/drm/drm_gem_shmem_helper.c:452 drm_gem_shmem_vunmap_locked+0x101/0x330

Only export the new vmap/vunmap helpers for Kunit tests. These are
not interfaces for regular drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 954907f7147d ("drm/shmem-helper: Refactor locked/unlocked functions")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251212160317.287409-4-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c     | 33 ++++++++++++++++++++++
 drivers/gpu/drm/tests/drm_gem_shmem_test.c |  6 ++--
 include/drm/drm_gem_shmem_helper.h         |  9 ++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 365b5737ca2c6..d9c26d15ef6b9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -15,6 +15,8 @@
 #include <asm/set_memory.h>
 #endif
 
+#include <kunit/visibility.h>
+
 #include <drm/drm.h>
 #include <drm/drm_device.h>
 #include <drm/drm_drv.h>
@@ -861,6 +863,37 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_prime_import_no_map);
 
+/*
+ * Kunit helpers
+ */
+
+#if IS_ENABLED(CONFIG_KUNIT)
+int drm_gem_shmem_vmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map)
+{
+	struct drm_gem_object *obj = &shmem->base;
+	int ret;
+
+	ret = dma_resv_lock_interruptible(obj->resv, NULL);
+	if (ret)
+		return ret;
+	ret = drm_gem_shmem_vmap_locked(shmem, map);
+	dma_resv_unlock(obj->resv);
+
+	return ret;
+}
+EXPORT_SYMBOL_IF_KUNIT(drm_gem_shmem_vmap);
+
+void drm_gem_shmem_vunmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map)
+{
+	struct drm_gem_object *obj = &shmem->base;
+
+	dma_resv_lock_interruptible(obj->resv, NULL);
+	drm_gem_shmem_vunmap_locked(shmem, map);
+	dma_resv_unlock(obj->resv);
+}
+EXPORT_SYMBOL_IF_KUNIT(drm_gem_shmem_vunmap);
+#endif
+
 MODULE_DESCRIPTION("DRM SHMEM memory-management helpers");
 MODULE_IMPORT_NS("DMA_BUF");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index 1d50bab51ef3f..3e7c6f20fbcca 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -19,6 +19,8 @@
 #include <drm/drm_gem_shmem_helper.h>
 #include <drm/drm_kunit_helpers.h>
 
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
 #define TEST_SIZE		SZ_1M
 #define TEST_BYTE		0xae
 
@@ -176,7 +178,7 @@ static void drm_gem_shmem_test_vmap(struct kunit *test)
 	ret = kunit_add_action_or_reset(test, drm_gem_shmem_free_wrapper, shmem);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
-	ret = drm_gem_shmem_vmap_locked(shmem, &map);
+	ret = drm_gem_shmem_vmap(shmem, &map);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 	KUNIT_ASSERT_NOT_NULL(test, shmem->vaddr);
 	KUNIT_ASSERT_FALSE(test, iosys_map_is_null(&map));
@@ -186,7 +188,7 @@ static void drm_gem_shmem_test_vmap(struct kunit *test)
 	for (i = 0; i < TEST_SIZE; i++)
 		KUNIT_EXPECT_EQ(test, iosys_map_rd(&map, i, u8), TEST_BYTE);
 
-	drm_gem_shmem_vunmap_locked(shmem, &map);
+	drm_gem_shmem_vunmap(shmem, &map);
 	KUNIT_EXPECT_NULL(test, shmem->vaddr);
 	KUNIT_EXPECT_EQ(test, refcount_read(&shmem->vmap_use_count), 0);
 }
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 92f5db84b9c22..8a23fe96120e7 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -301,4 +301,13 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 	.gem_prime_import       = drm_gem_shmem_prime_import_no_map, \
 	.dumb_create            = drm_gem_shmem_dumb_create
 
+/*
+ * Kunit helpers
+ */
+
+#if IS_ENABLED(CONFIG_KUNIT)
+int drm_gem_shmem_vmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map);
+void drm_gem_shmem_vunmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map);
+#endif
+
 #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
-- 
2.51.0

