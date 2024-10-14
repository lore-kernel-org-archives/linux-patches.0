Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0A1AB503;
	Mon, 14 Oct 2024 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917474; cv=none; b=hNi/zTpGgBHFAqgAci8sTsU+r5KulTsJYAsbJ5LQxkHRliDAHpcvo+yvGrEhswgx3zJ9wtmqUXPUFG7Tt28UTAnYN93SfhmhYr1p+MSUXc15qQSLzKC6PGN73Yg0YaPAxq/yZQqTeU3gX5GT+JeOIbMizegDjsvNprFojT1vh8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917474; c=relaxed/simple;
	bh=BM1Qgj5fC/7Ug9ARbnvIhccJEMwQOHQ/OSXzYIJrY7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrEm3qedZvcDR5JgETjyAxpySQZ7vyy4ey9HhsM1FqqoJctkHV0Hzuyz6EgCNume5zy+fIX3iTJ4SMXBAgh94zHGhZnctObTJ1EJ4zuLg75IRijnffU/Hrk3zs6nMBBBmJbYO07wpjohSRqdOu2mN8o0XWUbtRmH386gIgoRQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrIw01GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrIw01GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F585C4CEC3;
	Mon, 14 Oct 2024 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917474;
	bh=BM1Qgj5fC/7Ug9ARbnvIhccJEMwQOHQ/OSXzYIJrY7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrIw01GFDs4ZJQYptyB+wGINpR6SiKJvtwY5uTulwJ2Xf0b8hb8qXU2wxSvCveqsY
	 ++CGYk9F9tqu0OaOayZenJJZS0oj4mJBXVne33wr73xoFg27VYbd8SO2CD/exNiZa6
	 OAmsFLhxT2WF817T33MyTDP4/+s0yL75M0jpja8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1a3986bbd3169c307819@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/798] wifi: mac80211: use two-phase skb reclamation in ieee80211_do_stop()
Date: Mon, 14 Oct 2024 16:09:59 +0200
Message-ID: <20241014141219.713190525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 9d301de12da6e1bb069a9835c38359b8e8135121 ]

Since '__dev_queue_xmit()' should be called with interrupts enabled,
the following backtrace:

ieee80211_do_stop()
 ...
 spin_lock_irqsave(&local->queue_stop_reason_lock, flags)
 ...
 ieee80211_free_txskb()
  ieee80211_report_used_skb()
   ieee80211_report_ack_skb()
    cfg80211_mgmt_tx_status_ext()
     nl80211_frame_tx_status()
      genlmsg_multicast_netns()
       genlmsg_multicast_netns_filtered()
        nlmsg_multicast_filtered()
	 netlink_broadcast_filtered()
	  do_one_broadcast()
	   netlink_broadcast_deliver()
	    __netlink_sendskb()
	     netlink_deliver_tap()
	      __netlink_deliver_tap_skb()
	       dev_queue_xmit()
	        __dev_queue_xmit() ; with IRQS disabled
 ...
 spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags)

issues the warning (as reported by syzbot reproducer):

WARNING: CPU: 2 PID: 5128 at kernel/softirq.c:362 __local_bh_enable_ip+0xc3/0x120

Fix this by implementing a two-phase skb reclamation in
'ieee80211_do_stop()', where actual work is performed
outside of a section with interrupts disabled.

Fixes: 5061b0c2b906 ("mac80211: cooperate more with network namespaces")
Reported-by: syzbot+1a3986bbd3169c307819@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a3986bbd3169c307819
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20240906123151.351647-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6a9d81e9069c9..8861f63e2cfb9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -466,6 +466,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 {
 	struct ieee80211_local *local = sdata->local;
 	unsigned long flags;
+	struct sk_buff_head freeq;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
@@ -658,18 +659,32 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		skb_queue_purge(&sdata->status_queue);
 	}
 
+	/*
+	 * Since ieee80211_free_txskb() may issue __dev_queue_xmit()
+	 * which should be called with interrupts enabled, reclamation
+	 * is done in two phases:
+	 */
+	__skb_queue_head_init(&freeq);
+
+	/* unlink from local queues... */
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			if (info->control.vif == &sdata->vif) {
 				__skb_unlink(skb, &local->pending[i]);
-				ieee80211_free_txskb(&local->hw, skb);
+				__skb_queue_tail(&freeq, skb);
 			}
 		}
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
+	/* ... and perform actual reclamation with interrupts enabled. */
+	skb_queue_walk_safe(&freeq, skb, tmp) {
+		__skb_unlink(skb, &freeq);
+		ieee80211_free_txskb(&local->hw, skb);
+	}
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		ieee80211_txq_remove_vlan(local, sdata);
 
-- 
2.43.0



