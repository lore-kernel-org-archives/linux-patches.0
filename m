Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402342C237E;
	Mon, 17 Aug 2026 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977447; cv=none; b=C7PyqPFlfpOvARVZsb4/dSWqLqAphYhjNr63U8LxV8cfHXFYcqTrAlLiqNZKVG7Z26rAwz+sfQkz1kOrLa3VQDodkfhWpr2CNxJMtt25m2wQ5usHg9OIXbLWoLbWbzexp9vIUrkHHAqimKgDxmwRfWPHs1h2NCXJU04lmtwTtZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977447; c=relaxed/simple;
	bh=TWmQRnHvrNcdxrI/WWGU+fPQIm7XkC32UgCj7nxgb+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxZ0/dIYB7eLgqRtDxLB4LNTWvuexompLR3Lejd53OLA/rnutEFfxQOvZ35TtrzVO64v30+B4e7ICaf8bGRr8BqxqFLP1DB1BAAyHOV7iy7KU58PfJ/8mziNdeEuKc19eUUydR1u+JLkrhzgA1KeOmxe2gPwI5HNKyI88H8K9yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rixr55MC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rixr55MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964C21F000E9;
	Mon, 17 Aug 2026 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977446;
	bh=AxOrf6uBNvpRP5Av11yxWwogmxcT3dWxcc27f2yBolk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rixr55MCg18ulsJJ+aP5rxL2+FKfls57xdcGRexCg+nquyWY2fhFBJ0WVCBLp5YrY
	 ryaTd/x1bb8SxDGzpuTUt6ueAiRds9ODf9+nvhXC4RdUt2EI9cb6Vz+MqmtCouOR7E
	 sRODomBCIPTSf4N2fQuDkKSGjhdUS7aB3bnXPieY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 332/456] hwmon: (npcm750-pwm-fan): stop fan timer on device detach
Date: Mon, 17 Aug 2026 15:32:02 +0200
Message-ID: <20260817132552.617091034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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


