Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E742443E2D;
	Mon, 17 Aug 2026 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980312; cv=none; b=awKq/LNBQcU9vJQO8bmtpLZ4EuUwOplyQZ898XCXvoVWIr3EugZUY5Z3w8xYhxpWFGtwc/lL984V38cM375QFfkXMMTc6oHZwu2DRpWvHuUHmQnFUMEdzv3A6DqU17VvnIi3/nw3z6IBMoA2C3TZwSFASWTSWzrF0eLRqXJsXgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980312; c=relaxed/simple;
	bh=uAm4058QTkoxaMEiysfOJEBomrc/KR6POUU6ZboW7JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vukn7M4QhysKUUjCaoQ4QP6iKas8EEE+GhkAbpLLEIbnyNgdvYUWfjfSxLAxS3O4Q6KQ4P51HJ41/WCgvDnkOkFYWLzgcvQK3drBDTPIyE08LDRBFnNa83QtPuCjCpEu8TqKC348gwuhx4sQb72uVhiBdbKeqGyoFeFY6Pq8GeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxvBoyEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxvBoyEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F9C1F000E9;
	Mon, 17 Aug 2026 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980311;
	bh=8ZOsUBZNumYAmmBUqHhTAhwv8ht1WhT5T5oRM+iEkwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxvBoyEyGzkCMc3CR/+4vNPE0/1/cnQ7ly3cMyAsPc7ljmghNJSmZ96pDdcA/dqTB
	 UYAK1ACVNY9w+PJh1JHDzXCTi2XBnjk+TB6NXOK8dWOc9HyTPEHNv2cqQCZVbRSi3X
	 FZR/quiRDOgOiuwWsH5R7bsKIhAPwTSGNxqL3lHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/609] Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"
Date: Mon, 17 Aug 2026 15:33:06 +0200
Message-ID: <20260817132600.315798965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/thunderbolt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ef13aa36e55e8..6f01089e6f47d 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -884,12 +884,8 @@ static int tbnet_open(struct net_device *dev)
 
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
@@ -908,6 +904,11 @@ static int tbnet_open(struct net_device *dev)
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



