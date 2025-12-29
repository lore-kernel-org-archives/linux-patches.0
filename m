Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884BA331234;
	Mon, 29 Dec 2025 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025169; cv=none; b=M2LMxbKXIeWjVAn9sn3GvAFyXjIVfhzmdNoMTGcyIvUD+6v/jO9XpKf1HsovgL/pR5Vc9k3nrHbQ1AgPrlX0btkjYJGn3vitQF6HBHaaN3LpLPBdKfFlZmuX6L+4Xak+bW9FBwjBZ0VFDxlWkaLMCHTltI/ivCZ8n9wn3jDNfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025169; c=relaxed/simple;
	bh=41zqTYF+2KLbRY/cEBOxuE7ZZrMWWUIFFo4XO4aj/GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6eOLujdobyNnHxZlgau16Ksn2OGSoyJvZEOi0syMBvRjj2QOSFtv7s0F3/ERC9wQCLy5YtDI14BrMS0s1Hb2xCkFeNnZ2Gopwp/yfEbE/wT1ifQpNQysyJYxbMB0HDEGaCSw4/TF8xW+UngujnNTBoK3L1jFYdSlJZvLi10ZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc6W3xCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc6W3xCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12067C4CEF7;
	Mon, 29 Dec 2025 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025169;
	bh=41zqTYF+2KLbRY/cEBOxuE7ZZrMWWUIFFo4XO4aj/GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yc6W3xCpBS9OsSGYJv1jQd6xRHZuKvz8nBlEgMOjO+X2Duhfqpp9J9gFbq5xNwNen
	 AhYsl5nX42Z9GMxOE6z8N+oM1BB7rp3I9Z+DSWxZqyj9BqLVWRxDa2GhY69u8HB4Kd
	 DvTVNczKcgeP9aRh2ol4ae5qJWuFpEuxOHKxk1/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/430] hwmon: (tmp401) fix overflow caused by default conversion rate value
Date: Mon, 29 Dec 2025 17:08:40 +0100
Message-ID: <20251229160728.709178982@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 82f2aab35a1ab2e1460de06ef04c726460aed51c ]

The driver computes conversion intervals using the formula:

    interval = (1 << (7 - rate)) * 125ms

where 'rate' is the sensor's conversion rate register value. According to
the datasheet, the power-on reset value of this register is 0x8, which
could be assigned to the register, after handling i2c general call.
Using this default value causes a result greater than the bit width of
left operand and an undefined behaviour in the calculation above, since
shifting by values larger than the bit width is undefined behaviour as
per C language standard.

Limit the maximum usable 'rate' value to 7 to prevent undefined
behaviour in calculations.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Note (groeck):
    This does not matter in practice unless someone overwrites the chip
    configuration from outside the driver while the driver is loaded.
    The conversion time register is initialized with a value of 5 (500ms)
    when the driver is loaded, and the driver never writes a bad value.

Fixes: ca53e7640de7 ("hwmon: (tmp401) Convert to _info API")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Link: https://lore.kernel.org/r/20251211164342.6291-1-bigalex934@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp401.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 02c5a3bb1071..84aaf817144c 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -401,7 +401,7 @@ static int tmp401_chip_read(struct device *dev, u32 attr, int channel, long *val
 		ret = regmap_read(data->regmap, TMP401_CONVERSION_RATE, &regval);
 		if (ret < 0)
 			return ret;
-		*val = (1 << (7 - regval)) * 125;
+		*val = (1 << (7 - min(regval, 7))) * 125;
 		break;
 	case hwmon_chip_temp_reset_history:
 		*val = 0;
-- 
2.51.0



