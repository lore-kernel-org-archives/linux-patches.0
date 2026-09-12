Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACFD345CCE;
	Sat, 12 Sep 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227591; cv=none; b=eKZbzGtsspsEBR/EmYNX7VcE7SLcqSsn2q+mX+WkpTGFboX4AWX+OZibTPUjUi1adqio+csI86W7dzQLDz/C+0pPbtBxw8gajq+LsBMmeIh1uru/YD+08jdcCOJ4cFmuIJuPmsR4DwEp5Qnfk2H36sz/WptodIzVEcAnBrh6RHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227591; c=relaxed/simple;
	bh=IzMRqoXZLbcuIHZ1GLBKU34qwKKMh/VKspIDF4A8YTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRfZVYbm/Oqfwa8ovpf7uMkN/VNfPrsz6sxHSmoSeOBSPBvFqsrnIHyFCd8sToD8Oop16OqFxy3zdi2MarpgZYW7XmfZoEQ94m2YabakQUHYypWLjyxRHMxBUh0hGbveMzT2sVxo0Iw8SelexSCPeAc8ySeTJNAWuasE1HYj9Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDPT++kQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDPT++kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBC21F000FF;
	Sat, 12 Sep 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227589;
	bh=KB3dVOuzacI6aalK8WfbmOZrPsWcSJCyydJhG/A/lfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDPT++kQyYDlzLNeI397gZgtbl1mKxRcQ3lRPx/OdsGOauni4olLOYgkrYQiox4Tj
	 ZuADR4O3jSIAE6ixTIYcWtXhmAJ4Vuk8/3xhDaMtZp/kYNMTUsUBMsKAih+WEzwTwR
	 AGfRPUdHk46TG6zdaZEFv4nryMIwHTGfrYlX9lk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 6.1 0212/1191] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Sat, 12 Sep 2026 08:49:00 +0200
Message-ID: <20260912065552.973669783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


