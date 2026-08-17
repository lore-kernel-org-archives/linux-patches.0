Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF65041D111;
	Mon, 17 Aug 2026 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978564; cv=none; b=ol41rptFaLXk5iK+5djpKcFTgKCXOEc6v0f1aidgKpXuFAMzvr/cBG1TX1shsh/EoCGqLYP0X4imwW7k9sGH5K+UL1ZUKFSOTKG1zEGQF1yBv7V3kqNlMKWd/DX9EMrXkFqdk6Ku0MqsB+BUpV276rkfkOfEKzFo4ywwTy6PIfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978564; c=relaxed/simple;
	bh=frm2zLbL1/ZBLjUnSkh4obvtV3H/3m6/1RfoDQrxIWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx1gXKH+/mKQ4DIxsGwI94D/5h1RmsxR+bvqLpn+1fjB4cCgcNOKFiK0CxHBsslTzDbNwI9jtprefPIBZ7bzwmCZNlTtsFDSJIoWg3xEYnSZJYhwZVPysOS+e1jw7uJGgwlz0fPrvjLyYB91Vc9aQio3XK2wPqpw2BoUJYQw/wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs/+MR0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs/+MR0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB21F000E9;
	Mon, 17 Aug 2026 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978562;
	bh=6P3YCHQCfBttauVXBgRz3TZHY6mCdOmKC/xJyUm4sgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bs/+MR0JbOCnopofGvNSVMvyNUqxfwAKMSe+ha+eFEAaktZsr0BKzEMzDqTY3MkYB
	 kdVK4LvLULgPXhCebE+EVkpT6VMb3fcktXHgx12rKxMVxl41DqhyFc2HPeFr994+c6
	 9QjEk0VRogL+MTSbEhMSBzHen2sLHbjcB5ql7l7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/156] hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations
Date: Mon, 17 Aug 2026 15:32:55 +0200
Message-ID: <20260817132536.214513448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a20df5a43ec8..8a94c4cfb5d19 100644
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



