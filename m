Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C3243F4C8;
	Fri,  7 Aug 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117447; cv=none; b=MK/dBtEGpW4oTmGpfAcUSXySYRhCHM/v+/UnlnpPgIgVbhpgrkNcorDhfGyq+0bir31G7ADUlntf6vg8e3i83gJVBBA1tnmJ5i7oIggLZgnjSsAvcGJ49OXb85PAGSU+GvloLY7N1JXTXyuabheiYoiuMyccRUl7/jydBrtnQW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117447; c=relaxed/simple;
	bh=Ed4dsgjXGZItZ1XxaLWaVijCrehz/Fi6VBLS+NKHWj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heaMJ910bty+u70XEOHA9UKV2QDA+7lmj+RpQukAgk0AqdM9X5PWbeBgIWg6esj3UI71gVMzKavvqEUsKr/ewVCF9AWdXmOuWBGvT8jGiS8/E7MDzVh8L43pm1VZWwIXLj20wxlvl/PGXYMgcsJ50lhQ3CyZeKCoRk8FgKQqjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUSG+nxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUSG+nxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2F01F000E9;
	Fri,  7 Aug 2026 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117446;
	bh=anMe4kOO78yFrkDZM8YVlSSK+khGEwFQaELrwE6SBO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUSG+nxgM41AKB1wbhqZQof2DMyv6jgGjSr0QYwDhfl4xBs23Yn6rwFv28OgWSpsj
	 kjuW2UciIm11guPjcvO7BO7xK3ARp7nCehhOuk794IYP7WH0psIubxE6VSwpx81crH
	 IJhWW7aK3Z2Ru3XVu6mxXjcRSASxn5x1yjxuMutI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 323/438] hwmon: (npcm750-pwm-fan): stop fan timer on device detach
Date: Fri,  7 Aug 2026 16:38:39 +0200
Message-ID: <20260807143434.860766958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

commit f27f6976ea269219c1259a7c2f8c6dfe782540a3 upstream.

When a fan tach channel is present, npcm7xx_pwm_fan_probe() starts
fan_timer. The timer callback polls tach state and rearms the timer, but
the driver has no remove callback or devm cleanup action to stop it. On
device detach, the devm-managed driver data and I/O mappings can be
released while the timer is still pending or running.

Register a devm cleanup action before starting the timer and shut the
timer down synchronously from that action.

This issue was found by a static analysis tool.

Fixes: f1fd4a4db777 ("hwmon: Add NPCM7xx PWM and Fan driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/20260729100116.790-1-getshell@seu.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/npcm750-pwm-fan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/hwmon/npcm750-pwm-fan.c
+++ b/drivers/hwmon/npcm750-pwm-fan.c
@@ -358,6 +358,11 @@ static void npcm7xx_fan_polling(struct t
 	add_timer(&data->fan_timer);
 }
 
+static void npcm7xx_fan_cleanup(void *timer)
+{
+	timer_shutdown_sync(timer);
+}
+
 static inline void npcm7xx_fan_compute(struct npcm7xx_pwm_fan_data *data,
 				       u8 fan, u8 cmp, u8 fan_id, u8 flag_int,
 				       u8 flag_mode, u8 flag_clear)
@@ -1018,6 +1023,12 @@ static int npcm7xx_pwm_fan_probe(struct
 				msecs_to_jiffies(NPCM7XX_FAN_POLL_TIMER_200MS);
 			timer_setup(&data->fan_timer,
 				    npcm7xx_fan_polling, 0);
+			ret = devm_add_action_or_reset(dev,
+						       npcm7xx_fan_cleanup,
+						       &data->fan_timer);
+			if (ret)
+				return ret;
+
 			add_timer(&data->fan_timer);
 			break;
 		}


