Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41F13806D9;
	Thu, 30 Jul 2026 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426008; cv=none; b=Wl5S7AHUBiMrgOfQeNi5oR33cZUXK8iy+UrX325gWFjmllagtlJ3PMiTbDBp8EL7XrrULOo6/xJDkhYKvkSC0l2OnVnBdlSUD7kHIOcdZWD7XGpMpK5xyNxIy0ROPTlfiszTHrzf/7raUaxP8ac/naCGXOFieaqj8Li04CJMEIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426008; c=relaxed/simple;
	bh=j56ArIR4HhXtKIidvD0+VHye4GLOz60Y6UyHdF/dXbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwtDhi1lnUWHBJVTy3MWUB822KJZ55v74nZLxYZDQTJ/LdmZCaQEtIz8LlaHmMwNKHVkFRFB2/oh6weDU+4e7dE/7nv3sTx4Y/RdtWx7zoG+rQvIj4IKBcwD5r6+khr69Vb1V2otPkYjGUdERh+q4MpS+uR++jibexfNz4RFfes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny8tBr2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny8tBr2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40281F000E9;
	Thu, 30 Jul 2026 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426006;
	bh=Cko3bpWfwQI87lcRAKz6EvyhhCpj9NE/ehLtHafJ4H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ny8tBr2hLJVnoToHVpxK1pCFaL28O50bsGB3u5fA0uyyLpI5j+9pzDAZnnTXaL8As
	 vFRQPtqSs6LQ4UqP4JhBEqUgCUKke+gPyy5or/Swli5IRcrh/0kyA1G+z8aX66Et41
	 +knoKbbO4w/1wrc366DTsyDdJA4Oy8upIipaHXo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Pavel=20Ondra=C4=8Dka?= <pavel.ondracka@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 267/602] drm/radeon: fix r100_copy_blit for large BOs
Date: Thu, 30 Jul 2026 16:10:59 +0200
Message-ID: <20260730141441.582047078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Ondračka <pavel.ondracka@gmail.com>

commit f896e86273dbbebb5eac966b4a201b5c62a02e9a upstream.

r100_copy_blit() copies BOs as 1024-pixel-wide ARGB8888 blits, so one
GPU page becomes one blit row. Large copies are split into chunks of at
most 8191 rows.

The kernel register header names the packet coordinate dwords SRC_Y_X
and DST_Y_X. In the BITBLT_MULTI description in
R5xx_Acceleration_v1.5.pdf docs, these correspond to [SRC_X1 | SRC_Y1]
and [DST_X1 | DST_Y1], which are signed 13-bit coordinates in the
-8192..8191 range. The old code kept SRC/DST_PITCH_OFFSET at the BO base
and used SRC_Y_X/DST_Y_X as the chunk address, so large BO moves could
exceed that coordinate range.

Compute per-chunk SRC/DST_PITCH_OFFSET bases and emit zero source and
destination coordinates. r100_copy_blit() already packs
SRC/DST_PITCH_OFFSET as pitch plus base offset, so large chunk addresses
belong there rather than in the coordinate fields.

This fixes Prison Architect corruption with 4096x4096 mipped textures
after they are evicted to GTT under memory pressure on RV530.

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/6716
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Pavel Ondračka <pavel.ondracka@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87be26aee76239c6da03e599f238a426897f78ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/r100.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -906,6 +906,7 @@ struct radeon_fence *r100_copy_blit(stru
 {
 	struct radeon_ring *ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	struct radeon_fence *fence;
+	uint64_t cur_src_offset, cur_dst_offset;
 	uint32_t cur_pages;
 	uint32_t stride_bytes = RADEON_GPU_PAGE_SIZE;
 	uint32_t pitch;
@@ -934,6 +935,10 @@ struct radeon_fence *r100_copy_blit(stru
 			cur_pages = 8191;
 		}
 		num_gpu_pages -= cur_pages;
+		cur_src_offset = src_offset +
+			(uint64_t)num_gpu_pages * RADEON_GPU_PAGE_SIZE;
+		cur_dst_offset = dst_offset +
+			(uint64_t)num_gpu_pages * RADEON_GPU_PAGE_SIZE;
 
 		/* pages are in Y direction - height
 		   page width in X direction - width */
@@ -950,13 +955,13 @@ struct radeon_fence *r100_copy_blit(stru
 				  RADEON_DP_SRC_SOURCE_MEMORY |
 				  RADEON_GMC_CLR_CMP_CNTL_DIS |
 				  RADEON_GMC_WR_MSK_DIS);
-		radeon_ring_write(ring, (pitch << 22) | (src_offset >> 10));
-		radeon_ring_write(ring, (pitch << 22) | (dst_offset >> 10));
+		radeon_ring_write(ring, (pitch << 22) | (cur_src_offset >> 10));
+		radeon_ring_write(ring, (pitch << 22) | (cur_dst_offset >> 10));
 		radeon_ring_write(ring, (0x1fff) | (0x1fff << 16));
 		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, (0x1fff) | (0x1fff << 16));
-		radeon_ring_write(ring, num_gpu_pages);
-		radeon_ring_write(ring, num_gpu_pages);
+		radeon_ring_write(ring, 0);
+		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, cur_pages | (stride_pixels << 16));
 	}
 	radeon_ring_write(ring, PACKET0(RADEON_DSTCACHE_CTLSTAT, 0));


