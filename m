Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715CE375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302591; cv=none; b=DIwGS72uiLwzYxU7LLEfI0KHuM8ouAQ1fOue5TkktbOxgzkRYWWIWYIu8WBn3RHLqPaq4yCZkUnkDECP2+sJ7icFfLwsugKf+UDs+vtpZFB1bFCoPNQEi2bYV7QqhgJFGYs16m7Tc+iXULRAIgX9JQ2Vxb+ArVxwIcnWCvnI3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302591; c=relaxed/simple;
	bh=MkKfv91CsjHpB/Fyk9/xQGUwvf5kYX7AMR8KxELw0Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqM3FdyWknmh0ehCoW3N+8ec3FWelBdvPLiI3I/eI3wlCibUZ0sHQubKat3ksGJ1VT80vOkkoYzB74IPxj0JmNjvhXLolU5zvb2D5L6WgFtUDYwnfedF1Blkb1mS5Iafg4wBSd8/hS12np3OCLKG79RyqYAdWke3oOHJMnxNCIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fp9Rj6pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fp9Rj6pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEBBC2BCAF;
	Sat, 28 Feb 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302591;
	bh=MkKfv91CsjHpB/Fyk9/xQGUwvf5kYX7AMR8KxELw0Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fp9Rj6ptoL53iT07DIDyX+2zBEDaaJQI6QnIAyci7IpLNcApMcJNc0ZnMmNLQpLJ9
	 +eTH6u5/NWPncwbVP3o02X/MPa57001DrFrRNWCG8H3UWO2OpwN+kCDZil8hj8BGvS
	 q0Y4PRfXX3UKjNPhyn7jKcwlyBNnPzNBHbVvAktS7DevZbKIgugnxnFssT+fi/QEUW
	 GxWbsZWVN6A6JcXlX30QOg9zt288aeOCr1+j8gsa9lVeuH6JkKrJv3GVEF84IYqTDd
	 5lYHqLBOwWXXyClzrI2U/yMttnwcclwaSnBZw01mHXky1lqEvuvMnnddc7b5gzXugT
	 xL91LkRILmrbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/164] power: supply: rt9455: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:14:01 -0500
Message-ID: <20260228181505.1600663-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

