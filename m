Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0641A92A;
	Sat, 12 Sep 2026 09:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205339; cv=none; b=qHg7IKZk0bqq9gTW9QEI8plBUwZc4+l+XyvNPi58Cj+9n4Cr5+7GPvEYt3nJ72V0uFdmVqRGSwOx5duVyGeN0/Eoodnqc5GKkCYyW+bIoEw4UD1vW7oODwmTLzdfnHcEgWoIovOnuFSwiL30HjRK1XX/PmTNM2Z6hjJhEbgBA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205339; c=relaxed/simple;
	bh=eoU3t5QLQOhuKJnfZNf5oqHjT4MKXqYx6wtz8C1018I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbAZSVjAmeazZpVF0HNcW3a3ApQM1YmlQm7f1LqdEQXPAa5SOURsSNawczZDYVdZycoBL88NLdBTItTaewLC2KtZq0zZhdugQNp7B1pcNLfNGaZD0tRYccVXxclJYmgatNkwAEWaQMNSkJ61Y+FI25VlBWlSG5tcnbz5XcOeTdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZR2aGfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZR2aGfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F92B1F000FF;
	Sat, 12 Sep 2026 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205337;
	bh=ZJjWwYi8nArEhHW2TPS0C21M3THai7aF1WHt+2EoBnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZR2aGfpkc+FPXFXw//Oy/hkCrfwmCDNBKbHNrGZiui0wFxY5NZftR9eJPSaAoibM
	 viUO8+XZ1UgjUtxN2ifZEjoOZzDuG6deRiTFhIKAaN72OlyoKvsKarWw1iSoUaeKz6
	 mKS10UdhXTkYHsQCrJFLn6xNkDTaHgwGfZ//v2Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1798/1815] net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 08:59:08 +0200
Message-ID: <20260912065731.246701096@linuxfoundation.org>
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
index caac85fc08f1b..d4ace39248915 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -194,7 +194,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	dwmac1000_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses (perfect filtering) */
-	if (netdev_uc_count(dev) > perfect_addr_number)
+	if (netdev_uc_count(dev) + 1 > perfect_addr_number)
 		/* Switch to promiscuous mode if more than unicast
 		 * addresses are requested than supported by hardware.
 		 */
-- 
2.53.0



