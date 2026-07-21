Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C4A33ADB0;
	Tue, 21 Jul 2026 19:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661426; cv=none; b=iy2r5L+KuZyX7f+qRv5/PI/icO0nSQncBI68A0UAoEm1T8e+PgHMrRei50k+oFDCdz5O7LJJda54tf9vuryMCOvQvf3QY0wJxZUY87u/ck1kJgZvPBOjziJGP4DL6vWcP3/B3PKMs9WOdwApEY4IEreO1FByMYOGQ2+YvXCNTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661426; c=relaxed/simple;
	bh=1mnFdIxo6z6t9qTyQQ6rJLkVULgzUmE98gLsOZufrh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUSYGdy/NmqbDAT1ZyqjIUpWrkBTR0lOWeI8H6Mn546vYkPMY5sIl1wuFb9Jg+8a9scfc1OOgxXoifcB2mFGb9LHgANxY1ch7rULSt0T3aSrFRGtX/E2ih4BdKlANBy3HJw05tvhmkSkNoNkAt8NZ/tci58Pql7YTWjB+bh1m4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz5D0eGX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz5D0eGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9241F000E9;
	Tue, 21 Jul 2026 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661425;
	bh=3iadmjRtU0EG4tkMRV6xZ+RiqwwuwtYOsi58sneGs4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kz5D0eGXLHNFtKdjKewdB45U/RQ5suQBm4DA9iWDPkU1aZDjZ9tYR5cHJtmk9uheL
	 nAmla0qR9WRyNJYbytgKUqIJzdwS95hiWCxclCY3MjG+lxGgR5xdWWEaSSEz7p0KBI
	 aXcYPOOBKvauorM7uBMz72yzS+MHAEbt8Lh1la5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0062/1276] drm/amdgpu: fix integer overflow in amdgpu_gem_align_pitch()
Date: Tue, 21 Jul 2026 17:08:25 +0200
Message-ID: <20260721152447.473164356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Werner Kasselman <werner@verivus.ai>

[ Upstream commit fc3659f178d4a65599167d5a648bbeef4b0d4446 ]

amdgpu_gem_align_pitch() is passed u32 width and cpp from dumb buffer
creation but uses signed int internally.  The round-up add and the
aligned * cpp multiplication can overflow, returning zero or a negative
pitch.  A zero pitch propagates to a zero-sized GEM object allocation
that reaches userspace via DRM_IOCTL_MODE_CREATE_DUMB.

Switch the helper to unsigned int and use check_add_overflow() /
check_mul_overflow() so wraparound returns zero.  Reject a zero pitch
or size in amdgpu_mode_dumb_create() rather than allocating a zero-
byte BO.

Fixes: 8e911ab770f7 ("drm: amdgpu: Replace drm_fb_get_bpp_depth() with drm_format_plane_cpp()")
Signed-off-by: Werner Kasselman <werner@verivus.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 1a5df8b9466161..51875f00084c31 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -27,6 +27,7 @@
  */
 #include <linux/ktime.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
@@ -913,13 +914,14 @@ int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 	return r;
 }
 
-static int amdgpu_gem_align_pitch(struct amdgpu_device *adev,
-				  int width,
-				  int cpp,
-				  bool tiled)
+static unsigned int amdgpu_gem_align_pitch(struct amdgpu_device *adev,
+					   unsigned int width,
+					   unsigned int cpp,
+					   bool tiled)
 {
-	int aligned = width;
-	int pitch_mask = 0;
+	unsigned int aligned = width;
+	unsigned int pitch_mask = 0;
+	unsigned int pitch;
 
 	switch (cpp) {
 	case 1:
@@ -934,9 +936,12 @@ static int amdgpu_gem_align_pitch(struct amdgpu_device *adev,
 		break;
 	}
 
-	aligned += pitch_mask;
+	if (check_add_overflow(aligned, pitch_mask, &aligned))
+		return 0;
 	aligned &= ~pitch_mask;
-	return aligned * cpp;
+	if (check_mul_overflow(aligned, cpp, &pitch))
+		return 0;
+	return pitch;
 }
 
 int amdgpu_mode_dumb_create(struct drm_file *file_priv,
@@ -963,8 +968,12 @@ int amdgpu_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = amdgpu_gem_align_pitch(adev, args->width,
 					     DIV_ROUND_UP(args->bpp, 8), 0);
+	if (!args->pitch)
+		return -EINVAL;
 	args->size = (u64)args->pitch * args->height;
 	args->size = ALIGN(args->size, PAGE_SIZE);
+	if (!args->size)
+		return -EINVAL;
 	domain = amdgpu_bo_get_preferred_domain(adev,
 				amdgpu_display_supported_domains(adev, flags));
 	r = amdgpu_gem_object_create(adev, args->size, 0, domain, flags,
-- 
2.53.0



