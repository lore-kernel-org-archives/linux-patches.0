Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032767;
	b=lYajsav8p/Or81PaaKVoP64h0cziVCDrUNeIcL8RuJWceW0Zf+aTEqnMsc4Y7r1V69qC
	 wYRKT2ucbpnGac/1fG96akQkJv3g+v3xmYTg8MgqOdzLRH9uGkrlVnCdUjshXpGIEb911
	 r4Zc44YsmvqNhUnU3b/AZoSCQnad5sL3c4B+eMGLOS4Fitqedib5VaIKk9YGmuFI1/e+z
	 JszEYcW/DoK94+Lj6Ow1O0x9hAIj3cEvU9TdYj/cWifjprtaURm9yasCtmWJVBYooAmVU
	 NPnHUUt9fTMaJZd8z2aeq9NNQketS0ZDZLH8RTUbWy4Ng5zLIipvfjk1Y/IZyd9G/dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0pjVr5/WXB77h9ygFMvwl8COBVPaGy4kovtCOZ9SoQ4=;
	b=wd+KNX31aasCaVEJF416NJAHQvEiuGkTmXHe0wdv/iBEftSaGjBNeao6V+SFOzOtI4VB
	 fw49P1z4Ax6ZZjGDDlP99JeopA0w+Gy53Xfe67skOehf1QshVHN8cxrsxU5jWE8CcrwcK
	 jdOjwW6a3+MnvYBhWgEqcw0vi1n2B/j3jXtmb8xR6b+pOEgj+TQZiJQWPopV5lgEXXDDd
	 UH6GFHWzrfNP3kvP0gz+3B/oSSLP5m+YHdLoimWK4dXl6VjJH6AFMleOacmvJbq7G4ogo
	 8pbF7l5w3bfL3bfISXqaqc9uR6ahAXmx+chKbxcl2zlPxfad6D2+z6g2CYZUp0T1UFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UfVPCJh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53879606A338;
	Wed, 18 Nov 2026 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UfVPCJh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C9F1F000C4;
	Wed, 18 Nov 2026 20:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032767;
	bh=0pjVr5/WXB77h9ygFMvwl8COBVPaGy4kovtCOZ9SoQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfVPCJh2okPSHmop7sh/jElSPSTSoOOp7J93YtSlFKDuni13fRB3r/dCttT7Xt1td
	 +NO5F6y7EZ158wS05fiZAE8CsaU7uZPnFxigG/kPrzk8aHCAo2g8pLZQiDPTja5wFG
	 FyoYImPmOWLjw0dWi4rBWmFWKXh3+XSbMw+XyqBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1511/1756] virtio-net: fix frag overflow in big packets receive
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150109.043159522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bf4f177417384..f8c9b15e6cbcd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -847,6 +847,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
@@ -6450,7 +6459,8 @@ static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
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



