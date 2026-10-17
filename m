Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EF1F16B;
	Sat, 17 Oct 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257520; cv=none; b=ly06sdQvqlUXpC94GbjYyXI71wUMj1opOAqLstogyYVZovTOVkAhRMFSRad+hkg3I1aF3cnICE916ZoOBGgB9hIKRlXrHpPylybkycwKYUGMF7uMoMP/k2KOE8Ti7uZH9b414XAMNff3bJN6xffo/noE/G2PklhoWXZnfjhgC2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257520; c=relaxed/simple;
	bh=zMzHuhhD8Depd3jnOf11RjWQJ1GJBl+8xqcmnC5HT4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/VI+5x8cQEc1I8cB64NY4SAUtOAe+M1+O5k8HSD2RWzhV/ZrshEvEBEsSNEabtCchfsxDu/SfvGKaX2kBnA6hR2Q8VIe8hhWDcWzu2IpBqxbmF9s0cfFmjaim7KE+/xTjnZ4C2/yt72yyzpfDXf3fWG3rsviPCzli7E5uCNEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IygS7J7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IygS7J7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D21F000C4;
	Sat, 17 Oct 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257519;
	bh=3MZPO238aGUWc4KozVWBqFXr4ZLETJNCE6nZkjWcEDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IygS7J7RmVn19OX3FOBsFBfkollBppbhIr9rS58ZM/mAPsgdlU4VZ0IbLLiW578q7
	 wQWCdiPwH6uB0E3Ad07VByjThNaKWfKt9XV2G9C/0/fs5/tUW4AL93+esub2iEEtLW
	 qLNU192mxMKjteCMsTyFGQXBAXOGJbDDwnviQjyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youness HFA <hfa.youness@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0586/1674] drm/vmwgfx: validate pitch coming from userspace
Date: Sat, 17 Oct 2026 17:47:38 +0200
Message-ID: <20261017160446.129131989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 21bc51cb89ced74d6645a138cc2f21184bc75094 ]

Validate the pitch, alongside the box dimensions before trying
to copy data from the underlying surface. Fixes possible
out of bounds reads with cursor snooping.

Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: stable@vger.kernel.org
Reported-by: Youness HFA <hfa.youness@gmail.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Link: https://patch.msgid.link/20260809204515.211045-1-zack.rusin@broadcom.com
[ sashal: Adjusted context for vmw_kms_cursor_snoop() residing in the KMS code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 33f73d559be72..7524403427c7b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -370,6 +370,7 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	unsigned long kmap_num;
 	SVGA3dCopyBox *box;
 	unsigned box_count;
+	u64 src_extent;
 	void *virtual;
 	bool is_iomem;
 	struct vmw_dma_cmd {
@@ -381,6 +382,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 		vmw_surface_get_desc(VMW_CURSOR_SNOOP_FORMAT);
 	const u32 image_pitch = VMW_CURSOR_SNOOP_WIDTH * desc->pitchBytesPerBlock;
 
+	BUILD_BUG_ON(sizeof(*srf->snooper.image) != desc->pitchBytesPerBlock);
+
 	cmd = container_of(header, struct vmw_dma_cmd, header);
 
 	/* No snooper installed, nothing to copy */
@@ -418,8 +421,19 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
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
-	kmap_num = (VMW_CURSOR_SNOOP_HEIGHT*image_pitch) >> PAGE_SHIFT;
+	kmap_num = PFN_UP(src_extent);
 
 	ret = ttm_bo_reserve(bo, true, false, NULL);
 	if (unlikely(ret != 0)) {
@@ -433,14 +447,16 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 
 	virtual = ttm_kmap_obj_virtual(&map, &is_iomem);
 
-	if (box->w == VMW_CURSOR_SNOOP_WIDTH && cmd->dma.guest.pitch == image_pitch) {
+	if (box->w == VMW_CURSOR_SNOOP_WIDTH &&
+	    box->h == VMW_CURSOR_SNOOP_HEIGHT &&
+	    cmd->dma.guest.pitch == image_pitch) {
 		memcpy(srf->snooper.image, virtual,
 		       VMW_CURSOR_SNOOP_HEIGHT*image_pitch);
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
 
-- 
2.53.0



