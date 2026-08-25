Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAED32E06E4;
	Tue, 25 Aug 2026 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665216; cv=none; b=WiJ7FlLRM5NOs90aYdx43itpmlvci+8CCW4U4Br5pJw3Q31cPZX3aa856ZAQwdN9ZSUOTuMUyeDO5U+vaOu9YVdKDeuRGp+vFH11he6idjP9D0aB7/w7xxhH/RISMoU2dtAvycZVok8WzfAm1aITv1NxMqAb+R7h/oVPBVCfRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665216; c=relaxed/simple;
	bh=2StiLFgR4YAdu5t8vmasINaiTa/tUy1Z6suGfGSkNe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EmmjK+SlXPTCaj+FgBTB8E9jsfWl9CI/VMzLXX0z2WkAaftImSURLGd8tJzkIqk8GILbe1E015ZyibkVPAo9z80rKbK57SATgI7ftxJgxTMEKI7ux5n7XHpdOlaNZSr0eNtT/HyLVqFubVXm/Xeg8sU1nWrfnv9CajDBjORFlsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3xtCLYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3xtCLYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E5A1F000E9;
	Tue, 25 Aug 2026 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665215;
	bh=nO0L3CjXTwcj/E3YOV9v3dFfqg9g6ZyA7o8HDA416Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3xtCLYDmFFQk1oS+ckOhC+TKmj7ijF6QdQYHtMcMVzP5pSufOHZ4aS/0d/kuobKs
	 YMqHCIVrM4b+AQlwKjFHqdqhq3KL6lMwmhtfaBBh9r6xyn5bDAFINEh1tAt/T4HJox
	 qteNa+4psoWgzyoY8QXV1Dd1bv59/atfInLUr3oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.18 46/94] drm/xe: Fix DPT allocation paths.
Date: Tue, 25 Aug 2026 15:25:42 +0200
Message-ID: <20260825132543.711088951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

commit fc648757908304aedbad74f74bf58192aec383db upstream.

Remove the fallback for VRAM to system memory, I tested it and that
doesn't work at all, only a black screen with pipe fault errors were
observed.

On systems with media GT, extra latency is added when accessing stolen
memory when the GT is in MC6. Since we additionally aren't counting how
much memory is used for stolen and we could in theory fill up the
entire stolen area with DPT's, avoid using stolen and only use the
default memory region.

Using stolen may also result in random system hangs under load.

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7513
Fixes: 775d0adc01a5 ("drm/xe/fbdev: Limit the usage of stolen for LNL+")
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260630135523.1775379-2-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Acked-by: Matthew Brost <matthew.brost@intel.com> #teams
(cherry picked from commit a196406a3831291598fe8e73245914f7acffdfe0)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
[ adapted `pin_params->alignment` to `alignment` and renamed `XE_BO_FLAG_FORCE_WC` to `XE_BO_FLAG_SCANOUT` for the pre-rename flag name ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -101,30 +101,14 @@ static int __xe_pin_fb_vma_dpt(const str
 		dpt_size = ALIGN(intel_rotation_info_size(&view->rotated) * 8,
 				 XE_PAGE_SIZE);
 
-	if (IS_DGFX(xe))
-		dpt = xe_bo_create_pin_map_at_novm(xe, tile0,
-						   dpt_size, ~0ull,
-						   ttm_bo_type_kernel,
-						   XE_BO_FLAG_VRAM0 |
-						   XE_BO_FLAG_GGTT |
-						   XE_BO_FLAG_PAGETABLE,
-						   alignment, false);
-	else
-		dpt = xe_bo_create_pin_map_at_novm(xe, tile0,
-						   dpt_size,  ~0ull,
-						   ttm_bo_type_kernel,
-						   XE_BO_FLAG_STOLEN |
-						   XE_BO_FLAG_GGTT |
-						   XE_BO_FLAG_PAGETABLE,
-						   alignment, false);
-	if (IS_ERR(dpt))
-		dpt = xe_bo_create_pin_map_at_novm(xe, tile0,
-						   dpt_size,  ~0ull,
-						   ttm_bo_type_kernel,
-						   XE_BO_FLAG_SYSTEM |
-						   XE_BO_FLAG_GGTT |
-						   XE_BO_FLAG_PAGETABLE,
-						   alignment, false);
+	dpt = xe_bo_create_pin_map_at_novm(xe, tile0,
+					   dpt_size,  ~0ull,
+					   ttm_bo_type_kernel,
+					   XE_BO_FLAG_VRAM_IF_DGFX(tile0) |
+					   XE_BO_FLAG_GGTT |
+					   XE_BO_FLAG_PAGETABLE |
+					   XE_BO_FLAG_SCANOUT,
+					   alignment, false);
 	if (IS_ERR(dpt))
 		return PTR_ERR(dpt);
 


