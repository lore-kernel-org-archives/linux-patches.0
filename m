Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EA31C4EE8;
	Tue, 27 Aug 2024 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769777; cv=none; b=WyeVeqR5ZrRl4XzWPsZj0EsJvJGD+NZQNHvVJtiNC6FBNg9QezuI9w3yiTyt2+qoJeQiB8XiRyGuelBNaER84X/x04bOHz5Uxb4GcHjYAdo/4XqreoLgqIqNIH//PhNr7fOTM+zXGle5G/CGc/sC3uUjidyb6hAeK80RARqFMuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769777; c=relaxed/simple;
	bh=gH7lZFFGIsy7viyJYe4sfroJGaJo3jnPfjkurQSrmSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2KR7QXGDun3vRYNhT0ouj6RT4WRS6RIYjkrmhksm3SvkjxWVncJz+JMAXCjDUwTskvrnnUui8JL9Ik2YhXwIGLC5Ihz7BwkQ64wsjgy3Ii+U/iaepaIa3uxd4aO3fJzkqsz1kw6cDvB5zTuQp9HZ6M1l15+7N3UU23fNBNKzNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12KDbHmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12KDbHmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9860C6104B;
	Tue, 27 Aug 2024 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769777;
	bh=gH7lZFFGIsy7viyJYe4sfroJGaJo3jnPfjkurQSrmSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12KDbHmka4QDc1kdDz0PYLT9jIvBaiokbQlx2SB6zajpvu6dS/UaIAOIusu0yXKI8
	 CFRaHPBeIFO1mYIwSOLB313ZMMvv8HHMtkpY/B8VzVm4t7gtnz7ND4b9HcZefHEemB
	 BsIen+y5CNkv4VFLYz48ibiIKUKbs2Y2ggol2smw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 033/341] net: mana: Fix RX buf alloc_size alignment and atomic op panic
Date: Tue, 27 Aug 2024 16:34:24 +0200
Message-ID: <20240827143844.672854640@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 32316f676b4ee87c0404d333d248ccf777f739bc upstream.

The MANA driver's RX buffer alloc_size is passed into napi_build_skb() to
create SKB. skb_shinfo(skb) is located at the end of skb, and its alignment
is affected by the alloc_size passed into napi_build_skb(). The size needs
to be aligned properly for better performance and atomic operations.
Otherwise, on ARM64 CPU, for certain MTU settings like 4000, atomic
operations may panic on the skb_shinfo(skb)->dataref due to alignment fault.

To fix this bug, add proper alignment to the alloc_size calculation.

Sample panic info:
[  253.298819] Unable to handle kernel paging request at virtual address ffff000129ba5cce
[  253.300900] Mem abort info:
[  253.301760]   ESR = 0x0000000096000021
[  253.302825]   EC = 0x25: DABT (current EL), IL = 32 bits
[  253.304268]   SET = 0, FnV = 0
[  253.305172]   EA = 0, S1PTW = 0
[  253.306103]   FSC = 0x21: alignment fault
Call trace:
 __skb_clone+0xfc/0x198
 skb_clone+0x78/0xe0
 raw6_local_deliver+0xfc/0x228
 ip6_protocol_deliver_rcu+0x80/0x500
 ip6_input_finish+0x48/0x80
 ip6_input+0x48/0xc0
 ip6_sublist_rcv_finish+0x50/0x78
 ip6_sublist_rcv+0x1cc/0x2b8
 ipv6_list_rcv+0x100/0x150
 __netif_receive_skb_list_core+0x180/0x220
 netif_receive_skb_list_internal+0x198/0x2a8
 __napi_poll+0x138/0x250
 net_rx_action+0x148/0x330
 handle_softirqs+0x12c/0x3a0

Cc: stable@vger.kernel.org
Fixes: 80f6215b450e ("net: mana: Add support for jumbo frame")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d2f07e179e86..ae717d06e66f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -599,7 +599,11 @@ static void mana_get_rxbuf_cfg(int mtu, u32 *datasize, u32 *alloc_size,
 	else
 		*headroom = XDP_PACKET_HEADROOM;
 
-	*alloc_size = mtu + MANA_RXBUF_PAD + *headroom;
+	*alloc_size = SKB_DATA_ALIGN(mtu + MANA_RXBUF_PAD + *headroom);
+
+	/* Using page pool in this case, so alloc_size is PAGE_SIZE */
+	if (*alloc_size < PAGE_SIZE)
+		*alloc_size = PAGE_SIZE;
 
 	*datasize = mtu + ETH_HLEN;
 }
-- 
2.46.0



