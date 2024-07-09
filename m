Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC47158208;
	Tue,  9 Jul 2024 11:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523968; cv=none; b=j2+GbKoqH3niHqeduEjkL+Ger2pOadWOISdxP+GusupQJ7ESTM1Tlu3LN8K5lAUtLWq/9o+D6OTFnWIbh2PXPLDKsvRh9Z0v9EGqfOLfU++iCOzBqJJiO6mmDPx9vlR9kobKOqmMyZYlRFhrKrbAh210CaieV+kxG/ls3aJCs3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523968; c=relaxed/simple;
	bh=2+l5cdjmOpSInkPdmqVbx4USN70HfgoNYpE1cGT9/xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL79PzOmosgFQvnWcttZkWcn2gqWKHhfBUvkLoWdk4CPU+t2em1TlxVmKwF23+7HLYL1Yg4xG+iwoecr5M7YSAfe1QYzxwpRSwedSK5JFpGzuQ0jM5vwz7Evw1bLEDBHQT0aBV+YN8ehYRfvb+YlKDfDoXzJpOdIMqs1Xvp2f6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/QPkfMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/QPkfMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A57FC3277B;
	Tue,  9 Jul 2024 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523968;
	bh=2+l5cdjmOpSInkPdmqVbx4USN70HfgoNYpE1cGT9/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/QPkfMr0Djnmm+VzpdA85UEtqhV161RwrMCAgTbU3VCZ+VOnqWRbMM4HXjo2Yidp
	 FwvwfDzMCqNApEk0jH8tRObUdfF8hKpgN61WBDoTMglXNaHmJ9RXPLkihusxIpz5v4
	 zqneTDBJCR04s7/aVPKx+U1p4uGk7vK0e/7eq0EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 004/197] leds: an30259a: Use devm_mutex_init() for mutex initialization
Date: Tue,  9 Jul 2024 13:07:38 +0200
Message-ID: <20240709110709.078899647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit c382e2e3eccb6b7ca8c7aff5092c1668428e7de6 ]

In this driver LEDs are registered using devm_led_classdev_register()
so they are automatically unregistered after module's remove() is done.
led_classdev_unregister() calls module's led_set_brightness() to turn off
the LEDs and that callback uses mutex which was destroyed already
in module's remove() so use devm API instead.

Signed-off-by: George Stark <gnstark@salutedevices.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20240411161032.609544-9-gnstark@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-an30259a.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-an30259a.c b/drivers/leds/leds-an30259a.c
index 0216afed3b6e7..decfca447d8a7 100644
--- a/drivers/leds/leds-an30259a.c
+++ b/drivers/leds/leds-an30259a.c
@@ -283,7 +283,10 @@ static int an30259a_probe(struct i2c_client *client)
 	if (err < 0)
 		return err;
 
-	mutex_init(&chip->mutex);
+	err = devm_mutex_init(&client->dev, &chip->mutex);
+	if (err)
+		return err;
+
 	chip->client = client;
 	i2c_set_clientdata(client, chip);
 
@@ -317,17 +320,9 @@ static int an30259a_probe(struct i2c_client *client)
 	return 0;
 
 exit:
-	mutex_destroy(&chip->mutex);
 	return err;
 }
 
-static void an30259a_remove(struct i2c_client *client)
-{
-	struct an30259a *chip = i2c_get_clientdata(client);
-
-	mutex_destroy(&chip->mutex);
-}
-
 static const struct of_device_id an30259a_match_table[] = {
 	{ .compatible = "panasonic,an30259a", },
 	{ /* sentinel */ },
@@ -347,7 +342,6 @@ static struct i2c_driver an30259a_driver = {
 		.of_match_table = an30259a_match_table,
 	},
 	.probe = an30259a_probe,
-	.remove = an30259a_remove,
 	.id_table = an30259a_id,
 };
 
-- 
2.43.0



