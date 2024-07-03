Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626321836EF;
	Wed,  3 Jul 2024 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004907; cv=none; b=kZuQ171KyvO/k3BiT+Xb+K2CXJgNwgz/9b8tzHbRRgVX4MkX7zwvry0KL/yLDMQKRoVJOcvVZkWRXMr5l1FyvrKDobO6eb9AL471RSfrO2scLIQ//Qmzp2i3vcz3mS3M4Xp7FxedgKWUIZv12Uoep/pFI5B6WzpvLQJXhp5xtX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004907; c=relaxed/simple;
	bh=ZIlNFXgCQeK+kD4lYVi2xqRTVJ1mjiO+EDzZYw+a2Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foDOvc59sg4j1J44hKHO1mh2kdC/FBZjBETagHyvGBAr7Ps2LtNrhMIDHY6sPwUSOyIK2dk6Vdf9c6be7PSHDSOGRuGN9k1z0T8P8CDcT9dfUxh9h8PTO/l+my0gMSMWb2A7WcJ4XrXJ5wwnqUW0ZgXD/qW2TErAqEhX9eD29Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoD06sYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoD06sYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAC6C32781;
	Wed,  3 Jul 2024 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004907;
	bh=ZIlNFXgCQeK+kD4lYVi2xqRTVJ1mjiO+EDzZYw+a2Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoD06sYxthez1247wAi7J/7tlhPPD4jjSupeHY6OnwyYZclxLBw/X1FzpR80bebn3
	 P4G5GFbBc5gidjflIm7DQVi8V1R8IZaCVc80L95+x2kNBVDeZRgpuPBFShNCPfjrSM
	 wyG1fd2ghw26pdcLxfOzcvDuruQ27d+7W0mtlD08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/290] r8169: Fix possible ring buffer corruption on fragmented Tx packets.
Date: Wed,  3 Jul 2024 12:39:30 +0200
Message-ID: <20240703102911.308008043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Milmore <ken.milmore@gmail.com>

[ Upstream commit c71e3a5cffd5309d7f84444df03d5b72600cc417 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dd4404efdb8d6..d24eb5ee152a5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4278,11 +4278,11 @@ static void rtl8169_doorbell(struct rtl8169_private *tp)
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
@@ -4305,6 +4305,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	txd_first = tp->TxDescArray + entry;
 
+	frags = skb_shinfo(skb)->nr_frags;
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;
-- 
2.43.0



