Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD51441606;
	Mon, 17 Aug 2026 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974953; cv=none; b=dx3a7CgJGmzh6RlFefcSkozwZ5CJzAsOFs2MBCGNsZaaD5zuE51d5b3h5GmK/rxoLOC/UExGDQTv9JW1EIP39236p8+/MN/lQxQ3trx5+OQIN2F6SywIiqCndaohXS/R2P8j1+2urpwBhAXDVfgKMDHZrWyXkNnfd8qA1J3Vh+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974953; c=relaxed/simple;
	bh=yoJKaWdVCPJbZ7OCr7uQNlWpPWratrBsihzsM6Hn20k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UaRUGwx0HRji/LLxsPkUuAE3IRl+JRZ2NXqylvxDxowp0aRR4GI7Q2Oug+SSJQ8pAATeZ63GiqBjh2emXRPVOYeWe5pbhZXUIru3Cu0DLQ5nqN0BUMp+PPDWaIuVlHy1O1yEeoY9ZaH5X/rFp7Ym6BvWg2oHJtvgFzIo6fIiPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oq1admL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oq1admL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1A81F000E9;
	Mon, 17 Aug 2026 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974946;
	bh=Hka/5yo6g92Ksk7b6GwUPyleia8ybwCHWCU4KRJCzv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oq1admLdfN4QoNf3M77SpvTS8zxjXaHqnGWH43YzE+iClW4vnfziGxfabsVL6y25
	 Kr7PzwpZre+0Nda/SzEne2sOGfKZOktBHPhj9QD+rNt5yvFjp7COu4FBfXVzCkwKP/
	 3ihBy84w2nC7pAUUDcOYTP6wbqgax9JY6bUTdjQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/250] hwmon: (ltc4282) Clamp negative current limits
Date: Mon, 17 Aug 2026 15:31:09 +0200
Message-ID: <20260817132540.962579421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e253dd5f9f6d875a317895bf43ec9534ed7523cb ]

When a negative value is passed to ltc4282_write_curr(), the signed long
val is cast directly to u64:

drivers/hwmon/ltc4282.c:ltc4282_write_curr() {
        /* need to pass it in millivolt */
        u32 in = DIV_ROUND_CLOSEST_ULL((u64)val * st->rsense, DECA * MICRO);
        ...
}

This cast converts negative inputs into large positive values. The
subsequent division result overflows the u32 in variable, truncating
to a pseudo-random positive value. When this is passed to
ltc4282_write_voltage_byte(), it is clamped to the maximum limit instead
of zero.

Clamp val to 0 and to the maximum supported upper limit before the cast
and assign the result to a 64-bit temporary variable before the division
to avoid the underflow and an also possible overflow.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: cbc29538dbf7d ("hwmon: Add driver for LTC4282")
Cc: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index e5ea1db83da47..b45a6e128d32e 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -15,6 +15,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/i2c.h>
 #include <linux/math.h>
+#include <linux/math64.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -947,8 +948,11 @@ static int ltc4282_curr_reset_hist(struct ltc4282_state *st)
 static int ltc4282_write_curr(struct ltc4282_state *st, u32 attr,
 			      long val)
 {
+	s32 ulimit = min_t(u64, INT_MAX,
+			   div_u64((u64)INT_MAX * DECA * MICRO, st->rsense));
+	u64 val64 = clamp(val, 0, ulimit);
 	/* need to pass it in millivolt */
-	u32 in = DIV_ROUND_CLOSEST_ULL((u64)val * st->rsense, DECA * MICRO);
+	u32 in = DIV_ROUND_CLOSEST_ULL(val64 * st->rsense, DECA * MICRO);
 
 	switch (attr) {
 	case hwmon_curr_max:
-- 
2.53.0



