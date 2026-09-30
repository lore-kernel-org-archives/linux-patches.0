Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99CF348896;
	Wed, 30 Sep 2026 19:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796024; cv=none; b=boJAllgaiu7T0SpEqTDHOpFHtrLzd687i055U0nR5z5EytDsj0b+rm9UMJXms7Et2ehIyU22i5I9rxc0t4H9WALp6LY4jHyH6WZAtLWqBhgE4ntTAxzjfuP2Y2sfZ4FaJMrcMVlMttrvfRdv7mc+huv6bOJDZ7QVeaOXFH99VVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796024; c=relaxed/simple;
	bh=UmoZ7weR/AR4fjiBH8E6RGZuxxWW0sgy0ZPOCdjYdtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9d5tbe3Mtm2HKe9BntEsqoeHAROwRRhNtoUkqwBNPG2+H3UrKpvmq8reeHsogwQ0NxCk3f/JL4UdxODDutlYqP/ATQ3heS3fEGpsrJHYO9/ZUPE76XuQLE77YfQu2u4Al5Il/GHxAh2T9H7jiVMA0jNFbeGIdn4KqkV48EFJ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feoiL/R4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feoiL/R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119301F000FF;
	Wed, 30 Sep 2026 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796023;
	bh=wDDYarZz6uzGhEoOsjvE0gPu5XjbtWqGZRSOa0ctB7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feoiL/R43hHncjqeEavqs5qiHGLEki+WeiEgxC+AFPx4DnZ1RyYakiaV1BesXzjb1
	 k3xu80YAYGqhVe5PtdBlPTvBdlWffHKx4YlEzAYI0wRkbVGIeG852OOEtp62DVvtwA
	 kQuq26HlvfidbC/bV3rbS8KhC81k9HFMQ0aECVrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0768/1193] wifi: mac80211: set up the TX info early to fix failure paths
Date: Wed, 30 Sep 2026 17:24:12 +0200
Message-ID: <20260930152451.319118915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca983c9c943b..7acf34206a400 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2893,10 +2893,23 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
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
@@ -2935,10 +2948,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
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
 
@@ -2965,16 +2976,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
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
@@ -2998,16 +2999,17 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
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



