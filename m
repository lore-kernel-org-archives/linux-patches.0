Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046273;
	b=klI2X5v6tNVfrGPEvhhwvuS+/DfVifqn25sF/5gwSsvMdBAW7w/dok3e8vC/Tgyw80Dz
	 OOk1equLHeTc9Pf3qAFE7NQDEdwKdf2rclHioh2G4HLkb1RevWR7+zEuD/K1RuKP6oOZx
	 qxIA5DW/bfk1x+WdPgDyJSphkNt94NLbuLobjQ5npArra6gDP2HwC0Wlc3Ey/OArSi2qs
	 MJfuWANJKnzzgmDQm52UN6ZD+qSR2lHv0Unxqd+szmYqi0Niwv6qQoMXosv+UD7d3oalF
	 jdYIJj6jocgH/wzndy9ui6fvfMBF3uynso66WkY3bT/VySIW2rgSwKTnwhComNIPTig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1GMtnd/Di7AVZOGV/nj58btpmF7S/8KCuBq61XJBJ3E=;
	b=ZjshjPX1Abjgtt722VXvKYuzznZ3FaIWzwH4KhWnRmXeHHapz3X1FhbVLa5Sr9Kg4VbD
	 K05d324HxzyFWfkDNy2nklbHUOFE4BbLKRhcpGh01M/Kh3HorHxgorucxMUqBnrvijXP3
	 ESXURUOHm93F52vWWsh/BibfaApznkIgwBV33x2Q5DZ8lYAd/hUaLsXYFlyXDA0MlZWGU
	 35Zv1ST/lNfMfAEOpWpAOgkX3Y17OM7gonHU2I4F8GiyXKXDQt7DALnPUXm9NZ+3NNpLb
	 THITYr3kPVTKADWT5rXXO9PSDqvcPLFACwMmRjQpz1MRhVxEP/2XvQTxjDWOWxt5StA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehQAqTg8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF298606A31C;
	Wed, 18 Nov 2026 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehQAqTg8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87211F000C4;
	Wed, 18 Nov 2026 23:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046273;
	bh=1GMtnd/Di7AVZOGV/nj58btpmF7S/8KCuBq61XJBJ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehQAqTg82aRroBtF/AtLxo+rY1uYuWsLQbm/phF5W9Da9MI1rm6cyZKzz9p8wgBR1
	 Dln/W9q5spsYevovFpws28FsK5CVWAel0eqL2ICxyoFprDsDV1MwE2GQ2+5rVMQT9I
	 E+InnGB01Rx4qa8pSGcREJuYJZ2g0GSTFBf4Yaxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Musto <federico@rimpianto.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1222/2857] net: atl1c: drop oversized RX frames instead of panicking
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150245.569912614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Musto <federico@rimpianto.com>

[ Upstream commit c4ba1716853de5178a9df785844ebb5e397a80e6 ]

atl1c sizes its receive buffers from the netdev MTU plus a fixed set of L2
overheads, which comes to 1522 bytes at the default MTU.  A link partner
that sends a longer frame - in practice a MikroTik CCR2004-1G-2XS-PCIe,
whose RouterOS side defaults to l2mtu 1600 while the host stays at MTU 1500
- makes the length reported by the RX return descriptor exceed what the
hardware wrote, and skb_put() then either includes bytes that were never
received or trips skb_over_panic and takes the host down.

Compare the descriptor length against buffer_info->length, the length the
hardware was given, rather than against skb_tailroom(): the skb carries 64
bytes of slack for the DMA erratum, so tailroom is larger than the DMA
buffer and a frame in between would pass the check and still be delivered
with a tail the device never wrote.  The same test rejects frames shorter
than ETH_HLEN + ETH_FCS_LEN; before this change a reported length below
ETH_FCS_LEN underflowed in skb_put().

The frame is dropped with kfree_skb_reason(SKB_DROP_REASON_PKT_TOO_BIG) so
drop_monitor and the kfree_skb tracepoint see it, and counted through
dev_core_stats_rx_dropped_inc(), which survives atl1c_get_stats()
overwriting the hardware counters on every read.  It also counts as work:
atl1c_clean_rfd() has already recycled the RFD, and the refill at the end
of the poll only runs when work_done is non-zero, so sustained oversized
traffic would otherwise drain the ring and stop RX.

Tested on a MikroTik CCR2004-1G-2XS-PCIe (4x AR8151) in a Proxmox VE host,
with atl1c built from a DKMS tree carrying this change: the l2mtu-1600
traffic that panics the stock driver is dropped and counted with the patch
applied, and received normally once the host MTU is raised to match.

This complements commit 36c2009d90f2 ("net: atl1c: fix soft lockup on
out-of-range tpd_cons read"), which fixed the TX side of the same
"host dies while the card resets" problem.

Fixes: 43250ddd75a3 ("atl1c: Atheros L1C Gigabit Ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Federico Musto <federico@rimpianto.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 959160cdec6f3..3b70c4d45fed9 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1943,6 +1943,39 @@ static int atl1c_clean_rx(struct napi_struct *napi, int budget)
 			break;
 		}
 		atl1c_clean_rfd(rfd_ring, rrs, rfd_num);
+
+		/* A link partner whose l2mtu is larger than ours can hand us a
+		 * frame that does not fit the buffer the hardware was given:
+		 * the descriptor reports the untruncated length while at most
+		 * buffer_info->length bytes were written.  skb_put() of such a
+		 * length would pull in whatever the tail of the buffer holds
+		 * and, past the end of the skb, trips skb_over_panic and takes
+		 * the host down.  Bound it by what the device actually wrote
+		 * rather than by skb_tailroom(): the skb carries 64 bytes of
+		 * slack for the DMA erratum, so the two are not the same.
+		 *
+		 * Frames shorter than an Ethernet header plus its FCS are
+		 * rejected by the same test; before this, a length below
+		 * ETH_FCS_LEN underflowed in skb_put().
+		 */
+		if (unlikely(length < ETH_HLEN + ETH_FCS_LEN ||
+			     length > buffer_info->length)) {
+			dev_core_stats_rx_dropped_inc(netdev);
+			if (netif_msg_rx_err(adapter))
+				dev_warn_ratelimited(&pdev->dev,
+						     "dropped rx frame: %u bytes, buffer %u\n",
+						     length, buffer_info->length);
+			kfree_skb_reason(skb, SKB_DROP_REASON_PKT_TOO_BIG);
+			/* atl1c_clean_rfd() has already recycled the RFD, so
+			 * count the drop as work: the refill at the end of the
+			 * poll only runs when work_done is non-zero, and
+			 * sustained oversized traffic would otherwise drain the
+			 * ring and stop RX for good.
+			 */
+			work_done++;
+			continue;
+		}
+
 		skb_put(skb, length - ETH_FCS_LEN);
 		skb->protocol = eth_type_trans(skb, netdev);
 		atl1c_rx_checksum(adapter, skb, rrs);
-- 
2.53.0



