Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725311C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91042C433D2;
	Mon, 12 Jun 2023 10:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566400;
	bh=i5GRMU8X5vgM5A6CiqKzVnSXggRBGPrpNQtHLHRHZtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckpZb+pBEI++YGSIsH190DE+05tBJjl8xMzQ/BBgD99rX3gLWL+5ZpP78eDCV3TNw
	 G6OQ3Ue9VnHfSk8NLduGAj2mdLoqq43oq5E+nZIexiMtKXOKsPw+nfyu801KG8m34M
	 5ubiZ3aCo8rgvXzzLVTCJAL5ASM5tiFw6c4xhUF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/132] net: enetc: correct rx_bytes statistics of XDP
Date: Mon, 12 Jun 2023 12:25:52 +0200
Message-ID: <20230612101711.086762002@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
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

[ Upstream commit fdebd850cc065495abf1d64756496050bb22db67 ]

The rx_bytes statistics of XDP are always zero, because rx_byte_cnt
is not updated after it is initialized to 0. So fix it.

Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index df7747e49bb84..25c303406e6b4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1538,6 +1538,14 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		enetc_build_xdp_buff(rx_ring, bd_status, &rxbd, &i,
 				     &cleaned_cnt, &xdp_buff);
 
+		/* When set, the outer VLAN header is extracted and reported
+		 * in the receive buffer descriptor. So rx_byte_cnt should
+		 * add the length of the extracted VLAN header.
+		 */
+		if (bd_status & ENETC_RXBD_FLAG_VLAN)
+			rx_byte_cnt += VLAN_HLEN;
+		rx_byte_cnt += xdp_get_buff_len(&xdp_buff);
+
 		xdp_act = bpf_prog_run_xdp(prog, &xdp_buff);
 
 		switch (xdp_act) {
-- 
2.39.2



