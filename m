Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A212690F4;
	Wed,  4 Jun 2025 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999035; cv=none; b=oVGG0UPuF3FD8XLxnUNJb2kpcX1KUe7KM67cH+ojPWVD2Fga4bAM23vxMz5pGylQMhP89/i/x8692WzIDjSkyzHU8Ur7vTi7Bw3A/WJpCLNLF2yCionlJBVModweLLVlvd51UISAdc0si8ru8Fiz82nZRyXj6SVptA3WNnos1ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999035; c=relaxed/simple;
	bh=gkTWGmSLV1cpH0cPELHxYhpyB0jICgwWfoIOSvWpRZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFmVus/XAO7Aa5KcDS8oWBagdVwssdOwefjJHrRCc61BD2p/JGA3czIy5xeQEAD8mTRjOTcambBHQXLtBFaxSokpRpfxkaq8lWNesL/fh+y96nJGqKyRZYK3D/UCZihuazF1+onUyggSNuHrooUZR11iUz4DaLNhuKX3CuBq6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AvGJKZ+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvGJKZ+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFC8C4CEEF;
	Wed,  4 Jun 2025 01:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999035;
	bh=gkTWGmSLV1cpH0cPELHxYhpyB0jICgwWfoIOSvWpRZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvGJKZ+Zyg5yq2OeAvZapIWryxQWIrZDEf3oKx4Sr4LRbVF6pqX9cnTxTrZQIGk83
	 9MjwA+lIpf5T2PHUGvNQuhhCqWD03p7yR6N1Re5xrsMiFYlZvJYMLMd6CzRkk58+gn
	 obP/I5ZB8MX/npgzTnoQPWo9hxFsPYnpFQWiHHIjVS+Obz+hy1x6zki3/UdD1Fd/nP
	 gcdNUxIP+kAQjUJiKqAO3RqSTaqCc90R5/fIxSC61GgUCpTYEbTOEpzoQLGFz5YcoI
	 xR054l2b9PbIE+6R4ZoNYjcdcXai2NEUpwvoxKDaRA+30kOqhuZ9uAbAeCTE/w/8J1
	 to9Bx+G15pUkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ulli.kroll@googlemail.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 57/62] net: ethernet: cortina: Use TOE/TSO on all TCP
Date: Tue,  3 Jun 2025 21:02:08 -0400
Message-Id: <20250604010213.3462-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees based on
the following analysis: ## Critical Stability Fix This commit addresses
a critical hardware stability issue where the Cortina Gemini ethernet
driver would "lock up and crash" after minutes to hours of operation
under load. The commit message explicitly states: > "Without this quirk
the driver becomes unstable and lock up and and crash." > "After
numerous tests with the hardware locking up after something between
minutes and hours depending on load using iperf3 I have concluded this
is necessary to stabilize the hardware." ## Code Analysis of Changes The
changes are minimal and contained within the `gmac_map_tx_bufs` function
in `drivers/net/ethernet/cortina/gemini.c`: 1. **TCP Detection Logic**:
The code adds early TCP protocol detection: ```c bool tcp = false; if
(skb->protocol == htons(ETH_P_IP)) tcp = (ip_hdr(skb)->protocol ==
IPPROTO_TCP); else tcp = (ipv6_hdr(skb)->nexthdr == IPPROTO_TCP); ``` 2.
**TOE/TSO Activation for All TCP**: For non-GSO TCP frames, it now
activates the hardware TOE/TSO engine: ```c } else if (tcp) { mss =
netdev->mtu + skb_tcp_all_headers(skb); mss = min(mss, skb->len); word1
|= TSS_MTU_ENABLE_BIT; word3 |= mss; ``` 3. **Simplified Checksum
Logic**: The checksum handling is simplified by reusing the already-
determined `tcp` boolean instead of recalculating it. ## Hardware
Architecture Justification The commit explains this is necessary due to
the coupled nature of the hardware's TOE (TCP Offload Engine) and TSO
features: > "it is probably due to the TOE (TCP offload engine) feature
that is coupled with the segmentation feature - it is not possible to
turn one part off and not the other" This aligns with the datasheet
description that the NetEngine performs "IP/TCP header parsing, checksum
validation and connection lookup" as integrated hardware acceleration.
## Pattern Match with Historical Commits Looking at the provided similar
commits: - **Similar Commit #2**: "net: ethernet: cortina: Restore TSO
support" (Status: YES) - This is the direct predecessor that restored
TSO but didn't address the stability issue for non-segmented TCP frames
- **Similar Commit #3**: "net: ethernet: cortina: Locking fixes"
(Status: YES) - Another stability fix for the same driver Both
historical commits addressing Cortina Gemini stability issues were
marked as backport-worthy, establishing a pattern. ## Backport Criteria
Assessment ✅ **Fixes important bugs**: Prevents driver crashes and
hardware lockups ✅ **Small and contained**: Changes are localized to one
function with clear logic ✅ **Minimal risk**: Only affects TCP frame
handling, doesn't change architectural behavior ✅ **No new features**:
Uses existing hardware capabilities more appropriately ✅ **Critical
subsystem**: Network drivers are essential for system stability ## Risk
Assessment The risk is very low because: - The changes only affect how
TCP frames are processed by existing hardware features - The TOE/TSO
hardware engine was already in use for segmented frames - The
modification ensures consistent hardware state rather than leaving it
partially enabled - The fix has been tested extensively by the author
under load conditions This commit follows the stable tree criteria
perfectly: it's an important bug fix that prevents system crashes, has
minimal risk of regression, and doesn't introduce new features.

 drivers/net/ethernet/cortina/gemini.c | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 5af98fba74803..fce2ff1e1d834 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1148,6 +1148,7 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	struct gmac_txdesc *txd;
 	skb_frag_t *skb_frag;
 	dma_addr_t mapping;
+	bool tcp = false;
 	void *buffer;
 	u16 mss;
 	int ret;
@@ -1155,6 +1156,13 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
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
@@ -1167,8 +1175,26 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
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
@@ -1185,21 +1211,16 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
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

