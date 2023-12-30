Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC188483;
	Sat, 30 Dec 2023 12:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdPOTxGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89005C433C9;
	Sat, 30 Dec 2023 12:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938222;
	bh=KkREQEK64X68upucw6TEI2xo6m4RV+DIJCpkjmOeES4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdPOTxGX38g+6RtBWyK/no0rUJAUy3GW18oTgisM5hBosnRSQDGoBHS06opklhC91
	 W3U2p12x9AmUOwAUKclg8d5ybIo7YY6aB4lm8JiHJoENTi/MoMLv0qw3AnW4VWq0LU
	 6Tx745Q2oi7vd/BVsJgqxMMJw+I6xb4PSX+czg9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/112] drm/i915: Fix intel_atomic_setup_scalers() plane_state handling
Date: Sat, 30 Dec 2023 11:59:23 +0000
Message-ID: <20231230115808.319836336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit c3070f080f9ba18dea92eaa21730f7ab85b5c8f4 ]

Since the plane_state variable is declared outside the scaler_users
loop in intel_atomic_setup_scalers(), and it's never reset back to
NULL inside the loop we may end up calling intel_atomic_setup_scaler()
with a non-NULL plane state for the pipe scaling case. That is bad
because intel_atomic_setup_scaler() determines whether we are doing
plane scaling or pipe scaling based on plane_state!=NULL. The end
result is that we may miscalculate the scaler mode for pipe scaling.

The hardware becomes somewhat upset if we end up in this situation
when scanning out a planar format on a SDR plane. We end up
programming the pipe scaler into planar mode as well, and the
result is a screenfull of garbage.

Fix the situation by making sure we pass the correct plane_state==NULL
when calculating the scaler mode for pipe scaling.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231207193441.20206-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit e81144106e21271c619f0c722a09e27ccb8c043d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_scaler.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/skl_scaler.c b/drivers/gpu/drm/i915/display/skl_scaler.c
index 83a61efa84395..0b74f91e865d0 100644
--- a/drivers/gpu/drm/i915/display/skl_scaler.c
+++ b/drivers/gpu/drm/i915/display/skl_scaler.c
@@ -493,7 +493,6 @@ int intel_atomic_setup_scalers(struct drm_i915_private *dev_priv,
 {
 	struct drm_plane *plane = NULL;
 	struct intel_plane *intel_plane;
-	struct intel_plane_state *plane_state = NULL;
 	struct intel_crtc_scaler_state *scaler_state =
 		&crtc_state->scaler_state;
 	struct drm_atomic_state *drm_state = crtc_state->uapi.state;
@@ -525,6 +524,7 @@ int intel_atomic_setup_scalers(struct drm_i915_private *dev_priv,
 
 	/* walkthrough scaler_users bits and start assigning scalers */
 	for (i = 0; i < sizeof(scaler_state->scaler_users) * 8; i++) {
+		struct intel_plane_state *plane_state = NULL;
 		int *scaler_id;
 		const char *name;
 		int idx, ret;
-- 
2.43.0



