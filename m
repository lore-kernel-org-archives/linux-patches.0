Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFA63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA02C433D2;
	Mon, 20 Feb 2023 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901595;
	bh=HRST84SWVS9PGipPeDRXh2QU9h3jwN4zpqXUouakz24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAXYmu5kP21iA7sYV7Z/ZL2brg0T6RnOd4hRHq3re9kn/aS3gvkbRNeTe7rPV1U11
	 rtOkyzEML2GUzVTizihzCI6KbB/CfYEcfjvWHNP/pTP0sSzaDCfu321t6hF7W4yYvC
	 tEooaLg7E1bz6KawRp/q77r0rVU2uC8/s+qY+EPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 6.1 078/118] drm/vc4: crtc: Increase setup cost in core clock calculation to handle extreme reduced blanking
Date: Mon, 20 Feb 2023 14:36:34 +0100
Message-Id: <20230220133603.537090925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dom Cobley <popcornmix@gmail.com>

commit 247a631f9c0ffb37ed0786a94cb4c5f2b6fc7ab1 upstream.

The formula that determines the core clock requirement based on pixel
clock and blanking has been determined experimentally to minimise the
clock while supporting all modes we've seen.

A new reduced blanking mode (4kp60 at 533MHz rather than the standard
594MHz) has been seen that doesn't produce a high enough clock and
results in "flip_done timed out" error.

Increase the setup cost in the formula to make this work. The result is
a reduced blanking mode increases by up to 7MHz while leaving the
standard timing
mode untouched

Link: https://github.com/raspberrypi/linux/issues/4446
Fixes: 16e101051f32 ("drm/vc4: Increase the core clock based on HVS load")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127145558.446123-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -711,7 +711,7 @@ static int vc4_crtc_atomic_check(struct
 		struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 
 		if (vc4_encoder->type == VC4_ENCODER_TYPE_HDMI0) {
-			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 1000,
+			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 8000,
 						  mode->clock * 9 / 10) * 1000;
 		} else {
 			vc4_state->hvs_load = mode->clock * 1000;


