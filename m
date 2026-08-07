Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857A73B2FF2;
	Fri,  7 Aug 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115617; cv=none; b=vC6aPgJJU1g/uo4t0h9pn10eHiucmDxglnEyvdSHBD+NXQLktSDMWKmajK3Ott0SwFM6HrpovAp5H5hmj4ejRcaUsTYa+bb+420FtCNSVZbGq1JYnDZII11+DDZROFKwG5xC3ce5wyuh9Sp156hiMCtl0Xcrs5UIJ4v9TAujEco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115617; c=relaxed/simple;
	bh=AW1wtM92kJxo0lVorvhqYxHBmRET+7iNv2+fYN+Lxzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiKdBAFCTUNcz7dYzBHWsQYp5Eusjudfb1rvAQ/ZxNUXL0+ADhh9JYVap6ZjahSalXNe21ldv+Y95oDjazgtRjQ/uVBMc6WfTcSHWhYGXlBhM8yDMBKpY4jn2m20K6yz1BaskH3NI96OksQENLEHtQDTF51VYuaCwem7YMZCG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUPF17iK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUPF17iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24DC1F00A3A;
	Fri,  7 Aug 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115616;
	bh=QAofuyh8I2iqhetJW/AvhawDl39ssJXYXtf3Imm1jnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUPF17iKk6fxXjdJEjNBud9QOd2pcjc/w5zIGJiXciifp+p93O3PGfRdq5UU5dMdW
	 T00/C1BhvP0UazvBDxXEVP13KA4kE1Q92CovcEpaPSYIwpqqtuYoHeWZcTmZTrfeAc
	 bHb3NztqBGFKSKvnG8hgXk2ahz/XisxHv28UM8Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 340/396] drm/vmwgfx: validate external BO copy bounds for both stride paths
Date: Fri,  7 Aug 2026 16:38:20 +0200
Message-ID: <20260807143431.620286370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit 706c93c5813caabbb0d0a576c017d15aeec2c113 upstream.

vmw_external_bo_copy() trusts caller-supplied offsets, strides, and
heights and operates on imported dma-buf vmaps:

  - The equal-stride memcpy() bound was clamped after subtracting the
    offsets from dst_size and src_size; an offset larger than the BO
    size wraps the unsigned subtraction to a huge value and the
    resulting memcpy() runs off the end of the vmap.  dst_stride *
    height is also a u32 multiplication that can overflow.
  - The non-equal-stride row-by-row path had no bound at all.  The
    loop touches bytes through offset + (height - 1) * stride +
    width_in_bytes, with only a WARN_ON(dst_stride < width_in_bytes),
    and could likewise step past the end of either mapping.

The offsets and strides are derived from STDU/SOU plane state, so a
configured CRTC submitting a crafted atomic commit on an imported
framebuffer can reach this path.

Validate the exact row-copy endpoint against each BO's size up front
using check_mul_overflow() and check_add_overflow().  Use the bulk
memcpy() path only when width_in_bytes covers the whole stride;
otherwise copy one row at a time so partial-row updates near the bottom
of a framebuffer remain valid.  Also reject zero strides and stride <
width_in_bytes, both of which the row-by-row path cannot represent
safely.

Fixes: 50f119925091 ("drm/vmwgfx: Fix prime with external buffers")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-13-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c |   39 +++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
@@ -30,6 +30,7 @@
 
 #include "vmwgfx_bo.h"
 #include <linux/highmem.h>
+#include <linux/overflow.h>
 
 /*
  * Template that implements find_first_diff() for a generic
@@ -463,19 +464,42 @@ static int vmw_external_bo_copy(struct v
 		container_of(dst->tbo.bdev, struct vmw_private, bdev);
 	size_t dst_size = dst->tbo.resource->size;
 	size_t src_size = src->tbo.resource->size;
+	size_t dst_end, src_end;
 	struct iosys_map dst_map = {0};
 	struct iosys_map src_map = {0};
+	bool dst_mapped = false;
+	bool src_mapped = false;
 	int ret, i;
 	int x_in_bytes;
 	u8 *vsrc;
 	u8 *vdst;
 
+	if (!height || !width_in_bytes)
+		return 0;
+
+	if (!dst_stride || !src_stride)
+		return -EINVAL;
+	if (dst_stride < width_in_bytes || src_stride < width_in_bytes)
+		return -EINVAL;
+	if (check_mul_overflow((size_t)dst_stride, (size_t)height - 1, &dst_end) ||
+	    check_add_overflow(dst_end, (size_t)width_in_bytes, &dst_end) ||
+	    check_add_overflow((size_t)dst_offset, dst_end, &dst_end) ||
+	    dst_end > dst_size ||
+	    check_mul_overflow((size_t)src_stride, (size_t)height - 1, &src_end) ||
+	    check_add_overflow(src_end, (size_t)width_in_bytes, &src_end) ||
+	    check_add_overflow((size_t)src_offset, src_end, &src_end) ||
+	    src_end > src_size) {
+		drm_dbg_driver(&vmw->drm, "Out-of-bounds external BO copy\n");
+		return -EINVAL;
+	}
+
 	vsrc = map_external(src, &src_map);
 	if (!vsrc) {
 		drm_dbg_driver(&vmw->drm, "Wasn't able to map src\n");
 		ret = -ENOMEM;
 		goto out;
 	}
+	src_mapped = true;
 
 	vdst = map_external(dst, &dst_map);
 	if (!vdst) {
@@ -483,16 +507,13 @@ static int vmw_external_bo_copy(struct v
 		ret = -ENOMEM;
 		goto out;
 	}
+	dst_mapped = true;
 
 	vsrc += src_offset;
 	vdst += dst_offset;
-	if (src_stride == dst_stride) {
-		dst_size -= dst_offset;
-		src_size -= src_offset;
-		memcpy(vdst, vsrc,
-		       min(dst_stride * height, min(dst_size, src_size)));
+	if (src_stride == dst_stride && width_in_bytes == dst_stride) {
+		memcpy(vdst, vsrc, dst_stride * (size_t)height);
 	} else {
-		WARN_ON(dst_stride < width_in_bytes);
 		for (i = 0; i < height; ++i) {
 			memcpy(vdst, vsrc, width_in_bytes);
 			vsrc += src_stride;
@@ -508,8 +529,10 @@ static int vmw_external_bo_copy(struct v
 
 	ret = 0;
 out:
-	unmap_external(src, &src_map);
-	unmap_external(dst, &dst_map);
+	if (src_mapped)
+		unmap_external(src, &src_map);
+	if (dst_mapped)
+		unmap_external(dst, &dst_map);
 
 	return ret;
 }


