Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBCB4F96BD;
	Tue, 13 Oct 2026 12:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893245; cv=none; b=r9p+kFSMxnKZLRouhczxe+Y087VHH56c/60xCRYYwuHT1atNRsgsAKmBIJFXwCq9eBe9VchM6KQOtKXGcl3ggCNhX0BvACeW4jdBKkGAoioFPXF9thrMu1087crA1YB2nc2idqdD9wA0qu2N8VuAxgjHDyiPuNEXudO5Q6XojnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893245; c=relaxed/simple;
	bh=nzOHKnfci6dtfveVnVWMVL7Se5PECPnQVag4vgxQTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIIKT5zZNQD4Y8E5DIuG4iytoUdVFGKIRzzURlzcU/9cvXXnASfG5+gQwI06qcrHMy1KT1IiXpdmxqrTzI8264HXtiOijhQGX6RayLOcU7A527KWVJKW62su5mclQf+T+AhF9gbMi8OdljRHPQ34AExf7OMNPnrsvE88ZvDqI+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk0qvrtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk0qvrtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076631F0089B;
	Tue, 13 Oct 2026 12:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893243;
	bh=02rm9u9xw9v8QkPky0KtWGVXaDIqz5CWwD1mx1b6DHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fk0qvrttcxAD76BoYA6CRo/mgW7sSZKtqQvjumRYM9fUD/Fp6cAHJvEDsoTf00MLh
	 f02+gYNhIAvrprQRKso/kcZtr6e7oRf/rveg1zu284Zlt3xhljUvvBVb0hIA62XqlD
	 HED0U9RUNhUw0T0wiS+a9JeLY+Ult2r6ulO/57f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youness HFA <hfa.youness@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Subject: [PATCH 6.18 117/621] drm/vmwgfx: validate pitch coming from userspace
Date: Tue, 13 Oct 2026 13:31:52 +0200
Message-ID: <20261013112923.636197753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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


