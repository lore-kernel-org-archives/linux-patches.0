Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFBD25B0B0;
	Sat, 30 May 2026 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167111; cv=none; b=YWRH5QebDL4g86wJ9+Z4QBKRo1uXmypNt2AZHSZj8kXaPOjiK3QMCjGZRw5Ix6T5d2d5l1ENvesNaQ/TQS6xI/AOK2OVpLA+J2yQyuT/UEg/PRJAKdKeVV28NT2gtNfjx9gWdD6SeTAGAPsdIJo7p5aqZBWqHTmrsVv8VJnVubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167111; c=relaxed/simple;
	bh=YEvQslNq18FOlm8PJQWtTlch4Wdwko8dVzzQK4wfHfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcgF/bEQycQE623GkkwsyueLtD1S/ahAo7PMs3e15vlEOIiOBDxwKLGyEvMmA16W4LqktuDzbw9uYe6CGOqVAk7TSHQe7JXOG0bobpBLjRYA9KkOqYk0uEeEEay+qGbx9Z0q4yS9mpSqWvHXZG5UXC8dSVT/kEQUfriGNyhC4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCd1B6cP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCd1B6cP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFB1F00893;
	Sat, 30 May 2026 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167109;
	bh=ac0bBpf0JNzlEY43V+f6kErb5ErFkwrb9fOtttBotTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCd1B6cP6g/lvW7KRwN4jzLzGfkqj3qpeqslqF917qDKuDs8/uH/oJs9uN16CKTc2
	 1azK8/WK0n+8iDdolTX+UlIfViv2kHyT4Iz8+X7t9ZQqaWiyQgUKCZk60elagf1qa1
	 SsjBKqLSaZNz338PQaj6yoiVtgjoNK9Km7QwV/Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 566/589] hwmon: (pmbus/adm1266) register the gpio_chip after pmbus_do_probe()
Date: Sat, 30 May 2026 18:07:27 +0200
Message-ID: <20260530160239.508837965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 491403b9b76cf66abd81301c5901aa4a4549f1e8 upstream.

adm1266_probe() calls adm1266_config_gpio() -- which goes on to
devm_gpiochip_add_data() and exposes the gpio_chip callbacks to
gpiolib -- before pmbus_do_probe() has initialised the per-client
PMBus state (notably the pmbus_lock mutex the core hands out via
pmbus_get_data()).

That ordering is already a latent hazard: any GPIO access that lands
between adm1266_config_gpio() and the end of pmbus_do_probe() (for
example a sysfs read from a user space agent that opens the gpiochip
the instant gpiolib advertises it) races pmbus_do_probe()'s own
device accesses with no serialisation.

Move adm1266_config_gpio() down past pmbus_do_probe() so the chip
isn't reachable from userspace until the PMBus state it depends on
is fully initialised.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-4-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -468,10 +468,6 @@ static int adm1266_probe(struct i2c_clie
 	crc8_populate_msb(pmbus_crc_table, 0x7);
 	mutex_init(&data->buf_mutex);
 
-	ret = adm1266_config_gpio(data);
-	if (ret < 0)
-		return ret;
-
 	ret = adm1266_set_rtc(data);
 	if (ret < 0)
 		return ret;
@@ -484,6 +480,10 @@ static int adm1266_probe(struct i2c_clie
 	if (ret)
 		return ret;
 
+	ret = adm1266_config_gpio(data);
+	if (ret < 0)
+		return ret;
+
 	adm1266_init_debugfs(data);
 
 	return 0;


