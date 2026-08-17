Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1541B8F9;
	Mon, 17 Aug 2026 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974960; cv=none; b=lGuAd9shq8VohDv3IeRPCv1fMaxhkccdKJuMPOPNZmCyzgxqfsW9RvDTtV+cB9hfdHKItCFRV1WqYND09OesmB7IGLQGu1N33z4gdz1MNj2bCugZ7Fs7vSRdRDW8IYCANEkSUvk7YRfmy3/l6XcECEaT6i0pA07/cPBqMgB0Y9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974960; c=relaxed/simple;
	bh=SyH0sBlJc41zPHuSxlBnTBJlE/wOinPCAkJABpwqcnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laJx+j6HsaF9JvdIFe+b6Uf1zxkOVLSQ+zozXnVYTU5FlhLinCQulCDxOMH5iXvpccITSv9Niayo9qN3JO1cjFqNvY3DuwjOhWw3BeD+JPrq+LDdlv7DZEQwufHzmS0cHCz/Xaj9ub/COMdxMxtU70qe+/2Gu6NJp61eOiiRR1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPUGxxr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPUGxxr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B11F000E9;
	Mon, 17 Aug 2026 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974955;
	bh=xjZnoMXEoq5PyrlO2TNtgPTZlr1k2R4VYzzTkCLfr8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPUGxxr8bEAzExLb6Ok9ojwrM0lKXD1vHWqqMMLnFPXgIsigWAj7mwxChC16da2gp
	 Yu2MzIaXYyUOcbfDOInofWpn9MOxKKNtvhnDcutGXE8VyIEisd6wWPPNdYttvSLzw6
	 v1iIHfR91JCpVpH4vDK/f61kT1cC/fDWHqG0iI/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/250] net: fec: do not release NULL pages when RX buffer allocation fails
Date: Mon, 17 Aug 2026 15:31:11 +0200
Message-ID: <20260817132541.060907347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index a2cf8cbe2539e..7699a970cb25e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3341,8 +3341,15 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 
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



