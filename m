Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873743B0AFC;
	Wed,  8 Apr 2026 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673699; cv=none; b=XoRyVJS3fzCmM7akVCN1uuJJxGVxL0o0Y3ecagD+dDvY1qEi0ghUi9qKWxL9A4tfCBC+Y9Aft2e2B5Igolwzx1OxNYajori7kx9K/iG9/7IposKDBlLINcJOXxoeDLwmxi6WmxPTOmCKj7u1OltEs8qXnpfey10//BBXmWd1+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673699; c=relaxed/simple;
	bh=D5IXQLqa9nF/tLJtlmhMAtw+abkiCX9zxjDEp6yzpJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ow2AdKkHv0KpKl81zWkI+gnQ0ux8AJMEoEvlTkE9kfB4oCAWJeQo2Os5xIUFicDxFc8eNN48t8QKp2qG3IC40PlXqhfD6PFpMKbXOZ83koXAyHnqZugDlzLmDPmDnnHOOht/jpPsNnGfuWnyeq4RLntEN+oqBmLYblj1pFRzBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaDZ553p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaDZ553p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67BBC2BCB1;
	Wed,  8 Apr 2026 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673699;
	bh=D5IXQLqa9nF/tLJtlmhMAtw+abkiCX9zxjDEp6yzpJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaDZ553p8DK0Gy5gABO5rN9bsrBmXr2JPP+B1KDwMLIjT42Oo3y1CJ5bpl9zqvvFZ
	 oBmxpfhMI3JItd5O/c5+rSn37Ae7MYNWKmpCYm3gTSHQSN8oHdJj6SkmYV4byJA3TQ
	 +D0vKij8E4k95xycdPDWLJB1mbSgOJ/sZhM9VN8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/242] net: sfp: Fix Ubiquiti U-Fiber Instant SFP module on mvneta
Date: Wed,  8 Apr 2026 20:01:35 +0200
Message-ID: <20260408175929.135825262@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit eeee5a710f26ce57807024ef330fe5a850eaecd8 ]

In commit 8110633db49d7de2 ("net: sfp-bus: allow SFP quirks to override
Autoneg and pause bits") we moved the setting of Autoneg and pause bits
before the call to SFP quirk when parsing SFP module support.

Since the quirk for Ubiquiti U-Fiber Instant SFP module zeroes the
support bits and sets 1000baseX_Full only, the above mentioned commit
changed the overall computed support from
  1000baseX_Full, Autoneg, Pause, Asym_Pause
to just
  1000baseX_Full.

This broke the SFP module for mvneta, which requires Autoneg for
1000baseX since commit c762b7fac1b249a9 ("net: mvneta: deny disabling
autoneg for 802.3z modes").

Fix this by setting back the Autoneg, Pause and Asym_Pause bits in the
quirk.

Fixes: 8110633db49d7de2 ("net: sfp-bus: allow SFP quirks to override Autoneg and pause bits")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260326122038.2489589-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index dd8d37b44aac8..9d9c1779da900 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -473,11 +473,16 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 {
 	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
 	 * types including 10G Ethernet which is not truth. So clear all claimed
-	 * modes and set only one mode which module supports: 1000baseX_Full.
+	 * modes and set only one mode which module supports: 1000baseX_Full,
+	 * along with the Autoneg and pause bits.
 	 */
 	linkmode_zero(caps->link_modes);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
 			 caps->link_modes);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, caps->link_modes);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, caps->link_modes);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, caps->link_modes);
+
 	phy_interface_zero(caps->interfaces);
 	__set_bit(PHY_INTERFACE_MODE_1000BASEX, caps->interfaces);
 }
-- 
2.53.0



