Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA87309DCC;
	Tue, 16 Dec 2025 12:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887812; cv=none; b=rBhGpAuS63Q/Qk0lFePi0q8+MQpHGEIoqp2m15uYkD3SL2eLyVjia3AqgfNw9rB+7q4UNCD0B5tGfUESPS0ri4cqRz4o2Ab85k3LtHS73Mgle6/Oqow+f4naaCMBHkC7xtfSAKV5OzABRkL85qDtJ35gEZ1emPFWku6I7UG/0tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887812; c=relaxed/simple;
	bh=1r96Tkipo2ALEDeFDHXGef/qvjT200rcIk4i3MkZ5YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDo2lzc0GaXhmt1yOAg1UWqWOgv4JSSqcg8Cs3u731FENLpwY17Y4JDUi72Jww0VR9qxf+IOA32LhdWyTyLOALyCuQD6KZXDk/KwKQzYHmEWJeFEZbhFWskmD+/AMCB7g2r7yjNs+/LcOTbNBqGZ3F4Ja6Oy8VYmiIQYy6TQZ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjkLfhHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjkLfhHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D54C4CEF1;
	Tue, 16 Dec 2025 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887812;
	bh=1r96Tkipo2ALEDeFDHXGef/qvjT200rcIk4i3MkZ5YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjkLfhHSJ+LRuVCAK9wMYe/+Y/x8VEoLzntcU1rSZ1Bi2xZkZHZUscq1y8ODYibhc
	 Zz6IhogOhF2LQMr9l7Y2kvSxqAygZXgp3VMK6EQaYIbT5b1sIh5v8PkEnapVSLpG+i
	 C8NYefcMXDyH7oRZRIeAi0Bf7QSUlRqurvFAjpK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/614] phy: renesas: rcar-gen3-usb2: Fix an error handling path in rcar_gen3_phy_usb2_probe()
Date: Tue, 16 Dec 2025 12:11:51 +0100
Message-ID: <20251216111413.827303458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 662bb179d3381c7c069e44bb177396bcaee31cc8 ]

If an error occurs after the reset_control_deassert(),
reset_control_assert() must be called, as already done in the remove
function.

Use devm_add_action_or_reset() to add the missing call and simplify the
.remove() function accordingly.

While at it, drop struct rcar_gen3_chan::rstc as it is not used aymore.

[claudiu.beznea: removed "struct reset_control *rstc = data;" from
 rcar_gen3_reset_assert(), dropped struct rcar_gen3_chan::rstc]

Fixes: 4eae16375357 ("phy: renesas: rcar-gen3-usb2: Add support to initialize the bus")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20251023135810.1688415-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 3f6b480e10922..a38ead7c8055d 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -134,7 +134,6 @@ struct rcar_gen3_chan {
 	struct extcon_dev *extcon;
 	struct rcar_gen3_phy rphys[NUM_OF_PHYS];
 	struct regulator *vbus;
-	struct reset_control *rstc;
 	struct work_struct work;
 	spinlock_t lock;	/* protects access to hardware and driver data structure. */
 	enum usb_dr_mode dr_mode;
@@ -771,21 +770,31 @@ static enum usb_dr_mode rcar_gen3_get_dr_mode(struct device_node *np)
 	return candidate;
 }
 
+static void rcar_gen3_reset_assert(void *data)
+{
+	reset_control_assert(data);
+}
+
 static int rcar_gen3_phy_usb2_init_bus(struct rcar_gen3_chan *channel)
 {
 	struct device *dev = channel->dev;
+	struct reset_control *rstc;
 	int ret;
 	u32 val;
 
-	channel->rstc = devm_reset_control_array_get_shared(dev);
-	if (IS_ERR(channel->rstc))
-		return PTR_ERR(channel->rstc);
+	rstc = devm_reset_control_array_get_shared(dev);
+	if (IS_ERR(rstc))
+		return PTR_ERR(rstc);
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret)
 		return ret;
 
-	ret = reset_control_deassert(channel->rstc);
+	ret = reset_control_deassert(rstc);
+	if (ret)
+		goto rpm_put;
+
+	ret = devm_add_action_or_reset(dev, rcar_gen3_reset_assert, rstc);
 	if (ret)
 		goto rpm_put;
 
@@ -924,7 +933,6 @@ static void rcar_gen3_phy_usb2_remove(struct platform_device *pdev)
 	if (channel->is_otg_channel)
 		device_remove_file(&pdev->dev, &dev_attr_role);
 
-	reset_control_assert(channel->rstc);
 	pm_runtime_disable(&pdev->dev);
 };
 
-- 
2.51.0



