Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA5745BE3;
	Fri,  6 Dec 2024 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496347; cv=none; b=FBYpOrQCD9IMUJdKv/jR3l+6d55ZRKc22vjvq4/At2ZPyPUZxIyGK3vByq3nHtdQgKyA7C+HopqdWjyMA2SgNW58TvIsxxcBC3/dr4QUjA4MeewfuCL/9wI+klSb5iK7IVgekAJ26F4aBOGfCCLp0+4oQPKt3ssPqX7DPoa+Ycs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496347; c=relaxed/simple;
	bh=DJximOLl9WD2M8lxNhfJ7RYMeSwJ0D6gD6tc2JcekJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHV5bZucRSegFlCatthYfDNEC2psguBHPgJkzApy4c1nf1jqIGFSeP7pO+VB2tg7GNsDdwQNzTnedVopnS2aHv2sho+Vf3vTxAgAk4Y1tJ9fimBaDKOFpg2WRq4kMpfdu/yG1FxE9gMzxfKaHAMUJ1VfQtMqZs5RXxoMdAMo8eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKcUhcWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKcUhcWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B166C4CED1;
	Fri,  6 Dec 2024 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496346;
	bh=DJximOLl9WD2M8lxNhfJ7RYMeSwJ0D6gD6tc2JcekJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKcUhcWf/x/vXvb871fHdZB1TF+PxjODz09039jJssPn6OJzsN6OlhdqtcyzE6yQb
	 kZvWvF1Yp2uOvM4+Gum20jGusGNGvyDmyClLV5hZzHtjsWeUVBWIwc8WtpWh6ED/DC
	 RVBO12OLP9jwu7GqLRe6F+tSpMCnI/ODk2Znqk5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH 6.12 126/146] drm/bridge: it6505: Fix inverted reset polarity
Date: Fri,  6 Dec 2024 15:37:37 +0100
Message-ID: <20241206143532.503618172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chen-Yu Tsai <wenst@chromium.org>

commit c5f3f21728b069412e8072b8b1d0a3d9d3ab0265 upstream.

The IT6505 bridge chip has a active low reset line. Since it is a
"reset" and not an "enable" line, the GPIO should be asserted to
put it in reset and deasserted to bring it out of reset during
the power on sequence.

The polarity was inverted when the driver was first introduced, likely
because the device family that was targeted had an inverting level
shifter on the reset line.

The MT8186 Corsola devices already have the IT6505 in their device tree,
but the whole display pipeline is actually disabled and won't be enabled
until some remaining issues are sorted out. The other known user is
the MT8183 Kukui / Jacuzzi family; their device trees currently do not
have the IT6505 included.

Fix the polarity in the driver while there are no actual users.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029095411.657616-1-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2614,9 +2614,9 @@ static int it6505_poweron(struct it6505
 	/* time interval between OVDD and SYSRSTN at least be 10ms */
 	if (pdata->gpiod_reset) {
 		usleep_range(10000, 20000);
-		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
-		usleep_range(1000, 2000);
 		gpiod_set_value_cansleep(pdata->gpiod_reset, 1);
+		usleep_range(1000, 2000);
+		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
 		usleep_range(25000, 35000);
 	}
 
@@ -2647,7 +2647,7 @@ static int it6505_poweroff(struct it6505
 	disable_irq_nosync(it6505->irq);
 
 	if (pdata->gpiod_reset)
-		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
+		gpiod_set_value_cansleep(pdata->gpiod_reset, 1);
 
 	if (pdata->pwr18) {
 		err = regulator_disable(pdata->pwr18);
@@ -3135,7 +3135,7 @@ static int it6505_init_pdata(struct it65
 		return PTR_ERR(pdata->ovdd);
 	}
 
-	pdata->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	pdata->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(pdata->gpiod_reset)) {
 		dev_err(dev, "gpiod_reset gpio not found");
 		return PTR_ERR(pdata->gpiod_reset);


