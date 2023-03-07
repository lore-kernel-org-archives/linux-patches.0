Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BA8BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA24C433EF;
	Tue,  7 Mar 2023 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209859;
	bh=JSSwUkv1o5TPutBE+WW2EbqvyFkxexbWXlI4tv5ZMr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVRlfbjqaJOgMuSxnytfw6xluTFfnj7OSSIe5hqgPnA/tiANBAMUyzG/EGk9AWJWk
	 gXTf0Huubng8y2+rLxZqSEHkQq7EhgnmFjx/ekCXzgFIZLCeUFDVpnXMWcEvOoanlT
	 i76gUWDOLYrcovZB6x1VoUp5N5atS9Q5UOIKc5u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0353/1001] drm/vc4: hdmi: Correct interlaced timings again
Date: Tue,  7 Mar 2023 17:52:05 +0100
Message-Id: <20230307170036.762641786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 771d6539f27bd55f43d8a95d53a7eeaaffa2681c ]

The back porch timings were correct, only the sync offset was wrong.
Correct timing is now reported for 1080i and 576i, but the h offset is
incorrect for 480i for non-obvious reasons.

Fixes: fb10dc451c0f ("drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-14-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 21338e6a95056..3f3f94e7b8339 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1311,11 +1311,12 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 		     VC4_SET_FIELD(mode->crtc_vdisplay, VC5_HDMI_VERTA_VAL));
 	u32 vertb = (VC4_SET_FIELD(mode->htotal >> (2 - pixel_rep),
 				   VC5_HDMI_VERTB_VSPO) |
-		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				   interlaced,
 				   VC4_HDMI_VERTB_VBP));
 	u32 vertb_even = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
 			  VC4_SET_FIELD(mode->crtc_vtotal -
-					mode->crtc_vsync_end - interlaced,
+					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned long flags;
 	unsigned char gcp;
-- 
2.39.2



