Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA43A28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955B9C433EF;
	Mon, 12 Dec 2022 13:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852141;
	bh=r6ABrTExSj7XORA8ugle5D+yV4etWitLOUNUwkKrs/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0uMzXF2tj+sQP2if05ptY0palRA+b4NgWF25OHWQk7wIrzSurqYLha4OReS/zgb8
	 PhREwYzflazSgPpnDWfa1HFKnFoBIGlj/IWQ/1tZ83NC1OI4TwZJIwYEsBjAFr2jkf
	 eGm+g2vdweFdo12N4WfsY8zBhB0alvJl9na51qnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 002/157] drm/i915: Remove non-existent pipes from bigjoiner pipe mask
Date: Mon, 12 Dec 2022 14:15:50 +0100
Message-Id: <20221212130934.474226763@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 3c1ea6a5f4f55d4e376675dda16945eb5d9bb4de ]

bigjoiner_pipes() doesn't consider that:
- RKL only has three pipes
- some pipes may be fused off

This means that intel_atomic_check_bigjoiner() won't reject
all configurations that would need a non-existent pipe.
Instead we just keep on rolling witout actually having
reserved the slave pipe we need.

It's possible that we don't outright explode anywhere due to
this since eg. for_each_intel_crtc_in_pipe_mask() will only
walk the crtcs we've registered even though the passed in
pipe_mask asks for more of them. But clearly the thing won't
do what is expected of it when the required pipes are not
present.

Fix the problem by consulting the device info pipe_mask already
in bigjoiner_pipes().

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221118185201.10469-1-ville.syrjala@linux.intel.com
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
(cherry picked from commit f1c87a94a1087a26f41007ee83264033007421b5)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index fc5d94862ef3..d0f20bd0e51a 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3717,12 +3717,16 @@ static bool ilk_get_pipe_config(struct intel_crtc *crtc,
 
 static u8 bigjoiner_pipes(struct drm_i915_private *i915)
 {
+	u8 pipes;
+
 	if (DISPLAY_VER(i915) >= 12)
-		return BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
+		pipes = BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
 	else if (DISPLAY_VER(i915) >= 11)
-		return BIT(PIPE_B) | BIT(PIPE_C);
+		pipes = BIT(PIPE_B) | BIT(PIPE_C);
 	else
-		return 0;
+		pipes = 0;
+
+	return pipes & INTEL_INFO(i915)->display.pipe_mask;
 }
 
 static bool transcoder_ddi_func_is_enabled(struct drm_i915_private *dev_priv,
-- 
2.35.1



