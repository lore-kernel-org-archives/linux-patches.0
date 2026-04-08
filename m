Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF5337B81;
	Wed,  8 Apr 2026 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674322; cv=none; b=iokp2uw2BUHSVJyuHS1mAdflJXLGvFbeql/o98EeiDsVlGjOd6OuS8vQIVTIumuPZx/2BydGdWdNSX8pVfgmtKeEAHUY7ABr/tMAdI/KReJTHLicZHfZ9AlnxGwli6eY+BZgPSrzcqRocRs5u57WO+9UlrOQQVuKcucSF+Zluj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674322; c=relaxed/simple;
	bh=aYpJSWpOX8D1mqzt7R7eLmjM/v6wbKnMbAFW6zT/rhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt/5/icJ7u8AiXemxn9QMYJ4KoDo5n1huAV21CsxtCzjVWgZPaN3K9o+BrLxKXjSuhS4O/Zjo2lAlvJR1oYn0crWbtSsNPwKBua6hZ8KclDF1piATIjc9SQTTLP6HOtX0dJ3wxO85a4RcyxTfsK/OtkNjE5alxNYBly1dSXLHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/yNJdc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/yNJdc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B5BC19421;
	Wed,  8 Apr 2026 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674322;
	bh=aYpJSWpOX8D1mqzt7R7eLmjM/v6wbKnMbAFW6zT/rhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/yNJdc6ivhoLgo8/O0fQwlVLHR0w1L93Jt67WAZhq9XWXT0aXQXd4NAhGodNf+6G
	 mD993jri497OCmOBrP8P+IpmWBagiJqE4Z2omB7iL0KRYvRBEghssJoS7Wkdtz0Row
	 i4HX92YAhbf5C99kqOCM4e+j4YYpbigTMGn/OQ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 052/311] net: ti: icssg-prueth: fix missing data copy and wrong recycle in ZC RX dispatch
Date: Wed,  8 Apr 2026 20:00:52 +0200
Message-ID: <20260408175941.358917659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 5597dd284ff8c556c0b00f6a34473677426e3f81 ]

emac_dispatch_skb_zc() allocates a new skb via napi_alloc_skb() but
never copies the packet data from the XDP buffer into it. The skb is
passed up the stack containing uninitialized heap memory instead of
the actual received packet, leaking kernel heap contents to userspace.

Copy the received packet data from the XDP buffer into the skb using
skb_copy_to_linear_data().

Additionally, remove the skb_mark_for_recycle() call since the skb is
backed by the NAPI page frag allocator, not page_pool. Marking a
non-page_pool skb for recycle causes the free path to return pages to
a page_pool that does not own them, corrupting page_pool state.

The non-ZC path (emac_rx_packet) does not have these issues because it
uses napi_build_skb() to wrap the existing page_pool page directly,
requiring no copy, and correctly marks for recycle since the page comes
from page_pool_dev_alloc_pages().

Fixes: 7a64bb388df3 ("net: ti: icssg-prueth: Add AF_XDP zero copy for RX")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 11d5b23a61bad..a74a41ad59c82 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -902,6 +902,7 @@ static void emac_dispatch_skb_zc(struct prueth_emac *emac, struct xdp_buff *xdp,
 
 	skb_reserve(skb, headroom);
 	skb_put(skb, pkt_len);
+	skb_copy_to_linear_data(skb, xdp->data, pkt_len);
 	skb->dev = ndev;
 
 	/* RX HW timestamp */
@@ -912,7 +913,6 @@ static void emac_dispatch_skb_zc(struct prueth_emac *emac, struct xdp_buff *xdp,
 		skb->offload_fwd_mark = emac->offload_fwd_mark;
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	skb_mark_for_recycle(skb);
 	napi_gro_receive(&emac->napi_rx, skb);
 	ndev->stats.rx_bytes += pkt_len;
 	ndev->stats.rx_packets++;
-- 
2.53.0



