Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95E91AA1D2;
	Thu, 28 May 2026 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998430; cv=none; b=WpEREffDUyFSsFcQLigUxeFmlArt3EpBzm8SHwjDxj1AsOxZ4wO7NkRb9pXOL84L2N1hLxo7+m+IlWaiEagasHdc5b5twcJZ8cSAqphOeyZkAwNmk9h90OWUg/sd3h1PzAhTsRyRh8U9U1WvR/FNy/e6z9NH/1y80EEBFhyoU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998430; c=relaxed/simple;
	bh=FtysiS7Au7eJ+/i8aHWsmvM4pFmuQd6jGwKxNktQX8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA0FMGgZf9FADthH51jJAumamZgTf2537TIZhzLDuYsA+mBkWqdnJ2w5F6habQtYeBii4Ff30Nw7mjKBuMWNoz0Z9ema+13oPXc/mwMrp7uyjeQyZCQPaONsHBJO6PKseB1i2zVwbP5sUC0N6LRBx0SDtUgTwUtwsZWQw4sbItg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzJzBRyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzJzBRyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E0A1F000E9;
	Thu, 28 May 2026 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998428;
	bh=00ivADU3jPdnb81bhAjaTQ/G+D164dMIi5LHpcJJfMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzJzBRytZdNhGICo1Mu8+4IwViwsOWcFvm41UZsouErfW8aCiyrvFwDsuCyKYFxhI
	 8lDMva/rd7Bhd+U/M16oup3jMj319L8rCvmnWDjzqqJKczTpEk4HK1enNQs/TJsZ78
	 kFLawWniAaTdzhvAPSjEU+mrn4htxMXAvTGjUrC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 171/461] hwmon: (pmbus/adm1266) register the gpio_chip after pmbus_do_probe()
Date: Thu, 28 May 2026 21:45:00 +0200
Message-ID: <20260528194652.014194888@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


