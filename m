Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08128615A;
	Tue, 17 Dec 2024 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456262; cv=none; b=qxj/yQsCtPfY9206gZcWGH9CdtQPVw9EJRSkydmHwqop+YOghkX0tw/UcMK+k3hbi09sYcigl/Php3QmjLUN1rLeRVzYENbQESHY/juZ9GbtAIoThW5BC6fAhmdnStdg2KjMqysqwXYb3io1yVZa9uKzeg7nZO18DDmdSjCcSMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456262; c=relaxed/simple;
	bh=yxym0isy+6ZJhyw3P+QReoHHYdZkTkZDUOgLJ25/A9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qlvc+Kd7vF21RZcUXkyQzIVBFlUEtXG4kJHqSCvEnmry7AfP+4EQjpINNcwBB3Z+BB8+RwtROc6GboA2rkW7j46n4EjV8yn0zGpnB8UwgcNTLOYwP5vBPARH3XFu/xSvkKvFevgi/PaW1gbXyygGEbtmTnURPKUBXdzkq04xRsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTcSimqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTcSimqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A9FC4CEDD;
	Tue, 17 Dec 2024 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456261;
	bh=yxym0isy+6ZJhyw3P+QReoHHYdZkTkZDUOgLJ25/A9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTcSimqNzBKz6LfdBmAI+E/NSjhMN2Ctg5lBULH7pd2OAGRgD2qZCS7jieZ/HmOCu
	 pKkP0r49KmGI0TFcQuqjIRpafRQGncEmFdx1iDcM/4Om705ZTtsG/ynO9/wJhYsTsl
	 Gvk1Cm/ZEEaj7azci2xzrSWZDcUwNQyktcWn6uzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Rendec <rrendec@redhat.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 100/109] net: rswitch: Avoid use-after-free in rswitch_poll()
Date: Tue, 17 Dec 2024 18:08:24 +0100
Message-ID: <20241217170537.573479659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Rendec <rrendec@redhat.com>

commit 9a0c28efeec6383ef22e97437616b920e7320b67 upstream.

The use-after-free is actually in rswitch_tx_free(), which is inlined in
rswitch_poll(). Since `skb` and `gq->skbs[gq->dirty]` are in fact the
same pointer, the skb is first freed using dev_kfree_skb_any(), then the
value in skb->len is used to update the interface statistics.

Let's move around the instructions to use skb->len before the skb is
freed.

This bug is trivial to reproduce using KFENCE. It will trigger a splat
every few packets. A simple ARP request or ICMP echo request is enough.

Fixes: 271e015b9153 ("net: rswitch: Add unmap_addrs instead of dma address in each desc")
Signed-off-by: Radu Rendec <rrendec@redhat.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://patch.msgid.link/20240702210838.2703228-1-rrendec@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/rswitch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -799,13 +799,13 @@ static void rswitch_tx_free(struct net_d
 
 		skb = gq->skbs[gq->dirty];
 		if (skb) {
+			rdev->ndev->stats.tx_packets++;
+			rdev->ndev->stats.tx_bytes += skb->len;
 			dma_unmap_single(ndev->dev.parent,
 					 gq->unmap_addrs[gq->dirty],
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(gq->skbs[gq->dirty]);
 			gq->skbs[gq->dirty] = NULL;
-			rdev->ndev->stats.tx_packets++;
-			rdev->ndev->stats.tx_bytes += skb->len;
 		}
 
 		desc->desc.die_dt = DT_EEMPTY;


