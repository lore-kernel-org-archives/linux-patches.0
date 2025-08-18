Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B31A727D;
	Mon, 18 Aug 2025 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524036; cv=none; b=XiKD1zTG3dphcPoGsOHZ37pNVndsv0GiCqTG2IPUb7QTiR2Jgo61y2MAX1C3D56gzWDOEh9aztj9Adlmpcs/jTznxrhpL2ad4ZGDkV68MhD/UleSCYweKhDwr1FNgjaDxPu9BvxGXLrOBRBmQ5dr7Ult6h/58wJhkyvr7KPvsDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524036; c=relaxed/simple;
	bh=OwIEKnuPGd2X5GZi9thkcLYuWn+4+OcgOGn7/V6ck9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjQ6thDSKhYhlYUiHiJ+dQQ7mOpfcnc0nZ1hWGgtqCuO14gFmK98s9Be2fxBMFXsKqlZiiIMlFXepRxAq7NNwvAcNwP1Gvsn8Coy3eqwcdPTuDEHibHrXQPAFU1Q4SNrPvyDNgGvSNy2o/nhVUNb5G3jMMOLhC7TdT2b76cjjAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0h3KVrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0h3KVrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18918C4CEEB;
	Mon, 18 Aug 2025 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524036;
	bh=OwIEKnuPGd2X5GZi9thkcLYuWn+4+OcgOGn7/V6ck9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0h3KVrRKTz7Sd3EvVRXHQ+T9POkdywc2HEhhLxxkp+2xUYB8faE0WIYGarPyzLUX
	 fSG8sVtcMsmEmmkEYQiIlMljItsfPyyGt4+VHlK2+qJs66g46YHlpsSe3nNXWeobhK
	 zVYPymbFiGygLKmPhpeDFW5/YzOjEJxT5W7fZCAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Fu <fuzy5@lenovo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 348/515] watchdog: iTCO_wdt: Report error if timeout configuration fails
Date: Mon, 18 Aug 2025 14:45:34 +0200
Message-ID: <20250818124511.827990166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyan Fu <fuzy5@lenovo.com>

[ Upstream commit 40efc43eb7ffb5a4e2f998c13b8cfb555e671b92 ]

The driver probes with the invalid timeout value when
'iTCO_wdt_set_timeout()' fails, as its return value is not checked. In
this case, when executing "wdctl", we may get:

Device:        /dev/watchdog0
Timeout:       30 seconds
Timeleft:      613 seconds

The timeout value is the value of "heartbeat" or "WATCHDOG_TIMEOUT", and
the timeleft value is calculated from the register value we actually read
(0xffff) by masking with 0x3ff and converting ticks to seconds (* 6 / 10).

Add error handling to return the failure code if 'iTCO_wdt_set_timeout()'
fails, ensuring the driver probe fails and prevents invalid operation.

Signed-off-by: Ziyan Fu <fuzy5@lenovo.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250704073518.7838-1-13281011316@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 7672582fa407..e9bf53929b53 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -601,7 +601,11 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
 	if (iTCO_wdt_set_timeout(&p->wddev, heartbeat)) {
-		iTCO_wdt_set_timeout(&p->wddev, WATCHDOG_TIMEOUT);
+		ret = iTCO_wdt_set_timeout(&p->wddev, WATCHDOG_TIMEOUT);
+		if (ret != 0) {
+			dev_err(dev, "Failed to set watchdog timeout (%d)\n", WATCHDOG_TIMEOUT);
+			return ret;
+		}
 		dev_info(dev, "timeout value out of range, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
-- 
2.39.5



