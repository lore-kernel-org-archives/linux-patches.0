Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3801745BD6B;
	Sat, 28 Feb 2026 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301286; cv=none; b=RK0sOaAfYVLTU8siS4dhywsobvOfCMtXS43i7OwiiowXzcSgBf8MkireGuziT3eMkASAOZxIcZxdEG2acQ+SIBasHmtV6ukca+hBk1TiruJ9E4191dT8IUsRyG1q5wVECHHFsi2a4jCzr83NJL/Z5Di53Fg4QWrmr/1eD2+l8Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301286; c=relaxed/simple;
	bh=bm2Bw3ITA+aM3c12dBiFS/kfhp0kY/Qnb1B8VU+afxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFD9/WxsEfFsrjNtO7W+2U7orVUcVzQV/QURlqaLZm07Zf/3VvL/ZoAEWhipaGzWyby5JLA7KkU7D95K8oJ8PMZE4ljNebf63wjLuENh9qoLJFGXJMYDxTDW7f82NOF3MvHtsCAj4GgNqt8pyuuyblfLPdYUbVqpxI5XvO8TkZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zkurb310; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zkurb310"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B99C19423;
	Sat, 28 Feb 2026 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301286;
	bh=bm2Bw3ITA+aM3c12dBiFS/kfhp0kY/Qnb1B8VU+afxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zkurb3103rSZcEOPI5VYSSk2iOVADCCTXNhU4cxYWZRHGZiBQHmBav453d/BsAU+A
	 1PRINZAHLcS9CsNwTLBySBgXiefXxqvJ8GUcPTODA10DYgvmVcLFw9AwNvgD0DTff1
	 Oew3u7U0zHpUdGojIACA3yT0BNhNtywBf1S6n8x5r13nS3sELegSInQaQKWgJozPSX
	 GOUVRt7p1lJUQtBT7/LNi2DJ7F/jdTv/Z/MD0gY1WHbEjaNeqbqJeW3a//5JYs/Ep0
	 lltz4Yvf7UL3JlqDtITbMM6Xd+gv4pVZ69TfhXWpj7MGm55hPAaYflLuEo+KRLea8R
	 IYJJlixCb34JA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 470/752] drm/tests: shmem: Hold reservation lock around purge
Date: Sat, 28 Feb 2026 12:43:01 -0500
Message-ID: <20260228174750.1542406-470-sashal@kernel.org>
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

[ Upstream commit 3f41307d589c2f25d556d47b165df808124cd0c4 ]

Acquire and release the GEM object's reservation lock around calls
to the object's purge operation. The tests use
drm_gem_shmem_purge_locked(), which led to errors such as show below.

[   58.709128] WARNING: CPU: 1 PID: 1354 at drivers/gpu/drm/drm_gem_shmem_helper.c:515 drm_gem_shmem_purge_locked+0x51c/0x740

Only export the new helper drm_gem_shmem_purge() for Kunit tests.
This is not an interface for regular drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 954907f7147d ("drm/shmem-helper: Refactor locked/unlocked functions")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251212160317.287409-6-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c     | 15 +++++++++++++++
 drivers/gpu/drm/tests/drm_gem_shmem_test.c |  4 +++-
 include/drm/drm_gem_shmem_helper.h         |  1 +
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 57df74c3a627b..5c6da91bbba17 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -907,6 +907,21 @@ int drm_gem_shmem_madvise(struct drm_gem_shmem_object *shmem, int madv)
 	return ret;
 }
 EXPORT_SYMBOL_IF_KUNIT(drm_gem_shmem_madvise);
+
+int drm_gem_shmem_purge(struct drm_gem_shmem_object *shmem)
+{
+	struct drm_gem_object *obj = &shmem->base;
+	int ret;
+
+	ret = dma_resv_lock_interruptible(obj->resv, NULL);
+	if (ret)
+		return ret;
+	drm_gem_shmem_purge_locked(shmem);
+	dma_resv_unlock(obj->resv);
+
+	return 0;
+}
+EXPORT_SYMBOL_IF_KUNIT(drm_gem_shmem_purge);
 #endif
 
 MODULE_DESCRIPTION("DRM SHMEM memory-management helpers");
diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index d639848e3c8ea..4b459f21acfd9 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -340,7 +340,9 @@ static void drm_gem_shmem_test_purge(struct kunit *test)
 	ret = drm_gem_shmem_is_purgeable(shmem);
 	KUNIT_EXPECT_TRUE(test, ret);
 
-	drm_gem_shmem_purge_locked(shmem);
+	ret = drm_gem_shmem_purge(shmem);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_EXPECT_NULL(test, shmem->pages);
 	KUNIT_EXPECT_NULL(test, shmem->sgt);
 	KUNIT_EXPECT_EQ(test, shmem->madv, -1);
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 1b937166457fb..6802896e30c7c 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -309,6 +309,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 int drm_gem_shmem_vmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map);
 void drm_gem_shmem_vunmap(struct drm_gem_shmem_object *shmem, struct iosys_map *map);
 int drm_gem_shmem_madvise(struct drm_gem_shmem_object *shmem, int madv);
+int drm_gem_shmem_purge(struct drm_gem_shmem_object *shmem);
 #endif
 
 #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
-- 
2.51.0

