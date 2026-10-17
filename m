Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279BF38654F;
	Sat, 17 Oct 2026 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256332; cv=none; b=X3aASWU2ezFlib6Fvgwl8+YaMA5pKNIdEl50+iHNMvFb60yZmJB7XhUAygRHk2gEdvIZTOZL1d5vVg7idraVmq2KxIZ9sbYLSGeZKwGp190VwlfTd7fHE2aRntunbM2vDFFdEoqR16k+kRsi+EMbkqnlJDHuMRDZY2f7/nHTlTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256332; c=relaxed/simple;
	bh=9ZGv9tMtSuSmFkkc4Qe1GP7X8lzbO0y8LELtwNA8NOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8JBDO2WfsuHR8hau9kFbh4oGuvy0q3VoIPrzhLZ8KIkjaarLRkA80z6z3P9qu9o9ZdkVBWy9BxiP28WNGh9SGS2oGek446NtdDsp+FNGZWupt/I6NivXmlupCjKLb5bzzwZ7ItaOitFq2E/JKxKCqT6FB4ykF1KQy+nFQtM7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGsDdQYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGsDdQYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4122A1F000C4;
	Sat, 17 Oct 2026 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256330;
	bh=m4fpZlYgLIZc9y20ZDq8yVjIgihkXMTmK4r53j/U7cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGsDdQYakMwoRMKdE3FGJWlL7Yt9zgDaJj3Z4vAOL8MjsKtl6zhRDAssQIdBsjn0K
	 MlShDjy266XfieVMpm79qDJasOvEt5h/SAAge+NPrft1Ezvy7hLc71Shi4V7a7U2U/
	 Ec0nTMkF7f+EOwrQ0uFrFcqIKSDR+7HY8idxx/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0199/1674] wifi: mac80211: Add multicast to unicast support for 802.3 path
Date: Sat, 17 Oct 2026 17:41:11 +0200
Message-ID: <20261017160436.260504226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit 2307b36ce34fd2166509ea2aeef0de5768ed03b7 ]

mac80211 already supports multicast-to-unicast conversion for
native 802.11 TX paths, but this handling is missing for the
802.3 transmit path. Due to that the packet never converted to
unicast and directly pass it to 802.11 Tx path by checking the
destination address as multicast.

Extend ieee80211_subif_start_xmit_8023() to honor the
multicast_to_unicast setting by cloning and converting multicast
Ethernet frames into per-station unicast transmissions, following
the same behavior of the native 802.11 TX path and allow it
to take 802.3 path.

Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Link: https://patch.msgid.link/20260604162403.1563729-3-tamizh.raja@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 7f93ca31f7fd ("wifi: mac80211: prevent AP VLAN tx from other interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7acf34206a400..9450cb7dff54c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4701,19 +4701,14 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	kfree_skb(skb);
 }
 
-netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
-					    struct net_device *dev)
+static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
+					      struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 	struct ieee80211_key *key;
 	struct sta_info *sta;
 
-	if (unlikely(!ieee80211_sdata_running(sdata) || skb->len < ETH_HLEN)) {
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
 	rcu_read_lock();
 
 	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
@@ -4742,6 +4737,30 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 	ieee80211_subif_start_xmit(skb, dev);
 out:
 	rcu_read_unlock();
+}
+
+netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
+					    struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
+
+	if (unlikely(!ieee80211_sdata_running(sdata) || skb->len < ETH_HLEN)) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (unlikely(is_multicast_ether_addr(ehdr->h_dest) &&
+		     ieee80211_multicast_to_unicast(skb, dev))) {
+		struct sk_buff_head queue;
+
+		__skb_queue_head_init(&queue);
+		ieee80211_convert_to_unicast(skb, dev, &queue);
+		while ((skb = __skb_dequeue(&queue)))
+			__ieee80211_subif_start_xmit_8023(skb, dev);
+	} else {
+		__ieee80211_subif_start_xmit_8023(skb, dev);
+	}
 
 	return NETDEV_TX_OK;
 }
-- 
2.53.0



