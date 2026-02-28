Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1DA332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301227; cv=none; b=XGmd7VqzeUigJZmmFTRZ0dhyNcq7OfWKKmt0EzyNuaO49MaBubx5bhWNFA5Y03EPplb5zRj0vqlUcjkHQHHW1KhgaRh77lPW7cAOG4a1KzH2QsyaxALLEqzEuEkT8b7C69x3uaLnmRSyDD1brqsr0yyYo1Ww1puJqdAoehLetjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301227; c=relaxed/simple;
	bh=sUGRmpIzP6VTIdZXiy1GrpAXt4jwWFVe8WWblpyBuAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxvCSs04Y3SMgkUTgTVqEZXpwUKb7JjUx0/wAUpUVTBqpqJdwmEC5za+1uIXZb8uD5fqXStOMYk6bgaiRHnqooqeZomi8fCU8ZCxWbSlF/7mzmFV1qFrLRZ1rEpT7hubsDzqPpsCQ2wuY1LgyLbAgKDovv19qwPum8tERXB3uJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3xvKlj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3xvKlj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26374C19423;
	Sat, 28 Feb 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301227;
	bh=sUGRmpIzP6VTIdZXiy1GrpAXt4jwWFVe8WWblpyBuAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3xvKlj9KT/NhQyNJEWPxE3H7+1f1avic2fNN1ERygfb6bcL3lJAIB0E+6kKkFDQ9
	 3394u/30uFP8P8jTSgIaB5usobd6AK2TyZpxBH5hOzEea+ZVTpZnaA7I4hv7iBQ5oQ
	 WvbcsGGp8vD2yBO84ClaSM8z0ENhPl+qn9mliJyB6kBE/nveo2TYLgUv5sp55yOQPU
	 FFPuJXkCbhisaLW6FusqHihSdGdV/T0rfTjWsEz+sXIp/vRnB43FmlnSqDC1N22u0W
	 +G9HyYXeQiYG/jtFC2Sw172/lZMMYt3sOs8LS54OMF/Wr5qG+Z6AI0736EryqbU66M
	 q7QgW1KYIE+Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/752] net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
Date: Sat, 28 Feb 2026 12:41:56 -0500
Message-ID: <20260228174750.1542406-405-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 64868f5ecadeb359a49bc4485bfa7c497047f13a ]

kaweth_set_rx_mode(), the ndo_set_rx_mode callback, calls
netif_stop_queue() and netif_wake_queue(). These are TX queue flow
control functions unrelated to RX multicast configuration.

The premature netif_wake_queue() can re-enable TX while tx_urb is still
in-flight, leading to a double usb_submit_urb() on the same URB:

kaweth_start_xmit() {
    netif_stop_queue();
    usb_submit_urb(kaweth->tx_urb);
}

kaweth_set_rx_mode() {
    netif_stop_queue();
    netif_wake_queue();             // wakes TX queue before URB is done
}

kaweth_start_xmit() {
    netif_stop_queue();
    usb_submit_urb(kaweth->tx_urb); // URB submitted while active
}

This triggers the WARN in usb_submit_urb():

  "URB submitted while active"

This is a similar class of bug fixed in rtl8150 by

- commit 958baf5eaee3 ("net: usb: Remove disruptive netif_wake_queue in rtl8150_set_multicast").

Also kaweth_set_rx_mode() is already functionally broken, the
real set_rx_mode action is performed by kaweth_async_set_rx_mode(),
which in turn is not a no-op only at ndo_open() time.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260217175012.1234494-1-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/kaweth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index c9efb7df892ec..e01d14f6c3667 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -765,7 +765,6 @@ static void kaweth_set_rx_mode(struct net_device *net)
 
 	netdev_dbg(net, "Setting Rx mode to %d\n", packet_filter_bitmap);
 
-	netif_stop_queue(net);
 
 	if (net->flags & IFF_PROMISC) {
 		packet_filter_bitmap |= KAWETH_PACKET_FILTER_PROMISCUOUS;
@@ -775,7 +774,6 @@ static void kaweth_set_rx_mode(struct net_device *net)
 	}
 
 	kaweth->packet_filter_bitmap = packet_filter_bitmap;
-	netif_wake_queue(net);
 }
 
 /****************************************************************
-- 
2.51.0

