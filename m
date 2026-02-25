Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FE520C012;
	Wed, 25 Feb 2026 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983316; cv=none; b=TEMt2ssmdVDbt6YMlpdXQLA5gtiTRWoHytLOXOWgJBLRcPBu0rYyqFOmqyRGGkv33uAJpckbR6pD0YfI5MPrXKWbXpXTpdKOUx4ENa3MDbSMe6ikKa/nZ+ymCwZL7XqWTjjSLn+kFB72IVRtJ7qQVNpdpZ03L6/XVWtPMMop94Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983316; c=relaxed/simple;
	bh=ExV53+0y58fe373TKX46laTSPr9GSXgdTLigib89UaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/kKvksU2OT0NiqHyxc7ILvWlsCuRMwiKPW0oZZXaywJjgOw/kuR6XmDNhUspTiiFKCnqEyGqhWSTh0K1oWNiHvLwUyuR3zGF23vKJm54njFcO7wIfZIClmEx2EiY/WyTjYkZQWilI8n6b+Iy1+YZ/YWDBdGXd0lga0GIT3Mxwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w22Sntj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w22Sntj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFBBC19424;
	Wed, 25 Feb 2026 01:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983316;
	bh=ExV53+0y58fe373TKX46laTSPr9GSXgdTLigib89UaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w22Sntj0XqeDZ+4NdMnWSDQzNaxKgPdjWLDm/PWGsVZ7amWeMB03auat16gzs/WsB
	 i4zEyGD8L4OLetwzP5cZ2eWZZHxn3nQbv3occ4ToDuNN6kCpV1fo94uL3Wm2rQVQJH
	 hPReEe//NikLO+SLUpADnNvfkmThwPgmcPpVi0xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 450/781] power: supply: bq25980: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:19 -0800
Message-ID: <20260225012410.750613278@linuxfoundation.org>
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
index 723858d62d141..73f06f09f134c 100644
--- a/drivers/power/supply/bq25980_charger.c
+++ b/drivers/power/supply/bq25980_charger.c
@@ -1241,6 +1241,12 @@ static int bq25980_probe(struct i2c_client *client)
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
@@ -1251,12 +1257,6 @@ static int bq25980_probe(struct i2c_client *client)
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



