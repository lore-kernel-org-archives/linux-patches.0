Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B534029C;
	Fri, 21 Nov 2025 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733561; cv=none; b=GeUPWV7AbtSesbHSR/QJiIRSE6REEXB++e+4l9tl+GdORYQ0lHhO1MoJDG5xF0BAVp15uVs6YkGkCd7+oXyyLWc6z8wtBHeookXFeOg3q2twVrP72kV5U5LVdxjmQeByCeR5S6bBZlDIM6g/X22Urb8jVOVzOFyQl6V2gcYETAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733561; c=relaxed/simple;
	bh=AG523CzcmCX9BZ7hTK8gPtir7AXcPDxdET3BAJH1kZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJndhhzXRKijAVIQSyGyRYi4RA5XqsKrosQnUBrOHW08T+XkHbGXjg8PQhkN5+HbBAIQ3brcDqKhA69hR80Xa7Mjw1N6mdukHWTcLIJw1biF+sQfyLCl+s5Jni6ylfJgaYHcvcpUBEsX21BXdYLcOMHV38e7rEp3WwjawwEbt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5hrlgG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5hrlgG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3EC4CEF1;
	Fri, 21 Nov 2025 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733560;
	bh=AG523CzcmCX9BZ7hTK8gPtir7AXcPDxdET3BAJH1kZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5hrlgG7Mo1CvXtrwvRCyqF0FEzIghucLryv68435VexkvnxAZDSfyE/Rf3tpTocZ
	 LymywXvwPF5k/VIxo9a9bS7pVoUEyvUV9eCisLFaJRTBsFT4Q1UZwVHRX1a9x2KpFV
	 aDTJey7eFngrcZyo7s2FSplv6z7a8t/1/BdXJ8xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel DAlessandro <ariel.dalessandro@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 493/529] drm/mediatek: Disable AFBC support on Mediatek DRM driver
Date: Fri, 21 Nov 2025 14:13:12 +0100
Message-ID: <20251121130248.549645750@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Ariel D'Alessandro <ariel.dalessandro@collabora.com>

[ Upstream commit 9882a40640036d5bbc590426a78981526d4f2345 ]

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
[ Applied to mtk_drm_plane.c instead of mtk_plane.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_plane.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
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
 
 static void mtk_drm_plane_destroy_state(struct drm_plane *plane,


