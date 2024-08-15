Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4157C176ADE;
	Thu, 15 Aug 2024 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729532; cv=none; b=umIXlrLgQPpgWAqG52nX4o1x4xX3CzYG6SEt2vREYW9vQRInxKZPEvbek+ZQ0hxxwF/l83jQtdeziRvGmQFnii8IUF7ujhCDCOeuL9pggAkt0uRa+CeASVKFuqfuufBplkgWF1D9W9Z8cGtsGhltGkGpI3Sa414B9rH4VjBazS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729532; c=relaxed/simple;
	bh=k0dEhxtYO88dZmKx6+8Nsai5upGrrcwiok62K+RKWkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olVwLDXjmX5mUBZuCz5yOR4iquWAX/Ye/PMYwQcOJTAxg+4bFIwSoHAsc6jkCt28ztQ4MC9hKgkwplDUcZ6HVsv7Y9PcLNvdVAMqFSLq/m7E1tDRaDynpp8cKtRRlWgG7pyRICCO1WLuRMr6nFl4rjO3dhEcv1PvtK8IA7CIy3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8YW5KCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8YW5KCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F8CC32786;
	Thu, 15 Aug 2024 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729532;
	bh=k0dEhxtYO88dZmKx6+8Nsai5upGrrcwiok62K+RKWkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8YW5KCesNvgYxMJTyJwz3j9gywtUwMdEyhxfctPE5yIzxrau78VZwISxEndxGU8k
	 jy0PF1mK+bC/MIDpLDGXM27bMcdadxvS2z+hFKa/iAydCizaFUuW6dwXaFxJooDBVm
	 xFRq2LXubQyGvocRTgGUByKvUqUAzVRsluF2EF4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrei.lalaev@anton-paar.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/484] Input: qt1050 - handle CHIP_ID reading error
Date: Thu, 15 Aug 2024 15:19:44 +0200
Message-ID: <20240815131946.166340909@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



