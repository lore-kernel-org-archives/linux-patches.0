Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11220C012;
	Wed, 25 Feb 2026 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983315; cv=none; b=TGkeSdL3UUqEYpUEztxYeazNrZDjqLyT8ygr38b53is7a9Lp+cgxnc/pUbW/DFQhh7uFToHn6xdvi7kv7N6q7887JEIQBmR5mGtYG+tpZY22d9fu8BIwDpCUsTMaCzYD14XuqsJ2Mj8M8NBA4Y7Z/SAgfwL5iv6CBszQ078a+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983315; c=relaxed/simple;
	bh=ZRbiBrRkQq+a71c2BeKA6oDvW6TSn8IMKThANtivr/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsUG6uE4Yu+qaPQzqI5bFiBBTGMi4DRQdESankaMOwNxfnyhCBROfcKbRQJJMpdWi+5KPSHtcj3+7uABdrPcNGYa5DfnT4Cub7Pk50xjoCMwvIY0xIoAfLATq8ov0zk2lbNLCOx9M4baykqzb051ubyaVvoItnfLc5eGLMJ6i3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YszUBdwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YszUBdwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57825C116D0;
	Wed, 25 Feb 2026 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983315;
	bh=ZRbiBrRkQq+a71c2BeKA6oDvW6TSn8IMKThANtivr/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YszUBdwbPgnKdZDIEdpZoKV5xkT3UE8c2MD23fF4p8MNL6Q1YTh6kPWHyGSRliEWr
	 79y2GIdJjdktug1Z1qZV9hHb9udNKrJuA/2ZPWZWIM0iYF+O20w769/zbfODUWrlrK
	 QzNsU5Tm1UxbgvjlBiCXOSfZBdLMXtvviGYv876E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 449/781] power: supply: bq256xx: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:18 -0800
Message-ID: <20260225012410.724620849@linuxfoundation.org>
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

[ Upstream commit 8005843369723d9c8975b7c4202d1b85d6125302 ]

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

Fixes: 32e4978bb920 ("power: supply: bq256xx: Introduce the BQ256XX charger driver")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/39da6da8cc060fa0382ca859f65071e791cb6119.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq256xx_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/bq256xx_charger.c b/drivers/power/supply/bq256xx_charger.c
index ae14162f017a9..d3de4f8b80db1 100644
--- a/drivers/power/supply/bq256xx_charger.c
+++ b/drivers/power/supply/bq256xx_charger.c
@@ -1741,6 +1741,12 @@ static int bq256xx_probe(struct i2c_client *client)
 		usb_register_notifier(bq->usb3_phy, &bq->usb_nb);
 	}
 
+	ret = bq256xx_power_supply_init(bq, &psy_cfg, dev);
+	if (ret) {
+		dev_err(dev, "Failed to register power supply\n");
+		return ret;
+	}
+
 	if (client->irq) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
 						bq256xx_irq_handler_thread,
@@ -1753,12 +1759,6 @@ static int bq256xx_probe(struct i2c_client *client)
 		}
 	}
 
-	ret = bq256xx_power_supply_init(bq, &psy_cfg, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register power supply\n");
-		return ret;
-	}
-
 	ret = bq256xx_hw_init(bq);
 	if (ret) {
 		dev_err(dev, "Cannot initialize the chip.\n");
-- 
2.51.0



