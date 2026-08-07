Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F40747A877;
	Fri,  7 Aug 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117490; cv=none; b=UGAsC709oMPDm61EP0k1byZtLphzvOx73xRrGaHyICb28SGP5hzaMlWpp5xOCymyVT3jcZcaFknG7BggS7d1mYQBEJg1LY9Koek2BhKSou94WWyeYMcZOoEgsNlMaw47s7w7OmQExUj3EnfXPqmM73cJt8PJUeunbgAtJfeOHQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117490; c=relaxed/simple;
	bh=DVIollRPDNLqO6PaqBiYdhALzrSRY2UAc65F7JDlBgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uz1jiWJxq6Ma4TE3Cz/2Ife5i5HJLU/sFcJGXc5iyc5k1vUSjGbdFgZonr3Wpv6Q8dslbTaJw7N2PC4/bZLLPOydEDuAHcZLnCNY2Cua0Vjhlqy1VhGpwEVNkbtSVxv+ca1JaIEIAykAnNrvAT8kJCdz2GOEdAW80aOOLXrfnDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5Ww3pX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5Ww3pX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC66C1F000E9;
	Fri,  7 Aug 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117489;
	bh=Q9p9lfWTjRIeWkj0PFFAd4EYw65QkSRorfmmaDrS8Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5Ww3pX6JZvrESyfTxIA4nmeLAiQTYIHU9l0rpGZtj7d7ZGCESBEZ4q7wSdfRdF5d
	 hnDIGWQhJd/tUWfxEX2KeeIoGEXyPUOA5U/lwR33cFZkDL21m4TMYC1+4NIimbayeX
	 hD9gw64kiLvfClkDlxye4LaLgEsVmlxULPrDf1cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 336/438] power: supply: max17040: handle missing status supplier
Date: Fri,  7 Aug 2026 16:38:52 +0200
Message-ID: <20260807143435.136685669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 725668c6b6aa3971fe850659102c250d0d676e18 upstream.

MAX17040 does not report charger state itself, so the driver forwards
POWER_SUPPLY_PROP_STATUS to a supplier power supply. If no supplier is
registered, power_supply_get_property_from_supplier() returns -ENODEV and
leaves the output value untouched.

max17040_get_property() currently ignores that error and returns success,
so userspace can read an uninitialized status value from the battery power
supply. This happens on systems that use the fuel gauge without a charger
supplier relationship in firmware.

Return POWER_SUPPLY_STATUS_UNKNOWN when no supplier provides STATUS, and
propagate other supplier lookup errors.

Fixes: f4b782af61ae ("power: max17040: pass status property from supplier")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260701061042.1008-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -405,7 +405,11 @@ static int max17040_get_property(struct
 		val->intval = chip->low_soc_alert;
 		break;
 	case POWER_SUPPLY_PROP_STATUS:
-		power_supply_get_property_from_supplier(psy, psp, val);
+		ret = power_supply_get_property_from_supplier(psy, psp, val);
+		if (ret == -ENODEV)
+			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		else if (ret)
+			return ret;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		if (!chip->channel_temp)


