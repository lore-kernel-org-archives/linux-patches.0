Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A6F42F704;
	Tue, 21 Jul 2026 20:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665598; cv=none; b=X3UFqoW0wevcNktD7MVmE0y8CELe930r4YaMgbDYpRKEDU7V7G93fBupngGGvpmOa7Lv3UEIDK6TrNvKyRmrV6CIxDxeD28bh+n54F2h8af0ifAwN1sIQ8ohJnUmmX254+JgyFa8dOx2lZvojsk92jYBWllDlBKVMTBUjbx/Kgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665598; c=relaxed/simple;
	bh=Ph4sdyz6412ERXGbLgM74RYvSFR1jGBlpiY2H+uLq0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANEp/xZCuqab5N5LqHrnFtAAbfnnu9o1T6rnLs4Duqr/yExrvvkm5RmoVpLGYX51ErbVw7KNn1+NYrk5aoH2rNnzoOFFNtWzq92FNbENfLyIuM4iyQ1NtvkzQHc5vJlUW/KviSUEFtwD2uA9OpGmO8RSSipa/rfAJCxLkxY5Pbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGJEIgAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGJEIgAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874DB1F000E9;
	Tue, 21 Jul 2026 20:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665597;
	bh=wWF1s8JT3JREBQs3CRzzDN3EQfPVK+MH98V5Sxn73q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGJEIgAygd2LPUqV8rI6VlhhJ5SNFksCgVtHUPay3Rn3KTiSBbv2bnMfqIgcHbRfX
	 AI1nMMut/lOZh5LiGA/7qPq2rPZrrxIU1J36LeQ1rGh40a/IUXnP/tV19oFmWQKwf7
	 mAT3wd6JA+9iGxSAcOBCSMrzRAw8tQbsLKnwEWV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0362/1266] drm/radeon: fix integer overflow in radeon_align_pitch()
Date: Tue, 21 Jul 2026 17:13:19 +0200
Message-ID: <20260721152449.928009371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 96934fee7e9432..03600671370cfa 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/iosys-map.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 
 #include <drm/drm_device.h>
@@ -809,6 +810,7 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
 	int aligned = width;
 	int align_large = (ASIC_IS_AVIVO(rdev)) || tiled;
 	int pitch_mask = 0;
+	int pitch;
 
 	switch (cpp) {
 	case 1:
@@ -823,9 +825,12 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
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
@@ -839,8 +844,12 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
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



