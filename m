Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886CA2750ED;
	Thu, 15 Jan 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499274; cv=none; b=rVC0TDi4d6Gi9pY0yRxFRjF88D5QBGoqB26FmjHTiZalYI9OPWDHAaPwD4yi5piCSxbi0jBhJt17triekuCHPkW0DG/K2iE2sYFvZq1dS/p+T+VI70mH/rQKhmsthdQuDr//ccTuguVoub2XUtiDAmjOqdw2gDWTzWYs6mvjAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499274; c=relaxed/simple;
	bh=THs/jDWDNYpFGtLWOLkbyYZhExH6g2n+/Zg8mHwks+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZZYzgt83tJ2Fgg8BbFaugIfKXsDIYqPzd1ykCP8bpmXg8OwwgDtRdeAaSBXeCx+s0NfXreKLqfZoMPxEN5aUGLtS0Y9wIWgLyQhDqia9Xz6ZDDhhGf2bLW+aHI++Y27LSUm80i9Wf3auAq+Ry/uwtt1S2wuVuf9NmE1g6h8Aoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKtjtxNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKtjtxNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFB0C116D0;
	Thu, 15 Jan 2026 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499274;
	bh=THs/jDWDNYpFGtLWOLkbyYZhExH6g2n+/Zg8mHwks+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKtjtxNC0p9fcK1j+/58KhbXnWzRUf+sMDdHMrYLcnEzMNcaW5bNPYzt06EP0RRbL
	 aMq0mPGbp00jGE8VP77xJwyO20Be6G9ofiPKewql4y0Q1rGNkZIhvffEe52m/h/CWb
	 yJj+N/ObDk8+ePfiBRiCJguJRNCbIzkWgFvKg/cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/451] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
Date: Thu, 15 Jan 2026 17:46:11 +0100
Message-ID: <20260115164237.056922551@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>

[ Upstream commit 0c57ff008a11f24f7f05fa760222692a00465fec ]

Packets with pkt_type == PACKET_LOOPBACK are captured by
handle_frame() function, but they don't have L2 header.
We should not process them in handle_mode_l2().

This doesn't affect old L2 functionality, since handling
was anyway incorrect.

Handle them the same way as in br_handle_frame():
just pass the skb.

To observe invalid behaviour, just start "ping -b" on bcast address
of port-interface.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
Link: https://patch.msgid.link/20251202103906.4087675-1-skorodumov.dmitry@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index d04b1450875b6..a113a06c98a55 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -726,6 +726,9 @@ static rx_handler_result_t ipvlan_handle_mode_l2(struct sk_buff **pskb,
 	struct ethhdr *eth = eth_hdr(skb);
 	rx_handler_result_t ret = RX_HANDLER_PASS;
 
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		if (ipvlan_external_frame(skb, port)) {
 			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
-- 
2.51.0



