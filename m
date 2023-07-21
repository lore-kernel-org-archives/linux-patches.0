Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA851F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B8AC433C8;
	Fri, 21 Jul 2023 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956226;
	bh=PWF97O/gBhcSPe30b+7dXUBi36jIwlUGrMe4GJI67nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5q3umWI4EljgOdHu4PtWeXCFudbyPW/K6sGBVnKjRt5iDt6Mdd2XSbylwt1dp4wG
	 mIvOnWgNxsiWVQsgFnekySko2mfjNjdE/8SciY0ZQW8odqX+G8v1VD+g3GByQGelFG
	 XGEEZqyRtmSUX/4N6cRvOx1fLuj7OHU04IfMycW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 145/292] drm/amd/display: perform a bounds check before filling dirty rectangles
Date: Fri, 21 Jul 2023 18:04:14 +0200
Message-ID: <20230721160535.117430662@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit af22d6a869cc26b519bfdcd54293c53f2e491870 upstream.

Currently, it is possible for us to access memory that we shouldn't.
Since, we acquire (possibly dangling) pointers to dirty rectangles
before doing a bounds check to make sure we can actually accommodate the
number of dirty rectangles userspace has requested to fill. This issue
is especially evident if a compositor requests both MPO and damage clips
at the same time, in which case I have observed a soft-hang. So, to
avoid this issue, perform the bounds check before filling a single dirty
rectangle and WARN() about it, if it is ever attempted in
fill_dc_dirty_rect().

Cc: stable@vger.kernel.org # 6.1+
Fixes: 30ebe41582d1 ("drm/amd/display: add FB_DAMAGE_CLIPS support")
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5057,11 +5057,7 @@ static inline void fill_dc_dirty_rect(st
 				      s32 y, s32 width, s32 height,
 				      int *i, bool ffu)
 {
-	if (*i > DC_MAX_DIRTY_RECTS)
-		return;
-
-	if (*i == DC_MAX_DIRTY_RECTS)
-		goto out;
+	WARN_ON(*i >= DC_MAX_DIRTY_RECTS);
 
 	dirty_rect->x = x;
 	dirty_rect->y = y;
@@ -5077,7 +5073,6 @@ static inline void fill_dc_dirty_rect(st
 			"[PLANE:%d] PSR SU dirty rect at (%d, %d) size (%d, %d)",
 			plane->base.id, x, y, width, height);
 
-out:
 	(*i)++;
 }
 
@@ -5164,6 +5159,9 @@ static void fill_dc_dirty_rects(struct d
 
 	*dirty_regions_changed = bb_changed;
 
+	if ((num_clips + (bb_changed ? 2 : 0)) > DC_MAX_DIRTY_RECTS)
+		goto ffu;
+
 	if (bb_changed) {
 		fill_dc_dirty_rect(new_plane_state->plane, &dirty_rects[i],
 				   new_plane_state->crtc_x,
@@ -5193,9 +5191,6 @@ static void fill_dc_dirty_rects(struct d
 				   new_plane_state->crtc_h, &i, false);
 	}
 
-	if (i > DC_MAX_DIRTY_RECTS)
-		goto ffu;
-
 	flip_addrs->dirty_rect_count = i;
 	return;
 


