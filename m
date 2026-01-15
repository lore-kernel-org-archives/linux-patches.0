Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41A242049;
	Thu, 15 Jan 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495963; cv=none; b=AK68aGUjyiddeiLuHn3rZGdN+IpMQgfR1mxEwnvSOVii/g+TcEbfdzCcCaoUzM9DdkUWaJsfaErbGnzr6IaC/5CybUYjiSgueSkm/I8jc4RJMyFL4LGSogginsYYRdMGWuG5kwoyOzQ63Q/t17ayBPGp2XZVPa541G2177oQdGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495963; c=relaxed/simple;
	bh=+fE9ocsYsqYeUBCPX17vHAl8Rq1c5kFLiszicOkemrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YltHW/fxi5L5kmMTXduSye7VIWS7n7/SAMTE/52ITEDFdz3pxRdJJDcG6a0bFnv6+dyPQZshZb1dP+Xjm3UBF8tBOE2huKVJ7Wi5kGoqK8FmGBSnREuqxtoT7F9VgDH9qb2Zr6IP0dYYfWt5F8J1HhaT96zqf+0PsXs1uCgmYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NEo6vT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NEo6vT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C04C116D0;
	Thu, 15 Jan 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495963;
	bh=+fE9ocsYsqYeUBCPX17vHAl8Rq1c5kFLiszicOkemrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NEo6vT07qaiIU9EwedYalxj8eKyBCJO90kyxJlUIEgQVp3JDjgZFKP15aKsUSyFJ
	 vckc2qfLK8/p+j8XBn3enyBpV+brEzrZF2EXk88iZ2d5ntOQQ+aMA1TKpHpnnqjBM1
	 hj7UOSrR+vQSFQd3Ho+P6e4i3rOx0oFJyZ2heOwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Maxime Ripard <mripard@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 029/181] drm/tidss: Fix enable/disable order
Date: Thu, 15 Jan 2026 17:46:06 +0100
Message-ID: <20260115164203.379553019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 2fc04340cf30d7960eed2525d26ffb8905aca02b upstream.

TI's OLDI and DSI encoders need to be set up before the crtc is enabled,
but the DRM helpers will enable the crtc first. This causes various
issues on TI platforms, like visual artifacts or crtc sync lost
warnings.

Thus drm_atomic_helper_commit_modeset_enables() and
drm_atomic_helper_commit_modeset_disables() cannot be used, as they
enable the crtc before bridges' pre-enable, and disable the crtc after
bridges' post-disable.

Open code the drm_atomic_helper_commit_modeset_enables() and
drm_atomic_helper_commit_modeset_disables(), and first call the bridges'
pre-enables, then crtc enable, then bridges' post-enable (and vice versa
for disable).

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org # v6.17+
Fixes: c9b1150a68d9 ("drm/atomic-helper: Re-order bridge chain pre-enable and post-disable")
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20251205-drm-seq-fix-v1-4-fda68fa1b3de@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -28,9 +28,33 @@ static void tidss_atomic_commit_tail(str
 
 	tidss_runtime_get(tidss);
 
-	drm_atomic_helper_commit_modeset_disables(ddev, old_state);
-	drm_atomic_helper_commit_planes(ddev, old_state, DRM_PLANE_COMMIT_ACTIVE_ONLY);
-	drm_atomic_helper_commit_modeset_enables(ddev, old_state);
+	/*
+	 * TI's OLDI and DSI encoders need to be set up before the crtc is
+	 * enabled. Thus drm_atomic_helper_commit_modeset_enables() and
+	 * drm_atomic_helper_commit_modeset_disables() cannot be used here, as
+	 * they enable the crtc before bridges' pre-enable, and disable the crtc
+	 * after bridges' post-disable.
+	 *
+	 * Open code the functions here and first call the bridges' pre-enables,
+	 * then crtc enable, then bridges' post-enable (and vice versa for
+	 * disable).
+	 */
+
+	drm_atomic_helper_commit_encoder_bridge_disable(ddev, old_state);
+	drm_atomic_helper_commit_crtc_disable(ddev, old_state);
+	drm_atomic_helper_commit_encoder_bridge_post_disable(ddev, old_state);
+
+	drm_atomic_helper_update_legacy_modeset_state(ddev, old_state);
+	drm_atomic_helper_calc_timestamping_constants(old_state);
+	drm_atomic_helper_commit_crtc_set_mode(ddev, old_state);
+
+	drm_atomic_helper_commit_planes(ddev, old_state,
+					DRM_PLANE_COMMIT_ACTIVE_ONLY);
+
+	drm_atomic_helper_commit_encoder_bridge_pre_enable(ddev, old_state);
+	drm_atomic_helper_commit_crtc_enable(ddev, old_state);
+	drm_atomic_helper_commit_encoder_bridge_enable(ddev, old_state);
+	drm_atomic_helper_commit_writebacks(ddev, old_state);
 
 	drm_atomic_helper_commit_hw_done(old_state);
 	drm_atomic_helper_wait_for_flip_done(ddev, old_state);


