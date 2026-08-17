Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B193B774B;
	Mon, 17 Aug 2026 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980029; cv=none; b=mdQp4xar7b5u5oGsMwXBD0z/svjoDQl7G6dU1H6XxehOrzHi8/+DzrAcdj0lVFGpPAl9VAruiosunGtkz36bTA4hw7CGxV8t7dvYb6h/oJmzhBDBtGxfQul5TAPsC9fk/goQK3Enjo9vGWthXWxXa/8COoeLsGBgfV0H0BAFt8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980029; c=relaxed/simple;
	bh=iFtJcpTYjGiuR8461GqwUfU2xPQemC1/xS+CIK0+vVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lb3KvFpCiHDP+yqeSl+1aJYCzDnuIAkeSLJ0RL4jUgqVv+A/bE0bz+eW+0DTX4aePSsmSvBKJ0ESN6e10KlZILXhC1zpiAohujnJ6K3GHumbpwo3AxobUt3Zh5tbUFUKLYZQ/fY8Ltkd4vOGRti9XpGZpP3iAY6/CENEsdgX5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NViCeel5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NViCeel5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B241F000E9;
	Mon, 17 Aug 2026 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980028;
	bh=TQhxh1rN8Gw0ZkxhJKA8CMa95P1zuJ6z0lS7Qe7+6hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NViCeel52REc8AV47gufZPopWSLRVJ00qGbcD8okgIYKuwFU0kRqQVJATw4umaNCd
	 MYFGyegDZ1hr+wVDhBkSE31t/y7Acb39QeM3uPYBlKlWMNjH2NregFpBTW90rdFG8r
	 r0uDK6cDKc1f0M+aJh3GcaEjnk8gSCpB8jPiBIiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 430/609] hwmon: (npcm750-pwm-fan): stop fan timer on device detach
Date: Mon, 17 Aug 2026 15:32:06 +0200
Message-ID: <20260817132558.477209150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -360,6 +360,11 @@ static void npcm7xx_fan_polling(struct t
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


