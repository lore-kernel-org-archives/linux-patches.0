Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0F33CAA41;
	Wed, 30 Sep 2026 19:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795530; cv=none; b=SsrrxqcFsBB52/BicfuPnQ3ckZk3GF/IqZ1ERhNkWttFtBqbSEbi75AoWokwmovMAEeKRbMAFzDs4jE7fFKUQyRnpeCHJiGqU/Ql6+q0mu4dz2itV/Atxzvxh9VM4EAvY6up8rBFajcPupmcNXfjBZBCqNgTtse0UB98EGawZX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795530; c=relaxed/simple;
	bh=cNEKWABNOkFFxEaQ3nHdTu7iQIymznykU5+Nk0UAIOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeLmlh+EicZa5TXGFZSTvfZszJf0jmQMSwFmJhRvsJYSAO003KOoY4QbbGLXgv+7K7iw7ZY+f2v+hG4i+mmpE89bG+mGS/0Sw+WId88w/wD6omwnWgCiSxIojErmJBSFFvYNQdw45ejKt4kChWdEHonS3Roq3AIoSW4BVl6PXgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpNt21JA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpNt21JA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8444B1F000FF;
	Wed, 30 Sep 2026 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795529;
	bh=fkShyOWFmAfBu357jHgfxKvmD8Hmkhw7T0YXziXWet0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpNt21JAfDs6Q16f/fQDZwpg+i9AJeTQsteegyTkO5BwbNIAr9E4IkKQGekY0tIJU
	 fmlOBShKmwf3egrH2UtMgeclZbbozAhxcLm3djbP5p4WvlKvRvb0tgaqifltPf1zal
	 H+OgO67wvX9SHxDfrLAOPZ/MTZxPjM9aUpbM/Jes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0566/1193] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Wed, 30 Sep 2026 17:20:50 +0200
Message-ID: <20260930152446.816916218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b779240328d59..cee3fa146d69a 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -561,8 +561,11 @@ static void gpio_fan_shutdown(struct platform_device *pdev)
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



