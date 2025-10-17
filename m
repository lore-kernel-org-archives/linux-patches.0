Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366842F12C6;
	Fri, 17 Oct 2025 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715812; cv=none; b=AS4N4YKFH00k2QiUc7Tu+pkZpJzaG5TxF95EuWn4IOOD35/NReutUQ2gwYemP3B6oeBRGuF+idcFg1zX6IxcZfWUdmEpXo7eMlCqm19f1l1F4H918I+CzjbBdXycTFvIgt1PUjCdJP1F109k1UYIduQDD7DjpDYKVefRTVrH/8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715812; c=relaxed/simple;
	bh=NPQLYXJfVhs8ASL+C8uSusFxJNxffrROahGxSl3nwZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8IBNiFqYLe0FWFXFV5xARRBiN9O5mbhu0Tb5vGBv03j9NxdFWhDYlnVjm6F2vXQ198+GKmxIShInlc6bk3S+oB8zfB2AUp6M03IsN4A/shqZHegHTCXrbqzQeu+83MyWch1G2k+ifPaQo0xyIpErHcA3JZ3L2JmFJ6fZz+U2Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/uBUA+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/uBUA+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAAFC4CEE7;
	Fri, 17 Oct 2025 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715811;
	bh=NPQLYXJfVhs8ASL+C8uSusFxJNxffrROahGxSl3nwZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/uBUA+1ow+eswIrgis3sUv3NE8LJCJCqLJxqP2YzEVBD9gW713rtj4E8yMtDYFG+
	 GuYgbraHn9OOJUeTyvW7EhzA4msQXRL5hjTu5MLSJgAnz91csvqyqWq50yY7zVek6P
	 /Uga2qWp1EwY55HxnYCKlODgZLm77XO3ukISLURo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.17 312/371] wifi: rtw89: avoid possible TX wait initialization race
Date: Fri, 17 Oct 2025 16:54:47 +0200
Message-ID: <20251017145213.365094290@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit c24248ed78f33ea299ea61d105355ba47157d49f upstream.

