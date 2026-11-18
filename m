Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027719;
	b=V4SjJjrc4MjeP3vAJPYqyGGa5GvsuE2d3C6Ee7NLYN+WgvBOCizKgcnbwEwo6R1wqidp
	 V5qIcL3Al+nUWRT49HfWw04ZXmTGxRt5P8sbqTmGFF4yKBLEJQRFWm1pKkAkLs7dgHyNl
	 qG02G9NekGgJNR9sTFKdc8mp/MR7CPWotTT9KxkNf/rlMsQRQZsGBRZ6Yh0qmyOiXRHjA
	 cH6CTiCY/vucoilxtkIAE+HnHTJm10fHHKBhiuM9nSKAAPqDA2i4HVxlg4PUs3TM41wct
	 RmYg7wSm7gm4UMbmmDUs3trwdg4AMLpovT9OB/9moEfQzy7CG8SC0jL/U7zEJ9cnFXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ifsRVEJJJ1LmgP5/y5HupZKOT7Fbq6Jjkt2NERAU8Vc=;
	b=z7hIpWsfPf2CaywB9nNXXRp2vMZnxrfxKm/JAo4mqJrQ9i8olHSGs58AOsEr58NhVxhd
	 fcI/aEp8NgCVatamQN103VVwJR4iF/XM9hrep58DsjcEUl6v+zAF8UIKpTYsYJHMgephR
	 58wZ6izTS4bvqIfwIggaSpXd4MtPsAW7ciDw0S/D1RchwFNVWmBpHDwAI1auzmID3hDWy
	 WYETtmCEJ0dJ6XpOtdDNDxMER0YzOSXQ5xoidBYNJtrW3xpu4a5JgguVbNgrc0n2MTAXY
	 6Rzb0HhoHfo7na41aR5fc+CdVBhehb6emKgataUilaiYszG3FxT0nr3vQn68rVGxGBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LY/h1FSd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A4606A325;
	Wed, 18 Nov 2026 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LY/h1FSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E785A1F000C4;
	Wed, 18 Nov 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027719;
	bh=ifsRVEJJJ1LmgP5/y5HupZKOT7Fbq6Jjkt2NERAU8Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LY/h1FSdibJad6F8xjkqygaIRtdIcv4vyUyU6RXGFLWppTQ7aYfkhsfIWGn0RbXtK
	 COEcJbzfJwQLPUj9RIsisP8MKtS7HNmcmLn6Z4fxhm7lgqf0dS7pH7m4PG8x1zYl+N
	 2aNNtp//Xy5iP5NtCNX5OWHprd3//sUsX9l/V2/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1889/2151] virtio-net: fix frag overflow in big packets receive
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150230.608168470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 34390befdf8a8..ea83313caf363 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -909,6 +909,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
@@ -6780,7 +6789,8 @@ static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
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



