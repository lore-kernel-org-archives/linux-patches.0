Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A058329B78F;
	Tue, 11 Nov 2025 01:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825304; cv=none; b=HKO45NhgNAaC/cAI9KiezROjcYmVegAuXaBMELXqPLQBMP/p4hrbrIKe0d1G/mtqm5plr/mefT4w4K9qxKjjWc6m6FGzDHi2W6YdwgTGaojFHGIRR/thAhjBnFOG2Lb9vWxCg56JgbPiZ9KoKfl8bMNSsV4y79mup7yuqnZxhPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825304; c=relaxed/simple;
	bh=0mepcxHUdgkYNZEy8YiBXpctyAMwb2SFtmwLPgFq4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+MVHeffNncV4tl0WbSbX/i3+GMkvFghft690ICil2dCN4iV6Rdd8EIrfmCdQeeFYtmEPAx41/YxeYD4/FXJ8jY8SwLWPxj8zSRfdCz3AZRimlm0ichBz0Exib9B+d1HIUbjbnmNtSFqI045Pd+PKG4CcKtBqWIWpY/tb5Y7MNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRpJY8or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRpJY8or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37355C116B1;
	Tue, 11 Nov 2025 01:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825304;
	bh=0mepcxHUdgkYNZEy8YiBXpctyAMwb2SFtmwLPgFq4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRpJY8orDWXBDUEJ4cKjSV5S/J7dm03r4lSrCuW29FC9dyTIxofOdWf1o/VvooqTj
	 6/Ra+o14w4oiazVVeY/tIXMPXa9eLVscdBcDLUcr/cs9eMEm2VGDmbThzXMYcCHbDq
	 j52TUIXofO6qB6d35H/rNpiGnVGiKOjeP4Xev200=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel DAlessandro <ariel.dalessandro@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.17 745/849] drm/mediatek: Disable AFBC support on Mediatek DRM driver
Date: Tue, 11 Nov 2025 09:45:15 +0900
Message-ID: <20251111004554.447446861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel D'Alessandro <ariel.dalessandro@collabora.com>

commit 9882a40640036d5bbc590426a78981526d4f2345 upstream.

Commit c410fa9b07c3 ("drm/mediatek: Add AFBC support to Mediatek DRM
driver") added AFBC support to Mediatek DRM and enabled the
32x8/split/sparse modifier.

However, this is currently broken on Mediatek MT8188 (Genio 700 EVK
platform); tested using upstream Kernel and Mesa (v25.2.1), AFBC is used by
default since Mesa v25.0.

Kernel trace reports vblank timeouts constantly, and the render is garbled:

```
[CRTC:62:crtc-0] vblank wait timed out
WARNING: CPU: 7 PID: 70 at drivers/gpu/drm/drm_atomic_helper.c:1835 drm_atomic_helper_wait_for_vblanks.part.0+0x24c/0x27c
[...]
Hardware name: MediaTek Genio-700 EVK (DT)
Workqueue: events_unbound commit_work
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : drm_atomic_helper_wait_for_vblanks.part.0+0x24c/0x27c
lr : drm_atomic_helper_wait_for_vblanks.part.0+0x24c/0x27c
sp : ffff80008337bca0
x29: ffff80008337bcd0 x28: 0000000000000061 x27: 0000000000000000
x26: 0000000000000001 x25: 0000000000000000 x24: ffff0000c9dcc000
x23: 0000000000000001 x22: 0000000000000000 x21: ffff0000c66f2f80
x20: ffff0000c0d7d880 x19: 0000000000000000 x18: 000000000000000a
x17: 000000040044ffff x16: 005000f2b5503510 x15: 0000000000000000
x14: 0000000000000000 x13: 74756f2064656d69 x12: 742074696177206b
x11: 0000000000000058 x10: 0000000000000018 x9 : ffff800082396a70
x8 : 0000000000057fa8 x7 : 0000000000000cce x6 : ffff8000823eea70
x5 : ffff0001fef5f408 x4 : ffff80017ccee000 x3 : ffff0000c12cb480
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c12cb480
Call trace:
 drm_atomic_helper_wait_for_vblanks.part.0+0x24c/0x27c (P)
 drm_atomic_helper_commit_tail_rpm+0x64/0x80
 commit_tail+0xa4/0x1a4
 commit_work+0x14/0x20
 process_one_work+0x150/0x290
 worker_thread+0x2d0/0x3ec
 kthread+0x12c/0x210
 ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---
```

Until this gets fixed upstream, disable AFBC support on this platform, as
it's currently broken with upstream Mesa.

Fixes: c410fa9b07c3 ("drm/mediatek: Add AFBC support to Mediatek DRM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ariel D'Alessandro <ariel.dalessandro@collabora.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20251024202756.811425-1-ariel.dalessandro@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_plane.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_plane.c
@@ -21,9 +21,6 @@
 
 static const u64 modifiers[] = {
 	DRM_FORMAT_MOD_LINEAR,
-	DRM_FORMAT_MOD_ARM_AFBC(AFBC_FORMAT_MOD_BLOCK_SIZE_32x8 |
-				AFBC_FORMAT_MOD_SPLIT |
-				AFBC_FORMAT_MOD_SPARSE),
 	DRM_FORMAT_MOD_INVALID,
 };
 
@@ -71,26 +68,7 @@ static bool mtk_plane_format_mod_support
 					   uint32_t format,
 					   uint64_t modifier)
 {
-	if (modifier == DRM_FORMAT_MOD_LINEAR)
-		return true;
-
-	if (modifier != DRM_FORMAT_MOD_ARM_AFBC(
-				AFBC_FORMAT_MOD_BLOCK_SIZE_32x8 |
-				AFBC_FORMAT_MOD_SPLIT |
-				AFBC_FORMAT_MOD_SPARSE))
-		return false;
-
-	if (format != DRM_FORMAT_XRGB8888 &&
-	    format != DRM_FORMAT_ARGB8888 &&
-	    format != DRM_FORMAT_BGRX8888 &&
-	    format != DRM_FORMAT_BGRA8888 &&
-	    format != DRM_FORMAT_ABGR8888 &&
-	    format != DRM_FORMAT_XBGR8888 &&
-	    format != DRM_FORMAT_RGB888 &&
-	    format != DRM_FORMAT_BGR888)
-		return false;
-
-	return true;
+	return modifier == DRM_FORMAT_MOD_LINEAR;
 }
 
 static void mtk_plane_destroy_state(struct drm_plane *plane,


