Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714932BBF0;
	Wed, 17 Sep 2025 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113924; cv=none; b=TAnyi4xpz7HabnSHcMG/AUeFLTCK9cleOWy2a95vYzLOjQvbBXQ8maPrbtU+BOHyy3jFyWmeAmYS8+ao1SnJCPSYrSswoKjXuKBcxGjEMts+0JeS/2mhH/tZD+YWj9DLUS8V71DlTfBZt/E7R3tFC42l4E9WszJOZTfdlc1RWAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113924; c=relaxed/simple;
	bh=7DDz/XKwVDoMfLmxfZ42wS2Pk6T9f85Rnbp3xrzJG4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbXhV0KtWwhnJa0mphQ3KmboJ8xzk3YFGCdn6/ea7HFQJvH+DJpE/jOkp5qwulBRaGVziIICyC2U6g25E5fa0wB8hQeF39d6yh13BNR9Xc+S86Zhba2T3qXSzNQcT1lhmwxiJ3xLXV4IE4f24CAN58bmDy4SzCjf8SIvlkRfssI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhmj013G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhmj013G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223FAC4CEF0;
	Wed, 17 Sep 2025 12:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113924;
	bh=7DDz/XKwVDoMfLmxfZ42wS2Pk6T9f85Rnbp3xrzJG4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhmj013Gvv6AJDPn/+zgfYfP0/luvxciMxFo22vzd5yOZuL6g0Ziw84N5vWsghwja
	 aOwqQ8nLIpMsxlVrifRvADfwUoYGYHw0iZeEnC2lnH2hAS3nQ8GxCkF8NHsr9IoZX0
	 xqqynVXUyZ4lXgFGkl5t3s12dz2glElbmx7coj+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Richard Leitner <richard.leitner@skidata.com>,
	Simon Horman <horms@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/101] net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()
Date: Wed, 17 Sep 2025 14:34:51 +0200
Message-ID: <20250917123338.483638662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 03e79de4608bdd48ad6eec272e196124cefaf798 ]

The function of_phy_find_device may return NULL, so we need to take
care before dereferencing phy_dev.

Fixes: 64a632da538a ("net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Richard Leitner <richard.leitner@skidata.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250904091334.53965-1-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2a8b5429df595..8352d9b6469f2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2300,7 +2300,8 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 		 */
 		phy_dev = of_phy_find_device(fep->phy_node);
 		phy_reset_after_clk_enable(phy_dev);
-		put_device(&phy_dev->mdio.dev);
+		if (phy_dev)
+			put_device(&phy_dev->mdio.dev);
 	}
 }
 
-- 
2.51.0



