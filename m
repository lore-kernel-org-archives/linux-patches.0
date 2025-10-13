Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F227AC21;
	Mon, 13 Oct 2025 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369583; cv=none; b=m8Vgc8ITX+u+VmqjyepHtoy3T1dvab9bP0etmwyFgInH73aXGM2KbSF6NStDQvKOYs7wgOymiyMnUsB8zNamIOQTpgP3oqiec6bOxTHHrw2DekD0nCiotpYqQYJk1IfGvB6cNSHoONb8d3C5T3dvqqExut5gVM1WtjJtPxeAuuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369583; c=relaxed/simple;
	bh=BXyhv2GU6XZFyiGjcWClFfekzox9ZA2nEf2ZaWrIUsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Flx6MXjEk4BRfEIcd7KJcvBL8tMkBbrDs3yvHdts+JEmcAg4AIwBlwNZq0EHGKeuTmbI/B1+idlrWBxN5kyvqkiM5DMQsxNB5wSb5CIUCI0i14Yg/RyCauTWY0aQVQ2bLVpYw+oxYxG9e/b4OBYFqnl2PgBfFJzG9wU5gNjeVSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWRwt+NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWRwt+NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A442CC4CEE7;
	Mon, 13 Oct 2025 15:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369583;
	bh=BXyhv2GU6XZFyiGjcWClFfekzox9ZA2nEf2ZaWrIUsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWRwt+NKSF+fdicOSFBR2BSHLTZg/UjJ9II0529lxbPPo7gHJNGxqh0NGiDiXkkgl
	 XGY3QfsQI7UGp5BMw3S9Rm0FEg05mxn6XtkoSh1FZFZnaJmJ39UOSx2EF/FtMY1YV7
	 17023ZKlll+zJcgqcxthFLHFwGqNBeZtd9fTsf7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 270/563] net: phy: as21xxx: better handle PHY HW reset on soft-reboot
Date: Mon, 13 Oct 2025 16:42:11 +0200
Message-ID: <20251013144421.056710314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit b4d5cd20507b252c746fa6971d82ac96f3b3e5b7 ]

On soft-reboot, with a reset GPIO defined for an Aeonsemi PHY, the
special match_phy_device fails to correctly identify that the PHY
needs to load the firmware again.

This is caused by the fact that PHY ID is read BEFORE the PHY reset
GPIO (if present) is asserted, so we can be in the scenario where the
phydev have the previous PHY ID (with the PHY firmware loaded) but
after reset the generic AS21xxx PHY is present in the PHY ID registers.

To better handle this, skip reading the PHY ID register only for the PHY
that are not AS21xxx (by matching for the Aeonsemi Vendor) and always
read the PHY ID for the other case to handle both firmware already
loaded or an HW reset.

Fixes: 830877d89edc ("net: phy: Add support for Aeonsemi AS21xxx PHYs")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20250823134431.4854-2-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/as21xxx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/as21xxx.c b/drivers/net/phy/as21xxx.c
index 92697f43087dc..0052773606562 100644
--- a/drivers/net/phy/as21xxx.c
+++ b/drivers/net/phy/as21xxx.c
@@ -884,11 +884,12 @@ static int as21xxx_match_phy_device(struct phy_device *phydev,
 	u32 phy_id;
 	int ret;
 
-	/* Skip PHY that are not AS21xxx or already have firmware loaded */
-	if (phydev->c45_ids.device_ids[MDIO_MMD_PCS] != PHY_ID_AS21XXX)
+	/* Skip PHY that are not AS21xxx */
+	if (!phy_id_compare_vendor(phydev->c45_ids.device_ids[MDIO_MMD_PCS],
+				   PHY_VENDOR_AEONSEMI))
 		return genphy_match_phy_device(phydev, phydrv);
 
-	/* Read PHY ID to handle firmware just loaded */
+	/* Read PHY ID to handle firmware loaded or HW reset */
 	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_PHYSID1);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



