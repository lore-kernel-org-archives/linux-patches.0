Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434D22259C;
	Mon,  2 Jun 2025 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875935; cv=none; b=cPgSsp8kCc6+oeHnGmWqEPym7zwhc7wpzZUJkJpJGas1Wboj/USHV4uyAsmG5eb5w/BGQzx5XcnSzifxTyoO7CQ3MMN9MS7hxUtnxCYD5s+n017fxPoKf03MVWePkW+5GI/iZaBqz+wgWRuGUEkIYOBmmTqX0MffmPTTb5V1zKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875935; c=relaxed/simple;
	bh=0VMqUYP1PsWb5yId+rVoBG/+JBqBCRTzKKneINtk2OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3/DawgHFc1JcavrypjRZjNBliidIJxNwkbjg0jhYCdv6JJ8F14WmObiCctyjw/RaYinhikgqbkAQEygVVadkr7dk05euQSddtDLo0YJyQnTZI0nM3P3x3OldTjvrDpkf3w2PBSh5fDmCWyAmoNgc31tQsTpw0a8ilsxG0on/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBt1Y3sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBt1Y3sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0B8C4CEEB;
	Mon,  2 Jun 2025 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875935;
	bh=0VMqUYP1PsWb5yId+rVoBG/+JBqBCRTzKKneINtk2OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBt1Y3spvrGXPV6WObz5Ms22e+Ll457qwXDJTfm5pmcoakswaDdSoX2l92rlFhJDa
	 vYQWAi0yZZYieUgSp3ulpZ+ZoH2aSms6YKQ4h3hapluwii66YsZ7tAFj3LbblMm3Fs
	 0A3W/IleaEhr80H2l/BgVUYEIxnKjHH0K03bOLx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/207] net: enetc: refactor bulk flipping of RX buffers to separate function
Date: Mon,  2 Jun 2025 15:46:17 +0200
Message-ID: <20250602134258.981555242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1d587faa5be7e9785b682cc5f58ba8f4100c13ea ]

This small snippet of code ensures that we do something with the array
of RX software buffer descriptor elements after passing the skb to the
stack. In this case, we see if the other half of the page is reusable,
and if so, we "turn around" the buffers, making them directly usable by
enetc_refill_rx_ring() without going to enetc_new_page().

We will need to perform this kind of buffer flipping from a new code
path, i.e. from XDP_PASS. Currently, enetc_build_skb() does it there
buffer by buffer, but in a subsequent change we will stop using
enetc_build_skb() for XDP_PASS.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250417120005.3288549-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 612872c8c8e3c..1068a5ea17b7a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1264,6 +1264,16 @@ static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 	}
 }
 
+static void enetc_bulk_flip_buff(struct enetc_bdr *rx_ring, int rx_ring_first,
+				 int rx_ring_last)
+{
+	while (rx_ring_first != rx_ring_last) {
+		enetc_flip_rx_buff(rx_ring,
+				   &rx_ring->rx_swbd[rx_ring_first]);
+		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
+	}
+}
+
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				   struct napi_struct *napi, int work_limit,
 				   struct bpf_prog *prog)
@@ -1379,11 +1389,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				enetc_xdp_drop(rx_ring, orig_i, i);
 				rx_ring->stats.xdp_redirect_failures++;
 			} else {
-				while (orig_i != i) {
-					enetc_flip_rx_buff(rx_ring,
-							   &rx_ring->rx_swbd[orig_i]);
-					enetc_bdr_idx_inc(rx_ring, &orig_i);
-				}
+				enetc_bulk_flip_buff(rx_ring, orig_i, i);
 				xdp_redirect_frm_cnt++;
 				rx_ring->stats.xdp_redirect++;
 			}
-- 
2.39.5



