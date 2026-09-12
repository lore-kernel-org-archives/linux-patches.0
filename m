Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423EF3B2FE7;
	Sat, 12 Sep 2026 20:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243524; cv=none; b=TAONLwI/JjmQ+f0XmAfvXMg4OJTz1EE8nUtO4DdVfmGX3HKBKpmwqts61Nk+BnpnGNtuysd23vKC1FPNU+LvkyjnVuxQeezXhpXTq8DVX0/grZHsYuBrsx87eoK4c4z8p/Y0dTJ7HkLAVXgtZIj2L5y8TICnkFehWE12lH1fq0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243524; c=relaxed/simple;
	bh=Kr1RJ8QWnYC0Nq+QzAvXQ0GKuEkVabd4e2xDZGuzm2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M70HWiU3nsMuo+fflR0PmFNuk/SHjMG6ub9fv1yjg0ngUfoLZOd8UOBCU9rGydmFpo8zZ90oJCobDsGm/b3cIIy2jJzzPVXncEu5AituFwLs1iud4wbHjt7RA6pZFSHGlwFxGEW9z87jcHj93IpF65fjeNGIf9k18OrdwGKC2ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITcWogvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITcWogvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50F51F000FF;
	Sat, 12 Sep 2026 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243518;
	bh=XI6fQczgZNRh4OxGuC8hqezNvVWyzox4qkKDtD44pqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITcWogvsA+owN/RWYl2mgHSRZWAuxIdsL3wl9mYU4xNhXTz6yk/e41mE9SLUh9gvu
	 wXaSzPIZDijHOwhvRZdmdtpk/c90wUopAjRyTRyhCzByytcC2ik404H0aSUhLt3HyT
	 yVmHfhGqXmMPmB3qjZZgepj049Xhui52gn3JXDWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 781/798] net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:06:49 +0200
Message-ID: <20260912065534.967424222@linuxfoundation.org>
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

[ Upstream commit 2739d6f9a2b8729b0d85cbe0dc93e1d68670b6f2 ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-5-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 357762ce23ff9..4c9ce416c685c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -498,7 +498,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.53.0



