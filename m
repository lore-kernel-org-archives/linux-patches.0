Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9F1E04BF;
	Wed,  6 Nov 2024 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898068; cv=none; b=rTfUJYFF7uuLaEJTxkjiM+KQBwIgJDwUj/kvw8EhYc1k9vKsfz8mQrYLWX20mlIv7FzFYnyrQqGju78onRgskwOPN6q2v4iJURvDObhE8qTcx/e6XRwv2EM04OPQbypagXYjOaHI7m25rtHdsA1rfTNcN2gpCXu4y3OiFXzJkS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898068; c=relaxed/simple;
	bh=ssg1fSOiukTfwCOWz48yqeHZi50DdIAN7UBcFRQz/EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRWYg3+MAl7LN4G8HvNCq6bXMORj9FD4Un/GgZfDrPPuXoI4o9O2NFkDoZGolF02Qbi3P0EYTIqVBhsqaMy6OWHm2CAwAM3QUC8lutS7n6p2u8MszDT882KWDPho2KOkyvPDz+7cxdh7juur8l/zbWRL36HDsWea/Tog5ExtVWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BT10k7nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BT10k7nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D997EC4CECD;
	Wed,  6 Nov 2024 13:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898068;
	bh=ssg1fSOiukTfwCOWz48yqeHZi50DdIAN7UBcFRQz/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT10k7ncGU3JU1fqsDHd+XbacGEq869qtzYSM23qOc3rHS+7wPcMuJiN+c9huiYzl
	 RQIchVqMBQbPNC9NA3HL88HTgblBGPcfYP2ZFrrJ2pwXDWwiXe+ALx+r/BF9VtXNRL
	 6Ifenm1GLoolFB37NPG0hpPmwsXtLzCWQrLAUaBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/462] drm/radeon/evergreen_cs: fix int overflow errors in cs track offsets
Date: Wed,  6 Nov 2024 12:59:29 +0100
Message-ID: <20241106120333.384588700@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 3fbaf475a5b8361ebee7da18964db809e37518b7 ]

Several cs track offsets (such as 'track->db_s_read_offset')
either are initialized with or plainly take big enough values that,
once shifted 8 bits left, may be hit with integer overflow if the
resulting values end up going over u32 limit.

Same goes for a few instances of 'surf.layer_size * mslice'
multiplications that are added to 'offset' variable - they may
potentially overflow as well and need to be validated properly.

While some debug prints in this code section take possible overflow
issues into account, simply casting to (unsigned long) may be
erroneous in its own way, as depending on CPU architecture one is
liable to get different results.

Fix said problems by:
 - casting 'offset' to fixed u64 data type instead of
 ambiguous unsigned long.
 - casting one of the operands in vulnerable to integer
 overflow cases to u64.
 - adjust format specifiers in debug prints to properly
 represent 'offset' values.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 285484e2d55e ("drm/radeon: add support for evergreen/ni tiling informations v11")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/evergreen_cs.c | 62 +++++++++++++--------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index c410cad28f19f..468efa5ac8fc7 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -396,7 +396,7 @@ static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, unsigned i
 	struct evergreen_cs_track *track = p->track;
 	struct eg_surface surf;
 	unsigned pitch, slice, mslice;
-	unsigned long offset;
+	u64 offset;
 	int r;
 
 	mslice = G_028C6C_SLICE_MAX(track->cb_color_view[id]) + 1;
@@ -434,14 +434,14 @@ static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, unsigned i
 		return r;
 	}
 
