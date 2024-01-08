Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11C26AC1;
	Mon,  8 Jan 2024 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRIT2WrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094FCC433C7;
	Mon,  8 Jan 2024 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726838;
	bh=7MV2LSAyroYB9zdp16Md/QxbzRgFUbeYh6gcoMoDiWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRIT2WrAqzRHPNlSqmMUHvQ5on8ZynAuWzUiYSvb6d/dryUYqNL36wKG2cD67WFp7
	 LkcvrcX/jhWl768+Uob07+OJjj4+cS9cn2t3LpE3eCYbKALaNl0RKVrXJdblVMCuSB
	 nG1L4DpPaPjuVtPrQOv3Oj+TV2uGRn6lFTLaNGmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/124] drm/i915: Call intel_pre_plane_updates() also for pipes getting enabled
Date: Mon,  8 Jan 2024 16:08:41 +0100
Message-ID: <20240108150607.342701090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

[ Upstream commit d21a3962d3042e6f56ad324cf18bdd64a1e6ecfa ]

We used to call intel_pre_plane_updates() for any pipe going through
a modeset whether the pipe was previously enabled or not. This in
fact needed to apply all the necessary clock gating workarounds/etc.
Restore the correct behaviour.

Fixes: 39919997322f ("drm/i915: Disable all planes before modesetting any pipes")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231121054324.9988-3-ville.syrjala@linux.intel.com
(cherry picked from commit e0d5ce11ed0a21bb2bf328ad82fd261783c7ad88)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 2e0daad23aa61..a072fbb9872aa 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -6670,10 +6670,11 @@ static void intel_commit_modeset_disables(struct intel_atomic_state *state)
 		if (!intel_crtc_needs_modeset(new_crtc_state))
 			continue;
 
+		intel_pre_plane_update(state, crtc);
+
 		if (!old_crtc_state->hw.active)
 			continue;
 
-		intel_pre_plane_update(state, crtc);
 		intel_crtc_disable_planes(state, crtc);
 	}
 
-- 
2.43.0



