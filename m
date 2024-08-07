Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3717F7F5;
	Wed,  7 Aug 2024 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043540; cv=none; b=Wt5/HjwHP7LAZ6tGsJrwKmm0r7kBp9hkJ3NmeyZfhaMJHOio3OUDW9vMD5IikGmJO+i15kixypFaL9H4rdXB9AHmxPxNGDThBqetRemCKiJaec242QbH6+hGQ+oUbNAQMMufOX6CkGTy9EGWavS0yZnuVqKsRZcKjZEbrAd/e0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043540; c=relaxed/simple;
	bh=7okaDeJbe/27T9TAzPkoMr0kaZwNrONwcLXAxMwi8lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig4oZOz9Vtp2LpmahYkJ7vjCktQnLCStkcSKYo2PgY/LinK5IL+wkJLcHbTSNngarl+XOkfHjP2sAWyGYUOop3MKiJwA14NBMY9QuRXKxZUe80QDB7uAMVhquvCEExutKBE6l/IrOhcQtEFgmCsVdHFyjlg0jKAfDr5KBodcgN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ5TPiId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ5TPiId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F124C32781;
	Wed,  7 Aug 2024 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043540;
	bh=7okaDeJbe/27T9TAzPkoMr0kaZwNrONwcLXAxMwi8lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ5TPiIdal64eBMtKLEAMA17zQ5zbgog4MBCqjVbGpLmbvgwjt33MpV+NwsaCHSvX
	 5zFu0wiBqFRhpY665M/nWEMv5VkZYUwYkP2izJxa1Nqz864ufBLWfLA3KaqzL6v3LY
	 q8M3fRh7DMB1aX4Sqnzx/zIa1up4Gsi7EmO/Mt38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>
Subject: [PATCH 6.6 110/121] r8169: dont increment tx_dropped in case of NETDEV_TX_BUSY
Date: Wed,  7 Aug 2024 17:00:42 +0200
Message-ID: <20240807150022.999876259@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit d516b187a9cc2e842030dd005be2735db3e8f395 upstream.

The skb isn't consumed in case of NETDEV_TX_BUSY, therefore don't
increment the tx_dropped counter.

Fixes: 188f4af04618 ("r8169: use NETDEV_TX_{BUSY/OK}")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/bbba9c48-8bac-4932-9aa1-d2ed63bc9433@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4256,7 +4256,8 @@ static netdev_tx_t rtl8169_start_xmit(st
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
-		goto err_stop_0;
+		netif_stop_queue(dev);
+		return NETDEV_TX_BUSY;
 	}
 
 	opts[1] = rtl8169_tx_vlan_tag(skb);
@@ -4312,11 +4313,6 @@ err_dma_0:
 	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
-
-err_stop_0:
-	netif_stop_queue(dev);
-	dev->stats.tx_dropped++;
-	return NETDEV_TX_BUSY;
 }
 
 static unsigned int rtl_last_frag_len(struct sk_buff *skb)


