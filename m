Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E93FE37C;
	Thu, 28 May 2026 20:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999133; cv=none; b=D+MVpDqiQPKB7Qq7rxTt6VhbcqQ6b+L832uo0SHjCm74pIlp/6XmTkkA2o8toZtjo9a4oQpwn5JT+CiTjlDDnPCjLwI2Q2un3dyc87TNan7LOktVD7Lfbqx19SOv4ItL6XRi2DKNoEyMyTmJBATNbMkfrXd5Cq3Jr2YD+9NIDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999133; c=relaxed/simple;
	bh=LNGbRu92PaWbBbpQoISL9RHVc0navfRY+2xYV10ysmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fq+GlAi2y7Kz75XczWqfj+/D11JcK3nWLUq5oBrMWBmhG6qmFD7KRypblIxhZb/KToy5Kv0bo7cq9wzRjJcyfXVz6mCgzu+dRbKB9rfbLpC2VwQtBCFOavZprevDJABLvjHsgt8KpduCPunNXKOTDAxET9gRQpI5y48YRUw1VeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAMIUeZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAMIUeZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7D71F00A3C;
	Thu, 28 May 2026 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999132;
	bh=ID6RWiHmcih5qCVt1zJS83LuaKyr0uu7zAbVSddzYWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAMIUeZDhWCroJ8A9fw+HC+dY5M8l6orJSO74jdL7LzrkIsoWi7M1x/hmQ194e26h
	 rQKAHkB/vMqJcAgKfJ9w2EENqaUo/FOU4REjcwW1RiuBtY1XwVllt2QqUfO/JfynkV
	 5jjXC/rIeflG8KZLp3+5gp97B3a4vLukA5M3cF3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 393/461] platform/x86: uniwill-laptop: Properly initialize charging threshold
Date: Thu, 28 May 2026 21:48:42 +0200
Message-ID: <20260528194658.840532297@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c12cc42dadd85dea210d5699d4f21def827382eb ]

The EC might initialize the charge threshold with 0 to signal that
said threshold is uninitialized. Detect this and replace said value
with 100 to signal the EC that we want to take control of battery
charging. Also set the threshold to 100 if the EC-provided value
is invalid.

Fixes: d050479693bb ("platform/x86: Add Uniwill laptop driver")
Reviewed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260512232145.329260-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/uniwill/uniwill-acpi.c | 35 ++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/uniwill/uniwill-acpi.c b/drivers/platform/x86/uniwill/uniwill-acpi.c
index 6341dca20b76a..4b491fe8bdea4 100644
--- a/drivers/platform/x86/uniwill/uniwill-acpi.c
+++ b/drivers/platform/x86/uniwill/uniwill-acpi.c
@@ -1193,6 +1193,16 @@ static int uniwill_led_init(struct uniwill_data *data)
 							 &init_data);
 }
 
+static unsigned int uniwill_sanitize_battery_threshold(unsigned int value)
+{
+	/* 0 means "charging threshold not active" */
+	if (!value)
+		return 100;
+
+	/* Guard against invalid values */
+	return min(value, 100);
+}
+
 static int uniwill_get_property(struct power_supply *psy, const struct power_supply_ext *ext,
 				void *drvdata, enum power_supply_property psp,
 				union power_supply_propval *val)
@@ -1239,7 +1249,8 @@ static int uniwill_get_property(struct power_supply *psy, const struct power_sup
 		if (ret < 0)
 			return ret;
 
-		val->intval = clamp_val(FIELD_GET(CHARGE_CTRL_MASK, regval), 0, 100);
+		regval = FIELD_GET(CHARGE_CTRL_MASK, regval);
+		val->intval = uniwill_sanitize_battery_threshold(regval);
 		return 0;
 	default:
 		return -EINVAL;
@@ -1334,11 +1345,33 @@ static int uniwill_remove_battery(struct power_supply *battery, struct acpi_batt
 
 static int uniwill_battery_init(struct uniwill_data *data)
 {
+	unsigned int value, threshold, sanitized;
 	int ret;
 
 	if (!uniwill_device_supports(data, UNIWILL_FEATURE_BATTERY))
 		return 0;
 
+	ret = regmap_read(data->regmap, EC_ADDR_CHARGE_CTRL, &value);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The charge control threshold might be initialized with 0 by
+	 * the EC to signal that said threshold is uninitialized. We thus
+	 * need to replace this placeholder value with a valid one (100)
+	 * to signal that we want to take control of battery charging.
+	 * For the sake of completeness we also apply this to other
+	 * invalid threshold values.
+	 */
+	threshold = FIELD_GET(CHARGE_CTRL_MASK, value);
+	sanitized = uniwill_sanitize_battery_threshold(threshold);
+	if (threshold != sanitized) {
+		FIELD_MODIFY(CHARGE_CTRL_MASK, &value, sanitized);
+		ret = regmap_write(data->regmap, EC_ADDR_CHARGE_CTRL, value);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = devm_mutex_init(data->dev, &data->battery_lock);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



