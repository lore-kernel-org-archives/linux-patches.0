Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACC3BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7DDC433EF;
	Tue,  7 Mar 2023 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212829;
	bh=82gQNdo5je+dE/4l9FVgpGxP9TQM3V0YobUyE0w5/rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS9EpACg35ho5MOuOP+RMT3J4rY2FKGJ7cUqvFBC9zTBFLtv4di/UQgNJC/dLo5LV
	 BHSAwxse67l5l0HhqZTPVFb7y4dgYBmB+C+fyGlcU3S2qmKVCv6dHkn7RqnIZgMqzO
	 zPkgFfKc87bEvnEMZ0BV3v/X108bZnCm38xFOacA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/885] drm/vc4: hvs: Set AXI panic modes
Date: Tue,  7 Mar 2023 17:53:35 +0100
Message-Id: <20230307170014.224110438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit df993fced230daa8452892406f3180c93ebf7e7b ]

The HVS can change AXI request mode based on how full the COB
FIFOs are.
Until now the vc4 driver has been relying on the firmware to
have set these to sensible values.

With HVS channel 2 now being used for live video, change the
panic mode for all channels to be explicitly set by the driver,
and the same for all channels.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-2-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c  | 11 +++++++++++
 drivers/gpu/drm/vc4/vc4_regs.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 4ac9f5a2d5f99..ee55520c2f11d 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -884,6 +884,17 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		      SCALER_DISPCTRL_DSPEISLUR(2) |
 		      SCALER_DISPCTRL_SCLEIRQ);
 
+	/* Set AXI panic mode.
+	 * VC4 panics when < 2 lines in FIFO.
+	 * VC5 panics when less than 1 line in the FIFO.
+	 */
+	dispctrl &= ~(SCALER_DISPCTRL_PANIC0_MASK |
+		      SCALER_DISPCTRL_PANIC1_MASK |
+		      SCALER_DISPCTRL_PANIC2_MASK);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC0);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC1);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC2);
+
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
 	ret = devm_request_irq(dev, platform_get_irq(pdev, 0),
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index f0290fad991de..f121905c404d1 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -220,6 +220,12 @@
 #define SCALER_DISPCTRL                         0x00000000
 /* Global register for clock gating the HVS */
 # define SCALER_DISPCTRL_ENABLE			BIT(31)
+# define SCALER_DISPCTRL_PANIC0_MASK		VC4_MASK(25, 24)
+# define SCALER_DISPCTRL_PANIC0_SHIFT		24
+# define SCALER_DISPCTRL_PANIC1_MASK		VC4_MASK(27, 26)
+# define SCALER_DISPCTRL_PANIC1_SHIFT		26
+# define SCALER_DISPCTRL_PANIC2_MASK		VC4_MASK(29, 28)
+# define SCALER_DISPCTRL_PANIC2_SHIFT		28
 # define SCALER_DISPCTRL_DSP3_MUX_MASK		VC4_MASK(19, 18)
 # define SCALER_DISPCTRL_DSP3_MUX_SHIFT		18
 
-- 
2.39.2



