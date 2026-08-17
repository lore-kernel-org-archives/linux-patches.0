Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B4641F34C;
	Mon, 17 Aug 2026 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978008; cv=none; b=tfXKoRPqgtxS6RwncK1cjCcRMGTFxUJux+FVhyW+wjHH6UNjW3l6tWiI69/61MkZyd5qNM8+Sou5ynX4tR1yMHmqPshD54O5xfS1Ddgvyu55w16U2uD61Q9fyV6KuYg3IcdaNWTt8v47tVwa5NdszzY06/95/zjJcV4wFJCDuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978008; c=relaxed/simple;
	bh=w3BvrrXxmdG4BKi5hrvEzm5fUNNpD+ZzLFYpYmVB268=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOF7QhQ+7e9wI7B46pGKaP37iMrQUTTEHG5gvjo0/PAARDURFOM2/Nhh8DnJPq+v7uP5g0FDEd+Qh5/3u8Lxh467PNDrDxKajDAfPhIVLoMsCPn9/OJPtooxjTtxiuTMHm26wfb6Ncu3Ubc6540V+CMgd93XY+Yz+uPHmEjhqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUU+iwds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUU+iwds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A4E1F000E9;
	Mon, 17 Aug 2026 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978007;
	bh=QUawUCKQF9Di5yNPtidnng8a6ViuKeDUKN+ZXwZHJFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUU+iwdsavjw4ENKoCT5qyhmf7c/xfFtz9h/GhNhXo+IRsUCgcA5d9yLzibFfKjdr
	 vyIKoxeioOuYfyNB2H1+moNgug2j0hpDKnDx/4B0S0BR1OceNd1u5dvc7hhOam5PU3
	 KH7aD/9/7igmPg2ETnPazfS+o9g63Ri1t3yyuH6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/181] net: fec: do not release NULL pages when RX buffer allocation fails
Date: Mon, 17 Aug 2026 15:32:42 +0200
Message-ID: <20260817132538.112644783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

fec_enet_alloc_rxq_buffers() leaves the loop as soon as
page_pool_dev_alloc_pages() returns NULL and jumps to err_alloc, which
calls fec_enet_free_buffers(). That helper walks the whole ring and
hands every rx_skb_info[i].page to page_pool_put_full_page(), including
the entries the allocation loop never reached. Those are still NULL,
because the queue was allocated with kzalloc(), and
page_pool_put_full_page() dereferences the page, so an open that runs
out of memory oopses instead of returning -ENOMEM:

  Unable to handle kernel NULL pointer dereference at virtual address 00000014 when read
  Internal error: Oops: 5 [#1] SMP ARM
  CPU: 0 PID: 384 Comm: connmand Not tainted 6.18.43 #1
  Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
  PC is at fec_enet_free_buffers+0xb0/0x2a8
  Call trace:
   fec_enet_free_buffers from fec_enet_open+0x1e0/0x504
   fec_enet_open from __dev_open+0x114/0x238
   __dev_open from __dev_change_flags+0x190/0x208
   __dev_change_flags from netif_change_flags+0x1c/0x58
   netif_change_flags from dev_change_flags+0x44/0x74
   dev_change_flags from devinet_ioctl+0x3a4/0x768

Seen on a Colibri VF50, 128 MiB of RAM, on the first ifup after boot.

Skip the entries that hold no page, and clear the ones that do after
releasing them, so that a later failed open cannot release the same page
a second time.

Mainline is not affected. Commit a2ae70c0efe4 ("net: fec: add
fec_alloc_rxq_buffers_pp() to allocate buffers from page pool") replaced
this loop with fec_free_rxq_buffers(), which skips and clears the empty
entries. That commit is part of the XDP zero copy series and is not a
stable candidate, so this is the equivalent minimal fix for 6.18.y.

Fixes: 95698ff6177b ("net: fec: using page pool to manage RX buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d8189c433847c..22cd47d19ce24 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3323,8 +3323,15 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 
 	for (q = 0; q < fep->num_rx_queues; q++) {
 		rxq = fep->rx_queue[q];
-		for (i = 0; i < rxq->bd.ring_size; i++)
-			page_pool_put_full_page(rxq->page_pool, rxq->rx_skb_info[i].page, false);
+		for (i = 0; i < rxq->bd.ring_size; i++) {
+			struct page *page = rxq->rx_skb_info[i].page;
+
+			if (!page)
+				continue;
+
+			page_pool_put_full_page(rxq->page_pool, page, false);
+			rxq->rx_skb_info[i].page = NULL;
+		}
 
 		for (i = 0; i < XDP_STATS_TOTAL; i++)
 			rxq->stats[i] = 0;
-- 
2.53.0



