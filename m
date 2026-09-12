Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD40D41B8CC;
	Sat, 12 Sep 2026 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219333; cv=none; b=Ve1+uGkcjYWTyO7PLsDESKVuWzvXRW3PVhbTgXUTPvf5WC4fr08kzgVCn5bpzGpPATI4OrdMygBY5dGAB4O02+CBmrkQFQkXIIPmyHZuw4mJhAV3k2zaugP33a/Ts6IgSqH5JXea78vIO+Be8enZEE8XwYuJas3c7zPOL0YaP9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219333; c=relaxed/simple;
	bh=0GugpfpNheH65eyu3Xb35NwwplSBgfTXCH60SV3OTJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eywZPnJYUWEI9WPIvgua1qwts8v58PVJ5EHxuIR2cFtxYediJbFO/2lRUSF7mwgfPr6lS1WAib3jWBIokCTVzkY0CYvzP606SaDlEW0uQAEABInnr1ix6igkQw75ISnXpLhyFO5/EVAR+BAbyWHhiJqUEc7Jm3Y5QDiBH0PCoNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1/brEcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1/brEcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595981F000FF;
	Sat, 12 Sep 2026 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219332;
	bh=/1HltlTQ8+zyr4EfjQcL+/0RsSEIEwNtbN0XM4MZN28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1/brEcScd2E8TvdWsDWyTuDZFZBbuS4j6pvcU///ErrXDKb/pZEiPNofbnAgb3CA
	 NAGpdI8ISgxiozsLj0lMxGmBmX3+GeRIQdnEJ3tcDUFeIqxBZUM5M5x7wWDONvsLNu
	 4SQLVqjgZJ/KOZ2NpwN6Z1LK+AS6euAt4p6tKy7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1328/1376] net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:02:34 +0200
Message-ID: <20260912065637.130426893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 9698b6da3714fd2ef47846cb63098d2b2d252e25 ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-3-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index d413d76a89368..83fbd8fa759e5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -185,7 +185,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	dwmac1000_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses (perfect filtering) */
-	if (netdev_uc_count(dev) > perfect_addr_number)
+	if (netdev_uc_count(dev) + 1 > perfect_addr_number)
 		/* Switch to promiscuous mode if more than unicast
 		 * addresses are requested than supported by hardware.
 		 */
-- 
2.53.0



