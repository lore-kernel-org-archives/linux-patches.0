Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718DC17A2F6;
	Tue, 21 Jul 2026 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661429; cv=none; b=gcg4Noaqmo6jQLxZF9xnT3ubMmGjOcPVEpTTR4zPdLmtusphslY3//yOkIpoo1qB20twWQQePy7ILY9PsGkLFOW/athiMaR3DTynPaEW7EaY7WnJFFyEuyaYB3LMHeq0Xt3uTFbsUfSzs4oH46NDxHjKXFIXtNOmJI+zsnyNfwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661429; c=relaxed/simple;
	bh=lWB0ID8jTjoxdnpIw9Pmn2BICoU4DPyhpYZXuJfCsLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6nJWe+2qDG8FfYgpY2npqDigv2yq/9fseb/GQz/cCzOySU654On7TqeHreDIDtvMnXBIknVzWHIuascZK/cE/EYrFuWaCfl0pLorFlUYOZQHJlQRdkInIkKYvTXxlMs87M4gYmVCHPbyhD5e6waCDXGdna7oatFg5PzZPjCLjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJcZEC7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJcZEC7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77CB1F000E9;
	Tue, 21 Jul 2026 19:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661428;
	bh=62/is63yEYGyBCP1EZS+BIpXHtk1mLtJyRTToXQeLRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJcZEC7R0DathLenFkJw71EZRuPkc0WtHZkbBX+W9ye47d26NaR34nD15UhGyQd9T
	 b/kAcoBMLdcOvbF6KQ+/Jy8QqtcBIjhKY4SVClOnIaVy0UNFdC2d+Y9+btor1ePUkC
	 OomHGUzvbhezSNg7vaQvoY6h7SsY/eWHq5k03Los=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0063/1276] drm/radeon: fix integer overflow in radeon_align_pitch()
Date: Tue, 21 Jul 2026 17:08:26 +0200
Message-ID: <20260721152447.495574240@linuxfoundation.org>
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

[ Upstream commit ce3b24eb3ee8f82de851535f516bf21f83e82259 ]

radeon_align_pitch() has the same kind of overflow issue as the old
amdgpu helper: both the alignment round-up add and the final
'aligned * cpp' calculation can overflow signed int.

If that wraps, radeon_mode_dumb_create() can end up returning an
invalid pitch or creating a zero-sized dumb buffer.

Fix this by using check_add_overflow() for the alignment round-up and
check_mul_overflow() for the final pitch calculation, returning 0 on
overflow. Also reject zero pitch and size in
radeon_mode_dumb_create().

Found via AST-based call-graph analysis using sqry.

Fixes: ff72145badb8 ("drm: dumb scanout create/mmap for intel/radeon (v3)")
Signed-off-by: Werner Kasselman <werner@verivus.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index bf2d4b16dc2a7f..49a9ec358124c5 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -28,6 +28,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/iosys-map.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 
 #include <drm/drm_device.h>
@@ -807,6 +808,7 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
 	int aligned = width;
 	int align_large = (ASIC_IS_AVIVO(rdev)) || tiled;
 	int pitch_mask = 0;
+	int pitch;
 
 	switch (cpp) {
 	case 1:
@@ -821,9 +823,12 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
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
 
 int radeon_mode_dumb_create(struct drm_file *file_priv,
@@ -837,8 +842,12 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = radeon_align_pitch(rdev, args->width,
 					 DIV_ROUND_UP(args->bpp, 8), 0);
+	if (!args->pitch)
+		return -EINVAL;
 	args->size = (u64)args->pitch * args->height;
 	args->size = ALIGN(args->size, PAGE_SIZE);
+	if (!args->size)
+		return -EINVAL;
 
 	r = radeon_gem_object_create(rdev, args->size, 0,
 				     RADEON_GEM_DOMAIN_VRAM, 0,
-- 
2.53.0



