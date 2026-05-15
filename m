Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A473E00A6;
	Fri, 15 May 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861483; cv=none; b=iM4CCexewraQYzDi67mf7Jr/CT3Px68UD1gjaRXwvIyAd1lnsTDvfAaJQEzvYORu0jRnghyAKncFKqlOH8iMe4bINalZbVk0t9p05UOjTLCgBF9du7XJO/so2d+tvWgG0vQeqaWapsAmIEgYCpsO8I2oGDVvW6jp/s8E3MBtaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861483; c=relaxed/simple;
	bh=Zv/rBDw5MpHMhe61+sgwSWEaWY/8r+F4uqIa9abjCvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLQcJjqRB/Nt59EI57PPDN6c4tfbYdP2Oe449t2eqrvMS9+EgszjxMZB+Fz3Zjp87c/lBPkgGtOObb16B4wuCM7eNy4b+WW+h4++N3Oyuza9K4wNoemlG/cay8J1cylvIAcTfBCIvTnZTTcXJ+6vt0XdQd4lGK7eQLgnQpjAYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9fZTPji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9fZTPji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F37C2BCB0;
	Fri, 15 May 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861483;
	bh=Zv/rBDw5MpHMhe61+sgwSWEaWY/8r+F4uqIa9abjCvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9fZTPjiNtuBysY7N/SqjSZucpyLWWO/W7VdGwT51TN4RkzeZveZFwtjiwLPla8yC
	 lP9MYSvhVaBZFlPoJm9Tw2QxpMYdRGpBGGOMijMjuZ/QPSKnXkGaqj6PuZ6sxYBN+8
	 j+AQ4RdQ6uO0FGqiFt5GlHq35F5pQf3zNt55TT+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>
Subject: [PATCH 6.6 347/474] drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()
Date: Fri, 15 May 2026 17:47:36 +0200
Message-ID: <20260515154722.524933584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit 3d4c2268bd7243c3780fe32bf24ff876da272acf upstream.

drm_gem_fb_init_with_funcs() computes sub-sampled plane dimensions
using plain integer division:

  unsigned int width  = mode_cmd->width  / (i ? info->hsub : 1);
  unsigned int height = mode_cmd->height / (i ? info->vsub : 1);

However, the ioctl-level framebuffer_check() in drm_framebuffer.c uses
drm_format_info_plane_width/height() which round up dimensions via
DIV_ROUND_UP(). This inconsistency corrupts the subsequent GEM object
size check for certain pixel format and dimension combinations.

For example, with NV12 (vsub=2) and a 1-pixel-tall framebuffer the
GEM size validation path sees height=0 instead of height=1. The
expression (height - 1) then wraps to UINT_MAX as an unsigned int,
causing min_size to overflow and wrap back to a small value. A tiny
GEM object therefore passes the size guard, yet when the GPU accesses
the chroma plane it will read or write memory beyond the object's
bounds.

Fix by replacing the open-coded divisions with drm_format_info_plane_width()
and drm_format_info_plane_height(), which use DIV_ROUND_UP() and match
the calculation already used in framebuffer_check().

Fixes: 4c3dbb2c312c ("drm: Add GEM backed framebuffer library")
Cc: stable@vger.kernel.org # v4.14+
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260420013637.457751-1-ashutoshdesai993@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_framebuffer_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem_framebuffer_helper.c
+++ b/drivers/gpu/drm/drm_gem_framebuffer_helper.c
@@ -174,8 +174,8 @@ int drm_gem_fb_init_with_funcs(struct dr
 	}
 
 	for (i = 0; i < info->num_planes; i++) {
-		unsigned int width = mode_cmd->width / (i ? info->hsub : 1);
-		unsigned int height = mode_cmd->height / (i ? info->vsub : 1);
+		unsigned int width = drm_format_info_plane_width(info, mode_cmd->width, i);
+		unsigned int height = drm_format_info_plane_height(info, mode_cmd->height, i);
 		unsigned int min_size;
 
 		objs[i] = drm_gem_object_lookup(file, mode_cmd->handles[i]);


