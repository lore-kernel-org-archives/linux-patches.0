Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730533C53A;
	Fri,  9 Jan 2026 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962180; cv=none; b=GjgxYyzlTLRa97NPF8Rn5F71uYRR+bDc9+CZOVHSDMXy38VsjaZ9XNQ2dfKL1syYUVGZZ41fW94v/uVAxvhJ1757bMszl4XCdHQUA5q+dDIN6m5EaicpRWLgBbvFGyeptjT/vzEaxxfT+eGQI2kAjx3ysuXDwHjED+797kMb/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962180; c=relaxed/simple;
	bh=tQOfWtl+8INNjLE/tTzeUVibP+UHjC/ghiNhYGWIO4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkktsqPmUApOa3KvxNIMYWCHNYwQtzJJYMz63RSEihilwoolCeHEtPKmncWin93F9oyGFqDR61wrJ1pvhEsWsm2g0ehTKdniPmG+CefB9ipxfdFT46cur3f5UgG0FMTn8aOMNerzO9eQ/Xd57Al8jS7ux06H5XPemxSGNGbJ0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzpJ7mFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzpJ7mFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C19C19423;
	Fri,  9 Jan 2026 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962180;
	bh=tQOfWtl+8INNjLE/tTzeUVibP+UHjC/ghiNhYGWIO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzpJ7mFSXgzG2CyBC1k39YuI2Lrdo5XFkfbTdWq5zfjurfwjPyInT2+uSMpc3MQAJ
	 ol55mE88Tbiyj5mL4pmBuhezxDo7kKxLxqmZcfllP3dabRAQX7V7JLWQOIrv6rYtGV
	 WbJi/WTRiJjlDciU3Tw21vom/GknrIHKinbZvqT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 273/634] hwmon: (tmp401) fix overflow caused by default conversion rate value
Date: Fri,  9 Jan 2026 12:39:11 +0100
Message-ID: <20260109112127.806845290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f358ba679626..f869d585c345 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -408,7 +408,7 @@ static int tmp401_chip_read(struct device *dev, u32 attr, int channel, long *val
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



