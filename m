Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68825A321;
	Wed,  8 Apr 2026 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674337; cv=none; b=ou/IitrGceLc28xGmQo1MQ8JvojMrRmVBG1ZoNYL726eyFXKwhQu0n0ni4QDcqZ8mh0vYlEE/JIblwl7othBeLT9XF6f9flWWNhsz+X59B1+71VrEphc7GdXziGmeIM5RXcTjNwd0RWcb16Xtq/0uZMBzS2RL7b7UTYjb2lXXSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674337; c=relaxed/simple;
	bh=XSCCostlxw4oMMDlw3KPQfCo2OAS6i6crTn2bguWgeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdCj78bN+tXehVomOMIBIdX++Pp3Jn4H2CJaGxhnHZXkUVTVp858NZxwpRppQqMWgMLp8Y7pQAT78XScy0sZWkYwFKNvk+tFJ/d0xbGhNbbtJRcWqlqJIxwEu2x7M4n6Ssq+0415od8o4EtOCNdlgvBNkLeDJmGF5EoH+YAq6TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJPGsR5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJPGsR5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA2C19421;
	Wed,  8 Apr 2026 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674337;
	bh=XSCCostlxw4oMMDlw3KPQfCo2OAS6i6crTn2bguWgeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJPGsR5l6UI3eXdZEvMBF6ufGUHbnZFcMRXDW1Eo2r1KTILmGHngk0+zA+j1YyI94
	 82eZdlnDkaKenHRxmmVvJQtsccmhUyqGOUvX4xRSQCzLfrwMwYIalwZtdGKF/Q1M5d
	 AC7f+kZiDLhZ5R8OBp7CvKAFreSPWFzSxFZYaoCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 058/311] net: sfp: Fix Ubiquiti U-Fiber Instant SFP module on mvneta
Date: Wed,  8 Apr 2026 20:00:58 +0200
Message-ID: <20260408175941.582818480@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index ca09925335725..7a85b758fb1e6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -480,11 +480,16 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
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



