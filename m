Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6143B47D5;
	Sat, 12 Sep 2026 09:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205344; cv=none; b=SVKWYCJBUmI3s7HyE759V9ANyONqj4BdQrHtc4orY+g7Q9Bd8zuj31h1t1RVCvJJ11GN640ljnO2HxEHXWhK9kwo4eHCkLkJB1JVfJ3TedZa+DaakT1gEoXTH4j7yzaS0IDu7rIXCnR9EFYz1BQSIJ0qQq3Fv9cHn+IcI4KXsx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205344; c=relaxed/simple;
	bh=fMizFdaTlNZyZ7+ffMD2TgfBhT+38FKK8jUawiS7hEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kt5H73oDTqPVOddjnrNttnhB3jU1J2JbDKyfaa1cFUtSHuhY0QeK6YBcxNtFMsF5yF36kkk/1bb7nH2B1ynrRjAJOcpLNFSNv232oNdzy3xuIXZSrg9jdUyNEHs0URaNXQVXokEU1ekwrsJMUuN3HbZklKN3g3jMtI4fRzswBXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnpSaoNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnpSaoNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8CF1F000FF;
	Sat, 12 Sep 2026 09:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205343;
	bh=I1KwgsYOq86sdXU0vmr69LBU6+duFAGUAwVgIP085DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnpSaoNYJnrdNEZ/NtYQgiQ5z09EyTnyk9l4HorsbuLzF29TEAcK0585zFtVOxCf4
	 yblm6CwD1TtTd/WFUv/mbKpyGg5L7Z+jG8r7YKPSSY38++vUzb4BGlYFiO/XtYU63t
	 r1MCEIfIty9dXMJrfdVxMkrna5BslmpA377VaKas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1799/1815] net: stmmac: dwmac4: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 08:59:09 +0200
Message-ID: <20260912065731.270396372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c6fcfae27c3d0..18b357b257cc0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -521,7 +521,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.53.0



