Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA9426FA50;
	Wed, 30 Jul 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869153; cv=none; b=Wb/NFnLfxWMwCMr+ff2ay9lL+yiLWKI9Da8/JquDbH/eRrM7eLOtrKxqNilCwpkzUu1OI2OvS0HBJCmlTX9GZLus3tk41U3p+rdfVwu01Xq0UpvVZsRN8q9vi6JTvX+GFV0Lv8kDFS23XelEmtkST1RJ97PJ8YYP3Vs8VkRz080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869153; c=relaxed/simple;
	bh=08wLVZlE6dhQltdZtER8Z46kQfocxm0tnQiQ6BQ1reE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nR3ai/PyZLxcDvCWlfp+rGIU53FVG859qXwBVQflTfefE/VJ7u6WVlxumEF7HYtSrhzhHx8HjaE8XIr4QH1HygdUGWdS1sIQNtzxGnJZGdqxQT+OKCf3tjeXTI1+8OfQcH3oe7kI+KM3CsU//Y9FBHymUHfy9nzi7PIFJjF1Lt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6sH+LzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6sH+LzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCB0C4CEF5;
	Wed, 30 Jul 2025 09:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869153;
	bh=08wLVZlE6dhQltdZtER8Z46kQfocxm0tnQiQ6BQ1reE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6sH+LzIP4FLW+bDFoxVPUsjeFGoU9PwilUSrrYAkHBqSOCL4hPJsEp5Y8GjTCzxY
	 U9bik40bFkjGx9+XUqXGMkbyOFO6h+AJ27Jl2ISl7XM6bG9xzEX6UlUOkGtBhTJZWE
	 NaSDuIBMs4kh3y+pJ2zr7I/unNSHJE3tJ+yXFjzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.15 49/92] Revert "drm/gem-dma: Use dma_buf from GEM object instance"
Date: Wed, 30 Jul 2025 11:35:57 +0200
Message-ID: <20250730093232.651721761@linuxfoundation.org>
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

commit 1918e79be908b8a2c8757640289bc196c14d928a upstream.

This reverts commit e8afa1557f4f963c9a511bd2c6074a941c308685.

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
Link: https://lore.kernel.org/r/20250715155934.150656-8-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_dma_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem_dma_helper.c
+++ b/drivers/gpu/drm/drm_gem_dma_helper.c
@@ -230,7 +230,7 @@ void drm_gem_dma_free(struct drm_gem_dma
 
 	if (drm_gem_is_imported(gem_obj)) {
 		if (dma_obj->vaddr)
-			dma_buf_vunmap_unlocked(gem_obj->dma_buf, &map);
+			dma_buf_vunmap_unlocked(gem_obj->import_attach->dmabuf, &map);
 		drm_prime_gem_destroy(gem_obj, dma_obj->sgt);
 	} else if (dma_obj->vaddr) {
 		if (dma_obj->map_noncoherent)


