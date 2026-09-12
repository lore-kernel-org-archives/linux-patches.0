Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD0636E484;
	Sat, 12 Sep 2026 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210800; cv=none; b=PoSvLfC0D2xgF4Zf6SteNggP4znTsxFZ16m4zU43GdZyMW9sG+mpeH5vZ9dSE6VePN9fgIlvoc7YQBy0XzTobRmo3m90tHP6xADWiTCPwWVsww0+w3qWv2e4KGjGgF3uEofVxym5Mi3sRkc566ZpUOBfk9k//CKFdXX2Y1Jrmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210800; c=relaxed/simple;
	bh=Rdsvf+5JIPfNqz7egS0eTNlzGFstuGERbyPW+o6L0lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNL3xm1AD4H2rGvtE6qcusEIzD/Q1c9//Nj2j14jt+zaw4DyE7PrEHZTN3YLaWAnwjIJ1kF3PV/C2HbRb7wXAfZfUXIJFsqX4eA8Sigf+ZavvZ+uBgvoaGDfuVzQlJdESJXblmswaNNZqjxYyOLyvGf8pC4IjaoqLT7Nq8MIBUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnW3kzo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnW3kzo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF48A1F000FF;
	Sat, 12 Sep 2026 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210799;
	bh=vMDPAaQszl6FZWGfwmacmSUlwW5d7n54XLA/Wt66qnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnW3kzo2XcLT80KUKTuKN4UaHWjaJ07GY9SVLvuAYPPZS4/KYfHlXRL9kVPfXuT5K
	 2x/zkpoQZ4vVQgz+Mmii99DjaUkztWTQWHCzdTzy4dCsmXpShxgSfaMsOdkacRA27R
	 2QIAbfaRN8bVM+AJf3C0kEKGbbUrKoklZ0s4jzlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1098/1518] phy: renesas: rcar-gen3-usb2: Ignore missing VBUS regulator
Date: Sat, 12 Sep 2026 08:54:27 +0200
Message-ID: <20260912065648.290631482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 547d61ccb85a4..4739de1e99fb8 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -909,8 +909,17 @@ static int rcar_gen3_phy_usb2_vbus_regulator_get_exclusive_enable(struct rcar_ge
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



