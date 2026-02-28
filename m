Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911DC359A60
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302405; cv=none; b=lMdcOcoEAdosxvEbO4KJq0fjExR5GpiMhwpjlezS8AOCFVF493K5YGCk7qTWs9lFv98FeT9AXPDedCcy7J71OnUKIiq4cvJW613lPyBOz5+pC1UOoAGcdaSDsCWSqz1gD9UWqmZRFNA7FiMzSO/d/AmR1xMd9HMraNCu9ePozK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302405; c=relaxed/simple;
	bh=c8Si07jh1vi6Xy59d6QOq7I8JUVYHmNJDzIqmE1KgMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k74EcilxiWVRKkiM340+hqXRUkrZTftXoqiAj2Y1Y7TUnbGi90YturKz8mWv1QK6/YSCRaEifAnEXbaIi8saUyfkP/F2hUsJr0tkm/cM1ibDhOybmwdJAhgOw2tu82JvMVI9MZPPaRSM5AKrZtNZvbTB1B5zjNU/ZBtDwB+LUnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9AwCS89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9AwCS89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0529C19424;
	Sat, 28 Feb 2026 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302405;
	bh=c8Si07jh1vi6Xy59d6QOq7I8JUVYHmNJDzIqmE1KgMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9AwCS89uqqUFgMRSYfi/agI8vQCxE+Y5Rhxx413gZjTGifG0lQQrOYsnhW1hqxRD
	 xkUfyQa7sO93VlO40ubVPL3zGcwr1+rBUhn3Eu6gAnj8UssrZTJGW4jIsfabqhSZKz
	 iFNDJlzRyRogzogWo8o7/UaZKoDam0aWkqN89UIXZ7rgugS8dgDhfQdAqRLMmFLBBa
	 FVAHhC8CmQq/QYNpwZ4SxLQ8gceZxYp8RT7DNYWvy0fqa7z5P87sR0459T3TUCmG4g
	 diy5toyVhNFZ8QvxBvmM2AnXYQjsYXR/HrDlNOzkMt/x8RGx739G8lNIbcZS4UeUSC
	 H+9QRSLejLPdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/232] power: supply: bq25980: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:09:50 -0500
Message-ID: <20260228181127.1592657-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

[ Upstream commit 5f0b1cb41906e86b64bf69f5ededb83b0d757c27 ]

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

Fixes: 5069185fc18e ("power: supply: bq25980: Add support for the BQ259xx family")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/8763035cadb959e14787b3837f2d3db61f6e1c34.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25980_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/bq25980_charger.c b/drivers/power/supply/bq25980_charger.c
index 9339f56492827..54f444776f174 100644
--- a/drivers/power/supply/bq25980_charger.c
+++ b/drivers/power/supply/bq25980_charger.c
@@ -1241,6 +1241,12 @@ static int bq25980_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	ret = bq25980_power_supply_init(bq, dev);
+	if (ret) {
+		dev_err(dev, "Failed to register power supply\n");
+		return ret;
+	}
+
 	if (client->irq) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
 						bq25980_irq_handler_thread,
@@ -1251,12 +1257,6 @@ static int bq25980_probe(struct i2c_client *client,
 			return ret;
 	}
 
-	ret = bq25980_power_supply_init(bq, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register power supply\n");
-		return ret;
-	}
-
 	ret = bq25980_hw_init(bq);
 	if (ret) {
 		dev_err(dev, "Cannot initialize the chip.\n");
-- 
2.51.0

