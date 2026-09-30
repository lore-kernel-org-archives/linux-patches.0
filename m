Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4415187C1;
	Wed, 30 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788304; cv=none; b=hbVtcaNQWZCPKAo105YEUZCd2omT9rMp+4s4xcUcCR3Y1fXE3aPvQtgQnfQzqEnnsDJvPIMkLDYKFMej1eqZapnMaXMgGKx50p59t1VH1iK6ccn1/wX6b6X5GnDJtwYbz/+z+FmOME/Nq7D1Fwh1k6KXUDB8LTcVCq1tf8eMVAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788304; c=relaxed/simple;
	bh=k0MR+l397LKsXdXYeZkW786xGs6w/pr59VHH1FlgnU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3ckeAoCLtHMXYr4c4yvpGNj2ws4KUpx0SUagzBEuawJc5EapFUNh+diHNGt6Gd+J1W3S+wRIwVVv1lwiNmaYl+jtM817LY18Twa1jC6+/E39EepSHCHLZ94UCODPbf9z3HN7S97kCqkToqVqwBcZvBnbKYqoVFAOQgZNt5eFl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVkuXwNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVkuXwNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755891F000FF;
	Wed, 30 Sep 2026 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788303;
	bh=rraqrmNgyHaUvh49AM/zjPY9eHAVbbI7PQe1r3ym8PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVkuXwNzpmr68EoEX0UBj6pQ7uomJ8Kj4Bgl9C8ZsIiSPcJH43bd13oNL/jW6AhEA
	 LkM3J/rDM0ahK4Mn0qHu/0ykna6cxYS+6fNy7T1bVk8LSUvlzwwUJRGsdBAnWvsoCV
	 6AY8N+dwtBQcErTvXmA630Yl60N5iGowJilyE25w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/877] wifi: mac80211: set up the TX info early to fix failure paths
Date: Wed, 30 Sep 2026 17:16:29 +0200
Message-ID: <20260930152416.423471397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 50d3d79dc0743b616afb00d01a626c76758721f7 ]

The previous commit 2c51457d930f ("wifi: mac80211: free ack status
frame on TX header build failure") cleaned up the leak, but still
left the code a bit messy and the failed SKB didn't get reported
to userspace.

Fix this up by initialising skb->cb[] earlier, which allows using
ieee80211_free_txskb() and therefore reports it for the failure
in ieee80211_build_hdr(), and unifies the ieee80211_skb_resize()
failure path with it.

Assisted-by: LLM
Fixes: c3e7724b6bc2 ("mac80211: use ieee80211_free_txskb to fix possible skb leaks")
Link: https://patch.msgid.link/20260908122838.201719-22-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e78e71cb92f7f..228c717ea314b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2927,10 +2927,23 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	 */
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb)) {
-		ret = -ENOMEM;
-		goto free;
+		/* skb_share_check() already freed the skb */
+		if (info_id)
+			ieee80211_remove_ack_skb(local, info_id);
+		return ERR_PTR(-ENOMEM);
 	}
 
+	/* set this up so failure paths can clean up ack skb */
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+
+	info->flags = info_flags;
+	if (info_id) {
+		info->status_data = info_id;
+		info->status_data_idr = 1;
+	}
+	info->band = band;
+
 	hdr.frame_control = fc;
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
@@ -2969,10 +2982,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
-			ieee80211_free_txskb(&local->hw, skb);
-			skb = NULL;
 			ret = -ENOMEM;
-			goto free;
+			goto free_txskb;
 		}
 	}
 
@@ -2999,16 +3010,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	skb_reset_mac_header(skb);
 
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(*info));
-
-	info->flags = info_flags;
-	if (info_id) {
-		info->status_data = info_id;
-		info->status_data_idr = 1;
-	}
-	info->band = band;
-
 	if (likely(!cookie)) {
 		ctrl_flags |= u32_encode_bits(link_id,
 					      IEEE80211_TX_CTRL_MLO_LINK);
@@ -3032,16 +3033,17 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					     pre_conf_link_id, link_id);
 #endif
 			ret = -EINVAL;
-			goto free;
+			goto free_txskb;
 		}
 	}
 
 	info->control.flags = ctrl_flags;
 
 	return skb;
+ free_txskb:
+	ieee80211_free_txskb(&local->hw, skb);
+	return ERR_PTR(ret);
  free:
-	if (info_id)
-		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }
-- 
2.53.0



