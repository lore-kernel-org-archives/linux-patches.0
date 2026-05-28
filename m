Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB15313550;
	Thu, 28 May 2026 20:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000704; cv=none; b=slqwfJOjAcszMMgcINsFf7N7pzL1blfLTu4lMHe0jL8aakMUg9TICAwiyXvwYeX05bsgRQmyCVzwfA8n28inj672iHMv1R0PE792IabMrqfq8Qze4uAeZ8Xiar3klF0TbnUz97yrIKlVAP1zuczdGCKNtf/8gXn5Mv9JlNCXD3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000704; c=relaxed/simple;
	bh=RyLWzJp6ziu3UON/aX5JIXoCpUYBJTSAmLng0mbNAPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWDPnW+LA04S2ZTlVIfboKwAKF4LmLMUdJQLWyk8lf7AHX2Q55dJKERSjjuwkk6gmzcvEiNHDWvWpW6xfb521EsuI79NHUGbYv8DsbQqt443crPv2ZEtU2ZcOOFV/I8vMvkvu/cZMSRIA1QLPKzFa5ILTrQgMGGxkNE+Y8ce1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwT6RvUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwT6RvUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC02F1F000E9;
	Thu, 28 May 2026 20:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000703;
	bh=F2latnMWjBtp8g+MYNwmE2mOyvsDbcKCBIy7sVLcc14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwT6RvUoOHOwNmvFQJ0I7Y/vYpen3nqCZXgoZg9Hc/aBCQEWs3UCAcbYsspIWv9jd
	 VIXfBAmUhcd/aeYzHZsA6zUNMD50rE2fyTUZYuqJixHalr92idlKkaQJZmsyolCaBY
	 OJvtd1CxRpWgmBLbvODy8Yah0QsJEtMOtvQvwXP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 140/272] hwmon: (pmbus/adm1266) register the nvmem device after pmbus_do_probe()
Date: Thu, 28 May 2026 21:48:34 +0200
Message-ID: <20260528194633.292673174@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 6af713af91d5c34ec049eb3cc2c5b3f5eba953b8 upstream.

adm1266_probe() calls adm1266_config_nvmem() -- which goes on to
devm_nvmem_register() and exposes adm1266_nvmem_read() to userspace --
before pmbus_do_probe() has initialised the per-client PMBus state.

Same latent hazard as the gpio_chip one fixed in the previous patch:
once the nvmem device is registered, gpiolib's nvmem char-dev / sysfs
interface is reachable, and any concurrent read triggers
adm1266_nvmem_read() -> adm1266_nvmem_read_blackbox(), which issues
PMBus traffic that races pmbus_do_probe()'s own device accesses with
no serialisation.

Move adm1266_config_nvmem() down past pmbus_do_probe() so the nvmem
device isn't reachable from userspace until the PMBus state the
nvmem accessors depend on is fully initialised.

Fixes: 15609d189302 ("hwmon: (pmbus/adm1266) read blackbox")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-5-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -470,14 +470,14 @@ static int adm1266_probe(struct i2c_clie
 	if (ret < 0)
 		return ret;
 
-	ret = adm1266_config_nvmem(data);
-	if (ret < 0)
-		return ret;
-
 	ret = pmbus_do_probe(client, &data->info);
 	if (ret)
 		return ret;
 
+	ret = adm1266_config_nvmem(data);
+	if (ret < 0)
+		return ret;
+
 	ret = adm1266_config_gpio(data);
 	if (ret < 0)
 		return ret;


