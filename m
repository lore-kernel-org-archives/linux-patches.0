Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9006B37757A;
	Sat, 12 Sep 2026 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205374; cv=none; b=fpTRAGUPlWPFLiuO+5+Pn4Q/GF1xKZBpdqv9dLO1vcxDTocofLhO7IkgHiiNGIT7c+uekEl+HMWB3lSC8NJAiLxXUMqYlRUwzDBdk0gVJAGD1mEwDOpUllw6nBuvqMRr05s/Kae9LqaDB44ISFIFXawD7dE/Yj0aNX25Joh31Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205374; c=relaxed/simple;
	bh=Lb5yUvGHZqZSaveYqJ2Sw+imv8UX20zlJS83KT37KWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGJY8lbDg8719aMqMjf1s2ghIhearY6tAGzCEN6KL9C56glxIuG3/AsI/iEn6pzJDsXzFHSmVAcWVnW+n6pzCZbP3TsRPV3nSBTc39+z7rfG5E9+gLHJFqOWdFY6SOPr27bnYA/bjUPh0uxbEHw/OXVl4UWVPXX0kLOOOZpUihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuk68wU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuk68wU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FBF1F000FF;
	Sat, 12 Sep 2026 09:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205372;
	bh=Pxz25+tm7t4Jb963ZrY7zzl/XQHC7/fPqw0dnuhH7iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuk68wU5+gD2cOuYiIZIhGRpUU9c1o9hb9ZOkb37hpg4VWvDqNnOsD1WgZiWGyVsM
	 sZiXR5yZvyNGv55B0ExTYlSgoy/38BdVWyzq0Z5tyIbOdqy5hMB1P43uW8AzcRvigr
	 P+CTQcX3ayrcO8KbqQWj6YFvt7XyMadKSaLfWqPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baldin <DBaldin@dspace.de>,
	Pascal Kneuper <PKneuper@dspace.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1804/1815] net: stmmac: restore NET_IP_ALIGN in the RX DMA offset
Date: Sat, 12 Sep 2026 08:59:14 +0200
Message-ID: <20260912065731.386897006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pascal Kneuper <PKneuper@dspace.de>

[ Upstream commit 23680bf5f8c69c923546b84a8e6c401bef8b88fe ]

Since the RX path was converted to zero-copy, the page pool page is handed
to the stack directly as the skb head, and the offset the DMA engine writes
at is what determines the alignment of the packet headers.

Before the conversion the payload was copied into an skb obtained from
napi_alloc_skb(), which reserves NET_SKB_PAD + NET_IP_ALIGN. The
conversion moved the headroom into stmmac_rx_offset() but did not carry
over NET_IP_ALIGN, so on architectures where NET_IP_ALIGN is 2 the IP
header now lands misaligned:

  64 (NET_SKB_PAD) + 14 (ethernet) + 20 (IP) = 98

Same for the XDP branch:

  256 (XDP_PACKET_HEADROOM) + 14 (ethernet) + 20 (IP) = 290

On ARM32 this is fatal, because ldm and ldrd trap on unaligned addresses
even when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set.

Any received echo request panics the machine, e.g:

  Unhandled fault: alignment exception (0x001) at 0x81873062
  Internal error: : 1 [#1] SMP ARM
  Hardware name: Altera SOCFPGA Arria10
  PC is at icmp_echo+0x38/0xa8
  LR is at icmp_rcv+0x22c/0x370
  Call trace:
   icmp_echo from icmp_rcv+0x22c/0x370
   icmp_rcv from ip_protocol_deliver_rcu+0x2c/0x224
   ip_protocol_deliver_rcu from ip_local_deliver+0xc8/0x1a0
   ip_local_deliver from ip_sublist_rcv_finish+0x3c/0x50
   ip_sublist_rcv_finish from ip_list_rcv_finish+0x110/0x118
   ip_list_rcv_finish from ip_list_rcv+0xc8/0xdc
   ip_list_rcv from __netif_receive_skb_list_core+0x170/0x1c0
   ...
   napi_complete_done from stmmac_napi_poll_rx+0xcb0/0x1030
  Code: e24dd068 e59020a0 e28dc010 e0822001 (e8920003)
  Kernel panic - not syncing: Fatal exception in interrupt

The faulting instruction is the ldm of *icmp_hdr(skb) in icmp_echo().

Fix by adding NET_IP_ALIGN back to the RX offset, which restores the
alignment the stack used to get.

Note that commit a955318fe67e ("stmmac: align RX buffers") made a similar
change in 2021 and was reverted by commit 12d125b4574b ("stmmac: Revert
"stmmac: align RX buffers"") because it caused packet corruption. That
patch raised the offset from 0 without adjusting the buffer size
accounting, so the DMA engine could arguably write past the end of the RX
buffers, though this was never root caused.
Commit df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX
path") since derives the page pool allocation from stmmac_rx_offset(), so
the extra bytes are accounted for.

Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Cc: Daniel Baldin <DBaldin@dspace.de>
Signed-off-by: Pascal Kneuper <PKneuper@dspace.de>
Link: https://patch.msgid.link/20260824125014.47862-1-PKneuper@dspace.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 33cb2067be0aa..3a437409f78ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1531,9 +1531,9 @@ static void stmmac_display_rings(struct stmmac_priv *priv,
 static unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 {
 	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM;
+		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
 
-	return NET_SKB_PAD;
+	return NET_SKB_PAD + NET_IP_ALIGN;
 }
 
 static int stmmac_set_bfsize(int mtu)
-- 
2.53.0



