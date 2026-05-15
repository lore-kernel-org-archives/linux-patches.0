Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE5B3FF1DA;
	Fri, 15 May 2026 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860407; cv=none; b=MhE0SfTK3R6t3MTYBJIgvuS0tMGM5OEP6cJmEoLHCKzEtAT75ohJTgP0TKuepX3L7nmex9U5/us+WTDUsKrklAmsjfIkcXE7qSb6FsG8XAYFJ/OlUmyROXoBfpOEzSbnXAXJVvkUUXvYlYZFXHoqTN8DY/Smat6vyGW5GOPksjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860407; c=relaxed/simple;
	bh=oznLtrLFdgdWlgwAdHjeV7CoDA/b3zeF6U6SzQbHkhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqzxyVfR+xlLw6Xe0O7kb5cnrMacr7PVP7ePdIuApldBWkavjD1/j4xs2aW5q2bfDqBV3HGmoIdVyKQYgtag2W5Oo0pj7XKnv58Hc2MLF9LAiDI/noMgi7i3luetSMaE3ATjrqrw8DLNJCkS+/jVKOF3JmMTQqWaF0d5e7nMcvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1xKp8N4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1xKp8N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3513DC2BCB3;
	Fri, 15 May 2026 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860407;
	bh=oznLtrLFdgdWlgwAdHjeV7CoDA/b3zeF6U6SzQbHkhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1xKp8N410dul3WhdN4ouv0idIuIEqQ+dghw4eSKufztaG1PfcsPhVt+cYGcriQTV
	 fESVwCB5yGfRenvbPhfzRfOkz/jRrp9VXXFty9ivT+6w4rxvVGlV89M4zaT44glvsT
	 uENs7+69CUB4DsncedRZwAZ7XwWi+GTF/oNAdgdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>
Subject: [PATCH 6.12 078/144] drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()
Date: Fri, 15 May 2026 17:48:24 +0200
Message-ID: <20260515154655.339654768@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


