Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650F529344A;
	Wed, 30 Jul 2025 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869146; cv=none; b=JbMPx+8o1+KCKKTp39VkaefI8gKlIDGQR8zJ110PTSWax7/qbVh8WLQrezj6gK/BPabVBtvPpwKk4qGqxgi0hLeXQwwLVa+VdBDetFc07mZX/eQdOCkc1YzSiEdjELDpRLvuYJr5xNhYGK5V5Dgs3UDraHSA9Kj8s29BGX+ucP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869146; c=relaxed/simple;
	bh=pzDzD2PKqDEetpYxWwemRmeBz2AspTm3M+UNZwpPu0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tp1GqlvlBA64CdacIqX6GU9O+LqIEKKhmZWPc7iwRXxXmhZy+/0u78wEhs2bXCPUfJb3I2idlJ9/dwAT+QuO3vTa+ghssE8zqO1TyaWSMCwb4bAYPmG6xtqEKFMd0eNSIjH3ICWe+uzjkW2NaGfpSXZwEAycSArJw/MGjUcM6Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaAlNu2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaAlNu2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBBDC4CEF5;
	Wed, 30 Jul 2025 09:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869146;
	bh=pzDzD2PKqDEetpYxWwemRmeBz2AspTm3M+UNZwpPu0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaAlNu2lA4705EKTV3zCtXaaCyyM0I1yq2fsWsI6orpcIkSz+jqOrqH9xajpvJ6+K
	 W8FFSESFndwTHgx6dv2SEKzwkDc6fSq6l5OThOANoQdYt6SbY8QHkrJEbefZRzkA4b
	 XVw41C9kNMJ5h1BkaxwpFSQjMmcfioF7FJ34CZ38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.15 48/92] Revert "drm/gem-framebuffer: Use dma_buf from GEM object instance"
Date: Wed, 30 Jul 2025 11:35:56 +0200
Message-ID: <20250730093232.614265458@linuxfoundation.org>
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

commit 2712ca878b688682ac2ce02aefc413fc76019cd9 upstream.

This reverts commit cce16fcd7446dcff7480cd9d2b6417075ed81065.

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
Link: https://lore.kernel.org/r/20250715155934.150656-6-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_framebuffer_helper.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem_framebuffer_helper.c
+++ b/drivers/gpu/drm/drm_gem_framebuffer_helper.c
@@ -419,6 +419,7 @@ EXPORT_SYMBOL(drm_gem_fb_vunmap);
 static void __drm_gem_fb_end_cpu_access(struct drm_framebuffer *fb, enum dma_data_direction dir,
 					unsigned int num_planes)
 {
+	struct dma_buf_attachment *import_attach;
 	struct drm_gem_object *obj;
 	int ret;
 
@@ -427,9 +428,10 @@ static void __drm_gem_fb_end_cpu_access(
 		obj = drm_gem_fb_get_obj(fb, num_planes);
 		if (!obj)
 			continue;
+		import_attach = obj->import_attach;
 		if (!drm_gem_is_imported(obj))
 			continue;
-		ret = dma_buf_end_cpu_access(obj->dma_buf, dir);
+		ret = dma_buf_end_cpu_access(import_attach->dmabuf, dir);
 		if (ret)
 			drm_err(fb->dev, "dma_buf_end_cpu_access(%u, %d) failed: %d\n",
 				ret, num_planes, dir);
@@ -452,6 +454,7 @@ static void __drm_gem_fb_end_cpu_access(
  */
 int drm_gem_fb_begin_cpu_access(struct drm_framebuffer *fb, enum dma_data_direction dir)
 {
+	struct dma_buf_attachment *import_attach;
 	struct drm_gem_object *obj;
 	unsigned int i;
 	int ret;
@@ -462,9 +465,10 @@ int drm_gem_fb_begin_cpu_access(struct d
 			ret = -EINVAL;
 			goto err___drm_gem_fb_end_cpu_access;
 		}
+		import_attach = obj->import_attach;
 		if (!drm_gem_is_imported(obj))
 			continue;
-		ret = dma_buf_begin_cpu_access(obj->dma_buf, dir);
+		ret = dma_buf_begin_cpu_access(import_attach->dmabuf, dir);
 		if (ret)
 			goto err___drm_gem_fb_end_cpu_access;
 	}


