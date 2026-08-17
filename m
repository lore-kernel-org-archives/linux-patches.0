Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216573F3281;
	Mon, 17 Aug 2026 13:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974847; cv=none; b=RbD2jA6SxYYMA3Dj5NOiTCEhnMbgwthxLV1xE4IqOKHZeDWuCestsxpR26FxJDeYjeI+9RZl/kT0NkahFcbyRfcOnszgVRtlWJ7+pY0ICP5RgfeiDfZDNnMJNeXQsCW6Zq3hwsTiyGqylZ4ud785tyTBcc0nz6AZXtvt9IwXjUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974847; c=relaxed/simple;
	bh=prNh7ozj8A6ABltMWPcnAfHthUdxMjJ6XcHjFV1JqEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKuEAF0o0/mZlDPeJa3IZ9z3+DvzZai/hNsfLpEw4WlKAG4V1Kh9HqH9CxItw64yMm4uwWpIyx5URXVvVDN8sH0Jr2aBkQwQOp3jChKK+DbnagLjaaAUIocCkiE1NMKfrYPlIo7hxOruX/HtmwykcjkWDgZiRmtOxyg7KMtMk8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0mzNJjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0mzNJjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3D11F00A3E;
	Mon, 17 Aug 2026 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974839;
	bh=0D/O3GJJ7ub8quxDQI1ZSZKIput+vzTK41pVYTAjQQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0mzNJjT+ZJN0EqAkVZxiOKZDo4/0Fmau92953mZwE27rUAQwzCfC092/msnz59AT
	 4ziylsy0ZYTo2fbihraERvQ3H4JiSP4v3itjGYT4KVFyhwDmk8t7DkKEpa0rKvURVJ
	 3vWr+2q0gEU3Ds/KdjoN4NWcKjF9e8vfirs8avBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/250] Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"
Date: Mon, 17 Aug 2026 15:29:53 +0200
Message-ID: <20260817132537.763577892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d7d11d75b0b8..960839a651e51 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -928,12 +928,8 @@ static int tbnet_open(struct net_device *dev)
 
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
@@ -952,6 +948,11 @@ static int tbnet_open(struct net_device *dev)
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



