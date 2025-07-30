Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF24A32;
	Wed, 30 Jul 2025 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869310; cv=none; b=egQ+MKqQvVFdbLe+dUXMEbDJ6dp7vviWZ/jHRHN3lBDBPEQCFIG1sE55nJiZa+Zm52gCLXhxXaVBcPRFJVCjFqEHDx4tI6ImvswKZPFcfUz0psQ416WwLJ4jxLcIeVxlIKYayC+QJzUJ1ZVv6SaqJl4f/3bKZmrftRAOu00UjTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869310; c=relaxed/simple;
	bh=iQSANNrUC1ZAbxJ8YWw2ADD19XsGa5AoXo4nwAv8dsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihSl+PT/B8U5RCyTZl2FcCybEg8VumDHbgMyTgmL0ehizHVGBH4Sy3+f1y9ybmDEOwG2184RuN59ysOMfwvOZ9Gd2glMhF8sBENe/NMR5W5Ic1+qpg6J0PlNQYtB2mnMENMAYE8pFzKrXDmFxA0zE74wMPbFlUt6e/CNlXpl/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cl5ei353; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cl5ei353"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79218C4CEF8;
	Wed, 30 Jul 2025 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869309;
	bh=iQSANNrUC1ZAbxJ8YWw2ADD19XsGa5AoXo4nwAv8dsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cl5ei353XMoonpIRu+uidi0a5g7Ly2LbnnkM/zYLkL72c1hVs4ha4FADBxrfmQE1+
	 HMEcqPNfUXFIEL6tBbix464JqAouZrObIlt0EStbEagqOuu8TqExiZBYHViM+9F27g
	 FjMkv+mg6q/ZB47wc8IpGLv8pWdAbY7Kx6J0YpeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 86/92] Revert "drm/gem-shmem: Use dma_buf from GEM object instance"
Date: Wed, 30 Jul 2025 11:36:34 +0200
Message-ID: <20250730093234.070807201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 6d496e9569983a0d7a05be6661126d0702cf94f7 upstream.

This reverts commit 1a148af06000e545e714fe3210af3d77ff903c11.

The dma_buf field in struct drm_gem_object is not stable over the
object instance's lifetime. The field becomes NULL when user space
releases the final GEM handle on the buffer object. This resulted
in a NULL-pointer deref.

Workarounds in commit 5307dce878d4 ("drm/gem: Acquire references on
GEM handles for framebuffers") and commit f6bfc9afc751 ("drm/framebuffer:
Acquire internal references on GEM handles") only solved the problem
partially. They especially don't work for buffer objects without a DRM
framebuffer associated.

Hence, this revert to going back to using .import_attach->dmabuf.

v3:
- cc stable

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: <stable@vger.kernel.org> # v6.15+
Link: https://lore.kernel.org/r/20250715155934.150656-7-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -339,7 +339,7 @@ int drm_gem_shmem_vmap(struct drm_gem_sh
 	int ret = 0;
 
 	if (drm_gem_is_imported(obj)) {
-		ret = dma_buf_vmap(obj->dma_buf, map);
+		ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
 	} else {
 		pgprot_t prot = PAGE_KERNEL;
 
@@ -399,7 +399,7 @@ void drm_gem_shmem_vunmap(struct drm_gem
 	struct drm_gem_object *obj = &shmem->base;
 
 	if (drm_gem_is_imported(obj)) {
-		dma_buf_vunmap(obj->dma_buf, map);
+		dma_buf_vunmap(obj->import_attach->dmabuf, map);
 	} else {
 		dma_resv_assert_held(shmem->base.resv);
 


