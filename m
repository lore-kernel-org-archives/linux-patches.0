Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672386F2FE;
	Thu, 12 Dec 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017777; cv=none; b=d1skODxraRXc0PVZTXu1RBWH621u6XVZfODk2ZxcN6ev9jObjhu6xjc2FXugpkw9H5MRj2wwPXXm6/B8wu5tBPU8RgxcSAjc4p9LuM+DeE1GoUggU9MTWgttEzQXhSaNAnKUdLdvaO3sJ6Jz4KfOBbIExpBJv28uEgyeHtbLvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017777; c=relaxed/simple;
	bh=1KtkCpTod7W/5RU8GSTWvPVYq6dodiMC6tS4ZJONzzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OssaHKlitVG+7lQGNh75xnfbIMh7sQenJsONyAxxa+uNJZaV8WS4MaXZIfX9MLKcfYex6w9Ryz+OZ4QLA3cqyMbmB1OlH7qfelX3ccgmzW7kUrH1WKiM8lOc6fIAjx1HTZrbA+7IG6GQ6vqHFKfboLGgImPvH917XtCnQzQaHlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKphNoV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKphNoV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E7AC4CECE;
	Thu, 12 Dec 2024 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017777;
	bh=1KtkCpTod7W/5RU8GSTWvPVYq6dodiMC6tS4ZJONzzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKphNoV3vQmPnNjLVVFSlOb9V/3P6nALQYFbl8Rjpyw3kenEtbuBShBKOn4mNsm9+
	 ZorlzrFHyR7qgCV13xQfjXa8eclGeUf/qw3PlMMG7YxcxfxocSiLrL2atJA7vqhT6q
	 jeHjuxf4z4yC65AOh1F4sE5sPxWIIndk/Hx8yIs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/356] drm/bridge: it6505: Fix inverted reset polarity
Date: Thu, 12 Dec 2024 15:57:07 +0100
Message-ID: <20241212144248.903219559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c5f3f21728b069412e8072b8b1d0a3d9d3ab0265 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index fda2c565fdb31..2a7c620626a03 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2611,9 +2611,9 @@ static int it6505_poweron(struct it6505 *it6505)
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
 
@@ -2640,7 +2640,7 @@ static int it6505_poweroff(struct it6505 *it6505)
 	}
 
 	if (pdata->gpiod_reset)
-		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
+		gpiod_set_value_cansleep(pdata->gpiod_reset, 1);
 
 	if (pdata->pwr18) {
 		err = regulator_disable(pdata->pwr18);
@@ -3132,7 +3132,7 @@ static int it6505_init_pdata(struct it6505 *it6505)
 		return PTR_ERR(pdata->ovdd);
 	}
 
-	pdata->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	pdata->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(pdata->gpiod_reset)) {
 		dev_err(dev, "gpiod_reset gpio not found");
 		return PTR_ERR(pdata->gpiod_reset);
-- 
2.43.0



