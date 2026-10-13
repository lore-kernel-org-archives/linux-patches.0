Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA454F4CF0;
	Tue, 13 Oct 2026 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892313; cv=none; b=oJ5fjkuQ9Bi28ub1ZYvaBh8Kg7+qX7/HLzXvOD/uIwey+2qlE1ZrAiMqQ0zJ+lj8s9MCY14PyEPfBB6zgxNmQUm3cW/3vZAYErvwwmfm3ZuJ09epDrXugBNkVfl5N5NOfinU1zJOpAylyIXDFZ5cGOucSE5ebBhTKw5+vnF9Kpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892313; c=relaxed/simple;
	bh=OJzgmpJwxPty7UH5l0LZ3t+2SDYMGiVEFpSj+6s5uaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0xcbQ5wDr+bSTnhs3E27XMNURTdGgc+KQvaC0wpuo3Uho0yP7ziT7qC6XMYNgv5dClqYMvtOvkj7DTb/7mrRafwc5RqpqDLztp9jw3Q1Fx4J3SGwUemAmtrD5txex1NYY2O93UI2OwLiiNOPRezHFN1Qkgp2aqyY9NulQ9v4KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXH/w/6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXH/w/6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F791F000FF;
	Tue, 13 Oct 2026 11:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892311;
	bh=XfghZWBhuthgvp/r1HNlKdz0i8d5R2IoGQMJXnHUi+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXH/w/6pENIvTHPt69LI82KbRfUeh9D7WNO5QMfNmbSO8cuMmFNoonxbmZ+4lF6I0
	 u/nfHWlZG++aYxabKv7sQPRP/1Cie0uqiAk9Bzltx5VJGWarZMVI+u3yJ0dlhixR4P
	 iaR79Fol/an230/Fvd62BwSK26kK7AM3H1d2P/84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youness HFA <hfa.youness@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Subject: [PATCH 7.2 132/281] drm/vmwgfx: validate pitch coming from userspace
Date: Tue, 13 Oct 2026 13:37:28 +0200
Message-ID: <20261013112858.354510873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 21bc51cb89ced74d6645a138cc2f21184bc75094 upstream.

Validate the pitch, alongside the box dimensions before trying
to copy data from the underlying surface. Fixes possible
out of bounds reads with cursor snooping.

Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: stable@vger.kernel.org
Reported-by: Youness HFA <hfa.youness@gmail.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Link: https://patch.msgid.link/20260809204515.211045-1-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c
@@ -324,6 +324,7 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 	unsigned long kmap_num;
 	SVGA3dCopyBox *box;
 	u32 box_count;
+	u64 src_extent;
 	void *virtual;
 	bool is_iomem;
 	struct vmw_dma_cmd {
@@ -335,6 +336,8 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 		vmw_surface_get_desc(VMW_CURSOR_SNOOP_FORMAT);
 	const u32 image_pitch = VMW_CURSOR_SNOOP_WIDTH * desc->pitchBytesPerBlock;
 
+	BUILD_BUG_ON(sizeof(*srf->snooper.image) != desc->pitchBytesPerBlock);
+
 	cmd = container_of(header, struct vmw_dma_cmd, header);
 
 	/* No snooper installed, nothing to copy */
@@ -372,8 +375,19 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 		return;
 	}
 
+	if (box->w == 0 || box->h == 0)
+		return;
+
+	src_extent = (u64)(box->h - 1) * cmd->dma.guest.pitch +
+		     (u64)box->w * desc->pitchBytesPerBlock;
+	if (src_extent > bo->base.size) {
+		DRM_ERROR("Cursor snoop source of %llu bytes exceeds the %zu byte buffer\n",
+			  src_extent, bo->base.size);
+		return;
+	}
+
 	kmap_offset = cmd->dma.guest.ptr.offset >> PAGE_SHIFT;
-	kmap_num = (VMW_CURSOR_SNOOP_HEIGHT * image_pitch) >> PAGE_SHIFT;
+	kmap_num = PFN_UP(src_extent);
 
 	ret = ttm_bo_reserve(bo, true, false, NULL);
 	if (unlikely(ret != 0)) {
@@ -387,14 +401,16 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 
 	virtual = ttm_kmap_obj_virtual(&map, &is_iomem);
 
-	if (box->w == VMW_CURSOR_SNOOP_WIDTH && cmd->dma.guest.pitch == image_pitch) {
+	if (box->w == VMW_CURSOR_SNOOP_WIDTH &&
+	    box->h == VMW_CURSOR_SNOOP_HEIGHT &&
+	    cmd->dma.guest.pitch == image_pitch) {
 		memcpy(srf->snooper.image, virtual,
 		       VMW_CURSOR_SNOOP_HEIGHT * image_pitch);
 	} else {
-		/* Image is unsigned pointer. */
+		/* The destination stride is in pixels. */
 		for (i = 0; i < box->h; i++)
-			memcpy(srf->snooper.image + i * image_pitch,
-			       virtual + i * cmd->dma.guest.pitch,
+			memcpy(srf->snooper.image + i * VMW_CURSOR_SNOOP_WIDTH,
+			       virtual + (size_t)i * cmd->dma.guest.pitch,
 			       box->w * desc->pitchBytesPerBlock);
 	}
 	srf->snooper.id++;


