Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF0356742;
	Sat, 12 Sep 2026 09:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205349; cv=none; b=qTTIlMxitDCnaNgpO60927MqSSSw6LLv0vFeMQxz5Cd+TrThZLoSmxW1hYwyelVz+7R2Ji/DlzRSa/wPRB0DoZKe5aD9FwftJ/hTU8tHdkkUn8EwXUXjvpnaFSGrTias34nWGhy5BNJhTtVafGWfuubGe3gKctpCatzb7xHHdmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205349; c=relaxed/simple;
	bh=1PTAQ/A6gqYJsAhIyZcTbZMksbVSMPonNp8Y41uInQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1vp0YakjOgreCyO4UVC0t6Dc4EzEFTHsQ3sYCnXLA6a/7GbvmRsVvJCPqS8/79BTM2pusxADVd7Fd2FVnm2dJLTotUDE1KbTNCpgmk59iTIAuElJzlkIpZJlrwx2uBwtWA+FawyZSuoB+LyGDjRXLWJEyZsZpFTD34kBfjH8ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CA/MiU/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CA/MiU/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12ED1F000FF;
	Sat, 12 Sep 2026 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205347;
	bh=nKMb87sxUVItCkk0kXnh4V+eJZOy+QnbLkFfhrEXQYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CA/MiU/p3avi/GKS5Aw/3FIO3zQ5/74oGvAETZ2PytMtPgUIaD3WzjBs5ZAYr4xEG
	 0Rm/kheHgrfjkjawxoNzhJLr8OBfYgQOsrJX9zmzxomUCpgzN5URsrWZherRi6sdak
	 ES9qWEJTno7sX7WjpmXSzPwkGux/XwXZiKN7M1+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1800/1815] net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 08:59:10 +0200
Message-ID: <20260912065731.294300801@linuxfoundation.org>
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
index 52054f31376d5..fc6ddb51c6820 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -532,7 +532,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.53.0



