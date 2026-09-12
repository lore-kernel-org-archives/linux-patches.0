Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFE5390615;
	Sat, 12 Sep 2026 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230872; cv=none; b=e6XdXOxZQEpru8wR54C8T8EtIyIW6eg7DG1r6n0r8nMCTFjKzazcX6AkjLuB1C12Esu603pRKvZrDEpsbPS6tChLfXP5yWPZRMQloXUtKM2FdLtWJYs+Pp7pCfmOvZJmm2WMwZqd+iIz8iArH23My6KaQuf2F8+ofBV1I+9HJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230872; c=relaxed/simple;
	bh=zkJj8y/q3WI6DfEudbnm6CW+Fh5enR/WF0uYH7BT6CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bK0fZo0OUqKrdQM67dDD7vb3jqoayr1uzb3sGD1OroicKByG0hyAeEQNRSNDYW+AXDhcKZOupMFktcTa5C2kelJbd5erxRgrgWHNZbiRBU75+HorOPuUxfGMsVqP7oPfHMDhlbhliOVxTho8hBftFDLv1wR7uoZRRldosmTOP/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkdEkWW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkdEkWW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443861F000FF;
	Sat, 12 Sep 2026 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230871;
	bh=wJ8mV2lnROyUhuI9eEHvYf7NEP4MIAka87WJjBU5eGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkdEkWW7FKiRN8qzUQ7QniaHh0UGgVcxvy53GHjaLCe/DJtqasJflEzrRC2aj9S5j
	 nPEfKXhEKKunwuOLfKg61/8gqDo+xRblnGMXW3ZDYa4Gh0Gx5/oQD2zOZ4GPL11BXo
	 CY0YpOcNEoXUhdXH6+1mUmJKMyOP0gr/wj4gqquQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0884/1191] drm/sun4i: tcon-top: Keep mixer routes distinct
Date: Sat, 12 Sep 2026 09:00:12 +0200
Message-ID: <20260912065608.096626380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 62bac3202042a8cfd4d4969a6d057cebd8b7cc1a ]

Both mixer selectors reset to TCON 0. Selecting the same TCON for both
mixers causes black or corrupted output.

When a route would collide, park the other mixer on another described
TCON, or an unused selector if none exists.

Since the TCON index is now used as a shift, also reject negative
values.

Tested on Orange Pi 3 with TCON_LCD0 and TCON_TV0.

Link: https://lore.kernel.org/linux-sunxi/Zn8GVkpwXwhaUFno@titan/
Link: https://lore.kernel.org/linux-sunxi/20241108-tcon_fix-v1-1-616218cc0d5f@jookia.org/
Fixes: 05db311a792d ("drm/sun4i: tcon-top: Add helpers for mux switching")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/52eb247169b268054302afa71e598add0b04748d.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_tcon_top.c | 71 +++++++++++++++++++++-----
 drivers/gpu/drm/sun4i/sun8i_tcon_top.h |  6 +++
 2 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_tcon_top.c b/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
index da97682b68351..2e5d673750758 100644
--- a/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
+++ b/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
@@ -25,6 +25,49 @@ static bool sun8i_tcon_top_node_is_tcon_top(struct device_node *node)
 	return !!of_match_node(sun8i_tcon_top_of_table, node);
 }
 
