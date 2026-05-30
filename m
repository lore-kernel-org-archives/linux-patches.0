Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FAE329C6D;
	Sat, 30 May 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163899; cv=none; b=PEcnRdui7CWy9SPU+JL5kjAO4mtZr/9+DkZmaO/vmZDSCNiPlEFiOyutCd/CraBeJCqEKCbfVy7W0mIM2nAPikQcskp2V9wJbAnKvTk0SU6ogbbNWLppGfIu21DUMDdY03bP9GntgCvbyGxaXazZxK+dX7sRgN6OFGXqgFD6gaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163899; c=relaxed/simple;
	bh=CF63jfuR6IDbP+gwm5Yb0gdphy00NnlUDGI7QLeaWf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+u8Bcb++wrtI62axJu+sZdWChZ9Nnse73PHSG0yIAILE68Q3EJzepcEB/Vdr+is5jlxFcBnWxst3y8Qm5OHwWEnWTAm+vY2hPxsaMfgaSNk839xH08BKSAmLH9TgY71JoMuvro8dJN9aycdTKtXfr3NKGa2WYQM2o8FWsr2rg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SAvcTxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SAvcTxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F171F00893;
	Sat, 30 May 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163898;
	bh=w6FFm38U076VZpQt00MSGxp0JGGT8dClKM94hvi8aXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SAvcTxs4TBLyM1fUffHt4tGj8kqJEOLXzfviMnXVzJjp7l/72eaixk+OXPW+hvrZ
	 O24bvMiZ5EO49pVupCBIbZcM6l0gth8xa9tsSgm7X5k/eGmIzYqj87hUUqxELGsb5w
	 nqV/yZiSzl6OjmBfGlsP3TQbf8C2ANUybD1VZ5rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>
Subject: [PATCH 5.15 366/776] drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()
Date: Sat, 30 May 2026 18:01:20 +0200
Message-ID: <20260530160250.015415758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,8 +159,8 @@ int drm_gem_fb_init_with_funcs(struct dr
 	}
 
 	for (i = 0; i < info->num_planes; i++) {
-		unsigned int width = mode_cmd->width / (i ? info->hsub : 1);
-		unsigned int height = mode_cmd->height / (i ? info->vsub : 1);
+		unsigned int width = drm_format_info_plane_width(info, mode_cmd->width, i);
+		unsigned int height = drm_format_info_plane_height(info, mode_cmd->height, i);
 		unsigned int min_size;
 
 		objs[i] = drm_gem_object_lookup(file, mode_cmd->handles[i]);


