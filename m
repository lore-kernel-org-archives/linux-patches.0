Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590303;
	b=rnX4YYYEjMYjwNVrDfLNICUXdUaPu9cpVTAAPojClL2vikVMYv91IY/O+xwOjfx288pu
	 LncznXj2hZMIiG7UaPeEhhmHxRO+obTim/XRbHlvmKPi/bWZ80YFUkxvJRIXYJ8aKCanh
	 aci22sWLPj1Nqg2qZIHnwMUng9I7TRg91sdPB85MBWKkCSWmBYISGN2AA2ZrgIqGGqP+1
	 zzzdPCOSuovLuQiRodK9PqELIzt0ygZCGBb7ehFmkqdGIVhwBdnkaI1xnd7pBGeUqY2/k
	 M9tMF99CNepjvOlHnDEbzN+FTb9IcYrE6+MgyzuOMtgZS+hccrUdpz+r+TVT5V2TnsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5jas0ft+Ua81diBGCjMkgKqsyBRhE3p1ADKJls848w=;
	b=kzJY9esGsjA7KDJoy2DJ376XM7nQaJ/0qMBi7J5SjkCTUMkkAIcINdil9fV+c/juVwZO
	 n9ecQ6LoZIx/i+1AbTaxDTWTbDCLMyONQMDLoOaiq5bORG6oqN5Wwz3uknSoHZraV3X0B
	 q8Lw8Y55lQJwhcbXjPDI8nmOqnHxGDZLDTkiLCCU1VjTUWuksdvfSOS+hxqetQRAk/wkw
	 CMxfuRAAMizlp4/FxpyerE04I/Z2HahO8a188G4MYyNzUaiJX4CzVmwfEoaCtLHEg2+M1
	 m5xZiZ7GkNn6B7L3+c93c1RM0C6zI3mOcbt6GZcfS18awFJ0rR+wbiti/ys600I9OYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K6pVM/a8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0967607C353;
	Fri, 13 Nov 2026 17:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6pVM/a8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0DE1F000C9;
	Fri, 13 Nov 2026 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590303;
	bh=t5jas0ft+Ua81diBGCjMkgKqsyBRhE3p1ADKJls848w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6pVM/a8Tkbk8iabqaN94wbS6vJ1JDUS7YeeaVrzbl729hRvv9k5FXeqsoW6cjHAI
	 CniQmEUCCuHBbL/L5auwgqbJiyKMBKTdifLJ3irG+xKAUSnmv45pmLZw1xfdYwZUcF
	 15So2i51rlwAGKSD89rw2neLg+ly8/OPsXwGDEds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/686] hwmon: (gpio-fan) Update the speed cache before dropping the PM reference
Date: Fri, 13 Nov 2026 10:47:03 -0500
Message-ID: <20261113153830.802465303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit f324179e6ccd05dfdc8e98fba2e9d50aea8e7ea2 ]

set_fan_speed() writes the GPIO control value before dropping the runtime
PM reference when stopping the fan. pm_runtime_put_sync() decrements the
usage count even when suspending the device fails, but the error return
currently leaves speed_index at the previous running speed.

A request for that same running speed then returns success without
changing the GPIOs or taking a runtime PM reference. Retrying the stop
instead drops a reference the driver no longer owns and can trigger a
runtime PM usage count underflow warning.

Update speed_index after writing the GPIOs and before dropping the PM
reference. The initial same-speed check already excludes a stopped fan,
so a zero target is sufficient to identify the transition that needs a
PM put. Preserve the PM error return and the CONFIG_PM=n exception.

This keeps the cached control state and PM reference ownership consistent
without restoring running GPIOs after a possibly partial supply failure.
It does not clear persistent runtime PM errors or claim that a failing
regulator has successfully powered off.

Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261031095039.11683-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 1dfc02df9bbb0..34986266180e2 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -150,7 +150,10 @@ static int set_fan_speed(struct gpio_fan_data *fan_data, int speed_index)
 
 	__set_fan_ctrl(fan_data, fan_data->speed[speed_index].ctrl_val);
 
-	if (fan_data->speed_index > 0 && speed_index == 0) {
+	/* The GPIOs have changed, and a PM put drops the reference on error. */
+	fan_data->speed_index = speed_index;
+
+	if (speed_index == 0) {
 		int ret;
 
 		ret = pm_runtime_put_sync(fan_data->dev);
@@ -158,8 +161,6 @@ static int set_fan_speed(struct gpio_fan_data *fan_data, int speed_index)
 			return ret;
 	}
 
-	fan_data->speed_index = speed_index;
-
 	return 0;
 }
 
-- 
2.53.0



