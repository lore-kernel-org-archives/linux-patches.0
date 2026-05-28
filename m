Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EFD2E7379;
	Thu, 28 May 2026 20:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999718; cv=none; b=sgEww3cn9dpqZSSy8eJY2UzT1VykUGnE/0i+FkVyEiT1IkLxuR05TwXUDNQU2YLNEYkxWVBEbQ68zc1QRUAugBKY9jHSh6Z9HOHNUrc5uPLvuCc06GMoFEEUdjWTQ9zIUao0s2HG19h2+GAjKMWSbgZkBZyQGuhnH3/mgKS7GIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999718; c=relaxed/simple;
	bh=LwBrA+MwHJQzCuHTmJaWjUj1DxB8MM/TMygLBC/xka4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQOivqXc0Sw/c596juV/aFxfSD5UOwz3obpkhFfDuMLU5X//aLNFgqE6lLtDJCwYkP+hbdpMT2LREx+K46lzyFOyXhSpd35kPwrBP1ltDwbedCB7hAf/MM6jmukuqZticFAZUIXBE+PB7xxPfw50wlLHsfCnjCbwS3wA7JLHA7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsRD0ga5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsRD0ga5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B3B1F000E9;
	Thu, 28 May 2026 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999716;
	bh=8uaORNDnH7U/p9QzYNWoiAoBIWFt8r0AVUDtcJyW2ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsRD0ga54rPKQPjpwiFi6HWjdVB0bmIBZoeK7/1QBlJsPdI+V4/iWRTEgczqXsmRI
	 pTZEpUGuqAr/VcKEYTH2wXpc334mfC4SG36FgOfkTB0rT0/cxMucJQ7hjK+6u3JafD
	 26TIBCqKptmzC2jTjZ83hMJJgBfnSDDMlF7g51ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 167/377] hwmon: (pmbus/adm1266) register the gpio_chip after pmbus_do_probe()
Date: Thu, 28 May 2026 21:46:45 +0200
Message-ID: <20260528194643.264835716@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -466,10 +466,6 @@ static int adm1266_probe(struct i2c_clie
 	crc8_populate_msb(pmbus_crc_table, 0x7);
 	mutex_init(&data->buf_mutex);
 
-	ret = adm1266_config_gpio(data);
-	if (ret < 0)
-		return ret;
-
 	ret = adm1266_set_rtc(data);
 	if (ret < 0)
 		return ret;
@@ -482,6 +478,10 @@ static int adm1266_probe(struct i2c_clie
 	if (ret)
 		return ret;
 
+	ret = adm1266_config_gpio(data);
+	if (ret < 0)
+		return ret;
+
 	adm1266_init_debugfs(data);
 
 	return 0;


