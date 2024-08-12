Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB012C1A5;
	Mon, 12 Aug 2024 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480412; cv=none; b=K9HDEvmPw/6uw9dRLk+mGoIC18lReFWPSytUCB7wxZudVotxCgYjQAfdNPZCSs6WiVpvwYVAjQTKvf/5lYi1toBxH/UedXuo3hkBZTOS/gC5JFiujY5b+mSFukP9xYK4cauiVz0lQ3vExAL+4f9O+wy5Un52/1PhLkHlmLMeffE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480412; c=relaxed/simple;
	bh=T/ptafwQi1WhAIqDG1O9jYtZwPF/L2ukwALfWCgc+Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9MKiZYAgIWN+NWUAwjTD6IlcNQmqoV67xw5ZteVHonbQlCOLDXjTzRRBn2GVyvhrlqVES7S/zbFXoxb+8nxjDxeNdfofX0+oEGFG+J2g+7oT/HedHyoM1WrBGDcqxSUUeSUmIe7YIE6FrhORRgPjPJD7n7d+E1BXR3egCu0Dqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgppcTzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgppcTzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461A0C32782;
	Mon, 12 Aug 2024 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480410;
	bh=T/ptafwQi1WhAIqDG1O9jYtZwPF/L2ukwALfWCgc+Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgppcTzCptLqdLgDREEFUOOe6jcZvJ8YZsh5TfXhLBF9BkdojWGnY+LOfP+wFPUQA
	 TvSNFKS40/6AcJxG/zAVfO3oJ5vD8QNlcaX8wcNsddAWcFNNdgsGLyw/dVbRNrDtBJ
	 b+2TV9pMWBXW97LEoLZo6tz4RFJ3SqbzbbWDxaUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Ser <contact@emersion.fr>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Xaver Hugl <xaver.hugl@kde.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 156/263] drm/atomic: allow no-op FB_ID updates for async flips
Date: Mon, 12 Aug 2024 18:02:37 +0200
Message-ID: <20240812160152.519171457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Ser <contact@emersion.fr>

[ Upstream commit 929725bd7eb4eea1f75197d9847f3f1ea5afdad1 ]

User-space is allowed to submit any property in an async flip as
long as the value doesn't change. However we missed one case:
as things stand, the kernel rejects no-op FB_ID changes on
non-primary planes. Fix this by changing the conditional and
skipping drm_atomic_check_prop_changes() only for FB_ID on the
primary plane (instead of skipping for FB_ID on any plane).

Fixes: 0e26cc72c71c ("drm: Refuse to async flip with atomic prop changes")
Signed-off-by: Simon Ser <contact@emersion.fr>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Tested-by: Xaver Hugl <xaver.hugl@kde.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Michel Dänzer <michel.daenzer@mailbox.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240731191014.878320-1-contact@emersion.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index 02b1235c6d619..106292d6ed268 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1067,23 +1067,16 @@ int drm_atomic_set_property(struct drm_atomic_state *state,
 		}
 
 		if (async_flip &&
-		    prop != config->prop_fb_id &&
-		    prop != config->prop_in_fence_fd &&
-		    prop != config->prop_fb_damage_clips) {
+		    (plane_state->plane->type != DRM_PLANE_TYPE_PRIMARY ||
+		     (prop != config->prop_fb_id &&
+		      prop != config->prop_in_fence_fd &&
+		      prop != config->prop_fb_damage_clips))) {
 			ret = drm_atomic_plane_get_property(plane, plane_state,
 							    prop, &old_val);
 			ret = drm_atomic_check_prop_changes(ret, old_val, prop_value, prop);
 			break;
 		}
 
-		if (async_flip && plane_state->plane->type != DRM_PLANE_TYPE_PRIMARY) {
-			drm_dbg_atomic(prop->dev,
-				       "[OBJECT:%d] Only primary planes can be changed during async flip\n",
-				       obj->id);
-			ret = -EINVAL;
-			break;
-		}
-
 		ret = drm_atomic_plane_set_property(plane,
 				plane_state, file_priv,
 				prop, prop_value);
-- 
2.43.0



