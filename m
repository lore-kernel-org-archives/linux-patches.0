Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6A2D7380;
	Sat, 12 Sep 2026 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212534; cv=none; b=jJSBSZEtHJ8q4811+HFuYiugW3ieOLdLC1nx2i93BDEkx+WnGYAIPvHFJ9W/xOr+SQcr74Dd7SUANEInv+RuKsRaroNFUX8eRmnYVQCY2qgZqMaO7PjRbvHt/z6hjx35VlwU1A3cx1XQAOrgIxgEBgP4/srEpViEjNHmHYnLjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212534; c=relaxed/simple;
	bh=hEOBrZk/nO7KmjeyrP5D6+T05HSqd8LJE4z/YAd0V/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFFAnybkK6bbEH3sgkXoylP+90FyZnemWtvrDHKDA2m/WsS9KBzKgmqh+fOuxiOaTadu6E2LtiX8guQkBCgn0xyJF/xDDDCuemBGqZTzvk884GgrswVhG9t+J+zuZhL9xLI/gC7TvH0So1C7TUiAzZGDmpJtOEP2W71RnEyYvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfKdRgiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfKdRgiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70081F000FF;
	Sat, 12 Sep 2026 11:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212533;
	bh=hQcehqn+x+mfLtaTfqDVjW5ZGcKKi9DD6BvcsVqi2j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfKdRgiC144LH/4uhTDUiKsaknqhpYzCpMfgG/y/QT6AyWDpU01YkJ/RrgbMmgD5h
	 tFR5/teci7e8JY/yAXP6saiREicTARvp3uE9wfDFn6xOiBLRe5LvAlG3usk2X0e0Lr
	 T6/5HuYGraUrrW0ncogGk0jvXmHkOg6ZqhPr08A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baldin <DBaldin@dspace.de>,
	Pascal Kneuper <PKneuper@dspace.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1455/1518] net: stmmac: restore NET_IP_ALIGN in the RX DMA offset
Date: Sat, 12 Sep 2026 09:00:24 +0200
Message-ID: <20260912065656.469089987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6cf44d7bb642..a3eeb68c8d3f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1326,9 +1326,9 @@ static void stmmac_display_rings(struct stmmac_priv *priv,
 static unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 {
 	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM;
+		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
 
-	return NET_SKB_PAD;
+	return NET_SKB_PAD + NET_IP_ALIGN;
 }
 
 static int stmmac_set_bfsize(int mtu, int bufsize)
-- 
2.53.0



