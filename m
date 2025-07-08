Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5602E3385;
	Tue,  8 Jul 2025 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993001; cv=none; b=kzKqtLxvltNpaZFosVJSpZ2YY7yGVXy2KwYFcaQNB6w/qT5t9bmrfunjt4reZaaYXxtLXMT3YKt2JMVOeS6xbGOSDjHdyxXLztLa5Zi3NxRWB2U19N5Wl3M1KYnqGGQxJu9UzB3CfJ8fmW+UDa5T20eUd7XzED7H1SisJgU7jAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993001; c=relaxed/simple;
	bh=BdPepcYax6llQW7m0c9DcduqH0Qao0HxAC9MBrZl3Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5nb/s8t+GobPsf+RsPV8wujklvwU2PRk2L9Vucg0/JWi1dFXe8B5x1IbI3M+g2TceZoHQ7AbP8MN7EwB2TIPdR3GFLqZ8uQrmpvJzkF76vjxJnT+UNy873424J6HIokFX/F+eFTMgHOgRwy82rQBbMYHj1yRNnPMIAnaxM/b+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKhSrxyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKhSrxyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA930C4CEED;
	Tue,  8 Jul 2025 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993001;
	bh=BdPepcYax6llQW7m0c9DcduqH0Qao0HxAC9MBrZl3Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKhSrxyqiGTy8+ByHryb6dAemcuGMZVuNbWwafsfvqSXieb84h0PClPUhXzCAXSnt
	 ujXguDxMwlAvgb67F7KpHUf8yYmAYTo6V4yVTwKvAmom2oKQpBK81VtT5BSLpB1ADJ
	 MY5ohN1UY6sMeTxJTAndn8JoRYFsJ4JAjk6akgMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/232] drm/xe: Fix DSB buffer coherency
Date: Tue,  8 Jul 2025 18:22:29 +0200
Message-ID: <20250708162245.440687283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit 71a3161e9d7d2229cb4eefd4c49effb97caf3db3 ]

Add the scanout flag to force WC caching, and add the memory barrier
where needed.

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913114754.7956-2-maarten.lankhorst@linux.intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Stable-dep-of: a4b1b51ae132 ("drm/xe: Move DSB l2 flush to a more sensible place")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_dsb_buffer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_dsb_buffer.c b/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
index f99d901a3214f..f95375451e2fa 100644
--- a/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
+++ b/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
@@ -48,11 +48,12 @@ bool intel_dsb_buffer_create(struct intel_crtc *crtc, struct intel_dsb_buffer *d
 	if (!vma)
 		return false;
 
+	/* Set scanout flag for WC mapping */
 	obj = xe_bo_create_pin_map(xe, xe_device_get_root_tile(xe),
 				   NULL, PAGE_ALIGN(size),
 				   ttm_bo_type_kernel,
 				   XE_BO_FLAG_VRAM_IF_DGFX(xe_device_get_root_tile(xe)) |
-				   XE_BO_FLAG_GGTT);
+				   XE_BO_FLAG_SCANOUT | XE_BO_FLAG_GGTT);
 	if (IS_ERR(obj)) {
 		kfree(vma);
 		return false;
@@ -73,5 +74,9 @@ void intel_dsb_buffer_cleanup(struct intel_dsb_buffer *dsb_buf)
 
 void intel_dsb_buffer_flush_map(struct intel_dsb_buffer *dsb_buf)
 {
-	/* TODO: add xe specific flush_map() for dsb buffer object. */
+	/*
+	 * The memory barrier here is to ensure coherency of DSB vs MMIO,
+	 * both for weak ordering archs and discrete cards.
+	 */
+	xe_device_wmb(dsb_buf->vma->bo->tile->xe);
 }
-- 
2.39.5



