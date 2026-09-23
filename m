Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1433B535FAB;
	Wed, 23 Sep 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173897; cv=none; b=pXyN1wiauhCQpKl3Ts7h2e4gNAn6V6sfBBJ/i8J685zxhup+Q60uIPcehhiJ8NUhQ4wUUYYPnbaS7Gt2DLlOO5XqftchPELzs/D0hsgNit9IjfEI7yu7yZE6cdLnTy0/yMGavGGU6lJ6NTiRgt3XtAWrt484pghxhHTo3pT0RzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173897; c=relaxed/simple;
	bh=LaRF76Ap974aHCSvSeILc/PItMnHvquwkYUD5NK0Vsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1um4oWAmKrXWO0zpqzn36CdSM7MELjghjbXjktDJmUyGdbnZuTW4rjK1vpvg7O86ghIe373fnUh47n33mXf6Yr7YK8NTHX4aY5RHYK8TUVXKFxETNcWiyNbYHzfHYyMw31ZsCVc6VlPpfOqyAUHCmXOvaa38Ae2Z/dgCBXq1hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QddZADm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QddZADm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DFB1F000FF;
	Wed, 23 Sep 2026 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173895;
	bh=PtEfR3E8sUG2LnCHn1Gl6PNSpmbQeYRbE3WtUD3AUw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QddZADm5gC2c4re/UhzZcaCi2qKHwaw0W+Eh5zdDESThff6mh3MImLLExiaYqwwr1
	 tZBIa1g4yeV0rfOhgOJ8WPWvHwtbRxPUL7qGtJBMh8D9xkTL7zz8EN60j4UQ3Nd0vB
	 yus/a4vGuHTEOMZ1UdFotwMEw0IQBRIcG59ZWi58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 379/438] watchdog: rzv2h: Avoid division by zero
Date: Wed, 23 Sep 2026 16:06:40 +0200
Message-ID: <20260923140654.689783622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 6274281c41efa8dd1aa5234c59ad904ff89d7af4 upstream.

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: f6febd0a30b6 ("watchdog: Add Watchdog Timer driver for RZ/V2H(P)")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-4-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rzv2h_wdt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -278,6 +278,7 @@ static int rzv2h_wdt_probe(struct platfo
 	struct device *dev = &pdev->dev;
 	struct rzv2h_wdt_priv *priv;
 	struct clk *count_clk;
+	unsigned long rate;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -314,8 +315,12 @@ static int rzv2h_wdt_probe(struct platfo
 		return dev_err_probe(dev, -EINVAL, "Invalid count source\n");
 	}
 
+	rate = clk_get_rate(count_clk);
+	if (!rate)
+		return dev_err_probe(dev, -EINVAL, "Invalid clock rate\n");
+
 	priv->wdev.max_hw_heartbeat_ms = (MILLI * priv->of_data->timeout_cycles *
-					  priv->of_data->cks_div) / clk_get_rate(count_clk);
+					  priv->of_data->cks_div) / rate;
 	dev_dbg(dev, "max hw timeout of %dms\n", priv->wdev.max_hw_heartbeat_ms);
 
 	ret = devm_pm_runtime_enable(dev);