-	offset = track->cb_color_bo_offset[id] << 8;
+	offset = (u64)track->cb_color_bo_offset[id] << 8;
 	if (offset & (surf.base_align - 1)) {
-		dev_warn(p->dev, "%s:%d cb[%d] bo base %ld not aligned with %ld\n",
+		dev_warn(p->dev, "%s:%d cb[%d] bo base %llu not aligned with %ld\n",
 			 __func__, __LINE__, id, offset, surf.base_align);
 		return -EINVAL;
 	}
 
-	offset += surf.layer_size * mslice;
+	offset += (u64)surf.layer_size * mslice;
 	if (offset > radeon_bo_size(track->cb_color_bo[id])) {
 		/* old ddx are broken they allocate bo with w*h*bpp but
 		 * program slice with ALIGN(h, 8), catch this and patch
@@ -449,14 +449,14 @@ static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, unsigned i
 		 */
 		if (!surf.mode) {
 			uint32_t *ib = p->ib.ptr;
-			unsigned long tmp, nby, bsize, size, min = 0;
+			u64 tmp, nby, bsize, size, min = 0;
 
 			/* find the height the ddx wants */
 			if (surf.nby > 8) {
 				min = surf.nby - 8;
 			}
 			bsize = radeon_bo_size(track->cb_color_bo[id]);
-			tmp = track->cb_color_bo_offset[id] << 8;
+			tmp = (u64)track->cb_color_bo_offset[id] << 8;
 			for (nby = surf.nby; nby > min; nby--) {
 				size = nby * surf.nbx * surf.bpe * surf.nsamples;
 				if ((tmp + size * mslice) <= bsize) {
@@ -468,7 +468,7 @@ static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, unsigned i
 				slice = ((nby * surf.nbx) / 64) - 1;
 				if (!evergreen_surface_check(p, &surf, "cb")) {
 					/* check if this one works */
-					tmp += surf.layer_size * mslice;
+					tmp += (u64)surf.layer_size * mslice;
 					if (tmp <= bsize) {
 						ib[track->cb_color_slice_idx[id]] = slice;
 						goto old_ddx_ok;
@@ -477,9 +477,9 @@ static int evergreen_cs_track_validate_cb(struct radeon_cs_parser *p, unsigned i
 			}
 		}
 		dev_warn(p->dev, "%s:%d cb[%d] bo too small (layer size %d, "
-			 "offset %d, max layer %d, bo size %ld, slice %d)\n",
+			 "offset %llu, max layer %d, bo size %ld, slice %d)\n",
 			 __func__, __LINE__, id, surf.layer_size,
-			track->cb_color_bo_offset[id] << 8, mslice,
+			(u64)track->cb_color_bo_offset[id] << 8, mslice,
 			radeon_bo_size(track->cb_color_bo[id]), slice);
 		dev_warn(p->dev, "%s:%d problematic surf: (%d %d) (%d %d %d %d %d %d %d)\n",
 			 __func__, __LINE__, surf.nbx, surf.nby,
@@ -563,7 +563,7 @@ static int evergreen_cs_track_validate_stencil(struct radeon_cs_parser *p)
 	struct evergreen_cs_track *track = p->track;
 	struct eg_surface surf;
 	unsigned pitch, slice, mslice;
-	unsigned long offset;
+	u64 offset;
 	int r;
 
 	mslice = G_028008_SLICE_MAX(track->db_depth_view) + 1;
@@ -609,18 +609,18 @@ static int evergreen_cs_track_validate_stencil(struct radeon_cs_parser *p)
 		return r;
 	}
 
-	offset = track->db_s_read_offset << 8;
+	offset = (u64)track->db_s_read_offset << 8;
 	if (offset & (surf.base_align - 1)) {
-		dev_warn(p->dev, "%s:%d stencil read bo base %ld not aligned with %ld\n",
+		dev_warn(p->dev, "%s:%d stencil read bo base %llu not aligned with %ld\n",
 			 __func__, __LINE__, offset, surf.base_align);
 		return -EINVAL;
 	}
-	offset += surf.layer_size * mslice;
+	offset += (u64)surf.layer_size * mslice;
 	if (offset > radeon_bo_size(track->db_s_read_bo)) {
 		dev_warn(p->dev, "%s:%d stencil read bo too small (layer size %d, "
-			 "offset %ld, max layer %d, bo size %ld)\n",
+			 "offset %llu, max layer %d, bo size %ld)\n",
 			 __func__, __LINE__, surf.layer_size,
-			(unsigned long)track->db_s_read_offset << 8, mslice,
+			(u64)track->db_s_read_offset << 8, mslice,
 			radeon_bo_size(track->db_s_read_bo));
 		dev_warn(p->dev, "%s:%d stencil invalid (0x%08x 0x%08x 0x%08x 0x%08x)\n",
 			 __func__, __LINE__, track->db_depth_size,
@@ -628,18 +628,18 @@ static int evergreen_cs_track_validate_stencil(struct radeon_cs_parser *p)
 		return -EINVAL;
 	}
 
-	offset = track->db_s_write_offset << 8;
+	offset = (u64)track->db_s_write_offset << 8;
 	if (offset & (surf.base_align - 1)) {
-		dev_warn(p->dev, "%s:%d stencil write bo base %ld not aligned with %ld\n",
+		dev_warn(p->dev, "%s:%d stencil write bo base %llu not aligned with %ld\n",
 			 __func__, __LINE__, offset, surf.base_align);
 		return -EINVAL;
 	}
-	offset += surf.layer_size * mslice;
+	offset += (u64)surf.layer_size * mslice;
 	if (offset > radeon_bo_size(track->db_s_write_bo)) {
 		dev_warn(p->dev, "%s:%d stencil write bo too small (layer size %d, "
-			 "offset %ld, max layer %d, bo size %ld)\n",
+			 "offset %llu, max layer %d, bo size %ld)\n",
 			 __func__, __LINE__, surf.layer_size,
-			(unsigned long)track->db_s_write_offset << 8, mslice,
+			(u64)track->db_s_write_offset << 8, mslice,
 			radeon_bo_size(track->db_s_write_bo));
 		return -EINVAL;
 	}
@@ -660,7 +660,7 @@ static int evergreen_cs_track_validate_depth(struct radeon_cs_parser *p)
 	struct evergreen_cs_track *track = p->track;
 	struct eg_surface surf;
 	unsigned pitch, slice, mslice;
-	unsigned long offset;
+	u64 offset;
 	int r;
 
 	mslice = G_028008_SLICE_MAX(track->db_depth_view) + 1;
@@ -707,34 +707,34 @@ static int evergreen_cs_track_validate_depth(struct radeon_cs_parser *p)
 		return r;
 	}
 
-	offset = track->db_z_read_offset << 8;
+	offset = (u64)track->db_z_read_offset << 8;
 	if (offset & (surf.base_align - 1)) {
-		dev_warn(p->dev, "%s:%d stencil read bo base %ld not aligned with %ld\n",
+		dev_warn(p->dev, "%s:%d stencil read bo base %llu not aligned with %ld\n",
 			 __func__, __LINE__, offset, surf.base_align);
 		return -EINVAL;
 	}
-	offset += surf.layer_size * mslice;
+	offset += (u64)surf.layer_size * mslice;
 	if (offset > radeon_bo_size(track->db_z_read_bo)) {
 		dev_warn(p->dev, "%s:%d depth read bo too small (layer size %d, "
-			 "offset %ld, max layer %d, bo size %ld)\n",
+			 "offset %llu, max layer %d, bo size %ld)\n",
 			 __func__, __LINE__, surf.layer_size,
-			(unsigned long)track->db_z_read_offset << 8, mslice,
+			(u64)track->db_z_read_offset << 8, mslice,
 			radeon_bo_size(track->db_z_read_bo));
 		return -EINVAL;
 	}
 
-	offset = track->db_z_write_offset << 8;
+	offset = (u64)track->db_z_write_offset << 8;
 	if (offset & (surf.base_align - 1)) {
-		dev_warn(p->dev, "%s:%d stencil write bo base %ld not aligned with %ld\n",
+		dev_warn(p->dev, "%s:%d stencil write bo base %llu not aligned with %ld\n",
 			 __func__, __LINE__, offset, surf.base_align);
 		return -EINVAL;
 	}
-	offset += surf.layer_size * mslice;
+	offset += (u64)surf.layer_size * mslice;
 	if (offset > radeon_bo_size(track->db_z_write_bo)) {
 		dev_warn(p->dev, "%s:%d depth write bo too small (layer size %d, "
-			 "offset %ld, max layer %d, bo size %ld)\n",
+			 "offset %llu, max layer %d, bo size %ld)\n",
 			 __func__, __LINE__, surf.layer_size,
-			(unsigned long)track->db_z_write_offset << 8, mslice,
+			(u64)track->db_z_write_offset << 8, mslice,
 			radeon_bo_size(track->db_z_write_bo));
 		return -EINVAL;
 	}
-- 
2.43.0



