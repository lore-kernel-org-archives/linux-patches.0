Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A113AD517;
	Sat, 12 Sep 2026 20:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243522; cv=none; b=Jjfz6g5qHA8WftW+9j2zLnGjx/U5p98D6K4TbiLjmEF9yC5l7TO1dXQBvkclsgBAs4/mHcSb3td7ptGnrdNtm0hlz5JGRcAuru7M9575w2GQ524jzBLT1zIKVpHA8B2pbacmXMnyfn/GSXnezvv1Ki5+dD9aU6xgDZoZjPKFrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243522; c=relaxed/simple;
	bh=AfN3RaVT/Na2C6ca3qZlGDI1JaoF1Pc4s3+A9gIzUP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEPyM8Uga+tDjS28GXKk+Fur0o/GWYwwtkWUQh6ictFPficVizoESrcAyOcksohLTt6vV/bNAi8JnnrEYq6NkAOvrOjQPptGhZ4J9sRdQ+rx/ZjkpLWnoIA3GYE7+Aki2J+78LCQ3duaDLfRoZKnT45yktPo3AI3CRPzR/wR/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNN0yyOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNN0yyOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B4F1F00898;
	Sat, 12 Sep 2026 20:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243515;
	bh=KAUUxCyqK1u8gcDNXu2wJfIgSNaVK3IEUHHyRbf0PSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNN0yyOxpG85B5pPx0yEP6xahdYcS5WBTJrb1yW1PSGAX9w1SfVCQh18lDVtn7hOg
	 DaCT4gciPW8ZTKuLUNUmkIm1qyuDA8EE8SB+0x9c/oHSLvJVauXm8Ub9qFQXjOrKsO
	 PvSWhC8jvE23Frhx/Ka0CmrV4wspJHFdz3iwE9jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 780/798] net: stmmac: dwmac4: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:06:48 +0200
Message-ID: <20260912065534.945022197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 82187f42c014d22520b9c3c4e2cfb519223fb29b ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index c315e0605baa9..c8a4d345d5c53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -645,7 +645,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.53.0



