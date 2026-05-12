Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2643EDE66;
	Tue, 12 May 2026 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608293; cv=none; b=nTvw9F57EU2EifYYKbYUA5PcWObLWXLnm4yuCG+x2P70/SwsbVyveDP7aw7XIeB3V3ElmUeq4GGec3tKdbp6eNZJEySeV8trjsRCbtr8W32JttINqc9xXfA5/jXQ5nOywhi7Xo8o+cQdCNxyXAx7cu3lAjf2l5NQ3nUdP6ea4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608293; c=relaxed/simple;
	bh=G2Qx1036Izpf7jow8YppGl8AZ1ooQQ5ccTXWLqajoHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjkH4u5w0oypZ7nYqJTHdvHEDzKXOQ+IAek0TXnZtxooejbbdVft/yVhM3a2Jvg/+RoOHPwgIJHHr+pVGnZrwrzmrTaH6Q18fq5Nb/myDdOYtPt9wGCaVPImXiwEnDqu9xZkaCVIHAZDHUbNIwgPwzZxNmIq3hZgbsw52qCVDKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQUBhIJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQUBhIJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5426EC2BCB0;
	Tue, 12 May 2026 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608293;
	bh=G2Qx1036Izpf7jow8YppGl8AZ1ooQQ5ccTXWLqajoHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQUBhIJ9gZcBu0ia8JtZvwKiSSgJ/vRd4pm3CkLjtOB4DEbSPJsxV1rBngSmOjsY6
	 ZY+ZO2zhPUwNNzOUr5mPkQmOwEK+ZPxlkwTofnrcF0yMDBoW0mIbF9yS/llGa/+Eac
	 7iy5P1Pp2HCuT+MgifLsSzhn8Y0FnmI8xO/PftDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 023/270] net: stmmac: Disable EEE RX clock stop when VLAN is enabled
Date: Tue, 12 May 2026 19:37:04 +0200
Message-ID: <20260512173938.945368624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

commit c171e679ee66d7c0e2b58db9531af96797a76bca upstream.

On the Renesas RZ/V2H EVK platform, where the stmmac MAC is connected to a
Microchip KSZ9131RNXI PHY, creating or deleting VLAN interfaces may fail
with timeouts:

    # ip link add link end1 name end1.5 type vlan id 5
    15c40000.ethernet end1: Timeout accessing MAC_VLAN_Tag_Filter
    RTNETLINK answers: Device or resource busy

Disabling EEE at runtime avoids the problem:

    # ethtool --set-eee end1 eee off
    # ip link add link end1 name end1.5 type vlan id 5
    # ip link del end1.5

The stmmac hardware requires the receive clock to be running when writing
certain registers, such as those used for MAC address configuration or
VLAN filtering. However, by default the driver enables Energy Efficient
Ethernet (EEE) and allows the PHY to stop the receive clock when the link
is idle. As a result, the RX clock might be stopped when attempting to
access these registers, leading to timeouts and other issues.

Commit dd557266cf5fb ("net: stmmac: block PHY RXC clock-stop")
addressed this issue for most register accesses by wrapping them in
phylink_rx_clk_stop_block()/phylink_rx_clk_stop_unblock() calls.
However, VLAN add/delete operations may be invoked with bottom halves
disabled, where sleeping is not allowed, so using these helpers is not
possible.

Therefore, to fix this, disable the RX clock stop feature in the phylink
configuration if VLAN features are set. This ensures the RX clock remains
active and register accesses succeed during VLAN operations.

Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251113112721.70500-3-ovidiu.panait.rb@renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1204,7 +1204,11 @@ static int stmmac_phy_setup(struct stmma
 	/* Stmmac always requires an RX clock for hardware initialization */
 	config->mac_requires_rxc = true;
 
-	if (!(priv->plat->flags & STMMAC_FLAG_RX_CLK_RUNS_IN_LPI))
+	/* Disable EEE RX clock stop to ensure VLAN register access works
+	 * correctly.
+	 */
+	if (!(priv->plat->flags & STMMAC_FLAG_RX_CLK_RUNS_IN_LPI) &&
+	    !(priv->dev->features & NETIF_F_VLAN_FEATURES))
 		config->eee_rx_clk_stop_enable = true;
 
 	/* Set the default transmit clock stop bit based on the platform glue */


