Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623956;
	b=KjIlLh43Pm3107X1831t5ea79n5uqRTWjgSI4qtG6lhGKuMcmwQCCNG9p4b7SjWRJnh6
	 ByCU8xK9joPO87/5H2Dr75X2SF7JHivqmyFhMDq6gRbSwJpgD9KEzldDY5Soxj0dkFg4F
	 /iI2dZArlkWXxU4mRS2xdDaYvZxHHYm/D06Scv3/lCw1j+hEm46ZgGGXeN021CznWjtbZ
	 lkNcKynGAInm2pSCsl32UXaOgcxe+bMTBNxqbXRczl+tAl5kBWoHDrtRoPfnTSUrAV4Ex
	 LdM0T8SfXpAXqhJuqHQ3keZ8csf1mWq7q1rONXikmjOMHUZFRc8xwow8mVuV5adKAEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tB+ZZF1QOCc2mb0RbniBW0kYrGMW7tkiTEJFP/SJdog=;
	b=lEvQYCweUoqEwqMVxgttvUQ//pwvSc9kxZh7E/Q6BekqI6J0gCZoQblTDOjlgWRygEes
	 x/nLeCNFtzaQGyYOnevJm1M4H9lrqfdNVkTxlIggj1HwGtlOtpTSz89m8wa6wbvX1wwRK
	 M8/CKdJBFerJcs0PuCQKeDPOYYcVzS0d3gK8j4NjxJAzpTQcTk1DIg8UiT1CzIbm0eyJk
	 mO3GBHA7kMZW8oKxqpMbyUPKmMst4N4MwkC/he0xYc62kib7Za27KeGA899uGr/9VQ7tz
	 tluDV5wITFrWlA6znfz+1KKBuC2Vq9Oyh7b8e6Hs6FaPtQc0o8RYMge/eFzBfMOLvPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZL5L4QXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CDF606A321;
	Wed, 25 Nov 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZL5L4QXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F31F000C4;
	Wed, 25 Nov 2026 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623955;
	bh=tB+ZZF1QOCc2mb0RbniBW0kYrGMW7tkiTEJFP/SJdog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL5L4QXozmcS8exxd1SBTDGxtJcPhOMfDgvjWV0uXugCaZoFwRYl4OOsqR2qzBe91
	 vtw8vlPDb9TupBImCru5t1PUk1vSHOjDd4MTpV+PVQb6tTXQDaU0Fi0zFO3+KundcU
	 dkvWc0AnXcbT//9M/mfIWYoYrH/OCRkLTLeV9UL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/816] bpqether: reserve the Ethernet devices own header room on transmit
Date: Wed, 25 Nov 2026 15:26:28 +0100
Message-ID: <20261125143850.150055104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

bpq_xmit() makes sure the frame has AX25_BPQ_HEADER_LEN (16) bytes of
headroom, then pushes the two length bytes and lets dev_hard_header()
of the underlying device build the link layer header. That covers a
plain Ethernet header, but not a longer one.

A VLAN device on top of an Ethernet device that cannot insert the tag
in hardware, with reorder_hdr turned off, pushes an 18 byte header
(VLAN tag, then the Ethernet header). A UI frame sent from an AX.25
datagram socket with 8 digipeaters reaches bpq_xmit() with 17 bytes of
headroom once the KISS byte is dropped: skb_cow() leaves it alone, 15
bytes remain after the length bytes, and eth_header() underflows the
skb:

  skbuff: skb_under_panic: ... len:101 put:14 ... dev:eth0.5
  kernel BUG at net/core/skbuff.c:209!
  Call Trace:
   eth_header
   vlan_dev_hard_header
   dev_hard_start_xmit
   __dev_queue_xmit
   ax25_sendmsg
   __sys_sendto

No privilege is needed to open and bind such a socket, so any local
user can crash a host that runs bpqether over this kind of VLAN.

Look up the Ethernet device first and ask skb_cow() for
LL_RESERVED_SPACE() of that device plus the two length bytes.

Tested in a QEMU guest (6.12.94, KASAN) with bpq devices on eth0, on
eth0.6 (reorder_hdr on) and on eth0.5 (reorder_hdr off), eth0 being a
virtio-net port without VLAN tag insertion: UI frames with 0, 7 and 8
digipeaters on each. Before the change the 8 digipeater frame on
eth0.5 panicked the guest with 15 bytes of headroom left; after it,
79 bytes are left and all frames are sent, with no kernel report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 6b7e0767b46d918b5c8a5a2fbb8a9c8a2531d698)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index f027205347d34..ea6bee45e2a4d 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -257,12 +257,24 @@ static netdev_tx_t bpq_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_pull(skb, 1);			/* Drop KISS byte */
 	size = skb->len;
 
+	bpq = netdev_priv(dev);
+
+	orig_dev = dev;
+	dev = bpq_get_ether_dev(dev);
+	if (!dev) {
+		orig_dev->stats.tx_dropped++;
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	/*
 	 * We're about to mess with the skb which may still shared with the
 	 * generic networking code so unshare and ensure it's got enough
-	 * space for the BPQ headers.
+	 * space for the length bytes and for the link layer header of the
+	 * Ethernet device. That header can be longer than an Ethernet
+	 * header, e.g. on a VLAN device that inserts the tag itself.
 	 */
-	if (skb_cow(skb, AX25_BPQ_HEADER_LEN)) {
+	if (skb_cow(skb, LL_RESERVED_SPACE(dev) + 2)) {
 		if (net_ratelimit())
 			pr_err("bpqether: out of memory\n");
 		kfree_skb(skb);
@@ -275,15 +287,6 @@ static netdev_tx_t bpq_xmit(struct sk_buff *skb, struct net_device *dev)
 	*ptr++ = (size + 5) % 256;
 	*ptr++ = (size + 5) / 256;
 
-	bpq = netdev_priv(dev);
-
-	orig_dev = dev;
-	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
-		orig_dev->stats.tx_dropped++;
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
 	skb->protocol = ax25_type_trans(skb, dev);
 	skb_reset_network_header(skb);
 	dev_hard_header(skb, dev, ETH_P_BPQ, bpq->dest_addr, NULL, 0);
-- 
2.53.0



