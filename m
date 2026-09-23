Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1751739EF12;
	Wed, 23 Sep 2026 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174472; cv=none; b=oaZwlBoPd6CDOoPAIMNkfBhAUOWlB/a8hP+ikVDCCoSVV2Nigu82lokY+i7fmbpye73u1WX8bwy6k1GubtjIGMJiVaNshBXe1VqtoOxwulSJSSRWxXYqV9G6FG2JjERk2RiVR8uPbaX8MLjfKCjJx/wHF4eT/SADidWjacDYoRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174472; c=relaxed/simple;
	bh=W8d/ewYiua2nTVhw22ZMIHMIGfwhlMK3haHnBIrb7Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1hYzCKnw2xp/W/ulgrc2exFcnPVooUUfTkMl8d0JCg5IKbA0yuwWIwyi32wU/8YeOMzWrkuE7Qx5CRJyzBGvTrO8jMz3XKfIEqJ8cUTcL24Qy8vLcEtI2SapvG586BeiHbGrBXXVtqcuP2ZVYkzY6pdBjLg3JfgLW1jZzUro38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tu1j9byJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tu1j9byJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6A01F00893;
	Wed, 23 Sep 2026 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174471;
	bh=G5PCs8jAhhhjqE5WYE0IpP+77w3gC+Z6O4Ex8TsReWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tu1j9byJ/Q6jp7DK2x0xVCmBD/cDboP4j764fQjTd+ErzC0hRfGwPJtLF5dNx+FTD
	 GscOulvwpG8Es8iSqFe1BeaVU2f9/MFRt+7jYnxLmFmqfUWPgjR5wSRNqAI6YEMMwZ
	 yk4ViCmlDFEoDv06ijy1ZQyp7ebG1Os52p5zU7xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/398] wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()
Date: Wed, 23 Sep 2026 16:03:19 +0200
Message-ID: <20260923140646.678343064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 820b8cff81c796ba20573e04722ab62500713f97 ]

When mac80211 removes a sta, it calls .sta_state() which in turn calls
ath11k_mac_station_remove(). In that function we clean up both peers &
arsta related resources.

But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
assumes that all driver related resources are cleaned up beforehand. This
cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
in fact free arsta->rx_stats / tx_stats.

Extract the arsta cleanup from ath11k_mac_station_remove() into a
new ath11k_mac_station_cleanup() and call it from both there and
ath11k_mac_peer_cleanup_all().

This should handle kmemleaks reports like:
	unreferenced object 0xffffff801ae66400 (size 1024):
	  comm "hostapd", pid 1306, jiffies 4295011565
	  hex dump (first 32 bytes):
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace (crc d61c08ec):
	    kmemleak_alloc+0x3c/0x50
	    __kmalloc_cache_noprof+0x2b0/0x3e0
	    ath11k_mac_op_sta_state+0x1dc/0xb10
	    drv_sta_state+0xac/0x6f8
	    sta_info_insert_rcu+0x314/0x5e0
	    sta_info_insert+0x14/0x38
	    ieee80211_add_station+0x10c/0x1a0
	    nl80211_new_station+0x3e8/0x680
	    genl_family_rcv_msg_doit+0xc0/0x120
	    genl_rcv_msg+0x1b4/0x258
	    netlink_rcv_skb+0x4c/0x108
	    genl_rcv+0x38/0x60
	    netlink_unicast+0x190/0x278
	    netlink_sendmsg+0x15c/0x370
	    ____sys_sendmsg+0x120/0x290
	    ___sys_sendmsg+0x70/0xa0

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260731145830.769811-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4794caa9f7eaa..c97c07a7ef0fd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -873,6 +873,22 @@ static int ath11k_mac_set_kickout(struct ath11k_vif *arvif)
 	return 0;
 }
 
+static void ath11k_mac_station_cleanup(struct ieee80211_sta *sta)
+{
+	struct ath11k_sta *arsta;
+
+	if (!sta)
+		return;
+
+	arsta = ath11k_sta_to_arsta(sta);
+
+	kfree(arsta->tx_stats);
+	arsta->tx_stats = NULL;
+
+	kfree(arsta->rx_stats);
+	arsta->rx_stats = NULL;
+}
+
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
 {
 	struct ath11k_peer *peer, *tmp;
@@ -885,6 +901,7 @@ void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
 	list_for_each_entry_safe(peer, tmp, &ab->peers, list) {
 		ath11k_peer_rx_tid_cleanup(ar, peer);
 		ath11k_peer_rhash_delete(ab, peer);
+		ath11k_mac_station_cleanup(peer->sta);
 		list_del(&peer->list);
 		kfree(peer);
 	}
@@ -9720,7 +9737,6 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
 {
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
-	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
 	int ret;
 
 	if (ab->hw_params.vdev_start_delay &&
@@ -9744,12 +9760,7 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
 			   sta->addr, arvif->vdev_id);
 
 	ath11k_mac_dec_num_stations(arvif, sta);
-
-	kfree(arsta->tx_stats);
-	arsta->tx_stats = NULL;
-
-	kfree(arsta->rx_stats);
-	arsta->rx_stats = NULL;
+	ath11k_mac_station_cleanup(sta);
 
 	return ret;
 }
-- 
2.53.0



