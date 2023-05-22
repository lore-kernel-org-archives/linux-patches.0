Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F68C433D2;
	Mon, 22 May 2023 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785024;
	bh=0WnkKj5M+LxC1wqQrmFpIQm+dlwfx9PBn2RL/tPeOE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3TpHXkKvPgc90rC4h6pxQr5DvY4he+77QKnFDFFhgM85U/iCTpZ1g3t1Gmtrk01S
	 zsiu0Aoy0ueTQsmku1EAiwo57RAHRnpm2gB5IcaES8fFcMsx7gt62YDzJBiTwJVO67
	 RUrp3799aJ6hrNPH63S+07iHLDAlcYVdul6Poeyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 254/364] net: fec: remove the xdp_return_frame when lack of tx BDs
Date: Mon, 22 May 2023 20:09:19 +0100
Message-Id: <20230522190419.054295526@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 6ead9c98cafcbc6992cf35f0ca393df2c03e3316 ]

In the implementation, the sent_frame count does not increment when
transmit errors occur. Therefore, bq_xmit_all() will take care of
returning the XDP frames.

Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 241df41d500f1..577d94821b3e7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,7 +3798,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		xdp_return_frame(frame);
 		return NETDEV_TX_BUSY;
 	}
 
-- 
2.39.2



