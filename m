Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4731D366;
	Wed, 30 Sep 2026 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791560; cv=none; b=dmrJ5qonuUZnLH74fZ9VfVaqVrqOVj7TVWq5f0fbmxAyjvatCvyeVlBMtS2OGWwaVsu8FZYJrxq/E6YYkyvwTSmr9ZaBrD5EVZIYS3XtR6ckJnSxp/TtOQkG2zbCZQh74PJ7QlZ+FA9+Cj4cj9nEZw1LzTMohqkxAhrSRM+Zz0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791560; c=relaxed/simple;
	bh=zB4cyJrYAGjmuDRReMHT8Tb3YjQEi6tx5OwN+/L++Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/CpasIH6qXxSzzSpzpP1u3dPbfcTMWovDKqUlfh/3ku9JAQLrSsFPYWGiz9DZ4lkRPWtNKRVAmf8Fe78TAx78MyR4oH7c0qCI18PUvD20wsP4mZWAmqKnHdnKnsdZMdgtWfeKkbIUUOk8l1O0svnfFdwUZTEh3GM8o5ct/Hh/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8ZkmPuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8ZkmPuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002531F00898;
	Wed, 30 Sep 2026 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791559;
	bh=5l0eUlld8HbK1avQBVQ5+FtViZA8YSzs6JJFz/tnWYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8ZkmPuUl5XzwI3w2GKtKwOTlswxYhaEL+RyfDynY0TalmfkroWrHLAyqtrKGEJ5s
	 4J9GGXGRm7jwbiQEyTbr9SKjwQfKjzSHvxEeZvChnT6Lo0FBHuUeeFNn93PF/638Xq
	 5N9FnMpujMQkG0pFwUoVZ1LhEUh0nmNN47rztvIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/752] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Wed, 30 Sep 2026 17:23:35 +0200
Message-ID: <20260930152405.757145085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d518c10723a0..2039e2b9d3c44 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -562,8 +562,11 @@ static void gpio_fan_shutdown(struct platform_device *pdev)
 {
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
-	if (fan_data->gpios)
+	if (fan_data->gpios) {
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, 0);
+		mutex_unlock(&fan_data->lock);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



