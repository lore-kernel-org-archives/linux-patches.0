Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AFF486424;
	Sat, 12 Sep 2026 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237060; cv=none; b=hdZv5c0ceB1ASvuL5xAhXBqb96q6ahkvy3enousVOSOUgl9ltvEH0T/+vkre/4wAprbZrZOJ67Z4VsizI796wlVujiOcsfyvCP/n4w6pPoazvtskJjaW0DPjmDBJKUcuZweBY4JKWjXCRUackFCs58nqYzUZuZN7RKQYMP2yr9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237060; c=relaxed/simple;
	bh=J5xup4qNU6KpY4u2gif3lc1AFIdBsMSolBx+dS7N+qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4UjQwkJAE5mciXlcLrgF9+j8TZNXJePHoBeCOydmNuRhE92djV6tI4wH32D+WU9B5EQwCuwbevDv+ZbeewfZChjZcBHSaFssoJt1sjSAmH8OYRbxRAIUqz05bbDZ86dyGDnB2+4dAalKQ95z6ZoGgWT/8pX2Kh5cAezIPgSx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9oZfa1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9oZfa1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8798A1F000FF;
	Sat, 12 Sep 2026 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237059;
	bh=FKDrAU/OEr1IZw4+mRJb00/fZpqYfJvTYQy4jlSXgyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9oZfa1FpM1IMCoep1Wi0JMoeyHWksWr+eedkCO7rtn5Jv1YWRkJ19k5KNCLjfqF5
	 GKHzag6x3rdUPzL1ndLr0mHHZKlMz7kW0cuUa1qBlC8GbJ4+ugCz7/ioKek7THj3N0
	 445ZKNryiA1sM71DBV1ttecB99RcsZVpJlIOFAgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 5.15 183/935] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Sat, 12 Sep 2026 08:53:33 +0200
Message-ID: <20260912065531.014003196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


