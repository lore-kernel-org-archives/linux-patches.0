Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56815AAD7;
	Mon, 29 Jan 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548182; cv=none; b=QBKXBUCfxoFBy/0r43tAqJ8cB/6eKa6Dr9ijALuqw7F2Qt6u3boUfm1tylKTFewRL+ZcROip84xIgnq7P77WSjRdcbbvIUSn8pTVnrPnwo1G+fjFdD9u1ZTO4Qb6dyjqsOx2/X6xDPtFovDoEu7kfy2kA7iE96HT3StvSxgPlb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548182; c=relaxed/simple;
	bh=GMi3oLgils2tnFawQ3/w0agmp7UH7T858xzyZykIyWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX3I0zEfFIfRiZUVtBpk3TcmmHvb015vTwinbxO2gZbVskxTzTDV6Aox+b3GxhzhbR1G4mCx78J0/9HrC5Kpj5y6ebd3NddfWGsgl6B9x20/qsiCw+Stb39siAxsfiWcBKTj5MRDDU00VKcKqH8VcfdMuhwLzZE+1Yb9MXoQXYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHYDZg+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHYDZg+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C20C433F1;
	Mon, 29 Jan 2024 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548181;
	bh=GMi3oLgils2tnFawQ3/w0agmp7UH7T858xzyZykIyWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHYDZg+ChsGjvIBNfbCoN/oGxdQgEaCu90hai+51ebVVUb9M/MV+FToKikeQtvz7N
	 jVSB0tDxXWvSqskDC5k3qY9+D40OPVfTY/5EcZtvRFA96EJmeFfY1ur7XJlwQ70BiD
	 QUiEb9fV2/IRVsQ/rJWWsgqw+9A2B9ZEPm6R3/Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	Jiri Pirko <jiri@nvidia.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 202/346] net: stmmac: Wait a bit for the reset to take effect
Date: Mon, 29 Jan 2024 09:03:53 -0800
Message-ID: <20240129170022.342174271@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit a5f5eee282a0aae80227697e1d9c811b1726d31d ]

otherwise the synopsys_id value may be read out wrong,
because the GMAC_VERSION register might still be in reset
state, for at least 1 us after the reset is de-asserted.

Add a wait for 10 us before continuing to be on the safe side.

> From what have you got that delay value?

Just try and error, with very old linux versions and old gcc versions
the synopsys_id was read out correctly most of the time (but not always),
with recent linux versions and recnet gcc versions it was read out
wrongly most of the time, but again not always.
I don't have access to the VHDL code in question, so I cannot
tell why it takes so long to get the correct values, I also do not
have more than a few hardware samples, so I cannot tell how long
this timeout must be in worst case.
Experimentally I can tell that the register is read several times
as zero immediately after the reset is de-asserted, also adding several
no-ops is not enough, adding a printk is enough, also udelay(1) seems to
be enough but I tried that not very often, and I have not access to many
hardware samples to be 100% sure about the necessary delay.
And since the udelay here is only executed once per device instance,
it seems acceptable to delay the boot for 10 us.

BTW: my hardware's synopsys id is 0x37.

Fixes: c5e4ddbdfa11 ("net: stmmac: Add support for optional reset control")
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/AS8P193MB1285A810BD78C111E7F6AA34E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 49b81daf7411..d094c3c1e2ee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7467,6 +7467,9 @@ int stmmac_dvr_probe(struct device *device,
 		dev_err(priv->device, "unable to bring out of ahb reset: %pe\n",
 			ERR_PTR(ret));
 
+	/* Wait a bit for the reset to take effect */
+	udelay(10);
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
-- 
2.43.0



