Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C93264D2;
	Sat, 12 Sep 2026 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220866; cv=none; b=b4GYMrCHmwNQ03e2KvBL6Pv0iFmLFs9c3fDQhNjMIZyn1/9xdiCotZc9S5x0P++ZdMUKlpiJXLPQOqaeAmWB5t1JL+WQydKCkf/Nwnm4DHMhJyi3MIXorHvGKVdWuFWjjqpgHm8UiRteciTs2xmdh8sa0IhhEsaC53BIE/M/HtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220866; c=relaxed/simple;
	bh=rYLWDDdPzPFh29PZaPyl5HOasjQu/tN1USlVWwuYUek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDMq+b/W8+2v8zq4G3pOsi7GYSWpXFmQmiThGTfgUL8OSRBWXh2RRT+A67NVxn9tDRVYa5Cr3qLfRzeyVgmg/ff3OzBnUi1O9Qv+HqKQED6eZZf7RuLTQoHt9qsTdhCFvBysld8AUydpecCBKEqOOgifAOERUQu7h20ckAku4Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SszLRiZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SszLRiZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DC71F000FF;
	Sat, 12 Sep 2026 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220863;
	bh=XVQPDkm2smxn891eXOOUOlxXU9nH9fkjmaKIxgESfGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SszLRiZYPR4twJeCxEuUhgejufhwWfYzGNFK/IQZtJog0M/lD0vi514s+Pb5SyAI5
	 tmaqCcn7CEgF7R2pAiUDYlaj8NOk36lilPjSUlzplIPcm/8dJVslRQA0i4O+9xEVoA
	 +pVZnQjjyr3EeZjKyXLCIKEvyTbJb0QxCNRaQjFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 6.6 0266/1424] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Sat, 12 Sep 2026 08:44:58 +0200
Message-ID: <20260912065613.233116674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 82e15be2d8b9efa6fb1750528d9b6f40e6a8eea7 upstream.

netif_rx() already accounts packets it drops in the core rx_dropped
counter. ntb_netdev counts them again as both errors and drops.

Leave netif_rx() drops to the core. Count the packet and bytes
unconditionally since it was received successfully by the driver.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260819172539.1450821-2-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -125,13 +125,9 @@ static void ntb_netdev_rx_handler(struct
 	skb->protocol = eth_type_trans(skb, ndev);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	if (netif_rx(skb) == NET_RX_DROP) {
-		ndev->stats.rx_errors++;
-		ndev->stats.rx_dropped++;
-	} else {
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += len;
-	}
+	netif_rx(skb);
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


