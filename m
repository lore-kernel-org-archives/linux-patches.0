Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF88349AF7;
	Fri, 21 Nov 2025 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732236; cv=none; b=psf8+Xf17OI0RK4id1w5N4axBhiZ9sx9i11FIIHjJF/lyOoe9PqU4buNGA8lp6U5Xpc5PwXvc9TTN6IFen+KE8KqcWFbiBI3+xAyM7IUAz2RfEMIAISvB0HyN4KBU2lKOgxR08ormhditE5YXZ8gEh7eLMk0xPWMtToTstkH6Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732236; c=relaxed/simple;
	bh=TKZA5m7iVOcgkLoLMhnLUz0QanyBA0x4W4epoFEpb54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdUtKkH+3xplvIhhWqmvI4AJe2pCp14tcTk0OrmkSUm3kuojROWrWxS1xmXDAd1+xUeX+t767Xhbf9NIKIa+KmTPahh6DEJ8cAvAr2hDdyiVCngzmyll7jbOizH4mTht1XlPQL4pDuIcF0qD7jZlzMttD0L9DEghjvBYH5xAgKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Th0Ogqae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th0Ogqae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE83C4CEF1;
	Fri, 21 Nov 2025 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732236;
	bh=TKZA5m7iVOcgkLoLMhnLUz0QanyBA0x4W4epoFEpb54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Th0Ogqae5QFG9Z0DnGr/1pCMOLHKq0XvZo3mzjhJe8JxP+tLLKGZvSv6uSwnEvYvS
	 OG8+Lbs2qBv0urRKU+0DLuGAVutOCk4Cj2tnttyZgz88lWTutRY7gqh7lFbSglX0QT
	 9CDPI0L21qDjPUkb3O0VTBAKHLJraWgouCkFNxVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/529] net: phy: dp83867: Disable EEE support as not implemented
Date: Fri, 21 Nov 2025 14:05:49 +0100
Message-ID: <20251121130232.790808100@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 84a905290cb4c3d9a71a9e3b2f2e02e031e7512f ]

While the DP83867 PHYs report EEE capability through their feature
registers, the actual hardware does not support EEE (see Links).
When the connected MAC enables EEE, it causes link instability and
communication failures.

The issue is reproducible with a iMX8MP and relevant stmmac ethernet port.
Since the introduction of phylink-managed EEE support in the stmmac driver,
EEE is now enabled by default, leading to issues on systems using the
DP83867 PHY.

Call phy_disable_eee during phy initialization to prevent EEE from being
enabled on DP83867 PHYs.

Link: https://e2e.ti.com/support/interface-group/interface/f/interface-forum/1445244/dp83867ir-dp83867-disable-eee-lpi
Link: https://e2e.ti.com/support/interface-group/interface/f/interface-forum/658638/dp83867ir-eee-energy-efficient-ethernet
Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Cc: stable@vger.kernel.org
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251023144857.529566-1-ghidoliemanuele@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ inlined phy_disable_eee() functionality ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83867.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -774,6 +774,14 @@ static int dp83867_config_init(struct ph
 			return ret;
 	}
 
+	/* Although the DP83867 reports EEE capability through the
+	 * MDIO_PCS_EEE_ABLE and MDIO_AN_EEE_ADV registers, the feature
+	 * is not actually implemented in hardware.
+	 */
+	linkmode_zero(phydev->supported_eee);
+	linkmode_zero(phydev->advertising_eee);
+	phydev->eee_enabled = false;
+
 	if (phy_interface_is_rgmii(phydev) ||
 	    phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		val = phy_read(phydev, MII_DP83867_PHYCTRL);


