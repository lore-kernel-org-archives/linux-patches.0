Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B2F349B03;
	Tue,  6 Jan 2026 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719917; cv=none; b=KkCRM04UYG1zRMhmKbiTtJM2Tqu4Ibye/sEZiP9RktTh/7xWYVnYBCj2YkvlptRLKouxltCIAKXVFwtl39oHtlcrmWV01wpl8f0zVdVlYAn+JvDnLSuLyFqT7e3npDYK5lgDRuo9c7jMTKKT+KeTH67miXGQ1ji4H+Xg0bfMSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719917; c=relaxed/simple;
	bh=f0Gut2S9tgDX9LBIk1U7dQLsbPjmauIP/jqrF9C1bn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nabmbve7T2Pqu+D5k4PG38UjqtQgLhiebsAtReoA893jBPk/jm4jh6m93n5MLGjpZZ0b+ot/ttM5nHySziVMEgZ0gVBcVXr9WFRrH3R+LBoS75H3BuALVUDCxu7thmh8TYL0D+nOAKTTUGdcByYF4wdvAoQzL7smNzFh/qscf/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aawQ3Jp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aawQ3Jp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F348C116C6;
	Tue,  6 Jan 2026 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719916;
	bh=f0Gut2S9tgDX9LBIk1U7dQLsbPjmauIP/jqrF9C1bn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aawQ3Jp0Pb54yEC9n60L5sw6kzbr0l8r7b25K5ttuPrjnjIxjQAn3oMGyaigT755/
	 7RvlfOpix3oA7Yo01Bc4sRtTIHXWsL+p69Xc4wnrrv0d8lQI1DoOHKcs3qhU/HUdv1
	 QLVE4wiziD28wE1rr0LZ0WhQWyBc9KFgy/0PateQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/567] hwmon: (tmp401) fix overflow caused by default conversion rate value
Date: Tue,  6 Jan 2026 17:57:42 +0100
Message-ID: <20260106170454.291066340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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



