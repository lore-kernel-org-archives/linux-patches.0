Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BA74ED1B9;
	Thu, 17 Sep 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666151; cv=none; b=ouztz61sjP2GQlKTBQjHw2VF8V6Ncpgk/71A0HGBB7t6+VTnv95xU1cDbyUctVWN/VxZumLTdBLT2RpAmmuHq5O8pkhEOum7DtskfoqI40rZLyCSUCBa0Gk3auosfyW0PySHSlCvINeM1RWTJOm5O9TLT2DLyxcXa3xDFjlTpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666151; c=relaxed/simple;
	bh=pMS4L/jhdSSjihfZnwLbUFlN/tkdAM8g7qr67j6XhCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuqKjECPs+cxIvvNxNU/MRPM3mXuoyRWioK0zCby+F9dTdTiCoDtXJdhblzts2/enxEUgyWxchUFB7W66jeGeF9kh1n/Lug7H5hoUbpDn5YTKcSBs+9PHev8labeYFkegjs+hodqWBLCO9X+9V1amd7nQVvMuQtTEJ1P9LoW8+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POjDL6lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POjDL6lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBD1F000FF;
	Thu, 17 Sep 2026 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666149;
	bh=gsFTTmtEx6A4zEqZIcLcXABV6KLF5K6MKADU9d9URRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POjDL6lwAq2uSkO3avh69+TblvLE9lYbdvjUB+7t6sI7rKUw39I6S21UkUaU5BzSH
	 loQ10+N40qJ1OQZBe/jp+0eYxNpxMCPMA6OPQUxCXzM2UltxDMSa8tKvCRq/1BvtcW
	 SEDOJBPjvA+buOxauS6jGNj4nLHqFjpmeIEWpvyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0902/1250] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Thu, 17 Sep 2026 16:11:37 +0100
Message-ID: <20260917151616.439859212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a8892ced1e549..0da51041959c5 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -604,8 +604,11 @@ static void gpio_fan_shutdown(struct platform_device *pdev)
 {
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
-	if (fan_data->gpios)
+	if (fan_data->gpios) {
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, 0);
+		mutex_unlock(&fan_data->lock);
+	}
 }
 
 static int gpio_fan_runtime_suspend(struct device *dev)
-- 
2.53.0



