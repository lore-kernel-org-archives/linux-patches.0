Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F5D23D7FA;
	Tue, 26 Aug 2025 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207985; cv=none; b=NryzSm/fHsMPc+LeUVc1/UCcvihxIldDlpOsKVgboz9MAGzStE38GzW1W+r47jmdQD6yLpwCecJUnvIuz/sVbjlA69FBCNwpBJ+dNT4U2K13eDrPuQ1KjvAWifDp1wyt9L3hH8FdAUsRuJFFx6H95WENYm9pNPcUtnLp0FrStC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207985; c=relaxed/simple;
	bh=vMGhdW61XTeLYLLaEPekexlxdrR3PLgSvV9RCCLxV5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMCtL5z7Hz30Gd4v0LT6o+dz9uowp5X/3oiFBwRTt01n/i+pO3455dBVa//VIq9SHb56TfrjKpFzpiwFwLrwZEFpSGIBwtjKAiNnCEuVUN6bdDJL8k9scKkWQGAwsvPeWq8z8XQkTp0vItPHxUPO0OzZUaalUKwIOzOd+TTOUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAu5BvnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAu5BvnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276EC4CEF1;
	Tue, 26 Aug 2025 11:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207984;
	bh=vMGhdW61XTeLYLLaEPekexlxdrR3PLgSvV9RCCLxV5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAu5BvnE2GchHKlIBDRtpt0ywtI9fnBQc/1huECp4lXtY7GoTewQZJa6A6ySlrR0/
	 bAkPu8/CFm/Vk+D1tJ1lpSl7ZUk/GoMMSPndo73grQWBrkV66ciCuc7wlFJhm34pp7
	 NYXIEegT78q51jxt80Ajo/x8NiId/AELXkuZF6G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 394/457] regulator: pca9450: Use devm_register_sys_off_handler
Date: Tue, 26 Aug 2025 13:11:18 +0200
Message-ID: <20250826110947.032210009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 447be50598c05499f7ccc2b1f6ddb3da30f8099a ]

With module test, there is error dump:
------------[ cut here ]------------
  notifier callback pca9450_i2c_restart_handler already registered
  WARNING: kernel/notifier.c:23 at notifier_chain_register+0x5c/0x88,
  CPU#0: kworker/u16:3/50
  Call trace:
  notifier_chain_register+0x5c/0x88 (P)
  atomic_notifier_chain_register+0x30/0x58
  register_restart_handler+0x1c/0x28
  pca9450_i2c_probe+0x418/0x538
  i2c_device_probe+0x220/0x3d0
  really_probe+0x114/0x410
  __driver_probe_device+0xa0/0x150
  driver_probe_device+0x40/0x114
  __device_attach_driver+0xd4/0x12c

So use devm_register_sys_off_handler to let kernel handle the resource
free to avoid kernel dump.

Fixes: 6157e62b07d9 ("regulator: pca9450: Add restart handler")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20250815-pca9450-v1-1-7748e362dc97@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 14d19a6d6655..49ff762eb33e 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -34,7 +34,6 @@ struct pca9450 {
 	struct device *dev;
 	struct regmap *regmap;
 	struct gpio_desc *sd_vsel_gpio;
-	struct notifier_block restart_nb;
 	enum pca9450_chip_type type;
 	unsigned int rcnt;
 	int irq;
@@ -967,10 +966,9 @@ static irqreturn_t pca9450_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int pca9450_i2c_restart_handler(struct notifier_block *nb,
-				unsigned long action, void *data)
+static int pca9450_i2c_restart_handler(struct sys_off_data *data)
 {
-	struct pca9450 *pca9450 = container_of(nb, struct pca9450, restart_nb);
+	struct pca9450 *pca9450 = data->cb_data;
 	struct i2c_client *i2c = container_of(pca9450->dev, struct i2c_client, dev);
 
 	dev_dbg(&i2c->dev, "Restarting device..\n");
@@ -1128,10 +1126,9 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	pca9450->sd_vsel_fixed_low =
 		of_property_read_bool(ldo5->dev.of_node, "nxp,sd-vsel-fixed-low");
 
-	pca9450->restart_nb.notifier_call = pca9450_i2c_restart_handler;
-	pca9450->restart_nb.priority = PCA9450_RESTART_HANDLER_PRIORITY;
-
-	if (register_restart_handler(&pca9450->restart_nb))
+	if (devm_register_sys_off_handler(&i2c->dev, SYS_OFF_MODE_RESTART,
+					  PCA9450_RESTART_HANDLER_PRIORITY,
+					  pca9450_i2c_restart_handler, pca9450))
 		dev_warn(&i2c->dev, "Failed to register restart handler\n");
 
 	dev_info(&i2c->dev, "%s probed.\n",
-- 
2.50.1



