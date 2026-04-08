Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF43D8115;
	Wed,  8 Apr 2026 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673367; cv=none; b=Ol6Z8kgr3FarEoBlwxlEPdGaOa7shbXaWLwng9uz4VGQL3Ya6oRnEMnkChoCWKc+xIf+7TTd1GFQHMKSOtPxUnEaBVeT6VhRaHPooLvVuRntNHj62B57K+3a2d7MpzNuqAdaR0xTfduk1g0QEhI1g3XF7ilYHs8nD5BNf+mpErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673367; c=relaxed/simple;
	bh=OPIce0+EiGFKL4RmiGWKmcN9/W+cFZNKGXmtJ6jU2lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGNYDM3wIiFLc0yALZa3xLqnW7ZprVoGahT879Cw0sy1s2PBntreQoFp9MBvw5qXTpw+JYZJOVJJVeuJkRNLVYXTx26XJmJfgUZHC5bHrB7Rx8nUuA6hWVPeYSDF34pyUqGKJJHYhfoIgZ1xPit4ki/gQ1+t0qAg19jXPHT70iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJgXmV5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJgXmV5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEF2C2BC9E;
	Wed,  8 Apr 2026 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673366;
	bh=OPIce0+EiGFKL4RmiGWKmcN9/W+cFZNKGXmtJ6jU2lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJgXmV5Lzb+OjxTqrDYOEccI/p+ltJnGnSTvfHBjZsbt3IcbyQx3iAq2nwP08Lf7/
	 Sv6fg4tYTYTZsOrV1KOAUvr82KJ1DpDqbIe4xfYqxE7hbiZQKK0wpzeEJSqZD5ZVvV
	 p7uSetpjprT48P9ReVXZ5bwWsr85YHVAXTsLO8Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Gabor Juhos <j4g8y7@gmail.com>
Subject: [PATCH 6.18 204/277] usb: core: phy: avoid double use of usb3-phy
Date: Wed,  8 Apr 2026 20:03:09 +0200
Message-ID: <20260408175941.479998260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

commit 0179c6da0793ae03607002c284b53b6d584172d0 upstream.

Commit 53a2d95df836 ("usb: core: add phy notify connect and disconnect")
causes double use of the 'usb3-phy' in certain cases.

Since that commit, if a generic PHY named 'usb3-phy' is specified in
the device tree, that is getting added to the 'phy_roothub' list of the
secondary HCD by the usb_phy_roothub_alloc_usb3_phy() function. However,
that PHY is getting added also to the primary HCD's 'phy_roothub' list
by usb_phy_roothub_alloc() if there is no generic PHY specified with
'usb2-phy' name.

This causes that the usb_add_hcd() function executes each phy operations
twice on the 'usb3-phy'. Once when the primary HCD is added, then once
again when the secondary HCD is added.

The issue affects the Marvell Armada 3700 platform at least, where a
custom name is used for the USB2 PHY:

  $ git grep 'phy-names.*usb3' arch/arm64/boot/dts/marvell/armada-37xx.dtsi | tr '\t' ' '
  arch/arm64/boot/dts/marvell/armada-37xx.dtsi:    phy-names = "usb3-phy", "usb2-utmi-otg-phy";

Extend the usb_phy_roothub_alloc_usb3_phy() function to skip adding the
'usb3-phy' to the 'phy_roothub' list of the secondary HCD when 'usb2-phy'
is not specified in the device tree to avoid the double use.

Fixes: 53a2d95df836 ("usb: core: add phy notify connect and disconnect")
Cc: stable <stable@kernel.org>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20260330-usb-avoid-usb3-phy-double-use-v1-1-d2113aecb535@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/phy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/phy.c
+++ b/drivers/usb/core/phy.c
@@ -114,7 +114,7 @@ EXPORT_SYMBOL_GPL(usb_phy_roothub_alloc)
 struct usb_phy_roothub *usb_phy_roothub_alloc_usb3_phy(struct device *dev)
 {
 	struct usb_phy_roothub *phy_roothub;
-	int num_phys;
+	int num_phys, usb2_phy_index;
 
 	if (!IS_ENABLED(CONFIG_GENERIC_PHY))
 		return NULL;
@@ -124,6 +124,16 @@ struct usb_phy_roothub *usb_phy_roothub_
 	if (num_phys <= 0)
 		return NULL;
 
+	/*
+	 * If 'usb2-phy' is not present, usb_phy_roothub_alloc() added
+	 * all PHYs to the primary HCD's phy_roothub already, so skip
+	 * adding 'usb3-phy' here to avoid double use of that.
+	 */
+	usb2_phy_index = of_property_match_string(dev->of_node, "phy-names",
+						  "usb2-phy");
+	if (usb2_phy_index < 0)
+		return NULL;
+
 	phy_roothub = devm_kzalloc(dev, sizeof(*phy_roothub), GFP_KERNEL);
 	if (!phy_roothub)
 		return ERR_PTR(-ENOMEM);


