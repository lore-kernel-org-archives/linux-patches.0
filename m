Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1252038CFFE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302177; cv=none; b=ERFlbtkC5APvK+Ur/ctsuGIO633AX1Hw1DY9OFWopZ8S3FCZ1DGYhAJC2TToWs6Pd9/rC4u4d5KjUxlfDobNOefXi0yQTyHfeC69oaNwEmpJ8PETVgyMa01r39NN6mD93u+i/iRRbAaHaTMYRlmBv6mjPOTHjWKHMs/9jcBmo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302177; c=relaxed/simple;
	bh=6aGQ9EXmxtkg3zn4c73M2EK0fokDcKDky/rtwnQ0wEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIVJBPGI56xl16jf/yfZiV+R3X8xIKRspsazatWyty8w9pXifx0M1c5ooceQlJwOA4gnjClr5zv11E2FoZji9jjabv3cOE7wVSTs+bMuu1TBoJWc/HxmM5lZE+zgURfJYd5gUS7c+3pHRj5Hg+dErKtvSAkt2KBuRiFP9GOnpE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sp8J8m0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp8J8m0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE7EC116D0;
	Sat, 28 Feb 2026 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302176;
	bh=6aGQ9EXmxtkg3zn4c73M2EK0fokDcKDky/rtwnQ0wEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp8J8m0fsKHr4WaPBXbRxp3xpYnirL4CSO36CckTiK66IzPttPVUbDwEbE14sfJ1a
	 YUWIO4Fl0viRBu1u+/+VPc+kv+STAU9tCX0mDYOCJXeaOvsoNDs9O9fWPPqF6J0OKM
	 FhvTeoqqKPUDFxLM0ewNcDpe8XW+75gF9Yu0jTClhZVIAzl2rG9OMw9LkBhcZC/q0M
	 aI2Dear9oVa9hdKovzcZkDGh62+JmJlfgjFcPB5M5hlxcsLLCRh+YO+KqXQczmogab
	 a2+r3vzkLE2MceMxhJFXqQdaCozA08PW22WbTp1tLLqNmpGBYATFNxMDjO/80Bi/gj
	 A8sNbnI/ZkJvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/283] power: supply: rt9455: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:18 -0500
Message-ID: <20260228180709.1583486-176-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index e4dbacd50a437..248dc2b5e1f7c 100644
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

