Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7982488;
	Wed,  7 Aug 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043208; cv=none; b=Ol+NRDewsP8v9/xGgQ9la/0b4bL2iHdueP2+XyV/hNKdVJu/iduW9A7G6P9Lsi4AWOS24QP99i2RYM241wMhJXsAcnNYGug9GHhDJjQruei2CnuhMtH1CXuoWDcYy4eOmOtBqEMjkzAt9ShmM2NJDLl09hjL7UZi62wTErzwmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043208; c=relaxed/simple;
	bh=Tg7385+GFBkwL6ZhnxfFt5W1j2xrtSfL2SlNit6v67A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StUb3Cp1GPzELLs1eEijROtK5DHFXH90El9OMCbwv5IyYW8HJ7b4k5lDHWy9A52HzNRqViGY1FiZqS4niFudItGBCM9GRzGrQLhwhKFVFQRUQdzDIHwj4EnI3Zj3v4I4BbQbCfVG9OnwDt+1UP3jZ3T6FQh9AdYfaynYplBbAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSdpLLMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSdpLLMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CABBC32781;
	Wed,  7 Aug 2024 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043207;
	bh=Tg7385+GFBkwL6ZhnxfFt5W1j2xrtSfL2SlNit6v67A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSdpLLMjXJbVLlqZaP3+ftGTjw40PYXOgYeMjrwbCfY2yy4j3hUnw6IOl1w2+Clmp
	 Z4tANPCh9DiAUh3eeoEHjtdnGii54yyyMpqmbeCJ6WzDM46jSrQ3m495jNhgqYZF7A
	 phaat4hu8xbeaSZobxxDkPvdZViJEm1TW1qY3VMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>
Subject: [PATCH 6.10 111/123] r8169: dont increment tx_dropped in case of NETDEV_TX_BUSY
Date: Wed,  7 Aug 2024 17:00:30 +0200
Message-ID: <20240807150024.462926913@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4347,7 +4347,8 @@ static netdev_tx_t rtl8169_start_xmit(st
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
-		goto err_stop_0;
+		netif_stop_queue(dev);
+		return NETDEV_TX_BUSY;
 	}
 
 	opts[1] = rtl8169_tx_vlan_tag(skb);
@@ -4403,11 +4404,6 @@ err_dma_0:
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


