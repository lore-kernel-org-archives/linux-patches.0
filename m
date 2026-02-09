Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98B37756C;
	Mon,  9 Feb 2026 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647219; cv=none; b=JmkzfRnmt4atZ0SZfSAFjgKZykUmoFLe6IMdkkJJcjMcKoxbqqU3r7iCDOwPB+SYSNbO0gOu26teO5iVZ63WV6wEUeFDkmtpx0XGfT9ltD0dOOLaBtDKoYVznTZ2l9HXxRPLXLq+NXry6QPAMJL7Q/QNsXAvnuJz6scveClZTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647219; c=relaxed/simple;
	bh=WMviKmSDyxj9HJmq9TMupXpsiFbc5pMCMHcc+6AGPm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQPxFipdwjcCN8tujePwZPPkWMa2+srSms7P+Zp1T4gNfSIKp3mDDDC/EG3CJfwZVo7AwRw73tgMzjUWrkmTOSmOl9AL3OYtPiBGK2qPoerziYCyeu41bCGZF4FeVeLgzS5urxq9RN21uAq7HAvgL9wHJom7jWEQseKU4pTsCpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x3P92sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x3P92sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B3DC116C6;
	Mon,  9 Feb 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647218;
	bh=WMviKmSDyxj9HJmq9TMupXpsiFbc5pMCMHcc+6AGPm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x3P92sPz+MVg+riDV8aMpIchBXK+PEg38tGHb1Fqon4YyXI3EkQCiUI2aa4cyIIz
	 ATmnviKF5CXvyWB6WFbsdrFreVqKDzr220Ec4dILgGveSYmn4ef+HGIwOU0D+C0Ix5
	 T19fO6gqAZNB2/WH8sZzuXoND0k4B9VutydSGzrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 034/175] hwmon: (gpio-fan) Fix set_rpm() return value
Date: Mon,  9 Feb 2026 15:21:47 +0100
Message-ID: <20260209142321.702846315@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

commit f5c092787c48296633c2dd7240752f88fa9710fc upstream.

The set_rpm function is used as a 'store' callback of a device attribute,
and as such it should return with the number of bytes consumed. However
since commit 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support"),
the function returns with zero on success.

Due to this, the function gets called again and again whenever the user
tries to change the FAN speed by writing the desired RPM value into the
'fan1_target' sysfs attribute.

The broken behaviour can be reproduced easily. For example, the following
command never returns unless it gets terminated:

  $ echo 500 > /sys/class/hwmon/hwmon1/fan1_target
  ^C
  $

Change the code to return with the same value as the 'count' parameter
on success to indicate that all bytes from the input buffer are consumed.
The function behaved the same way prior to the offending change.

Cc: stable@vger.kernel.org
Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20260201-gpio-fan-set_rpm-retval-fix-v1-1-dc39bc7693ca@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gpio-fan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -291,7 +291,7 @@ static ssize_t set_rpm(struct device *de
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 	unsigned long rpm;
-	int ret = count;
+	int ret;
 
 	if (kstrtoul(buf, 10, &rpm))
 		return -EINVAL;
@@ -308,7 +308,7 @@ static ssize_t set_rpm(struct device *de
 exit_unlock:
 	mutex_unlock(&fan_data->lock);
 
-	return ret;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_RW(pwm1);


