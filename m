Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E494746D2B3;
	Tue, 21 Jul 2026 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655590; cv=none; b=Bs0zs/DQujIUErDhDuBFwc2KWFya2w1AtYCeQoxk/xkDFt913GKgn6yAe32fjj+fKeDN88BUTDzDi/U2s9QixK7LlSyAphuOLai+9zK4WR4KWNPvdX5Tgzi9Bbr4sK5PCe5yUHteHxVQ0qqLkN5XosD4dLinn7frQ0OrwHfym4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655590; c=relaxed/simple;
	bh=V45W132CyN/kpjXgsGl4RbSB1VNsnlca+QMzcO+auM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp+MxwLxoLIPP9VzrkIaaRLNIowsRJb7Lb+lUCma31NpP+NF9KpB6ZdMcHHlpF9bRpsrxXjNEbS6FtmhL0VYQBiytEHWmptjnBQl8lOSAxSVBOn2TYYMrbHz7h9Dyu+Lgi/l2Wr2OiN+BVNFgrXxgGTvRAZxnrl3KdB/1UXKndY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wK3Cie5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK3Cie5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516AB1F000E9;
	Tue, 21 Jul 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655588;
	bh=AcUOAV9Pko9D05EMCKdBX0D4KSOEtmy0RbFopVfXgpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wK3Cie5inClL3GucAifVs7sz9+Fcv6zZY1tcY51NODIb9jSjILvUE2GJOMh2FJWYy
	 W1lvWn6RmRtIrKbUC1FHBSFHchlJZftEQNYm0xbltQfmOD+tacW8kWoMxye/ZWdZCU
	 /IfdMKjUz2IguMWEXvnFI5byCyeYDss39Q+NqRjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0067/1611] drm/radeon: fix integer overflow in radeon_align_pitch()
Date: Tue, 21 Jul 2026 17:03:03 +0200
Message-ID: <20260721152516.341227303@linuxfoundation.org>
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
index f86773f3db200a..1e84342ac05134 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -28,6 +28,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/iosys-map.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 
 #include <drm/drm_device.h>
@@ -812,6 +813,7 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
 	int aligned = width;
 	int align_large = (ASIC_IS_AVIVO(rdev)) || tiled;
 	int pitch_mask = 0;
+	int pitch;
 
 	switch (cpp) {
 	case 1:
@@ -826,9 +828,12 @@ int radeon_align_pitch(struct radeon_device *rdev, int width, int cpp, bool tile
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
@@ -842,8 +847,12 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
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



