Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3931A814;
	Wed, 17 Sep 2025 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114116; cv=none; b=kOoJ8SSxPJuGiYhfw3tqmkCWISJuYczOKOgaTrNeKZyCyFHOGmRA96kr3VOYtgLs0pRMtzSgPjd1Ve0122uQsO8LbWANG6AhRHKaMeM/Ygg6GxBXqvbAQ+igiA18wYUuRzamsMDmWJkjqWbHiuzcZkq8sQkezJCymVhwCOnbdwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114116; c=relaxed/simple;
	bh=aCiKQKZ4VHY5vkloJry5l5pekod3KSPgEs8jc0n7m1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU3DSUAODOaiPRrBqfRLxcyjTTgXjTJULI9AErJnGWjBVGvWQrjIYP808YeKj3iMaLnRY3IdICGl1qAZolNUSwCK5oGRGhZocdutrMwRS2Luoh6eTCxh5b93S7i8EJ+3+Qa0CMKVfAcIUW6i8pNdwzvWcvy2Rmr+WtqkuErndFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnqSPnws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnqSPnws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D27EC4CEF0;
	Wed, 17 Sep 2025 13:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114116;
	bh=aCiKQKZ4VHY5vkloJry5l5pekod3KSPgEs8jc0n7m1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnqSPnwsypOuNyEd3LwBBDBWSRpd3fwo/4P4USPCJkxyPXnomqcaQ1D2QZcYv0aEb
	 oyNQFLHDce1VQl9RHkyhKXE/7qW+M44mWPXv8ZOlM9N9BwcmHeSAUplefB2yyVeV6S
	 OISRcQghth2JrHiiW7JaUUVbVnLmgrKFzftxHNac=
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
Subject: [PATCH 6.1 51/78] net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()
Date: Wed, 17 Sep 2025 14:35:12 +0200
Message-ID: <20250917123330.812758320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d10db5d6d226a..ca271d7a388b4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2137,7 +2137,8 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
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



