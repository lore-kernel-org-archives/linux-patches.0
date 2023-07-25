Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71F315AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3881DC433C8;
	Tue, 25 Jul 2023 10:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282224;
	bh=CC+uP/i9hvkblukM6LwUEyHc7baONL2aYwaN34Mrm0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2T1NcTXZwH6f0T8bH4GfQlm2fTAn4ZjCx1uTzCViVTyyll6Xxesuyl/lSAlMISGS
	 9O6h0k7ykuTxahR6hUlNVqLyrPTsUcwC8wSAbnT6kvbqJJ4F/QF9sUGz6ayDBryUv8
	 a/yFeL758MZAYzzXc+4SB1iUPOES9fhiR7oA3C2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Ser <contact@emersion.fr>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 6.4 052/227] drm/amd/display: only accept async flips for fast updates
Date: Tue, 25 Jul 2023 12:43:39 +0200
Message-ID: <20230725104516.934589291@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Ser <contact@emersion.fr>

commit 1ca67aba8d11c2849d395013e1fdce02918d5657 upstream.

Up until now, amdgpu was silently degrading to vsync when
user-space requested an async flip but the hardware didn't support
it.

The hardware doesn't support immediate flips when the update changes
the FB pitch, the DCC state, the rotation, enables or disables CRTCs
or planes, etc. This is reflected in the dm_crtc_state.update_type
field: UPDATE_TYPE_FAST means that immediate flip is supported.

Silently degrading async flips to vsync is not the expected behavior
from a uAPI point-of-view. Xorg expects async flips to fail if
unsupported, to be able to fall back to a blit. i915 already behaves
this way.

This patch aligns amdgpu with uAPI expectations and returns a failure
when an async flip is not possible.

Signed-off-by: Simon Ser <contact@emersion.fr>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      |    8 ++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   12 ++++++++++++
 2 files changed, 20 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8055,7 +8055,15 @@ static void amdgpu_dm_commit_planes(stru
 		 * Only allow immediate flips for fast updates that don't
 		 * change memory domain, FB pitch, DCC state, rotation or
 		 * mirroring.
+		 *
+		 * dm_crtc_helper_atomic_check() only accepts async flips with
+		 * fast updates.
 		 */
+		if (crtc->state->async_flip &&
+		    acrtc_state->update_type != UPDATE_TYPE_FAST)
+			drm_warn_once(state->dev,
+				      "[PLANE:%d:%s] async flip with non-fast update\n",
+				      plane->base.id, plane->name);
 		bundle->flip_addrs[planes_count].flip_immediate =
 			crtc->state->async_flip &&
 			acrtc_state->update_type == UPDATE_TYPE_FAST &&
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -398,6 +398,18 @@ static int dm_crtc_helper_atomic_check(s
 		return -EINVAL;
 	}
 
+	/*
+	 * Only allow async flips for fast updates that don't change the FB
+	 * pitch, the DCC state, rotation, etc.
+	 */
+	if (crtc_state->async_flip &&
+	    dm_crtc_state->update_type != UPDATE_TYPE_FAST) {
+		drm_dbg_atomic(crtc->dev,
+			       "[CRTC:%d:%s] async flips are only supported for fast updates\n",
+			       crtc->base.id, crtc->name);
+		return -EINVAL;
+	}
+
 	/* In some use cases, like reset, no stream is attached */
 	if (!dm_crtc_state->stream)
 		return 0;


