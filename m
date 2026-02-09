Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1816135CB6B;
	Mon,  9 Feb 2026 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647223; cv=none; b=hmvJmlrE6mAVuzUbLxL5T0rD42yIULpaQ+XJrS4j3lAnz07UusgYEqvHKpupQDxAYHEgGru8jfty/rGoBYGW9GyKXn+3fdRlKkI+gR09Cz/R2ZWF/VLTDtqNQNjkBIvvye+vQSFjnWTlLv5X+yzCT6ZNUuuzICnRkAzRMwu8qz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647223; c=relaxed/simple;
	bh=VGyDzsnCgmX52deX253Ok/V5MObkIF2w2X1I+6c0HyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANx+UrMWHlDVPCnaAzSNx0Z9xQX9zKZnpC0s5ODNe7m+jpFS6DSFgZZ/410rDcID19K6hnN4/xOsSPvs0kOJ5SGMIDYtSn9YUffAN8L3/h62JUcIvTEtJTfNdOIqTpgAVu64jV4uNBJkA9V5oDP+ydNrsDqDioj6kt+8a35Lu0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se2ngsmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se2ngsmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1986FC116C6;
	Mon,  9 Feb 2026 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647222;
	bh=VGyDzsnCgmX52deX253Ok/V5MObkIF2w2X1I+6c0HyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=se2ngsmLWF8jNMzRnQhfGPCt4Hf4YrfP03ThTq3+YE0+mTFP0CvKD4QG0r9MQUM/I
	 /+f5ifcYpNE3gyU5GG83EsG+ppLys2kURs9xYIQRrmWfIxvDo6rxiIaXSfhgR1mVEg
	 0SueRHVVNtCENuK2N9/0WV+Q2Rjnqc6m2bJrZNQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 035/175] hwmon: (gpio-fan) Allow to stop FANs when CONFIG_PM is disabled
Date: Mon,  9 Feb 2026 15:21:48 +0100
Message-ID: <20260209142321.737297029@linuxfoundation.org>
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

commit 52fb36a5f9c15285b7d67c0ff87dc17b3206b5df upstream.

When CONFIG_PM is disabled, the GPIO controlled FANs can't be stopped by
using the sysfs attributes since commit 0d01110e6356 ("hwmon: (gpio-fan)
Add regulator support").

Using either the 'pwm1' or the 'fan1_target' attribute fails the same way:

  $ echo 0 > /sys/class/hwmon/hwmon1/pwm1
  ash: write error: Function not implemented
  $ echo 0 > /sys/class/hwmon/hwmon1/fan1_target
  ash: write error: Function not implemented

Both commands were working flawlessly before the mentioned commit.

The issue happens because pm_runtime_put_sync() returns with -ENOSYS
when CONFIG_PM is disabled, and the set_fan_speed() function handles
this as an error.

In order to restore the previous behaviour, change the error check in
the set_fan_speed() function to ignore the -ENOSYS error code.

Cc: stable@vger.kernel.org
Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20260202-gpio-fan-stop-fix-v1-1-c7853183d93d@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gpio-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index d7fa021f376e..a8892ced1e54 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -148,7 +148,7 @@ static int set_fan_speed(struct gpio_fan_data *fan_data, int speed_index)
 		int ret;
 
 		ret = pm_runtime_put_sync(fan_data->dev);
-		if (ret < 0)
+		if (ret < 0 && ret != -ENOSYS)
 			return ret;
 	}
 
-- 
2.53.0



