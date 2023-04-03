Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407A6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB45C433D2;
	Mon,  3 Apr 2023 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533242;
	bh=30H4ztSUUBgo+PFzRC51WEixdOjzrExcRzYqlAvuAaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXdJNNcpRZXxEWZ8sjkcTELMLp3shYpHJ3+rv0TTFZMKdwSNTV+FA/bHb0pH61wM0
	 Gyx2pbBem05m+lkriVEdWM/iRYj/rNkMxcZ+Vol3w0sKflJdPzuDYd9HjcWVw45G5P
	 Cvr+MtyJrcQKtCwkpg6lbNM3rFMtCSzOgQJWrno0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 108/187] net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
Date: Mon,  3 Apr 2023 16:09:13 +0200
Message-Id: <20230403140419.531124619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 07b3af42d8d528374d4f42d688bae86eeb30831a ]

Using the QDMA tx scheduler to throttle tx to line speed works fine for
switch ports, but apparently caused a regression on non-switch ports.

Based on a number of tests, it seems that this throttling can be safely
dropped without re-introducing the issues on switch ports that the
tx scheduling changes resolved.

Link: https://lore.kernel.org/netdev/trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Reported-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230324140404.95745-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 332329cb1ee00..9f9df6255baa1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -713,8 +713,6 @@ static void mtk_mac_link_up(struct phylink_config *config,
 		break;
 	}
 
-	mtk_set_queue_speed(mac->hw, mac->id, speed);
-
 	/* Configure duplex */
 	if (duplex == DUPLEX_FULL)
 		mcr |= MAC_MCR_FORCE_DPX;
-- 
2.39.2



