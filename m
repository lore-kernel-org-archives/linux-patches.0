Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC27118B0A;
	Wed, 25 Feb 2026 01:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983328; cv=none; b=sd1RIbpqRWSJm8JCGxRJFE0pP1nTP20/cbYwjnQ1wpObysbB9oozzFcjIifq2mFJyLLnNGyDaGu5oH4WU8JOyPfoRWQMZK0uXjtNFmhlUgjHfrQLwDudocfieMVQq6RaFByE8AiAJd85L0bhCloAxEIuraP2Bnnp0+AffUSh4vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983328; c=relaxed/simple;
	bh=tBL4dPxMXRGnZGs5ea/HFXIzzMDdvypmzNdy4tHS3zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H13AHHKOfk6mpwYEiPubWCJvhbFuMJvUMnaghNg78aJKufgU+JlQFnIOuKBJzQGqXD0Vy5IJw+qocQQrd76VN6Fb/uXU1sk/RmIa34H9L8oypSDc7HEn7r+dduah2ddGfAsodBgq+xmIzUlDHfbQt917KaPl6xq+u3Mg3IWxxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beGa+qaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beGa+qaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E69C116D0;
	Wed, 25 Feb 2026 01:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983328;
	bh=tBL4dPxMXRGnZGs5ea/HFXIzzMDdvypmzNdy4tHS3zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beGa+qaHQ8daKLroCoRnwNs2J39Hwqmv49XKY9z6CR8u0uvnAiPWCUz0fENxsPRk0
	 rCsAcJzuOvaK/QVIk4odq9pYw64slgkmKHq9f0WhOVVAdYsVKCGcyKkspF38fX4D8M
	 eF/VeOQUX8FJEoWY4/GVIs3yqjGsgaajQY4vaPYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 460/781] power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:29 -0800
Message-ID: <20260225012411.002069726@linuxfoundation.org>
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

[ Upstream commit 39fe0eac6d755ef215026518985fcf8de9360e9e ]

In `probe()`, `request_irq()` is called before allocating/registering a
`power_supply` handle. If an interrupt is fired between the call to
`request_irq()` and `power_supply_register()`, the `power_supply` handle
will be used uninitialized in `power_supply_changed()` in
`wm97xx_bat_update()` (triggered from the interrupt handler). This will
lead to a `NULL` pointer dereference since

Fix this racy `NULL` pointer dereference by making sure the IRQ is
requested _after_ the registration of the `power_supply` handle. Since
the IRQ is the last thing requests in the `probe()` now, remove the
error path for freeing it. Instead add one for unregistering the
`power_supply` handle when IRQ request fails.

Fixes: 7c87942aef52 ("wm97xx_battery: Use irq to detect charger state")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/97b55f0479a932eea7213844bf66f28a974e27a2.1766270196.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/wm97xx_battery.c | 34 +++++++++++++++------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/power/supply/wm97xx_battery.c b/drivers/power/supply/wm97xx_battery.c
index b3b0c37a9dd2d..f00722c88c6fe 100644
--- a/drivers/power/supply/wm97xx_battery.c
+++ b/drivers/power/supply/wm97xx_battery.c
@@ -178,12 +178,6 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 				     "failed to get charge GPIO\n");
 	if (charge_gpiod) {
 		gpiod_set_consumer_name(charge_gpiod, "BATT CHRG");
-		ret = request_irq(gpiod_to_irq(charge_gpiod),
-				wm97xx_chrg_irq, 0,
-				"AC Detect", dev);
-		if (ret)
-			return dev_err_probe(&dev->dev, ret,
-					     "failed to request GPIO irq\n");
 		props++;	/* POWER_SUPPLY_PROP_STATUS */
 	}
 
@@ -199,10 +193,8 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 		props++;	/* POWER_SUPPLY_PROP_VOLTAGE_MIN */
 
 	prop = kcalloc(props, sizeof(*prop), GFP_KERNEL);
-	if (!prop) {
-		ret = -ENOMEM;
-		goto err3;
-	}
+	if (!prop)
+		return -ENOMEM;
 
 	prop[i++] = POWER_SUPPLY_PROP_PRESENT;
 	if (charge_gpiod)
@@ -236,15 +228,27 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 		schedule_work(&bat_work);
 	} else {
 		ret = PTR_ERR(bat_psy);
-		goto err4;
+		goto free;
+	}
+
+	if (charge_gpiod) {
+		ret = request_irq(gpiod_to_irq(charge_gpiod), wm97xx_chrg_irq,
+				  0, "AC Detect", dev);
+		if (ret) {
+			dev_err_probe(&dev->dev, ret,
+				      "failed to request GPIO irq\n");
+			goto unregister;
+		}
 	}
 
 	return 0;
-err4:
+
+unregister:
+	power_supply_unregister(bat_psy);
+
+free:
 	kfree(prop);
-err3:
-	if (charge_gpiod)
-		free_irq(gpiod_to_irq(charge_gpiod), dev);
+
 	return ret;
 }
 
-- 
2.51.0



