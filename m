Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D201A76A7;
	Thu, 15 Aug 2024 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733021; cv=none; b=J1MAOdvsd7D5na1uwNJWpH1yPr+FicBwSbraInAhMn2wH7q4+ocIIP5k3sZWlhkwfimNd/6nmKNMgeT4ubb8UjAWmizc2VNNFpUpDL/6/tuapi4rsG91Tx4pUxCnhEyX7t41pS4z4xTCKfREjAK0Sgskv2y3Hr/do1QIMZssh+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733021; c=relaxed/simple;
	bh=eIBkfy1WlOtmTvUhXl9HPM2Zzd5MHw1IK9p4r+PNhXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1F/miPZpzhVg9qLHm90A1UOOXyz+ntMbYvQLI7OcEvJFHwRszldW7BoPBDtnXEJLfupagnnmgtP3zcV55KiBLg4CPPyy1g3V4hNYgWzX1fxDsYKE6swG9L2kmHvu3p+EDMPOjwHFgsORSyVCzXSI35yClh3REoggfVraf+07uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRs9b1L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRs9b1L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18EBC32786;
	Thu, 15 Aug 2024 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733021;
	bh=eIBkfy1WlOtmTvUhXl9HPM2Zzd5MHw1IK9p4r+PNhXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRs9b1L2CelDfwcIOurQ4tku0ma34VyGfCtIp7s/NWPNhVAz2rRsiDLQ1A3+147SJ
	 RNKAsfU5DITc3vdI49cM1tgInjlbuZclkXdZWDtZ4KqKUqgtAfB0ieIMlfGjwHZpr0
	 7Y7vU8HXlIBiRnUavbfjR0D9ZQqvKz0/qvRBLHGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianggui Song <qianggui.song@amlogic.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/352] irqchip/meson-gpio: support more than 8 channels gpio irq
Date: Thu, 15 Aug 2024 15:26:22 +0200
Message-ID: <20240815131931.669988100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianggui Song <qianggui.song@amlogic.com>

[ Upstream commit cc311074f681443266ed9f5969a5b5a0e833c5bc ]

Current meson gpio irqchip driver only support 8 channels for gpio irq
line, later chips may have more then 8 channels, so need to modify code
to support more.

Signed-off-by: Qianggui Song <qianggui.song@amlogic.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220225055207.1048-3-qianggui.song@amlogic.com
Stable-dep-of: f872d4af79fe ("irqchip/meson-gpio: Convert meson_gpio_irq_controller::lock to 'raw_spinlock_t'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-meson-gpio.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-meson-gpio.c b/drivers/irqchip/irq-meson-gpio.c
index e50676ce2ec84..89dab14406e69 100644
--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -16,7 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
-#define NUM_CHANNEL 8
+#define MAX_NUM_CHANNEL 64
 #define MAX_INPUT_MUX 256
 
 #define REG_EDGE_POL	0x00
@@ -60,6 +60,7 @@ struct irq_ctl_ops {
 
 struct meson_gpio_irq_params {
 	unsigned int nr_hwirq;
+	unsigned int nr_channels;
 	bool support_edge_both;
 	unsigned int edge_both_offset;
 	unsigned int edge_single_offset;
@@ -81,6 +82,7 @@ struct meson_gpio_irq_params {
 	.edge_single_offset = 0,				\
 	.pol_low_offset = 16,					\
 	.pin_sel_mask = 0xff,					\
+	.nr_channels = 8,					\
 
 #define INIT_MESON_A1_COMMON_DATA(irqs)				\
 	INIT_MESON_COMMON(irqs, meson_a1_gpio_irq_init,		\
@@ -90,6 +92,7 @@ struct meson_gpio_irq_params {
 	.edge_single_offset = 8,				\
 	.pol_low_offset = 0,					\
 	.pin_sel_mask = 0x7f,					\
+	.nr_channels = 8,					\
 
 static const struct meson_gpio_irq_params meson8_params = {
 	INIT_MESON8_COMMON_DATA(134)
@@ -136,8 +139,8 @@ static const struct of_device_id meson_irq_gpio_matches[] = {
 struct meson_gpio_irq_controller {
 	const struct meson_gpio_irq_params *params;
 	void __iomem *base;
-	u32 channel_irqs[NUM_CHANNEL];
-	DECLARE_BITMAP(channel_map, NUM_CHANNEL);
+	u32 channel_irqs[MAX_NUM_CHANNEL];
+	DECLARE_BITMAP(channel_map, MAX_NUM_CHANNEL);
 	spinlock_t lock;
 };
 
@@ -207,8 +210,8 @@ meson_gpio_irq_request_channel(struct meson_gpio_irq_controller *ctl,
 	spin_lock_irqsave(&ctl->lock, flags);
 
 	/* Find a free channel */
-	idx = find_first_zero_bit(ctl->channel_map, NUM_CHANNEL);
-	if (idx >= NUM_CHANNEL) {
+	idx = find_first_zero_bit(ctl->channel_map, ctl->params->nr_channels);
+	if (idx >= ctl->params->nr_channels) {
 		spin_unlock_irqrestore(&ctl->lock, flags);
 		pr_err("No channel available\n");
 		return -ENOSPC;
@@ -451,10 +454,10 @@ static int __init meson_gpio_irq_parse_dt(struct device_node *node,
 	ret = of_property_read_variable_u32_array(node,
 						  "amlogic,channel-interrupts",
 						  ctl->channel_irqs,
-						  NUM_CHANNEL,
-						  NUM_CHANNEL);
+						  ctl->params->nr_channels,
+						  ctl->params->nr_channels);
 	if (ret < 0) {
-		pr_err("can't get %d channel interrupts\n", NUM_CHANNEL);
+		pr_err("can't get %d channel interrupts\n", ctl->params->nr_channels);
 		return ret;
 	}
 
@@ -509,7 +512,7 @@ static int __init meson_gpio_irq_of_init(struct device_node *node,
 	}
 
 	pr_info("%d to %d gpio interrupt mux initialized\n",
-		ctl->params->nr_hwirq, NUM_CHANNEL);
+		ctl->params->nr_hwirq, ctl->params->nr_channels);
 
 	return 0;
 
-- 
2.43.0