+static unsigned int sun8i_tcon_top_get_tcon_map(struct device_node *node)
+{
+	static const u32 out_ports[] = {
+		TCON_TOP_MIXER0_OUT_PORT,
+		TCON_TOP_MIXER1_OUT_PORT,
+	};
+	unsigned int i, map = 0;
+
+	for (i = 0; i < ARRAY_SIZE(out_ports); i++) {
+		struct device_node *port;
+
+		port = of_graph_get_port_by_id(node, out_ports[i]);
+		if (!port)
+			continue;
+
+		for_each_of_graph_port_endpoint(port, ep) {
+			struct of_endpoint endpoint;
+
+			if (of_graph_parse_endpoint(ep, &endpoint))
+				continue;
+
+			if (endpoint.id < TCON_TOP_PORT_TCON_NUM)
+				map |= BIT(endpoint.id);
+		}
+
+		of_node_put(port);
+	}
+
+	return map;
+}
+
+static unsigned int sun8i_tcon_top_park_index(struct sun8i_tcon_top *tcon_top,
+					      int tcon)
+{
+	unsigned int candidates;
+
+	candidates = tcon_top->tcon_map & ~BIT(tcon);
+	if (!candidates)
+		candidates = GENMASK(TCON_TOP_PORT_TCON_NUM - 1, 0) & ~BIT(tcon);
+
+	return ffs(candidates) - 1;
+}
+
 int sun8i_tcon_top_set_hdmi_src(struct device *dev, int tcon)
 {
 	struct sun8i_tcon_top *tcon_top = dev_get_drvdata(dev);
@@ -57,6 +100,7 @@ EXPORT_SYMBOL(sun8i_tcon_top_set_hdmi_src);
 int sun8i_tcon_top_de_config(struct device *dev, int mixer, int tcon)
 {
 	struct sun8i_tcon_top *tcon_top = dev_get_drvdata(dev);
+	u32 mixer_msk, other_msk;
 	unsigned long flags;
 	u32 reg;
 
@@ -70,21 +114,27 @@ int sun8i_tcon_top_de_config(struct device *dev, int mixer, int tcon)
 		return -EINVAL;
 	}
 
-	if (tcon > 3) {
-		dev_err(dev, "TCON index is too high!\n");
+	if (tcon < 0 || tcon >= TCON_TOP_PORT_TCON_NUM) {
+		dev_err(dev, "TCON index is invalid!\n");
 		return -EINVAL;
 	}
 
+	mixer_msk = mixer ? TCON_TOP_PORT_DE1_MSK : TCON_TOP_PORT_DE0_MSK;
+	other_msk = mixer ? TCON_TOP_PORT_DE0_MSK : TCON_TOP_PORT_DE1_MSK;
+
 	spin_lock_irqsave(&tcon_top->reg_lock, flags);
 
 	reg = readl(tcon_top->regs + TCON_TOP_PORT_SEL_REG);
-	if (mixer == 0) {
-		reg &= ~TCON_TOP_PORT_DE0_MSK;
-		reg |= FIELD_PREP(TCON_TOP_PORT_DE0_MSK, tcon);
-	} else {
-		reg &= ~TCON_TOP_PORT_DE1_MSK;
-		reg |= FIELD_PREP(TCON_TOP_PORT_DE1_MSK, tcon);
+
+	reg &= ~mixer_msk;
+	reg |= field_prep(mixer_msk, tcon);
+
+	if (field_get(other_msk, reg) == tcon) {
+		reg &= ~other_msk;
+		reg |= field_prep(other_msk,
+				  sun8i_tcon_top_park_index(tcon_top, tcon));
 	}
+
 	writel(reg, tcon_top->regs + TCON_TOP_PORT_SEL_REG);
 
 	spin_unlock_irqrestore(&tcon_top->reg_lock, flags);
@@ -142,6 +192,7 @@ static int sun8i_tcon_top_bind(struct device *dev, struct device *master,
 	if (!clk_data)
 		return -ENOMEM;
 	tcon_top->clk_data = clk_data;
+	tcon_top->tcon_map = sun8i_tcon_top_get_tcon_map(dev->of_node);
 
 	spin_lock_init(&tcon_top->reg_lock);
 
@@ -174,10 +225,6 @@ static int sun8i_tcon_top_bind(struct device *dev, struct device *master,
 		goto err_assert_reset;
 	}
 
-	/*
-	 * At least on H6, some registers have some bits set by default
-	 * which may cause issues. Clear them here.
-	 */
 	writel(0, regs + TCON_TOP_PORT_SEL_REG);
 	writel(0, regs + TCON_TOP_GATE_SRC_REG);
 
diff --git a/drivers/gpu/drm/sun4i/sun8i_tcon_top.h b/drivers/gpu/drm/sun4i/sun8i_tcon_top.h
index 0390584a330e5..2b887470a49f8 100644
--- a/drivers/gpu/drm/sun4i/sun8i_tcon_top.h
+++ b/drivers/gpu/drm/sun4i/sun8i_tcon_top.h
@@ -14,6 +14,10 @@
 #define TCON_TOP_PORT_SEL_REG		0x1C
 #define TCON_TOP_PORT_DE0_MSK			GENMASK(1, 0)
 #define TCON_TOP_PORT_DE1_MSK			GENMASK(5, 4)
+#define TCON_TOP_PORT_TCON_NUM			4
+
+#define TCON_TOP_MIXER0_OUT_PORT		1
+#define TCON_TOP_MIXER1_OUT_PORT		3
 
 #define TCON_TOP_GATE_SRC_REG		0x20
 #define TCON_TOP_HDMI_SRC_MSK			GENMASK(29, 28)
@@ -29,6 +33,8 @@ struct sun8i_tcon_top {
 	void __iomem			*regs;
 	struct reset_control		*rst;
 
+	unsigned int			tcon_map;
+
 	/*
 	 * spinlock is used to synchronize access to same
 	 * register where multiple clock gates can be set.
-- 
2.53.0



