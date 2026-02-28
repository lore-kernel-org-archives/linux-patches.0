Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94C34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301834; cv=none; b=iaCwGpIy1cBv3d/2T2nN1C4S1Lf5+VHrTNAUtYPZutjiBBzFoMGxPXtNzyUAMhJRPt4mL71rJ0ARkamK/utV+AOknd4xwgVekLsMUkpOGneNv7BJD9N1EyYJEO/9o7IAIHSvpvJ6c3frNXPu6RC2vURZlTaF+5Js4Gn6P6nu3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301834; c=relaxed/simple;
	bh=N13wIcIMWbXHMXWO02qwysTNALPzf9timKH7iOtw0w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tolst8p4P3n9TUq7RrcY1g4FB25EOo9dAH+52Eerjf3UXRUPgbuudhnusFs1GV2nzYhXI7ZpO2X5mSnL09wYCIue1seoYYCzqtT508/JYb1R2Ga+dAoubLuQuPa2UqBLhB2N+xdB+W0N2NfPBFR21ZaHeAcM6T5nq5h0YkszqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpR+vfgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpR+vfgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E638C116D0;
	Sat, 28 Feb 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301834;
	bh=N13wIcIMWbXHMXWO02qwysTNALPzf9timKH7iOtw0w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpR+vfgNAjEYCRlxd4h2fsF/RcHjop5SpI4a+5rffUzdU+iE1OSfAGNG3iOBApLAu
	 EjXKxaY9kQ/nT5iCMo78ulRMvt6+SSEV+rO0onWGh//BMx4esPclYmlX2N3p2jdchj
	 E3u8kLMX8r1hiLdvrzcXluBAYtv0qiM5USYTFYawlsmVMpCxjsMKQDa5OLe0Pf6u2X
	 PPuUzL33eOQimdz57cxF+ieODJKHqTZWpDabcmFYHrjXZogIyd8PUuvY1HWey2qBVH
	 JS5QU3hRq8fXesHweYQ8JAXJFtw6IVnJ5rZX2My+oXHFtl05YF65n8KGmax7FVaPo8
	 YuLp0qmGzcrSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/385] power: supply: bq256xx: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:54 -0500
Message-ID: <20260228180011.1568201-252-sashal@kernel.org>
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
index 5514d1896bb84..b47b73ed642e5 100644
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

