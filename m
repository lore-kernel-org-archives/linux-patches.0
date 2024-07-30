Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B10D1A6164;
	Tue, 30 Jul 2024 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356499; cv=none; b=c3C/USYR4dInWZAJgb4/dqnXutxuvKiaiNzWKrlYbNWTevRseaI1m20E6zHVLk1FTEGq8YTBn2B4Dr2zXBdxOyoHoxFuBV/VE3MvUm+bo7FM1LV1SuIUKWYvE85T0NtBu3loZ2gLYyZHqnohcSbAvVt/s78HlTV+TUFARDgl28c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356499; c=relaxed/simple;
	bh=Iv4N6TNJdcYvYkFJbvkhxe1kc8xGBsOJ9Uu1/0c9IcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXRIB2PHiLY4JoL+/oxYx0JzeObznH7tm5Ch1PFREPlpnZd6ivAzSfnY+AjcTCJGKc1Fb6kRL+ZOCpIvY/sG0k31ibMRSl5eZarShh8459eyR0SPNDUzextPRn5UlvYo46VGXNBSMsTfrlGTqrkfCx345YbSx96mZHNFLNDKdtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kigT9bXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kigT9bXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84BDC32782;
	Tue, 30 Jul 2024 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356499;
	bh=Iv4N6TNJdcYvYkFJbvkhxe1kc8xGBsOJ9Uu1/0c9IcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kigT9bXlBfQaLBY6+Q4OmBtIy9NUI9OuXZSN7HwlrrtFmWWOjxUg6X7tEy/RRk3y1
	 T4EpwiH4jziJ04z/8jV6Yn9NCi224P07I3L+Gn+nm3U4E1x0O5Vqw7pKtHxnz0OqsO
	 wgUNNlXzmftdD+mpGaMPAOWoyUaHhnGJmLdnbzxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrei.lalaev@anton-paar.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/440] Input: qt1050 - handle CHIP_ID reading error
Date: Tue, 30 Jul 2024 17:47:10 +0200
Message-ID: <20240730151623.568447072@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



