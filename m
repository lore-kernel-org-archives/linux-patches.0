Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C8D4F3ED7;
	Wed, 30 Sep 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785336; cv=none; b=bHzstU4xPf5aG5ErmXeyxnfWsQyEfqflO6hwiihUqt+T0n7Cl5Ih4v39y4mZR0MXuMyRWD95jq5mDkIQIIL6/gL+IFmEQKYV3chTPuB3dYwRPeTBC4Vq8CaIZr7ox286FkibJROKDMBOspjLBJrdw6QYbyi1/vpOEemwur1i4q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785336; c=relaxed/simple;
	bh=iNHCEflesLZmL7ANaVFHPvfnFwRzNOfqStQRe7H+XRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZRm2poXlRAu0RE4pMa8g0J5vKmFqSyGKq4DuT5PV/ZTy1thVlnTiiBuGe/thtDTzgTIHgsHcPZfHG/aJljnf5Wg6IhRoKYYXzEZQEYSF6Mc/TFl8QgMkKUgleu45B6v/fKGP5SYhi1qRjYbopxZ0hmjtg/38QTGNBymG0Z1YrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/XTb5kO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/XTb5kO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE691F000FF;
	Wed, 30 Sep 2026 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785327;
	bh=Dd5lYj8Ayi1i/9HiCdfWm/XgH4sEfk0xJ0a1fvlOt5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/XTb5kOqS5KBQT7OvquMEv5PC4ZZf2QLuvhd/u8XsXaLU7ar8Ji4aHU7gm371iYE
	 GmsT40LXiO4EAUI2DYpnbxNNK3PkO/BETKV1UKryehND6/DAukQl5Fk/ZXVyU7ET/v
	 KMXEQQwIywUiISWGo+UoQXZcsam8gm8Cvhmc4HM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/982] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Wed, 30 Sep 2026 17:20:06 +0200
Message-ID: <20260930152426.879969903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit bb2424c3502cc72292eedade46960c331d5f28fb ]

set_fan_speed() writes the control GPIOs one bit at a time. Every
other caller locks around it; gpio_fan_shutdown() doesn't. If it races
a locked caller, the GPIO writes can interleave and leave the fan at a
speed neither caller asked for.

Fixes: b95579cd8795 ("hwmon: (gpio-fan) Add a shutdown handler to poweroff the fans")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260830152150.27F5F1F000E9@smtp.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260901155404.1532092-1-congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index f1926b9171e0c..9abd6f7d45194 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -560,8 +560,11 @@ static void gpio_fan_shutdown(struct platform_device *pdev)
 {
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
-	if (fan_data->gpios)
+	if (fan_data->gpios) {
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, 0);
+		mutex_unlock(&fan_data->lock);
+	}
 }
 
 static int gpio_fan_suspend(struct device *dev)
-- 
2.53.0



