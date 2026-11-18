Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021289;
	b=ajGQhESvw9Texwy/XxRCl3cW4u1emFPQKa6pVDAx2BV6UVHkQOAfhf0/uFT8NvpVcTbB
	 A95MTsDah0zbL2MZ+/DCae7eVQthVW2aj8fYlgPaLIyV2imlgcIPjl8K+3XTx2GGCJXsz
	 OD85J+RuZLNfS8/rPurxbaEiYbAYeZLXjsmWZ2qmYnzXMZZ5Eh4D++nW4nWXqySHvU4Ts
	 RMF9ckDqF7h0Lq1CT7Ix3ed+MUwgzD4j+kRZz9aL3/bMboCeek8vyrhSCDtvvySlIQ8fK
	 x6W9Npt+lkxSND9UxI63nC3lvcNFsuCFvvxmCQxuobH9SLhXv51wzHgrpn0WwndPvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Z/0I82+QF82ZbpBKGFQ5leallI+BQZHDxd6m/0SZiw=;
	b=CrsXgVPw5IxHFkLrGNc7ftTSSgMNW10OYejR+zGbWVTXTTHyBkpELiPoFqn9ZSYwGRFf
	 iTMyFzUD2j8loN1iFZBRKpyZ/IMmY7Hg9dRK/WSShU+0MkqxK/lDMJzmHcWCw5lOucAXp
	 sGHEmqALG7nizA//BtI4E9XM9RNsqDIQqbItSh1BEhmRZgA+MncnRSwSgRS4CPiAOw06n
	 cK7hXOWCuD9P1VJfbUhmE79yn2djzfswCJiDnUxQYWdH2zWtlx4RM0ZTcLUDETHGIC7wo
	 vabAo7rmm3ndKvY62uIS36HVCmnxa7H8Gcx/mlctRhxfwQ4kJUpaT4kCH8ebmqtdemw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlpVCz9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF11760A2600;
	Wed, 18 Nov 2026 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlpVCz9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8F41F000C6;
	Wed, 18 Nov 2026 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021289;
	bh=5Z/0I82+QF82ZbpBKGFQ5leallI+BQZHDxd6m/0SZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlpVCz9Hdt3Uk6Lp6VhrtyMfX9S737SljuPCXl0/wnqSs7kkl2z+YXG64qGmlpkqP
	 YK3ea/A77rlo3EbSiNsIEAEZbvND8rQtPXipt6psjT7cBW/8GjbV0QFiM1XsFOgJw7
	 BbCxoguYdktSpV9mzbjsNYhX2fBxeUcKqV1gkR/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2254/2651] net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()
Date: Wed, 18 Nov 2026 15:58:14 +0100
Message-ID: <20261118150406.577709230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 07b624d2f5a4517d7d0022fbd4aef17e884b5686 ]

In bcmasp_rx_poll(), the driver removes a 2-byte alignment pad and
optionally strips the ETH_FCS_LEN CRC from received packets before
passing them to eth_type_trans().

If the hardware reports a descriptor size smaller than the sum of the
2-byte pad, the Ethernet header (ETH_HLEN), and optional CRC
(ETH_FCS_LEN), subtracting the pad and CRC lengths underflows u32 len.
This adds ~4 GiB to rx_bytes statistics, while the undersized frame
reaches eth_type_trans(), which reads past skb->len into stale buffer
data.

Check that desc->size is at least (2 + ETH_HLEN + (crc_fwd ? ETH_FCS_LEN
: 0)) before proceeding to process the descriptor.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-4-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 9ad5a982542f5..d679c796c8c20 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -523,6 +523,12 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
 					DMA_FROM_DEVICE);
 
 		len = desc->size;
+		if (unlikely(len < 2 + ETH_HLEN + (intf->crc_fwd ? ETH_FCS_LEN : 0))) {
+			u64_stats_update_begin(&stats->syncp);
+			u64_stats_inc(&stats->rx_dropped);
+			u64_stats_update_end(&stats->syncp);
+			goto next;
+		}
 
 		/* Allocate a page pool page as the SKB data area so the
 		 * kernel can recycle it efficiently after the packet is
-- 
2.53.0



