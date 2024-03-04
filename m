Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3253D1C6AB;
	Mon,  4 Mar 2024 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588188; cv=none; b=q39x3YoF8PJDj72/FSZi+CN2olO1265mA2uctdewYtEIjfAN8BWVxUiqosUOJhTRYg6PaZARJpuUYbFuZ0w6jvf/B+TxvCTUbMHfdMw9UkXCOXfLxqx5WX+QqWLBamtIFCHLMGL949fUcdWNltwyXueoBM2fpVqrcuNmNWjCVbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588188; c=relaxed/simple;
	bh=pPANHrBK7DKAHEV66DcrsxlFW32VG/r3psHd6bNsJqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxglrPxtZ5JUS+7M5EhdOZidHIT21qDeBBZwGWOgx1cqSC0WFZIwX7JA8UkoCBvYMviAhPFfBJyccexzURvgnSX904oid1Ehh3SidDDEsEdlMc4qQ+yRQTBa1uj5ryJvyRVHrMbzHlzAVogMbAgZuRaln000ZrBVihk/u0fRVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbRL1ipa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbRL1ipa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9805C433C7;
	Mon,  4 Mar 2024 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588188;
	bh=pPANHrBK7DKAHEV66DcrsxlFW32VG/r3psHd6bNsJqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbRL1ipa01CxjvyaMA0tPw+yDnZhPPJ1jYBXlwD6JNRT+1Sv6bk2yz9YAcoYUcp5d
	 thgv8KIA9gnF71HZwY1XetXlAj/660dRROkQ9bwYsOWGtNQKdiPAfeebYDe/3PNIt3
	 alFSZIaT/0JDxn/ZH/Zp/sVI8grqhRjDjNLjnz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/143] net: dpaa: fman_memac: accept phy-interface-type = "10gbase-r" in the device tree
Date: Mon,  4 Mar 2024 21:22:12 +0000
Message-ID: <20240304211550.318210029@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 734f06db599f66d6a159c78abfdbadfea3b7d43b ]

Since commit 5d93cfcf7360 ("net: dpaa: Convert to phylink"), we support
the "10gbase-r" phy-mode through a driver-based conversion of "xgmii",
but we still don't actually support it when the device tree specifies
"10gbase-r" proper.

This is because boards such as LS1046A-RDB do not define pcs-handle-names
(for whatever reason) in the ethernet@f0000 device tree node, and the
code enters through this code path:

	err = of_property_match_string(mac_node, "pcs-handle-names", "xfi");
	// code takes neither branch and falls through
	if (err >= 0) {
		(...)
	} else if (err != -EINVAL && err != -ENODATA) {
		goto _return_fm_mac_free;
	}

	(...)

	/* For compatibility, if pcs-handle-names is missing, we assume this
	 * phy is the first one in pcsphy-handle
	 */
	err = of_property_match_string(mac_node, "pcs-handle-names", "sgmii");
	if (err == -EINVAL || err == -ENODATA)
		pcs = memac_pcs_create(mac_node, 0); // code takes this branch
	else if (err < 0)
		goto _return_fm_mac_free;
	else
		pcs = memac_pcs_create(mac_node, err);

	// A default PCS is created and saved in "pcs"

	// This determination fails and mistakenly saves the default PCS
	// memac->sgmii_pcs instead of memac->xfi_pcs, because at this
	// stage, mac_dev->phy_if == PHY_INTERFACE_MODE_10GBASER.
	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
		memac->xfi_pcs = pcs;
	else
		memac->sgmii_pcs = pcs;

In other words, in the absence of pcs-handle-names, the default
xfi_pcs assignment logic only works when in the device tree we have
PHY_INTERFACE_MODE_XGMII.

By reversing the order between the fallback xfi_pcs assignment and the
"xgmii" overwrite with "10gbase-r", we are able to support both values
in the device tree, with identical behavior.

Currently, it is impossible to make the s/xgmii/10gbase-r/ device tree
conversion, because it would break forward compatibility (new device
tree with old kernel). The only way to modify existing device trees to
phy-interface-mode = "10gbase-r" is to fix stable kernels to accept this
value and handle it properly.

One reason why the conversion is desirable is because with pre-phylink
kernels, the Aquantia PHY driver used to warn about the improper use
of PHY_INTERFACE_MODE_XGMII [1]. It is best to have a single (latest)
device tree that works with all supported stable kernel versions.

Note that the blamed commit does not constitute a regression per se.
Older stable kernels like 6.1 still do not work with "10gbase-r", but
for a different reason. That is a battle for another time.

[1] https://lore.kernel.org/netdev/20240214-ls1046-dts-use-10gbase-r-v1-1-8c2d68547393@concurrent-rt.com/

Fixes: 5d93cfcf7360 ("net: dpaa: Convert to phylink")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/fman/fman_memac.c   | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 3b75cc543be93..76e5181789cb9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1074,6 +1074,14 @@ int memac_initialization(struct mac_device *mac_dev,
 	unsigned long		 capabilities;
 	unsigned long		*supported;
 
+	/* The internal connection to the serdes is XGMII, but this isn't
+	 * really correct for the phy mode (which is the external connection).
+	 * However, this is how all older device trees say that they want
+	 * 10GBASE-R (aka XFI), so just convert it for them.
+	 */
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+		mac_dev->phy_if = PHY_INTERFACE_MODE_10GBASER;
+
 	mac_dev->phylink_ops		= &memac_mac_ops;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
@@ -1140,7 +1148,7 @@ int memac_initialization(struct mac_device *mac_dev,
 	 * (and therefore that xfi_pcs cannot be set). If we are defaulting to
 	 * XGMII, assume this is for XFI. Otherwise, assume it is for SGMII.
 	 */
-	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_10GBASER)
 		memac->xfi_pcs = pcs;
 	else
 		memac->sgmii_pcs = pcs;
@@ -1154,14 +1162,6 @@ int memac_initialization(struct mac_device *mac_dev,
 		goto _return_fm_mac_free;
 	}
 
-	/* The internal connection to the serdes is XGMII, but this isn't
-	 * really correct for the phy mode (which is the external connection).
-	 * However, this is how all older device trees say that they want
-	 * 10GBASE-R (aka XFI), so just convert it for them.
-	 */
-	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
-		mac_dev->phy_if = PHY_INTERFACE_MODE_10GBASER;
-
 	/* TODO: The following interface modes are supported by (some) hardware
 	 * but not by this driver:
 	 * - 1000BASE-KX
-- 
2.43.0



