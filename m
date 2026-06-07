Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBDB12CDA5;
	Sun,  7 Jun 2026 10:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829951; cv=none; b=FFkrj8UBbALROmLSOsMDqkecnzmjXDOj78pukio/koe3AfZmWlqywqWgpdBoW95EHKOSpeWf6dA8l1utjcs4uqQ5pZ9HCba3Hn2LstbvwjnGIgpNk+iEjj7pipMAad5RgyEu3dNpdIiFVy9RJk7DjQwkNiKuqaBxGaUiV+Iljes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829951; c=relaxed/simple;
	bh=C+nPRrz0UPg0Q/6i++jw/LHlFznYYHcPpavCLG5exv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vx73YoDlkb5dZz3tTaQsjoDRfgyJBcpuLvmgNdYLtZCEsC06/jGqTFGbsg0oTAwwy0UF5CLDbrajBnmgvdeDusO2J6v6GiVhqx7/xvx4Ppdz1dtC9JQ+HXLejK7UPkIkwTqc9eho9G/CBAkY6shtWTSrRCLfd7f5EqzV93ECm9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EA8a0LpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EA8a0LpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F771F00893;
	Sun,  7 Jun 2026 10:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829950;
	bh=UNSlBAm/Tva0OOCKit8/kDD8nQfAMgN+gYElOtPJTY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EA8a0LpHY7N9k3ZZ92yksz6Q3jz1GzRnnUhTSepZ0o56QecY2TO4cvO0DUnCcl7Ot
	 sNYBfbBSVVIkRSuyf2R+GN1Q0Voe4pKe93s1Qgz1WF0+zNk48HV6SQSFBNNuRmMsUI
	 auCfdrYFzxshBORCo2UcwlSndxRQMDD7qnUiM8Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 329/332] hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock
Date: Sun,  7 Jun 2026 12:01:38 +0200
Message-ID: <20260607095740.216151252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

[ Upstream commit bab8c6fb5af8df7e753d196c1262cb78e92ca872 ]

adm1266_gpio_get(), adm1266_gpio_get_multiple(), and
adm1266_gpio_dbg_show() all issue PMBus reads against the device but
none of them take pmbus_lock.  The pmbus_core framework holds
pmbus_lock around its own multi-transaction sequences (notably the
"set PAGE, then read paged register" pattern used by hwmon
attributes), so an unlocked GPIO accessor can land between a PAGE
write and the subsequent paged read in another thread and corrupt
either side's view of the device state machine.

Take pmbus_lock at the top of each of the three accessors via the
scope-based guard().  The lock is uncontended in the common case and
adds only a single mutex round-trip per call.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-6-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -173,6 +173,8 @@ static int adm1266_gpio_get(struct gpio_
 	else
 		pmbus_cmd = ADM1266_PDIO_STATUS;
 
+	guard(pmbus_lock)(data->client);
+
 	ret = i2c_smbus_read_block_data(data->client, pmbus_cmd, read_buf);
 	if (ret < 0)
 		return ret;
@@ -195,6 +197,8 @@ static int adm1266_gpio_get_multiple(str
 	unsigned int gpio_nr;
 	int ret;
 
+	guard(pmbus_lock)(data->client);
+
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_GPIO_STATUS, read_buf);
 	if (ret < 0)
 		return ret;
@@ -236,6 +240,8 @@ static void adm1266_gpio_dbg_show(struct
 	int ret;
 	int i;
 
+	guard(pmbus_lock)(data->client);
+
 	for (i = 0; i < ADM1266_GPIO_NR; i++) {
 		write_cmd = adm1266_gpio_mapping[i][1];
 		ret = adm1266_pmbus_block_xfer(data, ADM1266_GPIO_CONFIG, 1, &write_cmd, read_buf);


