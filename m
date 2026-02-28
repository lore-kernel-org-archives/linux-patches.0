Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30737375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302589; cv=none; b=lXR8VxGe4kaN9NQN9Dyrts26fRwkfHtZVkkFGYyc5GX8VmtVoVdbarKb3lttLCF7Fp8Xi4/qNUgFZQX/5ng3lkpEt1z6OJTBBb3vYeLseuSC/sF+re59cKruemljLC+ELudjoMrJlx88DANaG3YoekWcdEwYBm+v74Zao7EZKjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302589; c=relaxed/simple;
	bh=4SLDZqVFJHJOGwbA+mMds5hIIRJrNsN9DuLkBqsaJ5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5XZnJzzonWOsWGF/POKCgdtC85uVt4yNJp7GgzECudpdkzis+LzZRBtAGqrBeRpTHTQrnRu5tw9g1/GhE3ykD7BfyUVvxcUpWueTwP2FtqKqu8iVlhB6KYbyJOC8e/H+TCIm+qSLzhbSw6jK7hT5Tsuo+QP86sDaDH+y9FhfEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPwfQefM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPwfQefM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952AAC19423;
	Sat, 28 Feb 2026 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302589;
	bh=4SLDZqVFJHJOGwbA+mMds5hIIRJrNsN9DuLkBqsaJ5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPwfQefMtnsFnZc/hZJ1nebV27AaUnRt8p71Nl5S7UIkGzgFJR4sWihGBxKOGajK+
	 SsCUQsxtGURcjUI/UooE70RPklpDdOZRIRKUb/UMHvVquL7go1p4Lw65U4GoWV8Il0
	 tnbsXIXskKHSO6c6rcmyA9Vxcn2fRBEfDZAF906WRa4tpmelLWLGASJfVSxvnoTcKW
	 Qs0fXjDEo+3MrTG5WDEHBSPRqXqdo5J64XZLLvtlGJIi591vCtlZRVELSOY2f7UKY2
	 /B/eCxZehL4P17rBsVle08L6XzWoNN5wH9qctBQhJmaLO7WytSlTbzqM2DBGGdzWle
	 wVubrm2XTBWQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/164] power: supply: bq25980: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:13:58 -0500
Message-ID: <20260228181505.1600663-99-sashal@kernel.org>
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
index 0008c229fd9c7..a93919c4ea275 100644
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

