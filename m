Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD874040;
	Mon, 29 Jan 2024 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548560; cv=none; b=jDRqU9N9icbxgyNUja5R2USOh1nPrUl5b0oigVEoyowEnmzmVbiytRD+zVprXiaJlZEn+sZ6oX3XfJHIczrgQYEn9jicHuGgT638QsPq7QFhTVgjlFUd8F+uQ4apXzQHYB2uGxOoFm1A8BHYzw47XLBkYs4XUE0jO8Wws9oOPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548560; c=relaxed/simple;
	bh=weoyGB30w9dSK6uXcg1RhjyDOzgsT9YWLSeCagZctmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGuTGR8vpsPUMpyI0PVr2jicEFsmOI89MBPMs4A6H2lkmtttBjtMNUxgPF7yEKHC32nFT8BxNllXn32fLdEnCqJoFvY4xOWVp86CExl2+vCPCxkjPOx1JolfZW9qhILMXH8Ex9W+eRA/nYjwrCsk6/1aJ4wwpM663Th53EKjsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKKLintG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKKLintG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F4BC433F1;
	Mon, 29 Jan 2024 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548560;
	bh=weoyGB30w9dSK6uXcg1RhjyDOzgsT9YWLSeCagZctmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKKLintG3r8jFpu2KBzWs8lwWtKjJ+iLBK4lKlecjarYJqR+udkdrDqd2l132lqae
	 1pcAtoIyQPCfgNIIlP7DELXw3jZjbHppeMWi5kYwgFBfv6Jgv7+4IYCecXwIiIb+TL
	 SP++Raw3VVTO7svWQdu2QMDb9f9PwmBbxyVKrrGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	Jiri Pirko <jiri@nvidia.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/331] net: stmmac: Wait a bit for the reset to take effect
Date: Mon, 29 Jan 2024 09:04:32 -0800
Message-ID: <20240129170020.968806606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 684ec7058c82..292857c0e601 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7441,6 +7441,9 @@ int stmmac_dvr_probe(struct device *device,
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



