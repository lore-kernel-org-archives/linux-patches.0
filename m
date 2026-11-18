Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042308;
	b=tLTBMI8HY0FfWkvrgeNQgcJt6f/eZ8qrpx1fr9bRms8owbT8EoxiAwig/JuEKJ+8SdLo
	 wup8pzUngwCBUwcrXXLH5QBzfKygmwudx6Mp5tY1wi428BzWg8n6bGZ3zRwRFAwfSqS2i
	 IfD76uZQd0/Tayc3ge1T0BdE+T12NVGOWI38xcb2J0SbuaKobg4f8Ctd+WsX7mSb0JM9m
	 a68lsCKzQSDxnG2iPM4alrClYxAytwUBAwARzoF9FQ3OAT/l+WYuDXwVN9tY3osbZe4mU
	 RCwCk7GPFLx3UUdoWMy/VxHolXJDHOZvV36PWoDQC+0tyi5xlcaCbQKkdWTsKRu6zxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=prMaMN1f52aCRNUCRN4Fx1y8CpLH0+MS5wgbjBKgk98=;
	b=vQYDUfFvEBbuTGb9oZerqexabTf0nwzKK82cpf3wXMfdHZftes7N/oKQu5FpCXxukvF+
	 Cbmw0eQJszkkKXSy7PMk31LGudC6y/0RPsRR5VSwAyjVzten2O0WfmvmjorgzOjvEE6lc
	 T/zKlNXyq5fSfBZdRT+CiQFwYp4AvQ7jX0xIoYyOmd6K9WXSqVwwZ8ydMQPLItAC7FQ4X
	 qT0ctVo8ngZfzEVzFm7EW/i72xD8/jpln0Lh4Df4g2Z99l818MRydpntOd38a3wuMYGUy
	 1q8ruLtcA1NMSIChJHgZQcwYKgj01JV+xlWkR9mXWJKwR9HdgKNia79JBSP9yuD1+XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrrues8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43937606A320;
	Wed, 18 Nov 2026 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrrues8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679271F000C7;
	Wed, 18 Nov 2026 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042308;
	bh=prMaMN1f52aCRNUCRN4Fx1y8CpLH0+MS5wgbjBKgk98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrrues8K2Hx5joD6WoIb/dDkgj/hk/68RuySDGdV5/bfpVHpuQnT2uIDSZYnVZa9X
	 pmvSkR6spChH+9m28MdYFhPlhZZ8jeb7xUEHMuWrDEmkhhA0PWdWO6yEkKof2l/P3W
	 Y8RWuo/LCQuuVgnvTMjm/819dKeeLtnM/yTYok4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3125/3318] virtio-net: fix frag overflow in big packets receive
Date: Wed, 18 Nov 2026 16:02:27 +0100
Message-ID: <20261118150453.673630057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b0e4ea3a0cd42eccad9cc4153afcad555480b9e6 ]

In big packets mode with guest GSO, add_recvbuf_big() posts a chain of
MAX_SKB_FRAGS + 1 pages. page_to_skb() copies only ETH_HLEN of the
first page into the linear area and adds the rest of that page as a
frag, then one frag per remaining page. A device that fills the entire
buffer therefore causes MAX_SKB_FRAGS + 1 frags, writing one
skb_frag_t past the end of skb_shinfo(skb)->frags[].

Post one page less. The buffer still fits a maximal GSO packet. A well
behaved device does not trigger this, as GSO packets are at most 64KB.

Also check the frag count in page_to_skb() before adding any frag as
defense in depth.

Fixes: 9ab86bbcf8be ("virtio_net: Defer skb allocation in receive path Date: Wed, 13 Jan 2010 12:53:38 -0800")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20261020032108.81879-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b98acab38ac4d..b8a966f03ef65 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -593,6 +593,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	}
 
 	BUG_ON(offset >= PAGE_SIZE);
+
+	/* The first frag starts at offset, each next frag is a full page. */
+	if (unlikely(DIV_ROUND_UP(offset + len, PAGE_SIZE) > MAX_SKB_FRAGS)) {
+		pr_debug("%s: rx error: len %u needs more than %d frags\n",
+			 vi->dev->name, len, MAX_SKB_FRAGS);
+		kfree_skb(skb);
+		return NULL;
+	}
+
 	while (len) {
 		unsigned int frag_size = min((unsigned)PAGE_SIZE - offset, len);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page, offset,
@@ -4501,7 +4510,8 @@ static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
 	 */
 	if (mtu > ETH_DATA_LEN || guest_gso) {
 		vi->big_packets = true;
-		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
+		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS - 1 :
+							   DIV_ROUND_UP(mtu, PAGE_SIZE);
 	}
 }
 
-- 
2.53.0



