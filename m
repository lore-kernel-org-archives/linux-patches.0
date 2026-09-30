Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6D25228D;
	Wed, 30 Sep 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783080; cv=none; b=P9QJNE1tJUKdbzZ/ZVbfG/fCPwB+ImcSQupwyCWLN0hkfGgednqqrvA3dTaGoze4NspkY/0sC5U3BTBrvOSy+NTz+FcS3b/ZflwkjT7cDcsaZlCxySP36lyFvgrGmyuIyysTaXqNgntXGEedXu5maXdTstile7CB+WFvZTh+Oeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783080; c=relaxed/simple;
	bh=u4VhVZT0vTByt+VOeGklhuY6R8CqPaTmWNwFj2mpsvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNSPTJDJrmfbhGt7vvPJkCGUO2G4g9IO1a2LCTYBHBxvkBaFiuj2DSThmfdX9HwBWxsAEuH6BD8KeeYFp5qJE3W6U/0755sqjE1q/jbn64ykw62eVhMVHBx7N+LD2n2IC0hUG5IoBs/X4K/smBIkGJkvADw6bdLjwIjeabPjpMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyeueT/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyeueT/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BFB1F00893;
	Wed, 30 Sep 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783074;
	bh=9dXBj7nskfHKkZFPYwDA0sJ3TxbEifCn+H7/b1ptvQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyeueT/qzbHoj0qIVJ92i+t6AXbERpUXNvqqZgelHatUaFbst2FgaaLA5CPQqFm4t
	 oK4Yf79rEojiaq2lrl4S2G5GXeuzmv8MhfN7co3nHyx5Rqv2lSIkm3fYOXF6nMPA4V
	 VQVJitoPDIpfeL+9bvR+UG8HFubz4/lieQt4gkqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/595] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Wed, 30 Sep 2026 17:22:45 +0200
Message-ID: <20260930152353.559662404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e0b3917dfe6f9..cfcd254a5ed18 100644
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



