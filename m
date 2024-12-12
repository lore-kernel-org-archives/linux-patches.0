Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C83A217F46;
	Thu, 12 Dec 2024 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017751; cv=none; b=UpnFJxBqo1k1ydggtftAcfq4aEMCIV/HLBaGZz1XFyk9k9rHa7YFu3xjjLdXNM2Wjsmg33Y1unvKAnqgNK26dD93ySjG5w1lznh4Hh2fqBEEceQlUMGNzhkIKVTXombP3j9/OCyshzTJyWFi5mvy+HTk3dPJjGEf/O3ncA9QRCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017751; c=relaxed/simple;
	bh=2/REeOAqhGLWIcAb1P1Cfe03SKOQsJeMohJRfVKq7DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCodpzJn66AKSLW52zIk2xeQtVo75v2Sbkg+LasgHry/5fnI/4y3d0Kz6vg29OUJglq+hKnfFeHpoDMLavzaxt4agdTYKQQ3X/UNRR7NntWNtXZwEpArijG422VGj8QRewuduWcN82/AQVQkssV/o+/Q277aRv875zCMsr7Ektg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLsEVWMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLsEVWMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D017C4CECE;
	Thu, 12 Dec 2024 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017751;
	bh=2/REeOAqhGLWIcAb1P1Cfe03SKOQsJeMohJRfVKq7DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLsEVWMTMlF5ehwUGH23rHmYX4Da8tmzjcw1ZvkvjP9jqza2ilwZZhWVpvrUFR3MV
	 dPzbrFW0tX4TtUclG3OxcG3DdlazXpl8vewBslPIEEHwuucvJIVtfXZ3yX3EtJ/Kof
	 YMhQUxsomqxkJQNn5q/x9GUnkpldjhsBNosLHisw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <frank.li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/356] i3c: master: svc: use slow speed for first broadcast address
Date: Thu, 12 Dec 2024 15:57:01 +0100
Message-ID: <20241212144248.656016177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit 20ade67bb1645f5ce8f37fa79ddfebbc5b5b24ef ]

I3C controller should support adjusting open drain timing for the first
broadcast address to make I3C device working as a i2c device can see slow
broadcast address to close its Spike Filter to change working at i3c mode.

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <frank.li@nxp.com>
Link: https://lore.kernel.org/r/20240910051626.4052552-2-carlos.song@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 52 +++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 139b51a575366..97d03d755a61f 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -182,6 +182,7 @@ struct svc_i3c_regs_save {
  * @ibi.lock: IBI lock
  * @lock: Transfer lock, protect between IBI work thread and callbacks from master
  * @enabled_events: Bit masks for enable events (IBI, HotJoin).
+ * @mctrl_config: Configuration value in SVC_I3C_MCTRL for setting speed back.
  */
 struct svc_i3c_master {
 	struct i3c_master_controller base;
@@ -212,6 +213,7 @@ struct svc_i3c_master {
 	} ibi;
 	struct mutex lock;
 	int enabled_events;
+	u32 mctrl_config;
 };
 
 /**
@@ -529,6 +531,54 @@ static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int svc_i3c_master_set_speed(struct i3c_master_controller *m,
+				     enum i3c_open_drain_speed speed)
+{
+	struct svc_i3c_master *master = to_svc_i3c_master(m);
+	struct i3c_bus *bus = i3c_master_get_bus(&master->base);
+	u32 ppbaud, odbaud, odhpp, mconfig;
+	unsigned long fclk_rate;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(master->dev);
+	if (ret < 0) {
+		dev_err(master->dev, "<%s> Cannot get runtime PM.\n", __func__);
+		return ret;
+	}
+
+	switch (speed) {
+	case I3C_OPEN_DRAIN_SLOW_SPEED:
+		fclk_rate = clk_get_rate(master->fclk);
+		if (!fclk_rate) {
+			ret = -EINVAL;
+			goto rpm_out;
+		}
+		/*
+		 * Set 50% duty-cycle I2C speed to I3C OPEN-DRAIN mode, so the first
+		 * broadcast address is visible to all I2C/I3C devices on the I3C bus.
+		 * I3C device working as a I2C device will turn off its 50ns Spike
+		 * Filter to change to I3C mode.
+		 */
+		mconfig = master->mctrl_config;
+		ppbaud = FIELD_GET(GENMASK(11, 8), mconfig);
+		odhpp = 0;
+		odbaud = DIV_ROUND_UP(fclk_rate, bus->scl_rate.i2c * (2 + 2 * ppbaud)) - 1;
+		mconfig &= ~GENMASK(24, 16);
+		mconfig |= SVC_I3C_MCONFIG_ODBAUD(odbaud) | SVC_I3C_MCONFIG_ODHPP(odhpp);
+		writel(mconfig, master->regs + SVC_I3C_MCONFIG);
+		break;
+	case I3C_OPEN_DRAIN_NORMAL_SPEED:
+		writel(master->mctrl_config, master->regs + SVC_I3C_MCONFIG);
+		break;
+	}
+
+rpm_out:
+	pm_runtime_mark_last_busy(master->dev);
+	pm_runtime_put_autosuspend(master->dev);
+
+	return ret;
+}
+
 static int svc_i3c_master_bus_init(struct i3c_master_controller *m)
 {
 	struct svc_i3c_master *master = to_svc_i3c_master(m);
@@ -611,6 +661,7 @@ static int svc_i3c_master_bus_init(struct i3c_master_controller *m)
 	      SVC_I3C_MCONFIG_I2CBAUD(i2cbaud);
 	writel(reg, master->regs + SVC_I3C_MCONFIG);
 
+	master->mctrl_config = reg;
 	/* Master core's registration */
 	ret = i3c_master_get_free_addr(m, 0);
 	if (ret < 0)
@@ -1620,6 +1671,7 @@ static const struct i3c_master_controller_ops svc_i3c_master_ops = {
 	.disable_ibi = svc_i3c_master_disable_ibi,
 	.enable_hotjoin = svc_i3c_master_enable_hotjoin,
 	.disable_hotjoin = svc_i3c_master_disable_hotjoin,
+	.set_speed = svc_i3c_master_set_speed,
 };
 
 static int svc_i3c_master_prepare_clks(struct svc_i3c_master *master)
-- 
2.43.0



