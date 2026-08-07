Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C472D314B6D;
	Fri,  7 Aug 2026 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116201; cv=none; b=HyoJJggqrZFEeysMm37AYXUcNBHh0xB7dhOx/0J08T/DMPwrxf4vn+NKc9vtOTl1K06ZKPGaTlqOkZE+blSxP0Ga43+9maNCi77oYcb1LmMqG36LC3hrgLOliXDl05ctVsNIBpAG1IDQfapnTOchBkpOMeHbgbMc0/bzTFMF9mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116201; c=relaxed/simple;
	bh=S4TAseVR49Vlx6rMdKr++7nyeg2AnXcftm4DoQKL8sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu+2jhhwtipC/4IAEI4+LTe6Qr5Wwwp5L9IbDogdEVrTe5ylddDpXKiPtVQBxZozenqi6HLi8O53HYgWzqJbYZXI0alPzxNAm0A2zLPTgrEbCJNAS/pkANccI5ANn0xwluXG8WEDxLYgsahIA3ePwBNZqW0ZSgZid0EzwYX7SfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVJhTj7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVJhTj7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BB91F000E9;
	Fri,  7 Aug 2026 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116200;
	bh=DgMJjNhCNFVPydzTOQJHuXMYxQ3WL1CN093KL5TnKeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVJhTj7QYmXWZYvaZ0/+IqOk+uP/M/7YS9kIiIEPdUKU5jzjd80ea8Eemeqn7xe9E
	 xUoyRs9N2zm7wAMSdKViXnyP8QGiebRfQn+IfgqVyrPsaTPkPHE3NwbG7Y+LFJZxQX
	 PGC06NBOkskAz/G3B2YdUiFtS0HEqLr0iePDOKrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 147/261] hwmon: (npcm750-pwm-fan): stop fan timer on device detach
Date: Fri,  7 Aug 2026 16:38:24 +0200
Message-ID: <20260807143418.535993895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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


