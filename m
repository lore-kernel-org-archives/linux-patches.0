Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4B547D466;
	Sat, 12 Sep 2026 16:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232111; cv=none; b=e9AmNii7sQbRvdZZKJVUvrfK+NfWGleUmiDl81JmCbQW0CsgHkv1T8a+wkIwWw4mdOyYVKZlhjNaW4Ph4NXJRk6xX0rbP4G0Hbdhr+an0OEi8ROQgxs0+3gLYH1V+CqgulWEYDhPj6Ka4k5Gs8jyVqZQPr8K9LR/GislN+bvdVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232111; c=relaxed/simple;
	bh=kwBPIBCkpGz2Tg9OTJa8npgWHjgaS6y40ZcXCVswJQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4mwiVeftFxao2/WsaTG715lkK3Q0gqXyJZ858icT/PXHYJ+ds1DXt4nr5cnfddeXyvsJRQJNpkHD5UeKr5yGzwxnQ1z46qIp6SFsieiFwJ7c5/gUpmHYAQ6NL6fum7Suu4y3gicQjCg6glwgVNoww++/z9x6bhAwpiU+M5IuZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aty0lyLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aty0lyLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954AD1F000FF;
	Sat, 12 Sep 2026 16:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232109;
	bh=fuCETcpmqvSyV4/3mr3m7Lc4CmQ8zYAzKbpuUNNzpsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aty0lyLBDscL5I0IUw1X4IY6pKVNXMUUh8zm7Rr4FvcB5tPlheov1K3uqao+VZhRg
	 X77eYqvW+2w7QrIIXVeuX6nnisF5Dzlb5+FNGDNvXeR7ZfFECNzd1+PU3FkReTOQTU
	 mf556yNN1AaYRyWllatuoJRhKyX2tXMAbih0Bpkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1134/1191] net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:04:22 +0200
Message-ID: <20260912065613.621850787@linuxfoundation.org>
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
index b73c8dcfaceeb..3c81ea343a2c1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -502,7 +502,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.53.0



