Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD703793CE;
	Thu, 20 Aug 2026 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244555; cv=none; b=UVBycqYq7Jg3Nk+5HAQzXajydAIufhivT9Tuk60dpGDTAPfsoVDc4PDXyQv0gmXAutFmrHiHFo5WCcGqaCq5CBbXkDqPOMHdS76vihsjMm/nnhQWT+jvON0G06jhrV1bt8epazKCWtNQwh6MnprwiZPpQfAs7GJEnPliogmhN5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244555; c=relaxed/simple;
	bh=j8JnsLNQ4s6fYN1Jnr6pzRLN09ueE6cddoEUW0k42kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmdX+w2fnH3fkXvSHU8DP2f44MC5xyAII4W9B0/j9TpLsJW2hpnLGuuVlPlKGTI1BgYezCuHRlw/qFw6/Q+PJVMGhzY3iun/WMaWXFVYQOKO/sGZ/AbwbOzWUqK4JvV2C7qkZcr18OuVfZ15N+scO7C84qC/cRk5Vxtg0VfrO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWJPJDu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWJPJDu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A597C1F000E9;
	Thu, 20 Aug 2026 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244554;
	bh=ALbneKN5MPeojh1i46sry8zwwtr/x1fzhSUT+jrpmIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWJPJDu0j25Fpz6kXSraIqjpTeBglegEu6QQ7J4gcc2XJ0HNG5RDp0rz/GDsa9Mtm
	 tDQID5TowMZT9SeiTabp8BrLnDePZbMyUD+HXkHl4V0/2/nJWZEkIKecrw/+I0XddW
	 CcD0h9Or48a+W5duwKRgg50XKgdCj95JY4KH/Vhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/235] hwmon: (npcm750-pwm-fan): stop fan timer on device detach
Date: Thu, 20 Aug 2026 16:57:24 +0200
Message-ID: <20260820145222.882020026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit f27f6976ea269219c1259a7c2f8c6dfe782540a3 ]

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
[ changed `timer_shutdown_sync()` to `timer_delete_sync()` since the former is absent in 5.10 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/npcm750-pwm-fan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/hwmon/npcm750-pwm-fan.c
+++ b/drivers/hwmon/npcm750-pwm-fan.c
@@ -360,6 +360,11 @@ static void npcm7xx_fan_polling(struct t
 	add_timer(&data->fan_timer);
 }
 
+static void npcm7xx_fan_cleanup(void *timer)
+{
+	timer_delete_sync(timer);
+}
+
 static inline void npcm7xx_fan_compute(struct npcm7xx_pwm_fan_data *data,
 				       u8 fan, u8 cmp, u8 fan_id, u8 flag_int,
 				       u8 flag_mode, u8 flag_clear)
@@ -1003,6 +1008,12 @@ static int npcm7xx_pwm_fan_probe(struct
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


