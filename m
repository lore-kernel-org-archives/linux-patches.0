Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D013A25F;
	Tue,  9 Jul 2024 11:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524240; cv=none; b=FNdTHHgWxvmEfvJ+0h8RXJa5HwSrzCFXThxaqImkVQdGAnqxP306wqSx3Px9fY3SCvy4gP8WtpCoMZRqGcqI4LE5oyI4vM3RsSGi27+YmKBxzZrvSYsT4uF2Ngg6XgzoBodFoSDAXOrUOFzQ0t2/d7ErOr6IXkUn9BFbkZm/iI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524240; c=relaxed/simple;
	bh=Sm6Vy5SeTtofdQwaKhBQ7ynfpcNKp/hTjJusGCU3J6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4+dMkiDdZbWFVQ+QDuqWqudK6tfpUcLgGjhpPr8baP0ah5AZPKDsaECj8LG0/iGV+gE9iuKosDnC9snriBtOc9O/B1TKueDJ/4tviUFyajxt/+31oxGRGt8aVFsv88PPQ2Dw972boRlL/nm1+DpIHagD2LDqN6cpkIvp1AjQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKGy/tK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKGy/tK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29FBC3277B;
	Tue,  9 Jul 2024 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524240;
	bh=Sm6Vy5SeTtofdQwaKhBQ7ynfpcNKp/hTjJusGCU3J6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKGy/tK212PuIdMqk02dC2KLWvi2rz7RXRDMLHmnXtcc+3oAI5ISLl3Oo0Z9pQje4
	 rcio2KcZxmP3sqnYD4eNtywIGBWeOx2ufviS1hhhGKkoAVBe+ivRq2Tb23phbc8iLI
	 dSP05Ssu9aYoCITJyGy3aKjvQvtbIrz2JRugcUAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Rendec <rrendec@redhat.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 117/197] net: rswitch: Avoid use-after-free in rswitch_poll()
Date: Tue,  9 Jul 2024 13:09:31 +0200
Message-ID: <20240709110713.477337303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Rendec <rrendec@redhat.com>

[ Upstream commit 9a0c28efeec6383ef22e97437616b920e7320b67 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index dcab638c57fe8..24c90d8f5a442 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -871,13 +871,13 @@ static void rswitch_tx_free(struct net_device *ndev)
 		dma_rmb();
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
 	}
-- 
2.43.0



