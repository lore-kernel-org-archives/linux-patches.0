Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2FA34C128;
	Wed,  3 Dec 2025 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780925; cv=none; b=pvDUbQrJuqlB927fxVWhFnEY/98zDzeEi+YFcDCsvQylGvXewRUJ8M3NQ01iBTL2fNPpF2T1jEW0JSumbV4en2c/mmc87j2Z9MZzz2qxbdx0rTNR9R72R5SY1pFqbPUX/ru7T/tPTwGMP6qkfOsZwmAYuEoKv1bUOnz6ktqXphY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780925; c=relaxed/simple;
	bh=5zeEjFiZ3q6rEF7W8TYE2rVpMeHn79p/RsOYyKTjLCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtBKAbsdnFOIKfOhQypZWy1OmSb/KzKSYopbKI1RhDItxBc0wJwqJueBf5fbexWTKpQDWTaKZIe0tjVVn0Xm7hDkzCXij6YuGW+cycTU2YPczHROT+9s0SX0ZHLnVvuXSzG3N9RhqM9Vo/yY/6MzpE/Ba5qMht3e0RdiztXKOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSe1MO4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSe1MO4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A859C4CEF5;
	Wed,  3 Dec 2025 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780925;
	bh=5zeEjFiZ3q6rEF7W8TYE2rVpMeHn79p/RsOYyKTjLCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSe1MO4OlSiobZz00yQwT9xW38a7zqCDNvHdB55vECI70Bn0TVoDnFxZo0nIoERGY
	 E/JHTCoqYRlZZF1dOneW6ud+mQx8sDjKl3CLHYh7WxcN+MhtlRHbwpcGjq+NHugUGx
	 jiXVIPYCxDY+/U9EgnyTeXuJ5HEWDJGFhnOXDj00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Oliver Sedlbauer <os@dev.tdt.de>
Subject: [PATCH 6.12 129/132] wifi: ath12k: correctly handle mcast packets for clients
Date: Wed,  3 Dec 2025 16:30:08 +0100
Message-ID: <20251203152348.095115509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Sarika Sharma <quic_sarishar@quicinc.com>

commit 4541b0c8c3c1b85564971d497224e57cf8076a02 upstream.

Currently, RX is_mcbc bit is set for packets sent from client as
destination address (DA) is multicast/broadcast address, but packets
are actually unicast as receiver address (RA) is not multicast address.
Hence, packets are not handled properly due to this is_mcbc bit.

Therefore, reset the is_mcbc bit if interface type is AP.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250411061523.859387-3-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ Adjust context ]
Signed-off-by: Oliver Sedlbauer <os@dev.tdt.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c |    5 +++++
 drivers/net/wireless/ath/ath12k/peer.c  |    3 +++
 drivers/net/wireless/ath/ath12k/peer.h  |    2 ++
 3 files changed, 10 insertions(+)

--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2214,6 +2214,11 @@ static void ath12k_dp_rx_h_mpdu(struct a
 	spin_lock_bh(&ar->ab->base_lock);
 	peer = ath12k_dp_rx_h_find_peer(ar->ab, msdu);
 	if (peer) {
+		/* resetting mcbc bit because mcbc packets are unicast
+		 * packets only for AP as STA sends unicast packets.
+		 */
+		rxcb->is_mcbc = rxcb->is_mcbc && !peer->ucast_ra_only;
+
 		if (rxcb->is_mcbc)
 			enctype = peer->sec_type_grp;
 		else
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -331,6 +331,9 @@ int ath12k_peer_create(struct ath12k *ar
 		arvif->ast_idx = peer->hw_peer_id;
 	}
 
+	if (arvif->vif->type == NL80211_IFTYPE_AP)
+		peer->ucast_ra_only = true;
+
 	peer->sec_type = HAL_ENCRYPT_TYPE_OPEN;
 	peer->sec_type_grp = HAL_ENCRYPT_TYPE_OPEN;
 
--- a/drivers/net/wireless/ath/ath12k/peer.h
+++ b/drivers/net/wireless/ath/ath12k/peer.h
@@ -47,6 +47,8 @@ struct ath12k_peer {
 
 	/* protected by ab->data_lock */
 	bool dp_setup_done;
+
+	bool ucast_ra_only;
 };
 
 void ath12k_peer_unmap_event(struct ath12k_base *ab, u16 peer_id);


