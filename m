Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213050;
	b=tArYiaUHK4B9jxBCZkFASIFZg75BGKGXIafqTD9yfvBp7dPVVNR4VAsOwsscLUOn4rVY
	 uqtKtdh2bDlOH3jJMXYp8GvfW+6AyQmWK1kyMy8+7syBbSSq9Fii6EeZbf3ozP4DBPmiZ
	 nuna7uGekR14D8KQ4x9fiI9OmwtC11uAfzFY40WK0izRd4R2DNIHfeiZhNLN10O3LpyRh
	 EbVwslzlL3cDUX+p3ydbWpvhlMmFesRhPyqmaZ360ruXVBCd2AgOSNr4TaSRdE2Qu06JU
	 LgRIOKtg+7EZMWIQJnBpuV7YgTopBDPhK2GdjJ23+E3Trk4oLmxN17gTPvzs93e+Csg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ah6960f7VtWQayHlue2hXcaAa0+PWfP74S5xm5rmU3g=;
	b=RSGNdj/TxtFImXesMknCRRdDeGrzTStTdD1flGP1YBa6iqYP0O+alSUsy9ezxPdBeNXx
	 +p2VJPjyS1ustrEjhAa6HshKNVmTgVeicxyiFYNSCHR+EEdhl/V+lsKIFms4PcQr96SmD
	 xbR/Mvz/dS7h86E3bjH+VyxezU20lIdXoBQ10YeaGMPCfMQhL9nWvIX/zU5nqxCCdxPWz
	 HXIlB5lXhAIdSMd9my9tLT2BRLpAtSoH4xDP4qjN97KTTVlT29lQqiZFw3scOTt5sHivd
	 9X89bAV3SVVZL45AwKaZJ6rogyU91tH7UprhB/vANjXddUO8A2yew7b6sYLktjNXytg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ox+V7++e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264E606A31C;
	Wed, 28 Oct 2026 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ox+V7++e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BFD1F01825;
	Wed, 28 Oct 2026 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213049;
	bh=Ah6960f7VtWQayHlue2hXcaAa0+PWfP74S5xm5rmU3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ox+V7++ebCW1sWhujp4H8+jg1bA8O/XJPq2LymExUabfa1qUD9L0N8mwuD+uBxkmU
	 942n/bPt8StYR8dbtOVlDBjRQepr4baWtT2vYkZSkqw2jg/uSKJ5UlS4jyXMwd31SL
	 qbzqwNvlxzs4eOuCkrdVqZOCYkrXFK7oJVf4oHj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0369/1887] xen/netfront: drop RX packets with a short Ethernet header
Date: Wed, 28 Oct 2026 17:41:05 +0100
Message-ID: <20261028170507.630149641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 089e58805c452e52179482b1025a8e309a57f801 upstream.

handle_incoming_queue() pulls pull_to bytes into the head before
calling eth_type_trans().  pull_to is the length of the first RX slot,
capped at RX_COPY_THRESHOLD, and that length comes from the backend.
Nothing checks it against ETH_HLEN.

If the first slot is shorter than ETH_HLEN and more slots follow, the
head ends up shorter than an Ethernet header while skb->len is longer,
and eth_type_trans() BUG()s in __skb_pull().  If the whole packet is
shorter than ETH_HLEN, eth_type_trans() reads the header past the end
of the data instead.

Pull at least ETH_HLEN, and drop the packet if that fails, which also
drops packets too short to hold an Ethernet header.  This also checks
the return value of the pull, which was ignored.

Fixes: 0d160211965b ("xen: add virtual network device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-short-head-v1-1-12d7113a7e4e@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1233,8 +1233,16 @@ static int handle_incoming_queue(struct
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
 		int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		if (pull_to > skb_headlen(skb))
-			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		/* pull_to comes from the first slot's length, which the
+		 * backend controls.  Make sure the head holds at least an
+		 * Ethernet header for eth_type_trans().
+		 */
+		if (!pskb_may_pull(skb, max(pull_to, ETH_HLEN))) {
+			kfree_skb(skb);
+			packets_dropped++;
+			queue->info->netdev->stats.rx_errors++;
+			continue;
+		}
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, queue->info->netdev);


