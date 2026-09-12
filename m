Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE124CEEA;
	Sat, 12 Sep 2026 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202969; cv=none; b=jzO1ZwceqEDtuFmqj9lCd+14Rvzyo1x2vPNfOjAG0ikjhaR+x3yfVVDPAX9xRCfi+p8k0gvcYXLsi5xER3uVXT3OVIyfqiczHlmC9sL8YgHzgjLX2Et4KVHQ2O1uniI2RHIm6pdsN81nG5svl0XdGyo+9bEgcJ2nSAbtJ5z6D50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202969; c=relaxed/simple;
	bh=+cGM3IN17I6yqjN9Cd2vnfhs0SUc7+jWTBwAXW9RLXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fd5O0pyv4eKpS3zv6KTOSot3xtxwSBeK50nhzsXmanS0T3oK3G8GuCaoouRiefAK9d89HnlnXyAn+eLYesJvb6xNrmAjTYgRfVKVKfx8TM8PqwgxMXJpg6FcfDQUXb4hWvWDoMRAtQrF7KizEBk3onAoeEMHjQVirQeicGsdjRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9cG2j9d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9cG2j9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43841F00893;
	Sat, 12 Sep 2026 08:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202968;
	bh=jVM7uerdR/IeheS7mTeLSYqrGeOkGO1i9SRn1K/kF8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9cG2j9dH2mGdFylzeyFRPm2fSmijEONZYZsNohdFTjAhBOqC3nc3ZHpWIwfTrKx+
	 XKxfrymFiYJwYDMKcTZ6elcNRa9qKgCVVUz4k44x/YXUZHjCnS/XA32PFuyeI/nTl1
	 A7WisFfDLiYpjPRwg3Mgw4zaZLbkNldkGgWhuhgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1311/1815] hwmon: (cros_ec) Register the thermal devices after the hwmon ones
Date: Sat, 12 Sep 2026 08:51:01 +0200
Message-ID: <20260912065719.794845421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9f1012119f2a4cb5a7f589dc77d5e15dbab49d00 ]

To guarantee consistency for the read-modify-write access in
cros_ec_hwmon_cooling_set_cur_state(), locking is necessary.
The locking will use standard hwmon device locks, which requires
the hwmon device to be ready before the fan devices are set up.

Reorder the initialization so this works.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20260711-cros_ec-hwmon-locking-v1-1-cb6d0fdbb2d3@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 26db27364088 ("hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cros_ec_hwmon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/cros_ec_hwmon.c b/drivers/hwmon/cros_ec_hwmon.c
index 03bfcc40bb7c3..60341b5cef248 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -570,13 +570,17 @@ static int cros_ec_hwmon_probe(struct platform_device *pdev)
 	priv->fan_control_supported = cros_ec_hwmon_probe_fan_control_supported(priv->cros_ec);
 	priv->temp_threshold_supported = is_cros_ec_cmd_available(priv->cros_ec,
 								  EC_CMD_THERMAL_GET_THRESHOLD, 1);
-	cros_ec_hwmon_register_fan_cooling_devices(dev, priv);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, "cros_ec", priv,
 							 &cros_ec_hwmon_chip_info, NULL);
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
+
+	cros_ec_hwmon_register_fan_cooling_devices(dev, priv);
+
 	platform_set_drvdata(pdev, priv);
 
-	return PTR_ERR_OR_ZERO(hwmon_dev);
+	return 0;
 }
 
 static int cros_ec_hwmon_suspend(struct platform_device *pdev, pm_message_t state)
-- 
2.53.0



