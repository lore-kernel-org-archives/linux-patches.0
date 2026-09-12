Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF9128B4FA;
	Sat, 12 Sep 2026 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204294; cv=none; b=sEx6SiD0fbsV8vJ8oyM2JP5W3OtrmY412AeDgYM8bD9Q/TfWBhhnSxZ0Zck1UUlG4DzgsIsJlTy1q9qwrJtWwyRuSCe+1SgJ61GcWqgzfxYONMQNnwgQrX3a+Ur82b/GKp06ifR9SHsNRGNEqw3GTLcfFReM1tmvkVRsCEOJLh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204294; c=relaxed/simple;
	bh=BGfYIAIKgT+/H40OCDlab1jb0Og858pEFtY0aocNCRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isOah8d3+QmIvy7JRRXEPUh/eW+HEPe7VyzLw5T1xR8gyLW0nAJwP7AWS9Tstnug46ZwzyBb0x92WgYBSWtv9VIzl9VoslZYNgqNpaO7B4VxPduJVaJccSI9beXOGk78cBYCQ0Q4JjVjNpRFZi4cr0LhMPFSeDLi6Ra44i2Ohlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc4Bkc/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc4Bkc/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F303A1F000FF;
	Sat, 12 Sep 2026 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204293;
	bh=6OgAPcLGgdIInOrngw1qrP87PgViX1Z8aD1PIYprX1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc4Bkc/jRyA59+RWHxg/dbSVfYDa/pi9lO0a48cHT/Jd4/jimO43EEMKGF7G1Lb7s
	 3SewNaTKgYI5g6scMF8/y2takPktn/AnvB/N8mAlUDKPprl0U2vwy9Kl0dsLY4U2IS
	 cr4j3W0+1FGDuFBEhiSR+/0pMfC5ER5M0KChB6UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Rugiero <mrugiero@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1556/1815] regulator: tps65185: wait for the IC to wake before the first I2C access
Date: Sat, 12 Sep 2026 08:55:06 +0200
Message-ID: <20260912065725.526631044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Rugiero <mrugiero@gmail.com>

[ Upstream commit 44f7b876b7c6c7b3a219b7a810d3d9548df21540 ]

The probe drives WAKEUP high with GPIOD_OUT_HIGH, enables the input
supply, and then issues a regmap_update_bits() on INT_EN2 with no wait
anywhere in between. The TPS65185 data sheet (TI SLVSAQ8G, February
2011, revised September 2017), section 7.6 "Timing Requirements: Data
Transmission", Figure 2 "Power-Up and Power-Down Timing Diagram",
footnote 1, requires 1.8 ms minimum between the WAKEUP rising edge and
the IC being ready to accept an I2C transaction. The driver calls no
delay function anywhere, and nothing on that path is guaranteed to take
that long.

On an RK3026 board the first transfer was NAKed:

  tps65185 0-0068: error -ENXIO: failed to enable temp irq

-ENXIO here is rk3x_i2c reporting REG_INT_NAKRCV. Probe failed, so
vposneg never registered and its consumer deferred indefinitely.

Wait after the supply rather than at the gpiod_get(). Figure 2 times
that 1.8 ms from a WAKEUP edge with VIN already up, whereas this driver
asserts WAKEUP before enabling vin-supply; the data sheet does not
describe that order, so on a board whose vin-supply is a switched
regulator that was off, a wait placed at the gpiod_get() could elapse
before the part had power. Waiting from whichever of the two comes last
satisfies the specified case and is the conservative choice in the
other.

It also goes above the interrupt request rather than immediately before
the INT_EN2 write, because that write is not necessarily the first
transfer: tps65185_irq_thread() reads INT1 and INT2, and it is
requested with IRQF_TRIGGER_LOW, so it can run as soon as the handler
is installed.

Tested on an ONYX BOOX C67ML (RK3026): the chip now probes, all three
regulators register and the EPD controller comes up.

Fixes: b0fc1e770194 ("regulator: Add TPS65185 driver")
Signed-off-by: Mario Rugiero <mrugiero@gmail.com>
Link: https://patch.msgid.link/20260815232229.68474-1-mrugiero@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65185.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/tps65185.c b/drivers/regulator/tps65185.c
index 1f13e4156cab1..6a3130177e7a3 100644
--- a/drivers/regulator/tps65185.c
+++ b/drivers/regulator/tps65185.c
@@ -5,6 +5,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
@@ -375,6 +376,11 @@ static int tps65185_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, ret,
 				     "failed to get vin regulator\n");
 
+	// TPS65185x PMIC for E Ink Vizplex Enabled Electronic Paper Display Chapter 7.6 Figure 2:
+	// "Minimum delay time between WAKEUP rising edge and IC ready to accept I2C transaction."
+	// https://www.ti.com/lit/ds/symlink/tps65185.pdf
+	usleep_range(1800, 3000);
+
 	data->dev = &client->dev;
 	i2c_set_clientdata(client, data);
 
-- 
2.53.0



