Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A7926461F;
	Mon, 17 Aug 2026 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980275; cv=none; b=HgyLexAd0mNO1Gs7iYZzJkQIhcx8r/YP8AzLZ+YjgxZ0f3QWTLZYha/w9AsKfkik2l7pOGa9tnLbXwc5I2WFeKX2PBfCF+kuvbtSn3aFmAxalKAz4LQPJJGJBtKe0fbMN7YIHcmEVx5J5qzvZqktc5lHwrQH/UPiplMjYnemXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980275; c=relaxed/simple;
	bh=SpsTTUZ8S3ODlpItZ9+sLPzkW5wF1VIOo3HCj8BtRKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1DXkR2/v4QZdsM8ShgjnSEZQFBvHGUNdcK4q+LAvBCbnWSNY/yhkB0xa5NAzuDICY4oZZRbp0sFdGqh6DbJHHOYCKK/+aqI0y1rvm4cPpnfyNXJUB6z7q8byZJSCfnsra++z5/vDb/E+knj/n3E00f1sYDKiapYTftEE2NZTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11xPagrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11xPagrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF291F00A3A;
	Mon, 17 Aug 2026 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980274;
	bh=BDTMcIPPUmUualOct8RQ6F2+/neFRwDRh1Q5hLKAADI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11xPagrBbToq0IRLrsOjb/VVU7WSfNlF4I4yjcZAFnxLXx1fUFT3hIRYlhqFF0Iq2
	 foE8xu3ndSSuXl6Ru9TmLMg3WZH4OkaDnkrl1/XjgXc4DNyU1B3FH/qIbvjxNxIpku
	 7piN5+/i6s5VQuRv6wcN/MWOReIpKqqdppia2shY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 515/609] hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations
Date: Mon, 17 Aug 2026 15:33:31 +0200
Message-ID: <20260817132601.075437599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0dabe8a56f772f0ece46d2597799f412c277d874 ]

In lm25066_probe(), the PMBus coefficients for current and power are
scaled based on the shunt resistor value. The calculation evaluates the
multiplication using 32-bit arithmetic because info->m is an int and
shunt is a u32:

static int lm25066_probe(struct i2c_client *client) {
    ...
    info->m[PSC_CURRENT_IN] = info->m[PSC_CURRENT_IN] * shunt / 1000;
    info->m[PSC_POWER] = info->m[PSC_POWER] * shunt / 1000;
    ...
}

For large coefficients like 26882 (LM25056) or 15076 (LM5066i), a device
tree shunt-resistor-micro-ohms value exceeding approximately 159,000
(159 mOhm, which is physically valid for low-current applications) causes
the intermediate product to exceed UINT_MAX (4,294,967,295). This results
in a silent wraparound before the division by 1000.

Furthermore, if the wrapped value has the most significant bit set,
converting it back to the signed int info->m results in negative
coefficients. This logic error leads to drastically corrupted current and
power readings, which can cause erratic thermal or power management
behavior in the system.

Fix the problem by using 64-bit operations for the multiply/divide
operations. This can still overflow, but only for unreasonably large
shunt resistor values.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 94ee5fcc240fe ("hwmon: (pmbus/lm25066) Support configurable sense resistor values")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/lm25066.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index a99f073c2d0b9..8fef24a25d728 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/math.h>
 #include <linux/of.h>
 #include "pmbus.h"
 
@@ -540,8 +541,8 @@ static int lm25066_probe(struct i2c_client *client)
 	if (of_property_read_u32(client->dev.of_node, "shunt-resistor-micro-ohms", &shunt))
 		shunt = 1000;
 
-	info->m[PSC_CURRENT_IN] = info->m[PSC_CURRENT_IN] * shunt / 1000;
-	info->m[PSC_POWER] = info->m[PSC_POWER] * shunt / 1000;
+	info->m[PSC_CURRENT_IN] = DIV_ROUND_CLOSEST_ULL((u64)info->m[PSC_CURRENT_IN] * shunt, 1000);
+	info->m[PSC_POWER] = DIV_ROUND_CLOSEST_ULL((u64)info->m[PSC_POWER] * shunt, 1000);
 
 #if IS_ENABLED(CONFIG_SENSORS_LM25066_REGULATOR)
 	/* LM25056 doesn't support OPERATION */
-- 
2.53.0



