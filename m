Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB93F928B;
	Mon, 17 Aug 2026 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973973; cv=none; b=YPc8w+I3++wsJy4+mGPRUzmcG9MzE1XiyVKM+CRVG6RLgScAbzpQo9Y21JrwRSEW2RtbJeoAWYc9YuzKyIGmL832XZ2euTDtJh3C35Jz2TCiRl7RLX1hcJ7FRHODGw6jjiwA0c/fWGiMrWenXVZoci0BMO9Z3e4lUgkHu5Y03/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973973; c=relaxed/simple;
	bh=04IlCNpf4u0P+9GNGyLjS38EEKascrvfSGxaq2xDUms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RutHP7SnhLCpEIhvHeFszt5PlN9+s3Yd2g03lpEs0H1pq2jpBNKMAres6GBc00CP6XF7CGCw0IT/M4XW3k5elVc6LcMPoSua0ZQWLcjZ4NCdBtLAXbVhS3UjrYGY3NdwqrL5GtopPNYWsTwOnoetThuP7Gw7j+Wt1KKd9Ru4GlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDvkuUc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDvkuUc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E881F00A3A;
	Mon, 17 Aug 2026 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973971;
	bh=zZCeVDF3Jz5CrwFschW4meaINxTNXdXGLNi94VscdZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDvkuUc1G5ACvh88AHQpgyiA3iGE2/PiYlrqsyo0fa9s3IEpjwUo/uzi2tDCZW9l8
	 u0FnfeA8Q8XpzClzd8HsWSWR2NC6UlSyDISLBURA+gaLt2IO9Ts1S0HWmCrgvFnOJ3
	 JOgrlSqowlZ6+oP2UR91GTDJtqKt071uotdhSFyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 037/271] Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"
Date: Mon, 17 Aug 2026 15:29:22 +0200
Message-ID: <20260817132538.275724192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Ye <fy15309206903@gmail.com>

[ Upstream commit 1881f2efbf7f78dc0a79a387b29fde6ff56d3731 ]

This reverts commit a8065af3346ebd7c76ebc113451fb3ba94cf7769.

Per the USB4 spec, a Transmit Descriptor Ring with E2E flow control
disabled does not require any credits to be available before the Host
Interface Adapter Layer transmits a tunneled packet from it. Once E2E is
enabled on that ring the controller must first obtain end-to-end
credits.

The ASMedia ASM4242 USB4 host router (PCI 1b21:2425) never delivers
those credits. The controller does accept the configuration: reading the
ring OPTIONS register back right after tb_ring_start() returns exactly
what was written, including RING_FLAG_E2E_FLOW_CONTROL (bit 28) and the
E2E HopID field. No credit ever arrives though, so the Tx ring's
hardware consumer index never advances and the link carries no traffic
at all.

Measured on two hosts connected point to point, onboard ASM4242 on MSI
X870E and X870, v6.17, stock drivers/net/thunderbolt/main.c with only
this revert applied on top:

  before: 100% packet loss to the peer; thunderbolt0 is up and the
          XDomain handshake completes ("new host found"), but iperf3
          fails with "No route to host" once the neighbour entry
          expires
  after:  0% packet loss, 0.28 ms RTT; iperf3 4.21 Gb/s one way and
          5.17 Gb/s the other (5 runs each, stddev <= 0.02), 1
          retransmit in 10 s

An instrumented build additionally showed a frozen-Tx-consumer watchdog
firing ~30k times in a 10 s window before this change.

Rx-side E2E is not touched by this revert, so peers that do return
credits keep receive-side flow control.

ASMedia does not look like an isolated case. The out-of-tree
thunderbolt-ibverbs project disables native E2E on AMD NHI by default,
noting that "Strix Halo has reproduced TX completion wedges with
multiple native E2E rings active" -- the same failure mode, on a
different vendor. Since the driver has no way to tell in advance which
host router returns the credits, going back to the previous behaviour
looks safer than adding a quirk per affected part; Tx-side E2E can be
reintroduced as an opt-in for controllers that are known to implement
the credit return.

Note that the reverted commit was not fixing a reported problem, it was
derived from the spec wording alone, so this revert is not expected to
regress a known workload. Cc'ing the original author in case there was
one.

Fixes: a8065af3346e ("net: thunderbolt: Enable end-to-end flow control also in transmit")
Cc: zhangjianrong <zhangjianrong5@huawei.com>
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260727123002.25225-1-fy15309206903@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index ac016890646cf..0cd98496d135d 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -929,12 +929,8 @@ static int tbnet_open(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-	flags = RING_FLAG_FRAME;
-	/* Only enable full E2E if the other end supports it too */
-	if (tbnet_e2e && net->svc->prtcstns & TBNET_E2E)
-		flags |= RING_FLAG_E2E;
-
-	ring = tb_ring_alloc_tx(xd->tb->nhi, -1, TBNET_RING_SIZE, flags);
+	ring = tb_ring_alloc_tx(xd->tb->nhi, -1, TBNET_RING_SIZE,
+				RING_FLAG_FRAME);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Tx ring\n");
 		return -ENOMEM;
@@ -953,6 +949,11 @@ static int tbnet_open(struct net_device *dev)
 	sof_mask = BIT(TBIP_PDF_FRAME_START);
 	eof_mask = BIT(TBIP_PDF_FRAME_END);
 
+	flags = RING_FLAG_FRAME;
+	/* Only enable full E2E if the other end supports it too */
+	if (tbnet_e2e && net->svc->prtcstns & TBNET_E2E)
+		flags |= RING_FLAG_E2E;
+
 	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE, flags,
 				net->tx_ring.ring->hop, sof_mask,
 				eof_mask, tbnet_start_poll, net);
-- 
2.53.0



