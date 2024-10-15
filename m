Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A681F1C07E0;
	Tue, 15 Oct 2024 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997051; cv=none; b=FJDK2snLh09OdR+HHDOfHZoT6zZ+CR5ko6Pie9HVZ79C8Lk2VwD7mArOaBejM6dDwud1T7fxsy1yDlh74L2+OX7Roj3/9MwWUpiqj30t/i/+EONVCzCEHGZV8RzhpUAdiadaqWfPROSt/hke7bgqm6acWhxgmrsqN/ve+pTnQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997051; c=relaxed/simple;
	bh=CAyvT2TJz7Aqdi7VTHbiFXsIpEQz7ZWPeemN04xC4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfX2c+E8+4DyBjZh93Q4f1sK0HKrbgYcF8WCeJIjzpg7rDVHdtCyrqA8CEHjB2LwGvBveMLK/vfgzRK3zTWScOjcca4DGRMjnwift0XoKGUtIlff6haQyVmB6MbBMB4UniuDVzVeU8A16EQLk/XJ01uB0zNXKOxQ0zE8okkW6QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7EKGOuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7EKGOuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA498C4CECF;
	Tue, 15 Oct 2024 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997051;
	bh=CAyvT2TJz7Aqdi7VTHbiFXsIpEQz7ZWPeemN04xC4Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7EKGOuWTIDryPxZ+EL0m7yAdhoP1nK+Npt9o40oEegy3CwGX2oTIJ2HShxN2BQIx
	 mbHgkzF+7LtXnE367BXtpHb4h6gNo1yk1bgyHijjC4Rh+Amd1zHZ5hvtgQmtuwoAgv
	 IA21gPC0mcbC1MGzJSjniahxv7HUazfX67sOPMG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1a3986bbd3169c307819@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/518] wifi: mac80211: use two-phase skb reclamation in ieee80211_do_stop()
Date: Tue, 15 Oct 2024 14:39:38 +0200
Message-ID: <20241015123919.858000387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 06ce138eedf1b..55e3dfa7505d4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -370,6 +370,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	unsigned long flags;
+	struct sk_buff_head freeq;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
@@ -565,18 +566,32 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		skb_queue_purge(&sdata->skb_queue);
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



