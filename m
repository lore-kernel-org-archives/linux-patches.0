Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B63B6C17;
	Tue, 21 Jul 2026 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672964; cv=none; b=hqxQHFmJZzZ4xbTFytLDammGdhXQzromB2xVxQ05UBr6UN9P8bbTcYxvdqoESMG6zTmzHhtyleZXdL7+ar7TXJiUlPOgeJErYfEE0j16wKf74bNgAVFnMSghXyLCbWOV8gFohm7WKvM23yrDQ4iDYwveBHuL6JKH4ZvTPWs4Ac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672964; c=relaxed/simple;
	bh=rJg3sVrZtokRLBKZITTbm5uGpVBIl/DsVtXJhVaSd28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejeAuuQmtJC6QdHZg6kOzMBb/XZA3WhG/dUdRb1E7M+bJziiRVF7gnpn0mnlcPFyXCWw6IgfGPm7aM+yrOdS7JZGAKX5avJyauNFV5qUJEXtjPii4YePK6dJFYFAm6quWAaOxEU/wakZsuT/JMQxqXBMvmZVvH4g20iPCneC5Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps+sS8aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps+sS8aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D561F000E9;
	Tue, 21 Jul 2026 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672963;
	bh=uWj8KCfdpHhRzrsSt06l2/b0iMKd+mcGTDRCnOvsYv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ps+sS8awBrN5RH7qsI66ksAjTSQQS3+MO9o9svzFRibON7xR5OgsFyW55TWO+2WgL
	 pfnabp4XZaq6pU7J4mv1w0uUw47aGf51sYDo7V5w4aKMcdKa33d9zIZDIZa4PenvFs
	 E4pAbb/we2uGP0ifDpK52w16M2n7kLrRwFDLeCm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 816/843] leds: lm3601x: Improve error reporting for problems during .remove()
Date: Tue, 21 Jul 2026 17:27:31 +0200
Message-ID: <20260721152424.432475470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 22a23436891886a66d21af3619f4a4e8809f0e0a ]

Returning an error value in an i2c remove callback results in a generic
error message being emitted by the i2c core, but otherwise it doesn't
make a difference. The device goes away anyhow and the devm cleanups are
called.

So instead of triggering the generic i2c error message, emit a more
helpful message if a problem occurs and return 0 to suppress the generic
message.

This patch is a preparation for making i2c remove callbacks return void.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1f0bdc2884b6 ("usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/flash/leds-lm3601x.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/leds/flash/leds-lm3601x.c
+++ b/drivers/leds/flash/leds-lm3601x.c
@@ -443,10 +443,15 @@ static int lm3601x_probe(struct i2c_clie
 static int lm3601x_remove(struct i2c_client *client)
 {
 	struct lm3601x_led *led = i2c_get_clientdata(client);
+	int ret;
 
-	return regmap_update_bits(led->regmap, LM3601X_ENABLE_REG,
-			   LM3601X_ENABLE_MASK,
-			   LM3601X_MODE_STANDBY);
+	ret = regmap_update_bits(led->regmap, LM3601X_ENABLE_REG,
+				 LM3601X_ENABLE_MASK, LM3601X_MODE_STANDBY);
+	if (ret)
+		dev_warn(&client->dev,
+			 "Failed to put into standby (%pe)\n", ERR_PTR(ret));
+
+	return 0;
 }
 
 static const struct i2c_device_id lm3601x_id[] = {


