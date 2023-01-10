Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884FFA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0736FC433D2;
	Tue, 10 Jan 2023 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374264;
	bh=aF9XGd847OBV9ASn/3QWJID57AOLr6pHJv2XGS0Veog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOIP35hLxHoiR7GGeo0ROBVJwAEKHjIMAmeMivAf3zFdf6vmb1ihkwC/AHr2TgoR/
	 BFOU8VBhxw0+R6PYQu7hNjnwKQiw7cDzlsGiZ48GPpdeGS63T2oAcaRSZLtwWQPV7H
	 qBpZJmty6S9Y4LgjqMduTh0ZhSviQB6wEkVNhM/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 076/148] drm/meson: Reduce the FIFO lines held when AFBC is not used
Date: Tue, 10 Jan 2023 19:03:00 +0100
Message-Id: <20230110180019.627162866@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlo Caione <ccaione@baylibre.com>

[ Upstream commit 3b754ed6d1cd90017e66e5cc16f3923e4a952ffc ]

Having a bigger number of FIFO lines held after vsync is only useful to
SoCs using AFBC to give time to the AFBC decoder to be reset, configured
and enabled again.

For SoCs not using AFBC this, on the contrary, is causing on some
displays issues and a few pixels vertical offset in the displayed image.

Conditionally increase the number of lines held after vsync only for
SoCs using AFBC, leaving the default value for all the others.

Fixes: 24e0d4058eff ("drm/meson: hold 32 lines after vsync to give time for AFBC start")
Signed-off-by: Carlo Caione <ccaione@baylibre.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
[narmstrong: added fixes tag]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216-afbc_s905x-v1-0-033bebf780d9@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_viu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index d4b907889a21..cd399b0b7181 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -436,15 +436,14 @@ void meson_viu_init(struct meson_drm *priv)
 
 	/* Initialize OSD1 fifo control register */
 	reg = VIU_OSD_DDR_PRIORITY_URGENT |
-		VIU_OSD_HOLD_FIFO_LINES(31) |
 		VIU_OSD_FIFO_DEPTH_VAL(32) | /* fifo_depth_val: 32*8=256 */
 		VIU_OSD_WORDS_PER_BURST(4) | /* 4 words in 1 burst */
 		VIU_OSD_FIFO_LIMITS(2);      /* fifo_lim: 2*16=32 */
 
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
-		reg |= VIU_OSD_BURST_LENGTH_32;
+		reg |= (VIU_OSD_BURST_LENGTH_32 | VIU_OSD_HOLD_FIFO_LINES(31));
 	else
-		reg |= VIU_OSD_BURST_LENGTH_64;
+		reg |= (VIU_OSD_BURST_LENGTH_64 | VIU_OSD_HOLD_FIFO_LINES(4));
 
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD1_FIFO_CTRL_STAT));
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD2_FIFO_CTRL_STAT));
-- 
2.35.1



