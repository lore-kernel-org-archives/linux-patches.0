Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6315ADB4;
	Mon, 23 Jun 2025 22:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717309; cv=none; b=jrPoB6yylBy3IhOBZ18bPZYGWmFwFEwUhuJ6FcWAQW83vb/Pxz6kkT4BLTxfptu3s79uEAueHWv89SZsZMXmfFbepORRCHwoCtFnbQEx1BBdWpHseea54NtU06xmRd/4jSrPAGLzhdHueFDssT+DEzwCCSKQsMYe4VaWBHcoN5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717309; c=relaxed/simple;
	bh=qzVzaZdjkG2zr/Io6IitburOimGwpIYAMMRLqgFwZYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFhgEi4rmRuZicwoHxq269qQjP5R/lwBjrzXI1Zgo4Y20g1CJqqkhf1pKuvAGTJQzFKaoELvNaasXGy/8LN4vZKhcswXjSPv3/q8K9YvGOpvGaQYSqGevat5IhnV3HhR+z668G+0GRXS6j0gnZmzpKm6coLZFk99Julbt6lHMDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUAaZ4ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUAaZ4ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D05C4CEEA;
	Mon, 23 Jun 2025 22:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717309;
	bh=qzVzaZdjkG2zr/Io6IitburOimGwpIYAMMRLqgFwZYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUAaZ4ni5YLT+qQs6Uac3sN0UleZcESLOq9CLMDanDouexB0RNKKUOcZqLjOfUEWy
	 4Z2IWqK3Iaw4/ngMyIUiBZY1xtypctk6Vzyp2mARQWbLhrIagZmSUHPchbbjeeB1Ci
	 yQDwonLPzFuj9NL7cAbexHsLd0AUX+Zk5UjjfRTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/414] hwmon: (ltc4282) avoid repeated register write
Date: Mon, 23 Jun 2025 15:08:20 +0200
Message-ID: <20250623130651.041399013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit c25892b7a1744355e16281cd24a9b59ec15ec974 ]

The fault enabled bits were being mistankenly enabled twice in case the FW
property is present. Remove one of the writes.

Fixes: cbc29538dbf7 ("hwmon: Add driver for LTC4282")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20250611-fix-ltc4282-repetead-write-v1-1-fe46edd08cf1@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index 4f608a3790fb7..953dfe2bd166c 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1511,13 +1511,6 @@ static int ltc4282_setup(struct ltc4282_state *st, struct device *dev)
 			return ret;
 	}
 
-	if (device_property_read_bool(dev, "adi,fault-log-enable")) {
-		ret = regmap_set_bits(st->map, LTC4282_ADC_CTRL,
-				      LTC4282_FAULT_LOG_EN_MASK);
-		if (ret)
-			return ret;
-	}
-
 	if (device_property_read_bool(dev, "adi,fault-log-enable")) {
 		ret = regmap_set_bits(st->map, LTC4282_ADC_CTRL, LTC4282_FAULT_LOG_EN_MASK);
 		if (ret)
-- 
2.39.5



