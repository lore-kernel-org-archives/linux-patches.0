Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059713B8BA5;
	Mon, 17 Aug 2026 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974211; cv=none; b=sz7em4oUgBqFfEtK3WEkEqRrEOxCVqEVyNXz6aTViN/ZvZOnURfJ1yV+jHFflk2CVyxBF+nCSKKZPDzUpZQaKxfgjhwXdCEXkuTDGvM04NfEO4AjzDxSEyFPTwHIk7BmY38Dh2yxt9yZxQse2nb6+SnvEW9kiRnQNpsZ4AFOX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974211; c=relaxed/simple;
	bh=Ue/NK2Bp08g6NRro1Q4gA3z3da/kRrdL4ziuxuERDKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQir+oeYnO4FFWG+Tn4lKRpVkvAWLNkLSE8a+JoOJ013Gz2BTUO9fBcGDacn/Zh4SyYpeCpUtzHXC2R2n/iBmFFKWwaCuqD0e09se17Pp3pSY5Z+CIJyXbPfhrBZ8oPbuf6TCf6MN3fbxBclhVjJnFJ6ku50ZvkfeJIer9Q7nTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKbSSYMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKbSSYMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED7E1F000E9;
	Mon, 17 Aug 2026 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974209;
	bh=EeZOD2YNCcKPM2FyXJoAUB8MvQNVu6HqtCiHkSa+i7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKbSSYMzcqg58F5F5Mjkixcd76ePbX2mGt8z5ldFZkwY3BmTnwGXOe0DabRQtSh2W
	 CsxqjzFSlq6NwaPVKqPAsEolAX1VMKruDNRK9k48yrcQXKtnI6wzTn8iqgNTHRQT67
	 UfLW1ubCc4EIREZ7YudbG6Zbp4+WyHqNuw3IdvvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 088/271] hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations
Date: Mon, 17 Aug 2026 15:30:13 +0200
Message-ID: <20260817132540.372775959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f7df7e2c9c5b..cb42832cebf0c 100644
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



