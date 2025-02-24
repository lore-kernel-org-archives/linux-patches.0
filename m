Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99F24BC09;
	Mon, 24 Feb 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408603; cv=none; b=bZhCLCojPqKwgQUCeMR+jH/YqwrofTKFLyHcqBuDa1qWQyPhHQ73kDxltKivIoWoS+ZygT0cK1mjUoqJ6OnCIyht793GINZEP2Zi9Wf3L8NY4T2mvpz6+ur66dWIchgU9GENaEVqfwGnBJwsqLXXyUwimi1INhpTBVyBqtQGkdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408603; c=relaxed/simple;
	bh=11bXifA3UjSAQy1DU4CrDLXuERyAlBwJVNT3puVmoSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThL1N09o5scSIGeoGN6DVLo650QmscsVNBk90Svhb+y4Ec0n8G6DXG9n7NRVWH93yekqznAMulLZTbtQz12zai5HDUx8qGG+cwQcSu206SeEBPV9L0YIIpdx+et/3BfEumUTRzxQ6pXaY/iTca3OvY5fS9H5wV1hpBw58N6rV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S90kFA/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S90kFA/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1EAC4CED6;
	Mon, 24 Feb 2025 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408603;
	bh=11bXifA3UjSAQy1DU4CrDLXuERyAlBwJVNT3puVmoSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S90kFA/RSEptUNvZbvXKW0Sv5y/B8JclSjsQVjzzhteJQNGgp4nwCiQkRuNFo3A6X
	 6oSDOrK0iRb6AbtB9BY1Y9Xm+c3iNa/SMe/iqbM+R6lxLF+/RpoS0A3YM0kYJfVM16
	 lUllBOQngNEFLcl8U3Q6s4+uN8l9RSxmmvyseRqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 106/154] drm: panel: jd9365da-h3: fix reset signal polarity
Date: Mon, 24 Feb 2025 15:35:05 +0100
Message-ID: <20250224142611.209170914@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit a8972d5a49b408248294b5ecbdd0a085e4726349 upstream.

In jadard_prepare() a reset pulse is generated with the following
statements (delays ommited for clarity):

    gpiod_set_value(jadard->reset, 1); --> Deassert reset
    gpiod_set_value(jadard->reset, 0); --> Assert reset for 10ms
    gpiod_set_value(jadard->reset, 1); --> Deassert reset

However, specifying second argument of "0" to gpiod_set_value() means to
deassert the GPIO, and "1" means to assert it. If the reset signal is
defined as GPIO_ACTIVE_LOW in the DTS, the above statements will
incorrectly generate the reset pulse (inverted) and leave it asserted
(LOW) at the end of jadard_prepare().

Fix reset behavior by inverting gpiod_set_value() second argument
in jadard_prepare(). Also modify second argument to devm_gpiod_get()
in jadard_dsi_probe() to assert the reset when probing.

Do not modify it in jadard_unprepare() as it is already properly
asserted with "1", which seems to be the intended behavior.

Fixes: 6b818c533dd8 ("drm: panel: Add Jadard JD9365DA-H3 DSI panel")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240927135306.857617-1-hugo@hugovil.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240927135306.857617-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -109,13 +109,13 @@ static int jadard_prepare(struct drm_pan
 	if (jadard->desc->lp11_to_reset_delay_ms)
 		msleep(jadard->desc->lp11_to_reset_delay_ms);
 
-	gpiod_set_value(jadard->reset, 1);
+	gpiod_set_value(jadard->reset, 0);
 	msleep(5);
 
-	gpiod_set_value(jadard->reset, 0);
+	gpiod_set_value(jadard->reset, 1);
 	msleep(10);
 
-	gpiod_set_value(jadard->reset, 1);
+	gpiod_set_value(jadard->reset, 0);
 	msleep(130);
 
 	ret = jadard->desc->init(jadard);
@@ -1130,7 +1130,7 @@ static int jadard_dsi_probe(struct mipi_
 	dsi->format = desc->format;
 	dsi->lanes = desc->lanes;
 
-	jadard->reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	jadard->reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(jadard->reset)) {
 		DRM_DEV_ERROR(&dsi->dev, "failed to get our reset GPIO\n");
 		return PTR_ERR(jadard->reset);


