Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5662264A5;
	Tue, 17 Jun 2025 16:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177366; cv=none; b=X77ZisLqyM92Z3ia2/QeJa+kAAu4QbtD8iCw5rx0c9EC+5YQf/NXhMW3Ts+jNbyuiHhgvVSvKd9xyExqE1Bg4BLl5Jv3VQM5tq+8F2fOHMZ786jaLyxjZUUV55Ewq526ckJLV2DgCPUIXBfmKn26D6xQQG6RjdVl0yqTl+EXpIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177366; c=relaxed/simple;
	bh=YKeYZ8kqf1Z1zTA9kS+3VvPtptV87jOKvIu3zcRwmE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9lwd2shjedWH/zBlke/Z4/7yTaINkYZfbhtnIBzYcdKBt38Gh1J4Rg5oc5e+4Td8RNDxvMlqx4WSg7dGgt9PkWoS7pmaDqRKuHioXkVuKb6X6/3UQiWOGTNVvS6yMwDvN7+GVk3WFfie33iVXWNIcneN/ykrvmq0KHzNiZLPQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxOekMtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxOekMtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF300C4CEE3;
	Tue, 17 Jun 2025 16:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177366;
	bh=YKeYZ8kqf1Z1zTA9kS+3VvPtptV87jOKvIu3zcRwmE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxOekMtcjm55+Dr/WjgPN0C1z4hzz478zoffJjOG4kj5dudW7lA7u1e6fx//HtNzR
	 9rx3n69MiFyR+tvtzM42iTX744QSF5CdpqcBVi+zUkhG04YvGy4Uwpwq6GIwY4aAhN
	 mZTkqVcXbTat0lWxsw8Aeo67lXIDiJi71S3SoBbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/512] counter: interrupt-cnt: Protect enable/disable OPs with mutex
Date: Tue, 17 Jun 2025 17:24:59 +0200
Message-ID: <20250617152433.105329123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 7351312632e831e51383f48957d47712fae791ef ]

Enable/disable seems to be racy on SMP, consider the following scenario:

CPU0					CPU1

interrupt_cnt_enable_write(true)
{
	if (priv->enabled == enable)
		return 0;

	if (enable) {
		priv->enabled = true;
					interrupt_cnt_enable_write(false)
					{
						if (priv->enabled == enable)
							return 0;

						if (enable) {
							priv->enabled = true;
							enable_irq(priv->irq);
						} else {
							disable_irq(priv->irq)
							priv->enabled = false;
						}
		enable_irq(priv->irq);
	} else {
		disable_irq(priv->irq);
		priv->enabled = false;
	}

The above would result in priv->enabled == false, but IRQ left enabled.
Protect both write (above race) and read (to propagate the value on SMP)
callbacks with a mutex.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Fixes: a55ebd47f21f ("counter: add IRQ or GPIO based counter")
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20250331163642.2382651-1-alexander.sverdlin@siemens.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/interrupt-cnt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/counter/interrupt-cnt.c b/drivers/counter/interrupt-cnt.c
index 229473855c5b3..bc762ba87a19b 100644
--- a/drivers/counter/interrupt-cnt.c
+++ b/drivers/counter/interrupt-cnt.c
@@ -3,12 +3,14 @@
  * Copyright (c) 2021 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
  */
 
+#include <linux/cleanup.h>
 #include <linux/counter.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
 
@@ -19,6 +21,7 @@ struct interrupt_cnt_priv {
 	struct gpio_desc *gpio;
 	int irq;
 	bool enabled;
+	struct mutex lock;
 	struct counter_signal signals;
 	struct counter_synapse synapses;
 	struct counter_count cnts;
@@ -41,6 +44,8 @@ static int interrupt_cnt_enable_read(struct counter_device *counter,
 {
 	struct interrupt_cnt_priv *priv = counter_priv(counter);
 
+	guard(mutex)(&priv->lock);
+
 	*enable = priv->enabled;
 
 	return 0;
@@ -51,6 +56,8 @@ static int interrupt_cnt_enable_write(struct counter_device *counter,
 {
 	struct interrupt_cnt_priv *priv = counter_priv(counter);
 
+	guard(mutex)(&priv->lock);
+
 	if (priv->enabled == enable)
 		return 0;
 
@@ -227,6 +234,8 @@ static int interrupt_cnt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	mutex_init(&priv->lock);
+
 	ret = devm_counter_add(dev, counter);
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to add counter\n");
-- 
2.39.5



