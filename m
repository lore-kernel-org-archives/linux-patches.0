Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D573A763EC;
	Mon, 15 Apr 2024 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191577; cv=none; b=i3Lw7GD3y5/H7ea/7qAfbJH15aBSl+ael/ByiXi63O4K5wr2ExgMlF1TEfSUNSYG2mQmQVuwMcTXPX++z9Vp0bhWxmRYL3aP7eRJjF2dZsqBs5zGghCOq1qjMQMirak+T1lHbea5qqB6NZ4ZuU14FzneZtaqHd1JAhaeTzLjm2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191577; c=relaxed/simple;
	bh=yXn97Z2K2qVhEDuON5IG6rL3Blb+npK1pEf3XW/a8Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBi2SnLsbGYArCp9HUhgJJtwOwdb4ZjlGBJuM26gv6QyhC9YIVCm9itSU/sjI6sFSQKWvGkxx+qCgL1qrAef0eL+FDaD4X0dib/v6xMOTuTcJO0JRNs6h7OfQJpkwRz5Zv0DS9k+8IZr4LV+hegYTlcezZAhKaLD7MNAHFcrHLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH/cxqQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH/cxqQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED6CC2BD11;
	Mon, 15 Apr 2024 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191577;
	bh=yXn97Z2K2qVhEDuON5IG6rL3Blb+npK1pEf3XW/a8Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH/cxqQWghWIjhH+OQ6ROByr/3YKfvEBDuz7bVU9GeCK8NFBpKSqY1TJXfe3Xs6en
	 M+Haxn6OVWkiKdrI2Hltus6+Ww3H9UDD876nGt9oqJ7hR19w8lyjOoG95PGWvNlm4K
	 4MrFhJoyezUIFXUk4Ne6VoI2Gt+NIwy+Vk4t+PxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/122] mmc: omap: fix broken slot switch lookup
Date: Mon, 15 Apr 2024 16:19:42 +0200
Message-ID: <20240415141953.892925938@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit d4debbcbffa45c3de5df0040af2eea74a9e794a3 ]

The lookup is done before host->dev is initialized. It will always just
fail silently, and the MMC behaviour is totally unpredictable as the switch
is left in an undefined state. Fix that.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-4-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 9fb8995b43a1c..aa40e1a9dc29e 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1384,13 +1384,6 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	if (IS_ERR(host->virt_base))
 		return PTR_ERR(host->virt_base);
 
-	host->slot_switch = gpiod_get_optional(host->dev, "switch",
-					       GPIOD_OUT_LOW);
-	if (IS_ERR(host->slot_switch))
-		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
-				     "error looking up slot switch GPIO\n");
-
-
 	INIT_WORK(&host->slot_release_work, mmc_omap_slot_release_work);
 	INIT_WORK(&host->send_stop_work, mmc_omap_send_stop_work);
 
@@ -1409,6 +1402,12 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
+	host->slot_switch = gpiod_get_optional(host->dev, "switch",
+					       GPIOD_OUT_LOW);
+	if (IS_ERR(host->slot_switch))
+		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
+				     "error looking up slot switch GPIO\n");
+
 	host->id = pdev->id;
 	host->irq = irq;
 	host->phys_base = res->start;
-- 
2.43.0



