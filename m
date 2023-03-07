Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D120DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E1EC433D2;
	Tue,  7 Mar 2023 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209846;
	bh=fYrUHkdw9yhnOmqN9DQmG9V0OSCmA5psQYNPMf+DzjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l186N4pfPWmB3Qx9xkNrpVMxp+VyCt1JdowvEaMpJdEX0KkZWICam0+Ca87MbHtm8
	 4I1QynRVWWmWZUisep2b1J03v7RhFY3t+BQicgsQUx23vp0OT72UPvURe3PCuso+Em
	 LusWOUI3scnuYjWTQUFhG1vrVr+AkYPKYf9hFKX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0350/1001] drm/vc4: hvs: SCALER_DISPBKGND_AUTOHS is only valid on HVS4
Date: Tue,  7 Mar 2023 17:52:02 +0100
Message-Id: <20230307170036.642750195@linuxfoundation.org>
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

[ Upstream commit 982ee94486863a41c6af9f2ab3f6681f72bc5c48 ]

The bit used for SCALER_DISPBKGND_AUTOHS in SCALER_DISPBKGNDX
has been repurposed on HVS5 to configure whether a display can
win back-to-back arbitration wins for the COB.

This is not desirable, therefore only select this bit on HVS4,
and explicitly clear it on HVS5.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-3-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c  | 10 ++++++----
 drivers/gpu/drm/vc4/vc4_regs.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index b335815eac6a5..57d99e7199ee5 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -370,28 +370,30 @@ static int vc4_hvs_init_channel(struct vc4_hvs *hvs, struct drm_crtc *crtc,
 	 * mode.
 	 */
 	dispctrl = SCALER_DISPCTRLX_ENABLE;
+	dispbkgndx = HVS_READ(SCALER_DISPBKGNDX(chan));
 
-	if (!vc4->is_vc5)
+	if (!vc4->is_vc5) {
 		dispctrl |= VC4_SET_FIELD(mode->hdisplay,
 					  SCALER_DISPCTRLX_WIDTH) |
 			    VC4_SET_FIELD(mode->vdisplay,
 					  SCALER_DISPCTRLX_HEIGHT) |
 			    (oneshot ? SCALER_DISPCTRLX_ONESHOT : 0);
-	else
+		dispbkgndx |= SCALER_DISPBKGND_AUTOHS;
+	} else {
 		dispctrl |= VC4_SET_FIELD(mode->hdisplay,
 					  SCALER5_DISPCTRLX_WIDTH) |
 			    VC4_SET_FIELD(mode->vdisplay,
 					  SCALER5_DISPCTRLX_HEIGHT) |
 			    (oneshot ? SCALER5_DISPCTRLX_ONESHOT : 0);
+		dispbkgndx &= ~SCALER5_DISPBKGND_BCK2BCK;
+	}
 
 	HVS_WRITE(SCALER_DISPCTRLX(chan), dispctrl);
 
-	dispbkgndx = HVS_READ(SCALER_DISPBKGNDX(chan));
 	dispbkgndx &= ~SCALER_DISPBKGND_GAMMA;
 	dispbkgndx &= ~SCALER_DISPBKGND_INTERLACE;
 
 	HVS_WRITE(SCALER_DISPBKGNDX(chan), dispbkgndx |
-		  SCALER_DISPBKGND_AUTOHS |
 		  ((!vc4->is_vc5) ? SCALER_DISPBKGND_GAMMA : 0) |
 		  (interlace ? SCALER_DISPBKGND_INTERLACE : 0));
 
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index f121905c404d1..95deacdc31e77 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -366,6 +366,7 @@
 
 #define SCALER_DISPBKGND0                       0x00000044
 # define SCALER_DISPBKGND_AUTOHS		BIT(31)
+# define SCALER5_DISPBKGND_BCK2BCK		BIT(31)
 # define SCALER_DISPBKGND_INTERLACE		BIT(30)
 # define SCALER_DISPBKGND_GAMMA			BIT(29)
 # define SCALER_DISPBKGND_TESTMODE_MASK		VC4_MASK(28, 25)
-- 
2.39.2



