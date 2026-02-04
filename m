Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E033D994;
	Wed,  4 Feb 2026 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217936; cv=none; b=s2SjB8e9l321/kco+bkTidLN6xhu6HHnOyyNgM8gE5ar3SW5XSlgiFpLHqFQpdgRfdOaGfJ81Tz3rfbF8uprpIkaWd2wXUqC+lvKFF5BoMfPHO0eDYnNk5kcpzn9NB12SQK3G/NQm9DgZN4xKJmGL0hF/2sQUQu3s/vDGPXBJHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217936; c=relaxed/simple;
	bh=N957M9e2gbafWxJ8J2tfYEakRXcsrs96sg+nfiKVfT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKqWMUElQMjwYEpGMPz5CRU/9uH/FiufLJykLI2RgnO28Bs2nCQIejdU7FjT8qli424Pb7FBB9dzuZoxUxPwWLP3t+NiF/K5ceOAA2enPQ8Kr6NTc0KHPbbyUU8vmDp//9tIwJFLjxVra6YkK6DshHRYpgFG0j+lvvUj+fZE9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8ay2gLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8ay2gLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC338C116C6;
	Wed,  4 Feb 2026 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217936;
	bh=N957M9e2gbafWxJ8J2tfYEakRXcsrs96sg+nfiKVfT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8ay2gLB2dpB3KIowOnoq045AFRHLOJ3YcZKU0LZBdZRiZcwHjRWsiVlJXuNIS9w/
	 6l2Uu0nDyybTcLLygSpXuQigWh9uUviNdv7U7/m0wYGD64j259o1a1dOYNTJX1V5GV
	 qnmNm3CaeU6v8Z+kk1qp7GfC2jkvGM+p3U8lZgyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/280] spi: sprd: adi: Use devm_register_restart_handler()
Date: Wed,  4 Feb 2026 15:38:24 +0100
Message-ID: <20260204143914.312290670@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 8e6a43961f24cf841d3c0d199521d0b284d948b9 ]

Use device life-cycle managed register function to simplify probe error
path and eliminate need for explicit remove function.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20231117161006.87734-5-afd@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 22e39c4c12c4e..24f1358e7e8ba 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -139,8 +139,7 @@ struct sprd_adi_data {
 	u32 slave_offset;
 	u32 slave_addr_size;
 	int (*read_check)(u32 val, u32 reg);
-	int (*restart)(struct notifier_block *this,
-		       unsigned long mode, void *cmd);
+	int (*restart)(struct sys_off_data *data);
 	void (*wdg_rst)(void *p);
 };
 
@@ -151,7 +150,6 @@ struct sprd_adi {
 	struct hwspinlock	*hwlock;
 	unsigned long		slave_vbase;
 	unsigned long		slave_pbase;
-	struct notifier_block	restart_handler;
 	const struct sprd_adi_data *data;
 };
 
@@ -371,11 +369,9 @@ static void sprd_adi_set_wdt_rst_mode(void *p)
 #endif
 }
 
-static int sprd_adi_restart(struct notifier_block *this, unsigned long mode,
-				  void *cmd, struct sprd_adi_wdg *wdg)
+static int sprd_adi_restart(struct sprd_adi *sadi, unsigned long mode,
+			    const char *cmd, struct sprd_adi_wdg *wdg)
 {
-	struct sprd_adi *sadi = container_of(this, struct sprd_adi,
-					     restart_handler);
 	u32 val, reboot_mode = 0;
 
 	if (!cmd)
@@ -449,8 +445,7 @@ static int sprd_adi_restart(struct notifier_block *this, unsigned long mode,
 	return NOTIFY_DONE;
 }
 
-static int sprd_adi_restart_sc9860(struct notifier_block *this,
-					   unsigned long mode, void *cmd)
+static int sprd_adi_restart_sc9860(struct sys_off_data *data)
 {
 	struct sprd_adi_wdg wdg = {
 		.base = PMIC_WDG_BASE,
@@ -459,7 +454,7 @@ static int sprd_adi_restart_sc9860(struct notifier_block *this,
 		.wdg_clk = PMIC_CLK_EN,
 	};
 
-	return sprd_adi_restart(this, mode, cmd, &wdg);
+	return sprd_adi_restart(data->cb_data, data->mode, data->cmd, &wdg);
 }
 
 static void sprd_adi_hw_init(struct sprd_adi *sadi)
@@ -591,9 +586,9 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	}
 
 	if (sadi->data->restart) {
-		sadi->restart_handler.notifier_call = sadi->data->restart;
-		sadi->restart_handler.priority = 128;
-		ret = register_restart_handler(&sadi->restart_handler);
+		ret = devm_register_restart_handler(&pdev->dev,
+						    sadi->data->restart,
+						    sadi);
 		if (ret) {
 			dev_err(&pdev->dev, "can not register restart handler\n");
 			goto put_ctlr;
@@ -607,14 +602,6 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static void sprd_adi_remove(struct platform_device *pdev)
-{
-	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
-	struct sprd_adi *sadi = spi_controller_get_devdata(ctlr);
-
-	unregister_restart_handler(&sadi->restart_handler);
-}
-
 static struct sprd_adi_data sc9860_data = {
 	.slave_offset = ADI_10BIT_SLAVE_OFFSET,
 	.slave_addr_size = ADI_10BIT_SLAVE_ADDR_SIZE,
@@ -658,7 +645,6 @@ static struct platform_driver sprd_adi_driver = {
 		.of_match_table = sprd_adi_of_match,
 	},
 	.probe = sprd_adi_probe,
-	.remove_new = sprd_adi_remove,
 };
 module_platform_driver(sprd_adi_driver);
 
-- 
2.51.0



