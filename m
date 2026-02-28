Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE78342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301835; cv=none; b=cmPQYRc9PGAfGUdg7Da8lzV9dUmHzy7Fygepe/PFoZYNQKk7vwxut/psDEI0TzHCYRSrt3Nd4h1BI6yqR6Pbp6Kdkm2xo6EhcS0ES4wrnK6MJzYWtTxdpVz3xU+XAAat91LkPmP8rdKrHeMZySXWhh0X5dECELFoMz/Zxbjfyq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301835; c=relaxed/simple;
	bh=3fNehaYq5RSq0T9fxUTcAWJKBRAWyyqOSz3GOvCnoRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY2hodrizU6LlvlwgKFanoB4j+yzUDfRz4RupWs5d6IILwVRPIlx9i5DdNgNy6sFi7bn4e7A602GoGRWOZ7b6TJ6TzhpFqDn7rqkLDzKZl9upppE7S49NG2U9QzmXy5QI6WZsy70mydI55AWGx8INkEeE1C/ykT6dXhybGF69nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0pcrAQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0pcrAQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F89FC116D0;
	Sat, 28 Feb 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301835;
	bh=3fNehaYq5RSq0T9fxUTcAWJKBRAWyyqOSz3GOvCnoRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0pcrAQCykFMLr4F5dsdthd1n3361qaeV70CPaapAx6/2ErJqXwuJh37x4/A4FtVq
	 cbpv2bKfOWbBMPfJukYeCmxeBPC7zcnyVdPE65FpwsPiRGIolX6s4+LFbU2iLsiNV8
	 MidyT8nNEsf8lGtnFnLrHOntTaY1evwlE+8whEq6n0NUdxyxJGucIBDmPunRRea/Cn
	 4DP7s8Vh3LG5bRfyOqjtrxPMjWSpdZrxZQpqQDEyloq+kM1wX5fheT6lSA4j5YZm8c
	 GNik16IPcDjVFyj8uZ4lHXj3LT/czt6oGtozOMs/QusluhNcjZEsBVO3i31r4JqZl9
	 GgyKWmvUm/ddw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/385] power: supply: bq25980: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:55 -0500
Message-ID: <20260228180011.1568201-253-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 0c5e2938bb36d..b3060df9449eb 100644
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

