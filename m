Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6E3D9DCA;
	Wed,  8 Apr 2026 19:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674861; cv=none; b=fs4fsTfTZBWKB6IePzhoE1vhejmAVv5TLzeEo6DoX+KS2Mdkop3XQ/lL5HdlKw4BQwrlomgz9V3aRJkDMFaMB8K+R6x9/VHIdVlYKuaDcUhjwVOzhyAix7gZj43p8qWezFEVn+4bpsTbRLgXYX12hgT/43nS8E6KSLN7e8swuaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674861; c=relaxed/simple;
	bh=EoWOo3o3IoZ3MG7xPQDktdJEJfpjga2fqPtj+G24f0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb7vYRjBS4cr/fFLROgYGKOa5jYx1Mr+Ym/2vVy83Ukd1JftJXWqht2vwmnUNztHOKAaULen/clQW/pbl+z5vU8pcicKppU9WUvnz7xtVQCq3zZCItV22zehXR983V3RCQ0BofjqJzyFBmlQek4dJ4R8ihYm27oQMY4tkAkTz8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=linwkzBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="linwkzBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A9C19421;
	Wed,  8 Apr 2026 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674861;
	bh=EoWOo3o3IoZ3MG7xPQDktdJEJfpjga2fqPtj+G24f0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=linwkzBYAAn8pr91cGAwOgWh4tXU2YwT9+dtprxmgrG4sGOK9vMn5B23kgRWweq6U
	 Ak548W/cdRWdCZjgl/Zq6XWw/abFu7BipGmNDnZX+8goWlmhA6nYq+xlwUf8mRXfr+
	 4cvCryRh0IYNCF6NBU2ggGNLjyWaeg2XSa6SRsZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Gabor Juhos <j4g8y7@gmail.com>
Subject: [PATCH 6.19 244/311] usb: core: phy: avoid double use of usb3-phy
Date: Wed,  8 Apr 2026 20:04:04 +0200
Message-ID: <20260408175948.503169349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


