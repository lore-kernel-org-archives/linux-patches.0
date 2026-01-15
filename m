Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEB933993;
	Thu, 15 Jan 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496156; cv=none; b=nBSGjvW4FXhlvgCMH47NehzLUU45xeLjlkTZbVOkvaRFotAEKBaCBvrFRURRudrl90FFXvMxtjKo78CTe/Bzcd0uSM/9/GxSIUNiim+DifNHIN7jIiLQe54Ex8Id/s4YlOIybfhPwCB2lPGlDVxFIvqjKC4HWy1cYuVADvXaKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496156; c=relaxed/simple;
	bh=obSmG1V08XcLAmedfX1Cosdckhf4gvuGtT673XdpvEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1MV/NFP2qhl8FrIwn5FWcLW2XZgCnu5/BzGdlttcmUmL4RSgcTUMI5jOgeu/ig3KTGF9AgdXunj2ZquG7vzdlPNnLnOsHT+QH69ugvp7o/r3FYzk2GLoC3gQkJyPoH3lbqaEdsCkz1kN4G77LtpOhcYuGBOqdeGe9JguArTVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmbWy4St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmbWy4St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAC5C116D0;
	Thu, 15 Jan 2026 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496156;
	bh=obSmG1V08XcLAmedfX1Cosdckhf4gvuGtT673XdpvEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmbWy4StNFEem8kxyP2KyojSl/rx2soFJq7pwVNYASjBHGsinMb2P+IY4YyZkDFgx
	 29jAm4mumLFQfWFgzp8HTp4nlfFCQqYyxCVmHXuT59fpXNByg1+KXsqoGnq2kzSgX5
	 efbHIhB1WNW2aqoEfwjbVZB5UHIUhORSviDYQQak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Wu <w.7erry@foxmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/181] net: mscc: ocelot: Fix crash when adding interface under a lag
Date: Thu, 15 Jan 2026 17:47:14 +0100
Message-ID: <20260115164205.823209145@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Jerry Wu <w.7erry@foxmail.com>

[ Upstream commit 34f3ff52cb9fa7dbf04f5c734fcc4cb6ed5d1a95 ]

Commit 15faa1f67ab4 ("lan966x: Fix crash when adding interface under a lag")
fixed a similar issue in the lan966x driver caused by a NULL pointer dereference.
The ocelot_set_aggr_pgids() function in the ocelot driver has similar logic
and is susceptible to the same crash.

This issue specifically affects the ocelot_vsc7514.c frontend, which leaves
unused ports as NULL pointers. The felix_vsc9959.c frontend is unaffected as
it uses the DSA framework which registers all ports.

Fix this by checking if the port pointer is valid before accessing it.

Fixes: 528d3f190c98 ("net: mscc: ocelot: drop the use of the "lags" array")
Signed-off-by: Jerry Wu <w.7erry@foxmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/tencent_75EF812B305E26B0869C673DD1160866C90A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 08bee56aea35f..c345d9b17c892 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2307,14 +2307,16 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-		struct net_device *bond = ocelot->ports[lag]->bond;
+		struct ocelot_port *ocelot_port = ocelot->ports[lag];
 		int num_active_ports = 0;
+		struct net_device *bond;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
-		if (!bond || (visited & BIT(lag)))
+		if (!ocelot_port || !ocelot_port->bond || (visited & BIT(lag)))
 			continue;
 
+		bond = ocelot_port->bond;
 		bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
-- 
2.51.0



