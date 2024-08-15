Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFCD63C;
	Thu, 15 Aug 2024 14:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731344; cv=none; b=vBwy7TShPY6wAZwGswT6quLKiWH33VdOz4QpBZ2M5OZplnhF4xWaIr9J0HTqAnUBu6tF6u0u0ys8KbPxfofGU6O+QW+6BzeivxccNqaMi0p9moGyuzvctOsI6xRvMD8Rzg4C0eqK+7kSsH1k94P49JVhu+ruHkyfmOhH2DBy+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731344; c=relaxed/simple;
	bh=0XM7YkoHrK4OZ2mRb0Mzbsll1JiuxQnBKoc21108jFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keYWAkQH4k6Q1G6nJ4Pp0i1WVkIvWR4HvPMhnSQ94CSGEWBy3hZFMrHSjM1geYTcFYLznhDC0cXQ+T/xq0tCwr2vS5869Pu9H1Zpl1iWrL3L3HtdXB4JWD7tLf+5iCo4dCCt1WBSb4ey9oeKZ4SUuxt1OLn/Aotr/fbQD0Uwmss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlIvU4Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlIvU4Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC12C32786;
	Thu, 15 Aug 2024 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731344;
	bh=0XM7YkoHrK4OZ2mRb0Mzbsll1JiuxQnBKoc21108jFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlIvU4VdawlkKICKcHUrxRIu8SsfYv/IZtsXuvwRTRjXd9kOu9XrCjldDe1fWKGQ/
	 DrxEWa3rELg3McA3wdAPBPl/rJRpSxGY6xxineWeVOwUsnDo0DhPXeHEABDdVF8XB9
	 oMN0xwtnrb9fonWXYSOjtXuiuDrCuD9taGagIZZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrei.lalaev@anton-paar.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/259] Input: qt1050 - handle CHIP_ID reading error
Date: Thu, 15 Aug 2024 15:23:21 +0200
Message-ID: <20240815131905.430151864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Lalaev <andrei.lalaev@anton-paar.com>

[ Upstream commit 866a5c7e2781cf1b019072288f1f5c64186dcb63 ]

If the device is missing, we get the following error:

  qt1050 3-0041: ID -1340767592 not supported

Let's handle this situation and print more informative error
when reading of CHIP_ID fails:

  qt1050 3-0041: Failed to read chip ID: -6

Fixes: cbebf5addec1 ("Input: qt1050 - add Microchip AT42QT1050 support")
Signed-off-by: Andrei Lalaev <andrei.lalaev@anton-paar.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20240617183018.916234-1-andrey.lalaev@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/qt1050.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/qt1050.c b/drivers/input/keyboard/qt1050.c
index 403060d05c3b3..7193a4198e214 100644
--- a/drivers/input/keyboard/qt1050.c
+++ b/drivers/input/keyboard/qt1050.c
@@ -226,7 +226,12 @@ static bool qt1050_identify(struct qt1050_priv *ts)
 	int err;
 
 	/* Read Chip ID */
-	regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	err = regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	if (err) {
+		dev_err(&ts->client->dev, "Failed to read chip ID: %d\n", err);
+		return false;
+	}
+
 	if (val != QT1050_CHIP_ID_VER) {
 		dev_err(&ts->client->dev, "ID %d not supported\n", val);
 		return false;
-- 
2.43.0



