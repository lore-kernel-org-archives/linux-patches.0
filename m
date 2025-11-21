Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B36264612;
	Fri, 21 Nov 2025 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731483; cv=none; b=mY1RfaB0QGnJ4jqKvrrA2fyImTy5Iz4cEP3yTtQBeK3u/OTciHWrVDuYFxL4vrNKPcs17MMRquNYwPC1JJa/3H5kge8uy+m3Qq2mReKsaHa8ZjplTIw1ccWUsj5+3dncAfvqncPnZeRuS027jhGbTdx6/2S9hnNAdM0lGCXaKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731483; c=relaxed/simple;
	bh=SXzkxeukIDlvhkGINGX4Go52n+TL4VLV9gTcw319DkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXggpHQQuMHIjPBoEsTYf357isoPmGz8gNUiuwY45vAdHBoS0/uOHjRW1j60L0t/Y58vEgTinc+MFlJK0i/6JyS7kmC3E3ZQv9laFIYfsksoI7BgE/KS1BDnxJWXXC051t4GKy/K7O7fBrmiDKzSTT8DFBEpYYSW6EDOmQQkCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Aw34EcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Aw34EcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69BDC4CEFB;
	Fri, 21 Nov 2025 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731483;
	bh=SXzkxeukIDlvhkGINGX4Go52n+TL4VLV9gTcw319DkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Aw34EcYog/cp7Z+7rDnAW2YinsRt0dYs9cGvxI4YwYeuQuj/knp8tiEzJtWlupRU
	 4wEy+ylok+I8cb4wlISJ8Mxg0COYCpnXf7Pk4mOfBQFvV6pwKd8AfQx99xs8dPOc5w
	 apzVg97bZWA6Jn+1vTbaCXLtIRIUv75E1A/1fA/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.17 222/247] drm/i915/psr: fix pipe to vblank conversion
Date: Fri, 21 Nov 2025 14:12:49 +0100
Message-ID: <20251121130202.701192451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 994dec10991b53beac3e16109d876ae363e8a329 upstream.

First, we can't assume pipe == crtc index. If a pipe is fused off in
between, it no longer holds. intel_crtc_for_pipe() is the only proper
way to get from a pipe to the corresponding crtc.

Second, drivers aren't supposed to access or index drm->vblank[]
directly. There's drm_crtc_vblank_crtc() for this.

Use both functions to fix the pipe to vblank conversion.

Fixes: f02658c46cf7 ("drm/i915/psr: Add mechanism to notify PSR of pipe enable/disable")
Cc: Jouni Högander <jouni.hogander@intel.com>
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patch.msgid.link/20251106200000.1455164-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 2750f6765d6974f7e163c5d540a96c8703f6d8dd)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -896,7 +896,8 @@ static bool is_dc5_dc6_blocked(struct in
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 	u32 current_dc_state = intel_display_power_get_current_dc_state(display);
-	struct drm_vblank_crtc *vblank = &display->drm->vblank[intel_dp->psr.pipe];
+	struct intel_crtc *crtc = intel_crtc_for_pipe(display, intel_dp->psr.pipe);
+	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(&crtc->base);
 
 	return (current_dc_state != DC_STATE_EN_UPTO_DC5 &&
 		current_dc_state != DC_STATE_EN_UPTO_DC6) ||


