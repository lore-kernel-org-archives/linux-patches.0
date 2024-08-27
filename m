Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE601C68BD;
	Tue, 27 Aug 2024 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770962; cv=none; b=GIRV2nh7unt73gz2ACrrEyCmULYEHTGmSR3P0if0GQcSjz+IbhyRW5Vg3i87pyXYif0WYaNd00sLHYmBVXtI9KX9n6zLYyaKU5w0wpQRf+3qZVBdC17oA5Qf7HEG92iEOk44gV1GZZfkM229kK1YsX/ErGF3q1+3zYEUIbVV14c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770962; c=relaxed/simple;
	bh=u10Jrvd+VvSiusOjyPkjAsKNiADXCFWDRkBco1WBA/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm5Zo5qcCT/C/VVcqPfQOA2oeB4retleVrVT5t2l1a2pojp/wllOEMm+T9tbzUzWkCG9Jn8d12rd/ihVTL2xdywKPTs2XNoRyTzEFGTQld5PYhjoP3iZwXJ5ytzGppFnnH+kp5EsHLEwdmL55pVkNAhv18YSKRklJ8qwOscjZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLvZWwyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLvZWwyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E529C61043;
	Tue, 27 Aug 2024 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770962;
	bh=u10Jrvd+VvSiusOjyPkjAsKNiADXCFWDRkBco1WBA/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLvZWwyb1d6azv0gVjyPB4nvWO/0AUJeZNmVbf+jLC1QScSei076P/AITTRyG9a9P
	 y9UAnVoW8/Wgyke0rJpQdlCg5LNRjjs1lzwpefhRgtHVf7LuMn9UA6jv8btmeFZAFf
	 lF2HH5IJDvZKBqteuKANrFzqmrY8gNSWqjJ03cHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 046/273] net: mana: Fix RX buf alloc_size alignment and atomic op panic
Date: Tue, 27 Aug 2024 16:36:10 +0200
Message-ID: <20240827143835.150832042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/microsoft/mana/mana_en.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -599,7 +599,11 @@ static void mana_get_rxbuf_cfg(int mtu,
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


