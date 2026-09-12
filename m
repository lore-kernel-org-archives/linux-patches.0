Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85B4BEE3C;
	Sat, 12 Sep 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232100; cv=none; b=FK18jnHlBda0tkG8t70xHwa1GCUzclG7emBUmU6S/H4QVMVSNaXes43bpomN2hDhKn4rWsALWPr1xaDf0X1Hi0k2c+W67LwCubYAWsmFquDCPi0X33oPci8dbKU80tsUuJBBb3qyl01M87jI2uBMkxuDav/LcXM3lScsBUtJm6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232100; c=relaxed/simple;
	bh=gabo2Mwq5m2S9PxP+OIWJVBvwMEewN9YZqsY7jq6ZmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6D/M9Ul/+2FiwMuiN9cVfEgNelJhtvu7Rf+1MBvlmrbV01KB3XMaPbH94m6Jz+h3iEN/zayuXEFmDUkT0p7VCknUAeU0In+RdaaSpoujNzDXvD7j6gqazrrLKKeo5Mmsz2oUkp1bEzWYlDSlHHlTsBtMJn3E4aD5aHhFU1f5f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrNJztuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrNJztuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF091F000FF;
	Sat, 12 Sep 2026 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232099;
	bh=TIQIyq8yBvlmHmg6k0ovZdDm8/rhQl6gjbD/+4reT0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrNJztuQjDJxl/5oXD2mO+judSU533+l0J+12eKA0W60zRUNjI8Yr81rrudq+uXcj
	 71HDDR6EN3gfOhymnBs8TjHsevds0X58OZJPwGriy6zAeWrnlHgo37A85+hzPDQWT5
	 nyPkRWnTvOfUcQq2UCi0kn8vbl9QxELIw++NPMnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1132/1191] net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:04:20 +0200
Message-ID: <20260912065613.577006957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3927609abc441..0ba22a395e111 100644
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



