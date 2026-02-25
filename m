Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39722505B2;
	Wed, 25 Feb 2026 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983324; cv=none; b=NA9wvV8uw6FfODi6ETIakv2KiS+Hjt+uoNULI4oaaE2AQh9PggO5aYkr1IxoCqhN/c+XFnOAFp3/a2sKe4OBP36iBpwlKi4B4GxfOKMiHZs09K46u56GHKoEtVgr91hz1/To0wmZfsz2f8dY/sEalyypyNaqarZgtz8WiCNOoDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983324; c=relaxed/simple;
	bh=CHabqQr8pW7MosvqDQFJAJ+7WyOuJAbha/D8b4CHxQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gULs+nukOg875vKnHavhz7A5Bp7DPg6t87wxQyBBKtcAl6Aalh3lBC9ptQkGO/E3fiBkpwgEniszpsq/KJtAwWlO2N4HTlu/xo/lxYBbeM/zrAO6Dx8rg+LJUk54EXG513VuwTYG1Zp1P/LczJpC0AZ8497fPwP94uUUecE981A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqoL/fXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqoL/fXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFF7C116D0;
	Wed, 25 Feb 2026 01:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983324;
	bh=CHabqQr8pW7MosvqDQFJAJ+7WyOuJAbha/D8b4CHxQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqoL/fXk+nK6TowBVuwp0CiQbnEGb3r5hdo1m12hCNMxrkGqqa3v2wIQ/OY8wht2m
	 MugWN0B/CGQuEtHEaknxmhrwLbP0P+8Cl87DAugR3UAjecqOXkNwICXFBOkUMT6FwO
	 DN4vBSc4up/0G41h05bHssiSZdMXwUkfLHZymo9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 456/781] power: supply: rt9455: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:25 -0800
Message-ID: <20260225012410.903331265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit e2febe375e5ea5afed92f4cd9711bde8f24ee6d2 ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/1567d831e04c3e2fcb9e18dd36b7bcba4634581a.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 1ffe7f02932f6..5130d2395e88f 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1663,6 +1663,15 @@ static int rt9455_probe(struct i2c_client *client)
 	rt9455_charger_config.supplied_to	= rt9455_charger_supplied_to;
 	rt9455_charger_config.num_supplicants	=
 					ARRAY_SIZE(rt9455_charger_supplied_to);
+
+	info->charger = devm_power_supply_register(dev, &rt9455_charger_desc,
+						   &rt9455_charger_config);
+	if (IS_ERR(info->charger)) {
+		dev_err(dev, "Failed to register charger\n");
+		ret = PTR_ERR(info->charger);
+		goto put_usb_notifier;
+	}
+
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					rt9455_irq_handler_thread,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -1678,14 +1687,6 @@ static int rt9455_probe(struct i2c_client *client)
 		goto put_usb_notifier;
 	}
 
-	info->charger = devm_power_supply_register(dev, &rt9455_charger_desc,
-						   &rt9455_charger_config);
-	if (IS_ERR(info->charger)) {
-		dev_err(dev, "Failed to register charger\n");
-		ret = PTR_ERR(info->charger);
-		goto put_usb_notifier;
-	}
-
 	return 0;
 
 put_usb_notifier:
-- 
2.51.0



