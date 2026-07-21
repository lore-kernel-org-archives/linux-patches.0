Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724D846D2B3;
	Tue, 21 Jul 2026 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655587; cv=none; b=BtVX898sNqaG5kJBIfql882nyUUAP0xF9jWSi8SObhlrY2R0Zs8KtvJ762yFXp6ZLdduNYTaOlCj+kfSCOVSWkNMHY5g0xYOoh1JAsPBFyBUyQctOEow08VdqeOUCLqBnOkXIrvqNgxgfjxdYbLLXfFQjuOYEyvbSF8KSZvlyFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655587; c=relaxed/simple;
	bh=mcNmW3UDCsvv82gegy/KYpjkmSyjHNkRj7bmZaehIsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+JjnlX6mjx2uzOrhheiKrGh65abW1hNpym6AMQOVI+shTEJACnnYeiEfFpkxMJDQWmvD6J40SJr0WgG+kIyx5NaGpc7oNdexhrygoVPuoFKktycaS4bvDtKvueZwBcWXKCCnT5dukNtbhuLvfMC671BLD627O0SOZ7lJNHANwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUZiCuud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUZiCuud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969081F00A3A;
	Tue, 21 Jul 2026 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655586;
	bh=r8uLvb/2KFt8eoKOVKz9W1SKXo98rCe4h7CZO/3Jpko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUZiCuudJWeiPuvvE6JQsg4phAhMHJYH5dY7Osy0wIrgWb3BjshC7h8u00hYM4vS3
	 mVsTSrdCbgbvTjPk03pWll8KlSD4BN2zbXob16G80FhMyOd3om3Q+BF3k4iKINdnny
	 jTVcwBkSqxqxrQKcyVGerVHMswOXYcK71bLMP+3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0066/1611] drm/amdgpu: fix integer overflow in amdgpu_gem_align_pitch()
Date: Tue, 21 Jul 2026 17:03:02 +0200
Message-ID: <20260721152516.318004640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1bc1233487a0b6..cd52ddd27c58b3 100644
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
@@ -1209,13 +1210,14 @@ int amdgpu_gem_list_handles_ioctl(struct drm_device *dev, void *data,
 	return ret;
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
@@ -1230,9 +1232,12 @@ static int amdgpu_gem_align_pitch(struct amdgpu_device *adev,
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
@@ -1259,8 +1264,12 @@ int amdgpu_mode_dumb_create(struct drm_file *file_priv,
 
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



