Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D88134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5091CC433EF;
	Mon, 12 Jun 2023 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566742;
	bh=mgv5O7odsdV7cG3JC7MZcwKZ4LMQ/4IXX/St/g2/OCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6Dfey71PJSQ4hDirI11cAv3WtkX03uu0rbeNTv3V28rnhi/JoZcEUq8rCdEXb0Mx
	 WiyetWGbgJIRW7VPqO1O4cR5ZWPuKSkjCZI49cCd1o+cTlw4Um+x8eDZ/PHQrhRZOu
	 Sdyno+OPxdhiSx2Be3bad5ALY/gr0Id0+UlZGfgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 015/160] net: enetc: correct the statistics of rx bytes
Date: Mon, 12 Jun 2023 12:25:47 +0200
Message-ID: <20230612101715.788896389@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 7190d0ff0e17690a9b1279d84a06473600ba2060 ]

The rx_bytes of struct net_device_stats should count the length of
ethernet frames excluding the FCS. However, there are two problems
with the rx_bytes statistics of the current enetc driver. one is
that the length of VLAN header is not counted if the VLAN extraction
feature is enabled. The other is that the length of L2 header is not
counted, because eth_type_trans() is invoked before updating rx_bytes
which will subtract the length of L2 header from skb->len.
BTW, the rx_bytes statistics of XDP path also have similar problem,
I will fix it in another patch.

Fixes: a800abd3ecb9 ("net: enetc: move skb creation into enetc_build_skb")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 2fc712b24d126..f7248aed93d98 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1222,7 +1222,13 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		if (!skb)
 			break;
 
-		rx_byte_cnt += skb->len;
+		/* When set, the outer VLAN header is extracted and reported
+		 * in the receive buffer descriptor. So rx_byte_cnt should
+		 * add the length of the extracted VLAN header.
+		 */
+		if (bd_status & ENETC_RXBD_FLAG_VLAN)
+			rx_byte_cnt += VLAN_HLEN;
+		rx_byte_cnt += skb->len + ETH_HLEN;
 		rx_frm_cnt++;
 
 		napi_gro_receive(napi, skb);
-- 
2.39.2



