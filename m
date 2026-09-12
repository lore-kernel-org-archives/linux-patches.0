Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E820344DBD;
	Sat, 12 Sep 2026 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241567; cv=none; b=DkyT0nPdEH3nBjz6AmDAJz5RKxPeBKExk/605ekO81cLJn8SrOBXtbURnafUTRsjDW5jV2H6hcMjj9GFLYHjkY0upHc2bBD+btQfqxVlqb6WXve6a6tkW0iUXLwOVQjQlducKXrE5Hb+cdmfxivh+EogJEW6JGYqRu7jH0ibHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241567; c=relaxed/simple;
	bh=1bIv3uRvDx4S3/FGupkG44IIogn+gWGD1CDqGYT7joc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCk0OdbI+u3l8/JxJTwCmjnW/hZ7wdCOG2qOKNbXilIqmejLZRGXrANhbXNmwaRZI52C1mW6JQVrsE5XL+0SHO3wJ9ZWl+x1dWC8JAEzgyC6lx/bSkTb1wR0oznJT3r6M/xdvf4jsEo8i7iKDVPL+RsGvW0bwO6dUxnJQwecI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wq8Vjq25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wq8Vjq25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE9F1F000FF;
	Sat, 12 Sep 2026 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241566;
	bh=oWNZXNT6z4ao34SRNt+MWnTjV4UUX1KlvsEBB9y2d4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wq8Vjq25ZtbS5UU3+u6TGE6QshjAdtR+7kRNrICxa7GH46o27uwN4TtLB+1KI/BDf
	 zxE3z+w9T9+z28/xparabwGr14q1o7/OMSz8j4CvF+vN5GDuV0KqB3UAuEQupcWsiL
	 2yAxJL0lDaf9IuJ2TJCBq+a5ec7Hf2ky0/SAgwH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 5.10 163/798] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Sat, 12 Sep 2026 08:56:31 +0200
Message-ID: <20260912065520.758385490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
 


