Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E423EE1FC;
	Fri,  4 Sep 2026 06:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502848; cv=none; b=oexrFY0EI8TPg6VMPE/L0+keYEkI3PisXZ4h+XQpn0s+LtRKFQ2h4D1ucmUnrSmjm4obOLXpEVdMbieumYpwxchwBzKyfTlg8/csVVFWtIeUW42gtk28QmQkX3Fps64dyfmiiZDProkCwn+mAD3ov+EHcAqpeNuNZ/x9k6cBrRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502848; c=relaxed/simple;
	bh=VRoCZznJZ4f6l2Wv3cB/DIyAfp+sRdeF+kVbkrcKuuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+T8vlCaRULfX5rewwQMfx1+KflFo5cnhaALigWZLhq70xvrVzJ3nrcyPRDPb1ORL7aixK26hvzSqU99qV3Va7wt/rQla5O256CpibBnAQAO4Chk0tglwG39NZ6pSLzxBQcEYEi9qMYWydlnl7IFGlR6Rczf84OuwtksGr/+n3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYiD4iNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYiD4iNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199731F00A3D;
	Fri,  4 Sep 2026 06:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502847;
	bh=UJgB31cyOQ6ZEZ7wRTvhposlxiMEw9RYJ1ncTM9MamA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYiD4iNIt2xoLUtI6splqVllxcbpv+bguimt7+1b5QFlB+H+aT9w76TxOLavNv6BX
	 Olt63trkUrDOfh1J7e4zAILWvF6hZmKr0O38CzlMoXV5oOO5povSVjB375h1QIoWgI
	 L39E8wisHlExHdyWaRNdsTPbwb+0Kn6h/ljAXqYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 6.12 350/403] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Fri,  4 Sep 2026 07:02:33 +0200
Message-ID: <20260904045742.773873634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
 


