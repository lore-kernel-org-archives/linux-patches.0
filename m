Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0824191F66;
	Mon, 22 Sep 2025 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569516; cv=none; b=ajn6V/ufsQHsI7ChOZXRb6v1ddp8h5iPrmUfSwNOkznnM2h7lEUUgWLyrp9GMIYDOstEQZa2tD36rtTudwAhfaYhF1jrozi+TBNFw7u+OfWqDMf9OTZvfGCYrnGeCaUC66uTsrN8Ezid00Cdk5LevqckN0R0FhA9XFGcfi/0SWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569516; c=relaxed/simple;
	bh=TwYEtDF4wRTiwmfBVu912lyTYmal8JkR4kzNrHfth1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkFqvDFaFfBweXf9NF8trPA+l6WMsjtUdSMDbVkwQgWyUg1YCDaylPlmEtZKsx25UZdO3YF6fqjDi4aZ6Nnm1JmcfSaef2hfQ+lxR0DBm17EeV4PfmxjsO46bSttN0927j0/VBJgl9XNA3khoYkzCWaaYTxnz4JzFSXOe4jBJys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyb0QTWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyb0QTWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBA5C4CEF0;
	Mon, 22 Sep 2025 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569516;
	bh=TwYEtDF4wRTiwmfBVu912lyTYmal8JkR4kzNrHfth1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dyb0QTWGv5d326x/+x8roEv51wNDHSzE1+X/0+pbfch73sY0BztWFOO7NwrrVdR95
	 xKVOLW3IrjFpeqKMWIveNKnl0DlFyeLpHuYup4INUpWzfmvOG7IUIUUGvoZrzSbrkC
	 iQnNzKWeAshJSIGdZxDDdel1cmjIliuRF0lxqIAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 23/61] power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery
Date: Mon, 22 Sep 2025 21:29:16 +0200
Message-ID: <20250922192404.188398667@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 2c334d038466ac509468fbe06905a32d202117db upstream.

Since commit

	commit f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")

the console log of some devices with hdq enabled but no bq27000 battery
(like e.g. the Pandaboard) is flooded with messages like:

[   34.247833] power_supply bq27000-battery: driver failed to report 'status' property: -1

as soon as user-space is finding a /sys entry and trying to read the
"status" property.

It turns out that the offending commit changes the logic to now return the
value of cache.flags if it is <0. This is likely under the assumption that
it is an error number. In normal errors from bq27xxx_read() this is indeed
the case.

But there is special code to detect if no bq27000 is installed or accessible
through hdq/1wire and wants to report this. In that case, the cache.flags
are set historically by

	commit 3dd843e1c26a ("bq27000: report missing device better.")

to constant -1 which did make reading properties return -ENODEV. So everything
appeared to be fine before the return value was passed upwards.

Now the -1 is returned as -EPERM instead of -ENODEV, triggering the error
condition in power_supply_format_property() which then floods the console log.

So we change the detection of missing bq27000 battery to simply set

	cache.flags = -ENODEV

instead of -1.

Fixes: f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")
Cc: Jerry Lv <Jerry.Lv@axis.com>
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/692f79eb6fd541adb397038ea6e750d4de2deddf.1755945297.git.hns@goldelico.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1873,7 +1873,7 @@ static void bq27xxx_battery_update_unloc
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
 	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -1; /* read error */
+		cache.flags = -ENODEV; /* read error */
 	if (cache.flags >= 0) {
 		cache.temperature = bq27xxx_battery_read_temperature(di);
 		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)


