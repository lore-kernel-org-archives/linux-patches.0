Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0822F6931;
	Sat, 12 Sep 2026 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240673; cv=none; b=lTJd99Kz1awNaXb2ZhV5/51e/U+gpASv5wRnfgoqE7mDtb853uyMmBdgskLctmfQCDe++fpC6Y9IWGmCfCAXdvithwVTraAKMKcF9d46pO5mgEp6UVXdkXVPhTPZ47wwsNeQ4UQ8614+YXDEvb9QGQcWqhbzaFYM4aLfV0k/WG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240673; c=relaxed/simple;
	bh=kyH9dgCHTbOldYMreiGkgKRU3t2OcIVhpLm4TzUzt5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKqdgBZl4sS7UAyz48bz2QayPg3jAXoED9UlQz3A+4JYo8WdNv4OtzJl9RnX15/oq4nucbhTNCf+ox5JFqBLXlFB5RIf/JY0xgAobcS7gQ9q5BLT53NZO7wbgnE2102NVPaeyoS9C+SCVHqxB9lN35nSEFudlE9NP7p+opGzHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/O9oot8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/O9oot8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AD71F000FF;
	Sat, 12 Sep 2026 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240672;
	bh=LIU/Rs7M2Xjzo0NNwyeilvN3m1p4gU3xrjJ3K4QDISU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/O9oot8/rUZ8v4FPusEJnm0gUB+5c/H8OEhw7uGvIp2Bp2hdpFc8XQrfmH9BNY3R
	 mD1583S5lJoqyQI8Tds/y71QW2tVsHsY5eH69UQdq+lLaa3S2SS3fdI63s6Yal0Sli
	 tcFCkgBvE7kFOHqrQyddW9ix702dLebBr89/t4I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 917/935] net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:05:47 +0200
Message-ID: <20260912065547.852935171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 0e00dd83d027a..be79e9a61105b 100644
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



