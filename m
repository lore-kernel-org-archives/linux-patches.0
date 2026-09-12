Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B56416CFA;
	Sat, 12 Sep 2026 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203281; cv=none; b=Foc4fqIMO776SdKDlgQMINqxbcFaz471rZ7xuMVmBzKIilUhezDA14Em7e5SlYRI2F4FskdRLYI62JF53dPL0Y8TN6/ENoDRNuv7A0scu2KSOrF68MQymrxMiHo7+Wk7HbG2VFfR3kOssory4NXzW7dVWCMAVVG5gsaONEObqWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203281; c=relaxed/simple;
	bh=OyK9Ii5V+nUUAGa5A0GEJ5lNbR/+oZQPBF8ksuNpBS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5YKjLTUpEVsWHeHRH+TDkn1m++pn1BCBgREECGsLWHjFP3gVa0u0jsZ7kYoHdwBwrFvHTCiXohOxfaKRJdyeaB1iacyTLy3QVdXstL6wYvvAEq3qd09XomubBy4BhO/75qaCL8ag5ODeSpeIldj8tkG7GI0A1Q6drp/REzxS1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqajMQXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqajMQXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8741F000FF;
	Sat, 12 Sep 2026 08:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203279;
	bh=9Is7t9U0zDaa2Gyi07CzVSag60wMNXLHUrEKnQUPNsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqajMQXRicAGKOnPNtN8Gv3qMIH9dG/TLkVc+F3mAWGZ7VTJdHNBaiISgxXwIP8Dq
	 CbNAGZ4w5oVYIdDjv7VhvFbCmeKP70/8vcPd18WPsFGv0KaMkDPwzFRGmjvCTbpDc2
	 bSlyTijc0Z9wQWEitFi9SXLJCOXHNhM9tyWN5gPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1333/1815] phy: renesas: rcar-gen3-usb2: Ignore missing VBUS regulator
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065720.317262211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 9ea8d49c6cc6e217f5f5818369f659dc25bf89bf ]

Commit b6d7dd157763 ("phy: renesas: rcar-gen3-usb2: Add regulator for
OTG VBUS control") introduced support for controlling OTG VBUS through
the regulator framework.

As part of this change, the driver started requesting an exclusive "vbus"
regulator for OTG-capable PHYs with no_adp_ctrl set. The lookup failure
was propagated unconditionally, causing probe to fail on platforms where
no VBUS regulator is described.

On RZ/V2H and RZ/V2N, which do not use a VBUS regulator, this results
in the following error:

    phy_rcar_gen3_usb2 15800200.usb-phy:
    dummy supplies not allowed for exclusive requests (id=vbus)

This failure completely prevents the USB 2.0 interface from initializing.

Fix this by allowing the probe to continue if an external VBUS regulator
is missing. Only propagate the error if the internal vbus-regulator node
is explicitly present, or if the lookup returns -EPROBE_DEFER. For all
other missing regulator errors, gracefully assume no external VBUS
regulator is available and return 0.

Fixes: b6d7dd157763 ("phy: renesas: rcar-gen3-usb2: Add regulator for OTG VBUS control")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260702125855.3157253-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 1a823deb6eb11..7dab11bfcb1cd 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -898,8 +898,17 @@ static int rcar_gen3_phy_usb2_vbus_regulator_get_exclusive_enable(struct rcar_ge
 	int ret;
 
 	channel->vbus = devm_regulator_get_exclusive(dev, "vbus");
-	if (IS_ERR(channel->vbus))
-		return PTR_ERR(channel->vbus);
+	if (IS_ERR(channel->vbus)) {
+		ret = PTR_ERR(channel->vbus);
+		/* If vbus-regulator node was present vbus regulator should be available */
+		if (channel->otg_internal_reg)
+			return ret;
+
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		return 0;
+	}
 
 	if (enable) {
 		ret = regulator_enable(channel->vbus);
-- 
2.53.0



