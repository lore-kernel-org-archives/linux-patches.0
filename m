Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF86237889;
	Mon, 18 Dec 2023 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVUug28n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF4C433C8;
	Mon, 18 Dec 2023 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908415;
	bh=jC8TOH0RaGJ7iH3pkZANn28B9XXZ6HWkMDdfVNb8wQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVUug28nRdVcRi7GEbjAhhjHA+5pYSFoiHcYjPekvblq+w7Evu6C86hkh7WlIUTTS
	 bphlnnDlE6VNuu5RaiCBaPlPaKvWYF5SwNz+8MIrAVVfK40pqFB2GUHjIrNfJ+/1zS
	 LDuSU6SOBmqibXTTz+6q6Yp5eVsool4Zaf+U//JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 151/166] drm/i915: Fix intel_atomic_setup_scalers() plane_state handling
Date: Mon, 18 Dec 2023 14:51:57 +0100
Message-ID: <20231218135111.882175037@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit c3070f080f9ba18dea92eaa21730f7ab85b5c8f4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/skl_scaler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/skl_scaler.c
+++ b/drivers/gpu/drm/i915/display/skl_scaler.c
@@ -504,7 +504,6 @@ int intel_atomic_setup_scalers(struct dr
 {
 	struct drm_plane *plane = NULL;
 	struct intel_plane *intel_plane;
-	struct intel_plane_state *plane_state = NULL;
 	struct intel_crtc_scaler_state *scaler_state =
 		&crtc_state->scaler_state;
 	struct drm_atomic_state *drm_state = crtc_state->uapi.state;
@@ -536,6 +535,7 @@ int intel_atomic_setup_scalers(struct dr
 
 	/* walkthrough scaler_users bits and start assigning scalers */
 	for (i = 0; i < sizeof(scaler_state->scaler_users) * 8; i++) {
+		struct intel_plane_state *plane_state = NULL;
 		int *scaler_id;
 		const char *name;
 		int idx, ret;


