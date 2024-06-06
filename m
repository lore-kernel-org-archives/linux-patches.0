Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76219FA95;
	Thu,  6 Jun 2024 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683138; cv=none; b=cm6Qt3zP/Pz+7WGNxE5jwnmfXFoYDQN8ZA0oqTmGmiNH+TqGepldc+2t+WptXpCw/9GvZkcGQrqtY2g7HNyxWU5k/Wc4bwXPjhgS2siioIpj3FSUHvQh5JVYZFBecRHWEJbSoiuywdXM/NVsTxKaYhJxHr71pt/LTYquzip4xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683138; c=relaxed/simple;
	bh=GUwEQWJIf9a35Rq6zR8iZEJ+rgwnsU075P3JeJ60ol8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs9hUmtV+76iLqMCpk+fQYYa02HMBShl20rIlypXGWdlmY115RTdAjRTcTM/lhS/64UqcGv6J9qVkjwRNZynWtUP8G5MPT353WOAqzFt+27SM1oJ2ALgAmw/ixUdYPqexwzZpJ2yDqpQ7vNT3nMa8xlvCam/cp5aJy2aqjILrhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpQoM+F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpQoM+F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11129C2BD10;
	Thu,  6 Jun 2024 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683138;
	bh=GUwEQWJIf9a35Rq6zR8iZEJ+rgwnsU075P3JeJ60ol8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpQoM+F7yapOk4mpGayVDeNE906xf2iM6grUxMlpC4tlharzrWD+O5UGJr8gBRJNG
	 bMduFHUJYMajhEbCrWWi+rNFbVjZNK1xbZpwiUloRD8z5Dlr9FnVN/jjZFmt3twgop
	 W20J1tlmhHmx2Z4v8QbWMXJTw4JRcmKFKtJbiA74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 010/473] r8169: Fix possible ring buffer corruption on fragmented Tx packets.
Date: Thu,  6 Jun 2024 15:58:59 +0200
Message-ID: <20240606131700.159572123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Milmore <ken.milmore@gmail.com>

commit c71e3a5cffd5309d7f84444df03d5b72600cc417 upstream.

An issue was found on the RTL8125b when transmitting small fragmented
packets, whereby invalid entries were inserted into the transmit ring
buffer, subsequently leading to calls to dma_unmap_single() with a null
address.

This was caused by rtl8169_start_xmit() not noticing changes to nr_frags
which may occur when small packets are padded (to work around hardware
quirks) in rtl8169_tso_csum_v2().

To fix this, postpone inspecting nr_frags until after any padding has been
applied.

Fixes: 9020845fb5d6 ("r8169: improve rtl8169_start_xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Ken Milmore <ken.milmore@gmail.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/27ead18b-c23d-4f49-a020-1fc482c5ac95@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4263,11 +4263,11 @@ static void rtl8169_doorbell(struct rtl8
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	unsigned int frags = skb_shinfo(skb)->nr_frags;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
 	struct TxDesc *txd_first, *txd_last;
 	bool stop_queue, door_bell;
+	unsigned int frags;
 	u32 opts[2];
 
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
@@ -4290,6 +4290,7 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	txd_first = tp->TxDescArray + entry;
 
+	frags = skb_shinfo(skb)->nr_frags;
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;


