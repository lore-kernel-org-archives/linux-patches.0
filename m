Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7DF33A712;
	Fri,  9 Jan 2026 11:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959905; cv=none; b=RdQWC1MWMN4WMC8+DFLa6GkosNTLTO4GRqCTt5YSDhPK4DrfhqvtoHMe3XdHMjPo0G6hh23CsutYPm+tc/pqb6uTpOntNpfEG945jM1dxWd7eBKSk7KwltZ4f/ZZMMLqAd5Tr9j/xVK+nsF69XX1iMM2TTM6GeCslOtCwDFKbOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959905; c=relaxed/simple;
	bh=mim64aLuLOSZRNdD+ajai/y9jQuCSM5lOaWlPVwBtt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTND+frynU4W1buj9ClIBy2XEMQS2PDAiDzgkAxSjtb/iFzsw6foeVEMQrckx0busD9eUPuuQIzwGn60oEqAm992SJmglZBgHnvTtlQoAO24KIMQ4OAf34YBGU9vcHqD+Jb/Xz3AhDO0+Nn4Ypo7k+G/sAijQY87Li06de8GmkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvbHf3H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvbHf3H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0736C4CEF1;
	Fri,  9 Jan 2026 11:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959905;
	bh=mim64aLuLOSZRNdD+ajai/y9jQuCSM5lOaWlPVwBtt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvbHf3H/dsx7276RAB4IcgT4pUKP1KJb4o61YOHWOBk7ipTDF4k3KntUdcKPQyBYv
	 jWpjuW48xpqPEJqazXYvXmaGOZ5JAIhFBFl11EHqoETOgBW/rzoaOQX4GtyZlRDQXi
	 q6PftKNrC3acStyo2hb93N2VwSVoKBMLpAIaGhRE=
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
Subject: [PATCH 6.6 184/737] phy: renesas: rcar-gen3-usb2: Fix an error handling path in rcar_gen3_phy_usb2_probe()
Date: Fri,  9 Jan 2026 12:35:23 +0100
Message-ID: <20260109112140.917293547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a6391361a0be..89a9693c9f577 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -117,7 +117,6 @@ struct rcar_gen3_chan {
 	struct extcon_dev *extcon;
 	struct rcar_gen3_phy rphys[NUM_OF_PHYS];
 	struct regulator *vbus;
-	struct reset_control *rstc;
 	struct work_struct work;
 	spinlock_t lock;	/* protects access to hardware and driver data structure. */
 	enum usb_dr_mode dr_mode;
@@ -658,21 +657,31 @@ static enum usb_dr_mode rcar_gen3_get_dr_mode(struct device_node *np)
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
 
@@ -814,7 +823,6 @@ static void rcar_gen3_phy_usb2_remove(struct platform_device *pdev)
 	if (channel->is_otg_channel)
 		device_remove_file(&pdev->dev, &dev_attr_role);
 
-	reset_control_assert(channel->rstc);
 	pm_runtime_disable(&pdev->dev);
 };
 
-- 
2.51.0



