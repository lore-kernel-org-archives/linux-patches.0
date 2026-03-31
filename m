Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DF622578D;
	Tue, 31 Mar 2026 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976882; cv=none; b=CGkmw9FAj/ThqpfGKeAb+iNoALogx8niZmm7n5Vj67kdwHVSYxL7hw/7M8PGonzkIU4LTUJOmuCE3dgIxFTSFHSO+92hn5Hld9g8vG56AafVQmjD3oaH6KTH//rp/DXpwiG/wfp7jle3vjw14opfQtznQwhlEEVCK8+9AeHMT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976882; c=relaxed/simple;
	bh=b/iXBvdXiHpcbSmIQBMruaqR5gOjDoDckO4PAxyYnc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+A0nDM0u/2ulpOv7bWiXLtAbLUm9hn8uK7wE7N1yr2OuonCvMj9NmofTCie5Sddh9cWCuZqI47SOprmKxo++AxsBSBsk/glYnzy+rlxW+gqOSHvU8FwuikaWT/wNIHRUtRC/TDP774THngPtJurAsq+bE54l9quXSmJYi73yyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp9nZc/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp9nZc/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2745DC19423;
	Tue, 31 Mar 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976882;
	bh=b/iXBvdXiHpcbSmIQBMruaqR5gOjDoDckO4PAxyYnc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp9nZc/1P8frL/rBZUt/V6m4iojuXN+M5SKBOSjP7LezEuMeJDyMLbmzxIwPtDWP4
	 rcDYqsiEUqOoeRrvHN9HJL8XUt13rkefwy9ToPgtgaOt/kTPqhCklzWYmlryAxqZT2
	 KxbYIHmihuf4RiviZWbXc7I7mSftXub3Xk7dZEI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 237/309] drm/i915: Unlink NV12 planes earlier
Date: Tue, 31 Mar 2026 18:22:20 +0200
Message-ID: <20260331161802.300820170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit bfa71b7a9dc6b5b8af157686e03308291141d00c upstream.

unlink_nv12_plane() will clobber parts of the plane state
potentially already set up by plane_atomic_check(), so we
must make sure not to call the two in the wrong order.
The problem happens when a plane previously selected as
a Y plane is now configured as a normal plane by user space.
plane_atomic_check() will first compute the proper plane
state based on the userspace request, and unlink_nv12_plane()
later clears some of the state.

This used to work on account of unlink_nv12_plane() skipping
the state clearing based on the plane visibility. But I removed
that check, thinking it was an impossible situation. Now when
that situation happens unlink_nv12_plane() will just WARN
and proceed to clobber the state.

Rather than reverting to the old way of doing things, I think
it's more clear if we unlink the NV12 planes before we even
compute the new plane state.

Cc: stable@vger.kernel.org
Reported-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Closes: https://lore.kernel.org/intel-gfx/20260212004852.1920270-1-khaled.almahallawy@intel.com/
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Fixes: 6a01df2f1b2a ("drm/i915: Remove pointless visible check in unlink_nv12_plane()")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260316163953.12905-2-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
(cherry picked from commit 017ecd04985573eeeb0745fa2c23896fb22ee0cc)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_plane.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -421,11 +421,16 @@ void intel_plane_copy_hw_state(struct in
 		drm_framebuffer_get(plane_state->hw.fb);
 }
 
+static void unlink_nv12_plane(struct intel_crtc_state *crtc_state,
+			      struct intel_plane_state *plane_state);
+
 void intel_plane_set_invisible(struct intel_crtc_state *crtc_state,
 			       struct intel_plane_state *plane_state)
 {
 	struct intel_plane *plane = to_intel_plane(plane_state->uapi.plane);
 
+	unlink_nv12_plane(crtc_state, plane_state);
+
 	crtc_state->active_planes &= ~BIT(plane->id);
 	crtc_state->scaled_planes &= ~BIT(plane->id);
 	crtc_state->nv12_planes &= ~BIT(plane->id);
@@ -1498,6 +1503,9 @@ static void unlink_nv12_plane(struct int
 	struct intel_display *display = to_intel_display(plane_state);
 	struct intel_plane *plane = to_intel_plane(plane_state->uapi.plane);
 
+	if (!plane_state->planar_linked_plane)
+		return;
+
 	plane_state->planar_linked_plane = NULL;
 
 	if (!plane_state->is_y_plane)
@@ -1535,8 +1543,7 @@ static int icl_check_nv12_planes(struct
 		if (plane->pipe != crtc->pipe)
 			continue;
 
-		if (plane_state->planar_linked_plane)
-			unlink_nv12_plane(crtc_state, plane_state);
+		unlink_nv12_plane(crtc_state, plane_state);
 	}
 
 	if (!crtc_state->nv12_planes)


