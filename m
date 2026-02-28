Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F9335AC21
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302727; cv=none; b=a9LLyIG0h2qPJfVZVXmKl9pD1X/JzsH2Kig50teqN7JUECDn2s+Agc0Vsn5Z0duXFpOXKvj1mMM64pBLGS0/mEym7CVhR364YnNtoZRo4Dwi4e9gIibjGl3zhZxzitUXZBvbhwP90F+yg/ZTOBfMQwcOUqzP11vBKWkq06IIwBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302727; c=relaxed/simple;
	bh=MkKfv91CsjHpB/Fyk9/xQGUwvf5kYX7AMR8KxELw0Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5yzr3A/W4Nloyb1lr9SkrRwWM7rPeHVKOz4BewJlGXh1N/J/hDNSctA242OAj1TYG2QXNTHqzfkQGNfqS7Gqc5seAD+cVNsrDVdOo/VdO7YEpJa5yOEIlkILkY0To3yebqwM0utlYkXW5i+KVsYJYGIDKchKAHPVyrrNxPTzxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joP9gyA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joP9gyA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1AAC19424;
	Sat, 28 Feb 2026 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302726;
	bh=MkKfv91CsjHpB/Fyk9/xQGUwvf5kYX7AMR8KxELw0Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joP9gyA6Z39+8MFrrNyo9fl2y/SkPQr4lVZpCeDvjSesftcs/+ZGq6eQF7RwKs60p
	 UiSrunCQp1NNIb4RmwePBjB2x3CCDcFgfr9KUNnrnYC5iYEOq7zbLW1R68zv7Jww+6
	 iGpZaDE3azw0kgjIb5i0NGmTgRzPP7XjsgqtYTaSSTeCWRn9BCwdQYSNBgfF6AXpkt
	 djmJ39dbT/dv5palUImM8FW+cHpMTJcSzKkxi5Uxd/nhaG/awgnWnN6XWWeXmWGrrp
	 wjHuPd42fOvLmh0KN6kwlTH40HLmMXyYyXWPLgbXn3Cqy3jB4919jRWfky0oAI9Bkq
	 RNMqfG0Tdd9Cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/147] power: supply: rt9455: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:36 -0500
Message-ID: <20260228181736.1605592-88-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index a84afccd509f1..89b414fac6c3a 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1665,6 +1665,15 @@ static int rt9455_probe(struct i2c_client *client,
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
@@ -1680,14 +1689,6 @@ static int rt9455_probe(struct i2c_client *client,
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

