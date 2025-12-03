Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B2347BDB;
	Wed,  3 Dec 2025 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778434; cv=none; b=BHnaP84BoxT1sv8jruH/mWJQIXIzd2tbFvXo2q6eqOa2wSBNXdS5VQCECL2sBcajq66pN/oi1SaXQjm/750XQc6hSSoQHNh1403lBZdl+dLDBoKeGoNvv2pXsaSEW5RCncCFLXNF/P+BJkKJzsDGPS969N5ZsYR7L5JZovMx2MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778434; c=relaxed/simple;
	bh=V68IN+jwCFelQuRdygHVO9yemFp+cdTBmsSnMw6nFCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vC8r4oAGPDVPMsr94msrACSD563pV4Zm2aaexcpMjUxZzFRKues/XnYHTLur3p08UpbfobxezlkUT2cWjVcl1SCIyW0f0VBGsnJaKKDSSjFGvfg4hHGfwKzfzZTHUj9nY62Ysm5btpjafJLkEuaZqRlXP0Mwc9qO9fPxdfBQkDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM7USTdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM7USTdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B8EC4CEF5;
	Wed,  3 Dec 2025 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778434;
	bh=V68IN+jwCFelQuRdygHVO9yemFp+cdTBmsSnMw6nFCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM7USTdUc3l+ghcRJfLnXrDJnEb36u0gBwdLoKOUxIIB28JwRC/Cwt0ipg5J0lnWX
	 xF9I6Ag3hMx1pHshKgiuNG73kI6HiTOebthckA9vZv1tlGI2pbINgy9b4uWTV3EGrR
	 rZ555r3oL7DLpZPyEqnfgPqzOlv51yKUJLuYzjJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/392] net: dsa: sja1105: Convert to mdiobus_c45_read
Date: Wed,  3 Dec 2025 16:28:13 +0100
Message-ID: <20251203152426.791150045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 639e4b93ab68f5f5fc4734c766124ca96c167f14 ]

Stop using the helpers to construct a special phy address which
indicates C45. Instead use the C45 accessors, which will call the
busses C45 specific read/write API.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: da62abaaa268 ("net: dsa: sja1105: fix SGMII linking at 10M or 100M but not passing traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ec1c0ad591184..5c37478a7e822 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2180,14 +2180,13 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		u32 reg_addr = mdiobus_c45_addr(MDIO_MMD_VEND2, MDIO_CTRL1);
-
 		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
 							      mac[i].speed);
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
 		if (priv->xpcs[i])
-			bmcr[i] = mdiobus_read(priv->mdio_pcs, i, reg_addr);
+			bmcr[i] = mdiobus_c45_read(priv->mdio_pcs, i,
+						   MDIO_MMD_VEND2, MDIO_CTRL1);
 	}
 
 	/* No PTP operations can run right now */
-- 
2.51.0



