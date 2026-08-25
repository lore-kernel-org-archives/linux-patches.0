Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704E33C276D;
	Tue, 25 Aug 2026 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665598; cv=none; b=eBWk9ts12Cdg9v7g7JPWUoclqqyWIx8DUIVpFkp0mTwXe+AeMA25rEQci3kP31ZPmI7WeHjDkS5o4btEVpqUG4PV3aLFsGw+NnPB5CTY/XYTR+VU1TLcVAwAiclYJElfNNcDf7oxJsIR0267fC8Cdx4S053qc/lRQgohoV3Lo70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665598; c=relaxed/simple;
	bh=6VMQlgTgu1Owa2SzSZaowNsi15dIYATLmrYQ0goCTcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WD299svoP6TCLxYum+51xkGTdtnzTyfUcaEuDufMbPb67S0/STyLfbCxyDnTqdu5sZoKZEfKeqx4KERl6n53NvnmCf9LUQyOwkPXWuKXQcuhdJbwSOMVdJZWXSwYzHQ4qoToyolWo2e5JHbnuUOlOz/J2VFyLOYhuFK/CdQDT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKpJEoPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKpJEoPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F68A1F000E9;
	Tue, 25 Aug 2026 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665593;
	bh=oCPnfmmKBsQpYVZaSn14omkmgOYX2pHVxafV6o1eexk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKpJEoPtjE5SSFrnCcovrF2JOEaFxbJptnFccN2YNT1+Zms6tmUdYqWbdlcSdt80H
	 rkNdg8Rz+gOPkvLo3mg8yebxeVizpZjovCeFmFRzT8FQZz0hCBKC9vzb1mWqiDfo8a
	 P82oZ5NBd0dwpim/YOHsOQQM6X+lV4+lh3eLbQbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.12 56/77] drm/xe: Fix DPT allocation paths.
Date: Tue, 25 Aug 2026 15:26:18 +0200
Message-ID: <20260825132543.759927865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit fc648757908304aedbad74f74bf58192aec383db ]

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
[ Replaced `xe_bo_create_pin_map_at_novm()` with `xe_bo_create_pin_map()`, dropped the alignment argument, and renamed `XE_BO_FLAG_FORCE_WC` to `XE_BO_FLAG_SCANOUT`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -97,24 +97,12 @@ static int __xe_pin_fb_vma_dpt(const str
 		dpt_size = ALIGN(intel_rotation_info_size(&view->rotated) * 8,
 				 XE_PAGE_SIZE);
 
-	if (IS_DGFX(xe))
-		dpt = xe_bo_create_pin_map(xe, tile0, NULL, dpt_size,
-					   ttm_bo_type_kernel,
-					   XE_BO_FLAG_VRAM0 |
-					   XE_BO_FLAG_GGTT |
-					   XE_BO_FLAG_PAGETABLE);
-	else
-		dpt = xe_bo_create_pin_map(xe, tile0, NULL, dpt_size,
-					   ttm_bo_type_kernel,
-					   XE_BO_FLAG_STOLEN |
-					   XE_BO_FLAG_GGTT |
-					   XE_BO_FLAG_PAGETABLE);
-	if (IS_ERR(dpt))
-		dpt = xe_bo_create_pin_map(xe, tile0, NULL, dpt_size,
-					   ttm_bo_type_kernel,
-					   XE_BO_FLAG_SYSTEM |
-					   XE_BO_FLAG_GGTT |
-					   XE_BO_FLAG_PAGETABLE);
+	dpt = xe_bo_create_pin_map(xe, tile0, NULL, dpt_size,
+				   ttm_bo_type_kernel,
+				   XE_BO_FLAG_VRAM_IF_DGFX(tile0) |
+				   XE_BO_FLAG_GGTT |
+				   XE_BO_FLAG_PAGETABLE |
+				   XE_BO_FLAG_SCANOUT);
 	if (IS_ERR(dpt))
 		return PTR_ERR(dpt);
 