The value of skb_data->wait indicates whether skb is passed on to the
core mac80211 stack or released by the driver itself.  Make sure that by
the time skb is added to txwd queue and becomes visible to the completing
side, it has already allocated and initialized TX wait related data (in
case it's needed).

This is found by code review and addresses a possible race scenario
described below:

      Waiting thread                          Completing thread

rtw89_core_send_nullfunc()
  rtw89_core_tx_write_link()
    ...
    rtw89_pci_txwd_submit()
      skb_data->wait = NULL
      /* add skb to the queue */
      skb_queue_tail(&txwd->queue, skb)

  /* another thread (e.g. rtw89_ops_tx) performs TX kick off for the same queue */

                                            rtw89_pci_napi_poll()
                                            ...
                                              rtw89_pci_release_txwd_skb()
                                                /* get skb from the queue */
                                                skb_unlink(skb, &txwd->queue)
                                                rtw89_pci_tx_status()
                                                  rtw89_core_tx_wait_complete()
                                                  /* use incorrect skb_data->wait */
  rtw89_core_tx_kick_off_and_wait()
  /* assign skb_data->wait but too late */

Found by Linux Verification Center (linuxtesting.org).

Fixes: 1ae5ca615285 ("wifi: rtw89: add function to wait for completion of TX skbs")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250919210852.823912-3-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/core.c |   39 ++++++++++++++++--------------
 drivers/net/wireless/realtek/rtw89/core.h |    3 +-
 drivers/net/wireless/realtek/rtw89/pci.c  |    2 -
 3 files changed, 24 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1091,25 +1091,14 @@ void rtw89_core_tx_kick_off(struct rtw89
 }
 
 int rtw89_core_tx_kick_off_and_wait(struct rtw89_dev *rtwdev, struct sk_buff *skb,
-				    int qsel, unsigned int timeout)
+				    struct rtw89_tx_wait_info *wait, int qsel,
+				    unsigned int timeout)
 {
-	struct rtw89_tx_skb_data *skb_data = RTW89_TX_SKB_CB(skb);
-	struct rtw89_tx_wait_info *wait;
 	unsigned long time_left;
 	int ret = 0;
 
 	lockdep_assert_wiphy(rtwdev->hw->wiphy);
 
-	wait = kzalloc(sizeof(*wait), GFP_KERNEL);
-	if (!wait) {
-		rtw89_core_tx_kick_off(rtwdev, qsel);
-		return 0;
-	}
-
-	init_completion(&wait->completion);
-	wait->skb = skb;
-	rcu_assign_pointer(skb_data->wait, wait);
-
 	rtw89_core_tx_kick_off(rtwdev, qsel);
 	time_left = wait_for_completion_timeout(&wait->completion,
 						msecs_to_jiffies(timeout));
@@ -1172,10 +1161,12 @@ int rtw89_h2c_tx(struct rtw89_dev *rtwde
 static int rtw89_core_tx_write_link(struct rtw89_dev *rtwdev,
 				    struct rtw89_vif_link *rtwvif_link,
 				    struct rtw89_sta_link *rtwsta_link,
-				    struct sk_buff *skb, int *qsel, bool sw_mld)
+				    struct sk_buff *skb, int *qsel, bool sw_mld,
+				    struct rtw89_tx_wait_info *wait)
 {
 	struct ieee80211_sta *sta = rtwsta_link_to_sta_safe(rtwsta_link);
 	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
+	struct rtw89_tx_skb_data *skb_data = RTW89_TX_SKB_CB(skb);
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	struct rtw89_core_tx_request tx_req = {};
 	int ret;
@@ -1192,6 +1183,8 @@ static int rtw89_core_tx_write_link(stru
 	rtw89_core_tx_update_desc_info(rtwdev, &tx_req);
 	rtw89_core_tx_wake(rtwdev, &tx_req);
 
+	rcu_assign_pointer(skb_data->wait, wait);
+
 	ret = rtw89_hci_tx_write(rtwdev, &tx_req);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to transmit skb to HCI\n");
@@ -1228,7 +1221,8 @@ int rtw89_core_tx_write(struct rtw89_dev
 		}
 	}
 
-	return rtw89_core_tx_write_link(rtwdev, rtwvif_link, rtwsta_link, skb, qsel, false);
+	return rtw89_core_tx_write_link(rtwdev, rtwvif_link, rtwsta_link, skb, qsel, false,
+					NULL);
 }
 
 static __le32 rtw89_build_txwd_body0(struct rtw89_tx_desc_info *desc_info)
@@ -3426,6 +3420,7 @@ int rtw89_core_send_nullfunc(struct rtw8
 	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
 	int link_id = ieee80211_vif_is_mld(vif) ? rtwvif_link->link_id : -1;
 	struct rtw89_sta_link *rtwsta_link;
+	struct rtw89_tx_wait_info *wait;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
 	struct rtw89_sta *rtwsta;
@@ -3435,6 +3430,12 @@ int rtw89_core_send_nullfunc(struct rtw8
 	if (vif->type != NL80211_IFTYPE_STATION || !vif->cfg.assoc)
 		return 0;
 
+	wait = kzalloc(sizeof(*wait), GFP_KERNEL);
+	if (!wait)
+		return -ENOMEM;
+
+	init_completion(&wait->completion);
+
 	rcu_read_lock();
 	sta = ieee80211_find_sta(vif, vif->cfg.ap_addr);
 	if (!sta) {
@@ -3449,6 +3450,8 @@ int rtw89_core_send_nullfunc(struct rtw8
 		goto out;
 	}
 
+	wait->skb = skb;
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ps)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -3460,7 +3463,8 @@ int rtw89_core_send_nullfunc(struct rtw8
 		goto out;
 	}
 
-	ret = rtw89_core_tx_write_link(rtwdev, rtwvif_link, rtwsta_link, skb, &qsel, true);
+	ret = rtw89_core_tx_write_link(rtwdev, rtwvif_link, rtwsta_link, skb, &qsel, true,
+				       wait);
 	if (ret) {
 		rtw89_warn(rtwdev, "nullfunc transmit failed: %d\n", ret);
 		dev_kfree_skb_any(skb);
@@ -3469,10 +3473,11 @@ int rtw89_core_send_nullfunc(struct rtw8
 
 	rcu_read_unlock();
 
-	return rtw89_core_tx_kick_off_and_wait(rtwdev, skb, qsel,
+	return rtw89_core_tx_kick_off_and_wait(rtwdev, skb, wait, qsel,
 					       timeout);
 out:
 	rcu_read_unlock();
+	kfree(wait);
 
 	return ret;
 }
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -7389,7 +7389,8 @@ int rtw89_h2c_tx(struct rtw89_dev *rtwde
 		 struct sk_buff *skb, bool fwdl);
 void rtw89_core_tx_kick_off(struct rtw89_dev *rtwdev, u8 qsel);
 int rtw89_core_tx_kick_off_and_wait(struct rtw89_dev *rtwdev, struct sk_buff *skb,
-				    int qsel, unsigned int timeout);
+				    struct rtw89_tx_wait_info *wait, int qsel,
+				    unsigned int timeout);
 void rtw89_core_fill_txdesc(struct rtw89_dev *rtwdev,
 			    struct rtw89_tx_desc_info *desc_info,
 			    void *txdesc);
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1372,7 +1372,6 @@ static int rtw89_pci_txwd_submit(struct
 	struct pci_dev *pdev = rtwpci->pdev;
 	struct sk_buff *skb = tx_req->skb;
 	struct rtw89_pci_tx_data *tx_data = RTW89_PCI_TX_SKB_CB(skb);
-	struct rtw89_tx_skb_data *skb_data = RTW89_TX_SKB_CB(skb);
 	bool en_wd_info = desc_info->en_wd_info;
 	u32 txwd_len;
 	u32 txwp_len;
@@ -1388,7 +1387,6 @@ static int rtw89_pci_txwd_submit(struct
 	}
 
 	tx_data->dma = dma;
-	rcu_assign_pointer(skb_data->wait, NULL);
 
 	txwp_len = sizeof(*txwp_info);
 	txwd_len = chip->txwd_body_size;


