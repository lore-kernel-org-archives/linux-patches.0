Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6BE43303D;
	Tue, 21 Jul 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662316; cv=none; b=jcDec6SjiTzUNsDX0wy0fuOXbw3qQgUudVtnWSuSsX+LzclHH5hVT3DpxPmMDbgvVo5F48uOqdIFa8cUrN9pXZ/I5KsaUT9+/Frt9gyzdrVrBKScz61E+97qlMOqeio2hyTA92pXnZt303LjFay8M1Jil7/RtQz0zY2nzLR3oRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662316; c=relaxed/simple;
	bh=0OX/AEDYUwXUnX7j0xVh5M5KHh9szIcAb0I6o4CDsT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br0Uv7XP8BVlmaf9j/v9BB3zsdjgWfsMZu9vlPGe8FskOnqOm9Kyyt8WhAnrUWqY5UDMPnmdm/nIfNF9NaQ0znfigN6kjtaqsmz9f0/ylO6RXwlxueBs1bAalsSU4WgDRJKUIgAkjIPFWQvhb8RX1rlKDLXWPzJCk1L3jtzbkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6eqbOpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6eqbOpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B31F000E9;
	Tue, 21 Jul 2026 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662315;
	bh=R/REkgcNWz+3EvI7ROBverNrzpSQQczVMJFg1vzpZFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6eqbOpnVRKvrXT+/T2IC5LlZ/3mmT66+KoKQNA40dDod0dnYOZ2bX7svW4kFULcM
	 y/sa6GF2tF+19gTMwUum1d6eylW08UZcdk8c/m56FVqsmWTOLeTZ7Er1ZHHL7Q7Cxy
	 LY94drILmsqeX0fxTYdHUTYGC92MLuu9Nm/j54zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0397/1276] net: ethernet: oa_tc6: Remove FCS size in RX frame
Date: Tue, 21 Jul 2026 17:14:00 +0200
Message-ID: <20260721152454.987390744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit a5a1d11dd3729146abe7420b874bab15870a42b4 ]

OA TC6 MAC-PHY appends FCS to the incoming frame. It must be
removed from the frame before being passed to the stack.

With FCS in the frame, many applications, like ping or any
application that uses IP layer may work as they may
carry the packet size information in the protocol.

Application like ptp4l, particularly if it uses layer 2
for its communication, it will fail with "bad message" due to
the extra 4 bytes added by the presence of FCS.

Fixes: d70a0d8f2f2d ("net: ethernet: oa_tc6: implement receive path to receive rx ethernet frames")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260611-level-trigger-v5-3-4533a9e85ce2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -751,6 +751,17 @@ static int oa_tc6_process_rx_chunk_foote
 
 static void oa_tc6_submit_rx_skb(struct oa_tc6 *tc6)
 {
+	/* MAC-PHY delivers each frame with its Ethernet FCS attached.
+	 * Strip it before handing over to the stack, unless the user
+	 * has asked to keep it via NETIF_F_RXFCS. Keeping the FCS
+	 * in the frame is harmless for IP traffic, but is parsed as
+	 * a (malformed) suffix TLV by PTP, which makes ptp4l reject
+	 * every message with "bad message" error.
+	 */
+	if (!(tc6->netdev->features & NETIF_F_RXFCS) &&
+	    tc6->rx_skb->len > ETH_FCS_LEN)
+		skb_trim(tc6->rx_skb, tc6->rx_skb->len - ETH_FCS_LEN);
+
 	tc6->rx_skb->protocol = eth_type_trans(tc6->rx_skb, tc6->netdev);
 	tc6->netdev->stats.rx_packets++;
 	tc6->netdev->stats.rx_bytes += tc6->rx_skb->len;


