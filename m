Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DFB2222A9;
	Mon, 23 Jun 2025 21:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714762; cv=none; b=P+GGQSt08ZrKLH4X2iDG4nd99P2hnS2RkrcXL672ATgK10v6ZsywXF1gURnXIPkLD/bAbLclQVuTDYMcX4LmiCbb7XUyEQK/8QnLM00t4DeK26H8z1X40878AQzDwVI2gDVzjYqc76wcuOu/OaXPFcbbtThXlN8HzsEaRyvvjTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714762; c=relaxed/simple;
	bh=ExgXrT69UTx9vwHajI+3hqWbw5md9nKqBeAjKaPC4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrzVXzOxW4J20VAc2TAOfE0/GeryaXcjOgR7GIYnRcnIV/VkTs1s6lre9kfJ4kvJ88cJPKEPx27g9FxRR7rbCc5F8Ps1j8JAY+GyhfBd/0dhE47yw3/tB8yJHe5OUq+UU5Wo+u2mQM0J9ytqhM8f/Az1D01hAbM4qyG2IXiIDxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pr2caacK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pr2caacK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBFAC4CEED;
	Mon, 23 Jun 2025 21:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714762;
	bh=ExgXrT69UTx9vwHajI+3hqWbw5md9nKqBeAjKaPC4ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pr2caacK+7BWgQPBy9vXMLJwSH4N7YpgIfYz/UbPXw5ULFXyyL+eZzHSQnfApnuBS
	 mJmB/czMp9d5tWAjanLdIpbPEfmTqw7JfebEy7fEIcBdusktCeCT5Wh/qA0dcC4xSk
	 QcEmr+1dv6ckVjeUCEoRYYciG9KzEyBI8qU2LCIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 414/592] net: ethernet: cortina: Use TOE/TSO on all TCP
Date: Mon, 23 Jun 2025 15:06:12 +0200
Message-ID: <20250623130710.285709689@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 6a07e3af4973402fa199a80036c10060b922c92c ]

It is desireable to push the hardware accelerator to also
process non-segmented TCP frames: we pass the skb->len
to the "TOE/TSO" offloader and it will handle them.

Without this quirk the driver becomes unstable and lock
up and and crash.

I do not know exactly why, but it is probably due to the
TOE (TCP offload engine) feature that is coupled with the
segmentation feature - it is not possible to turn one
part off and not the other, either both TOE and TSO are
active, or neither of them.

Not having the TOE part active seems detrimental, as if
that hardware feature is not really supposed to be turned
off.

The datasheet says:

  "Based on packet parsing and TCP connection/NAT table
   lookup results, the NetEngine puts the packets
   belonging to the same TCP connection to the same queue
   for the software to process. The NetEngine puts
   incoming packets to the buffer or series of buffers
   for a jumbo packet. With this hardware acceleration,
   IP/TCP header parsing, checksum validation and
   connection lookup are offloaded from the software
   processing."

After numerous tests with the hardware locking up after
something between minutes and hours depending on load
using iperf3 I have concluded this is necessary to stabilize
the hardware.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20250408-gemini-ethernet-tso-always-v1-1-e669f932359c@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 517a15904fb08..6a2004bbe87f9 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1144,6 +1144,7 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	struct gmac_txdesc *txd;
 	skb_frag_t *skb_frag;
 	dma_addr_t mapping;
+	bool tcp = false;
 	void *buffer;
 	u16 mss;
 	int ret;
@@ -1151,6 +1152,13 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	word1 = skb->len;
 	word3 = SOF_BIT;
 
+	/* Determine if we are doing TCP */
+	if (skb->protocol == htons(ETH_P_IP))
+		tcp = (ip_hdr(skb)->protocol == IPPROTO_TCP);
+	else
+		/* IPv6 */
+		tcp = (ipv6_hdr(skb)->nexthdr == IPPROTO_TCP);
+
 	mss = skb_shinfo(skb)->gso_size;
 	if (mss) {
 		/* This means we are dealing with TCP and skb->len is the
@@ -1163,8 +1171,26 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 			   mss, skb->len);
 		word1 |= TSS_MTU_ENABLE_BIT;
 		word3 |= mss;
+	} else if (tcp) {
+		/* Even if we are not using TSO, use the hardware offloader
+		 * for transferring the TCP frame: this hardware has partial
+		 * TCP awareness (called TOE - TCP Offload Engine) and will
+		 * according to the datasheet put packets belonging to the
+		 * same TCP connection in the same queue for the TOE/TSO
+		 * engine to process. The engine will deal with chopping
+		 * up frames that exceed ETH_DATA_LEN which the
+		 * checksumming engine cannot handle (see below) into
+		 * manageable chunks. It flawlessly deals with quite big
+		 * frames and frames containing custom DSA EtherTypes.
+		 */
+		mss = netdev->mtu + skb_tcp_all_headers(skb);
+		mss = min(mss, skb->len);
+		netdev_dbg(netdev, "TOE/TSO len %04x mtu %04x mss %04x\n",
+			   skb->len, netdev->mtu, mss);
+		word1 |= TSS_MTU_ENABLE_BIT;
+		word3 |= mss;
 	} else if (skb->len >= ETH_FRAME_LEN) {
-		/* Hardware offloaded checksumming isn't working on frames
+		/* Hardware offloaded checksumming isn't working on non-TCP frames
 		 * bigger than 1514 bytes. A hypothesis about this is that the
 		 * checksum buffer is only 1518 bytes, so when the frames get
 		 * bigger they get truncated, or the last few bytes get
@@ -1181,21 +1207,16 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		int tcp = 0;
-
 		/* We do not switch off the checksumming on non TCP/UDP
 		 * frames: as is shown from tests, the checksumming engine
 		 * is smart enough to see that a frame is not actually TCP
 		 * or UDP and then just pass it through without any changes
 		 * to the frame.
 		 */
-		if (skb->protocol == htons(ETH_P_IP)) {
+		if (skb->protocol == htons(ETH_P_IP))
 			word1 |= TSS_IP_CHKSUM_BIT;
-			tcp = ip_hdr(skb)->protocol == IPPROTO_TCP;
-		} else { /* IPv6 */
+		else
 			word1 |= TSS_IPV6_ENABLE_BIT;
-			tcp = ipv6_hdr(skb)->nexthdr == IPPROTO_TCP;
-		}
 
 		word1 |= tcp ? TSS_TCP_CHKSUM_BIT : TSS_UDP_CHKSUM_BIT;
 	}
-- 
2.39.5



