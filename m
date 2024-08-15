Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04371714A1;
	Thu, 15 Aug 2024 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730254; cv=none; b=KmQoaZJt/p5fUxT8qLyj1AEkYsypCCAT8/6vC1r+ODzXC141GsDsQCNt0qcWtaNvoICIAlwG7Atwm6fLiHvSgaYTPEZWYQ4mkhklS2LYNSonbTWbBh8MyaM+gvF1etJ7S9vyXTPXR0MhZxvX8BRXX0khE7wJBe//lGa9NxGgP4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730254; c=relaxed/simple;
	bh=pVt6r0XEqxrCFFScv/zZzp8Vmt94iIEXa4abpduRy/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evKkDqRhOj+1Meo1gyjWGYEfOgNijspQGwclg1z666//XJIGRL8d+6tpXL0xHcCcjv2UGHZYWRn3lxhozfjhxdSGVRmY11fqXJgze/B+wob2IwwMLfRIXhlLe1D0Sc4yTf3dH9e7NV6oBwQxh2ggiXzjqRulP7OzvdCGk/vv9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1Za4p0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1Za4p0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6033CC32786;
	Thu, 15 Aug 2024 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730253;
	bh=pVt6r0XEqxrCFFScv/zZzp8Vmt94iIEXa4abpduRy/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1Za4p0f4BgZXMIm45mD6nI4NFEj/mIjJjqr+pp/2rsMGmH1/nL/h0GEYxYCuCqUf
	 hQLglMRCByx9Pg7OHkJzh34SEEbOx2y+HL9Sbg4Y3IsbYbDxKgATIe9JaUba6T2PyW
	 Ykm3Pb0tkFo9fyAFlg//DBvI1xnleStxr1ur4lvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>
Subject: [PATCH 5.15 351/484] r8169: dont increment tx_dropped in case of NETDEV_TX_BUSY
Date: Thu, 15 Aug 2024 15:23:29 +0200
Message-ID: <20240815131954.985473851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4283,7 +4283,8 @@ static netdev_tx_t rtl8169_start_xmit(st
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
-		goto err_stop_0;
+		netif_stop_queue(dev);
+		return NETDEV_TX_BUSY;
 	}
 
 	opts[1] = rtl8169_tx_vlan_tag(skb);
@@ -4356,11 +4357,6 @@ err_dma_0:
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


