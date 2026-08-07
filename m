Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9DF3AAF54;
	Fri,  7 Aug 2026 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117345; cv=none; b=DNMs+ohyDMv+/OlVL690RuK8u1fj3ChD420ZnWZPIX4Qo1hLeEbMOSE49CzbYkULx5mb4IPjxLYWJ0kl5Qwjvr9szOnCHx5Hdxfn8HZgbcpCfQdYbsPb1LHKDAS50LNhAa1QUmbmRxdWmZiEMCc2h7oD1AXKDF5HNPtj0KcuOSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117345; c=relaxed/simple;
	bh=FItE2Ixsvzb9/Bh90mP20fKtX357b7d2+kfhP4Q3Tdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLqGYLvged5edQjC5P0KDTuOO5mGl697PqQLF4QmqhIeZh7uWkulPb46CoOA1CMwByUchnpRa9Az8L1czGj4Fkn3CSpBNgwhU5Q8awwhO50St0xApvOlLsuqMB+d1pEziEFs+6v9AF2417/C8nWk0h7jjrMshX0nMcQjV+yovXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy3LEy1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy3LEy1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64CD1F000E9;
	Fri,  7 Aug 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117344;
	bh=G5//EgCxubUnwihlVoeWMakqYFLRn1LEoknbdlFuGNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy3LEy1tOz9o/PVBo4oi23KlvPKaI+ror22S8b4AG3fOoZySU+QQvI3Xoz9uKKu3J
	 06RbD7SeF2J6Zrrhc3a6usZTfEzbJNx3jTE7D7P0hFpuUV/FBh6/l7d693DJAIwQkY
	 Jq8aW0OxabCvPCQgSpDY1dqe8TVntcA3rijwgEfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.1 286/438] wifi: mac80211: fix tid_tx use-after-free on BA session stop
Date: Fri,  7 Aug 2026 16:38:02 +0200
Message-ID: <20260807143434.076278736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 2f067f5a450ea07efd249142a11d940a068fe29c upstream.

ieee80211_stop_tx_ba_cb() hands tid_tx to kfree_rcu() through
ieee80211_remove_tid_tx(), and then reads tid_tx->ndp after dropping
sta->lock:

	ieee80211_remove_tid_tx(sta, tid);	/* kfree_rcu(tid_tx, rcu_head) */
	...
	spin_unlock_bh(&sta->lock);

	if (start_txq)
		ieee80211_agg_start_txq(sta, tid, false);

	if (send_delba)
		ieee80211_send_delba(..., tid_tx->ndp);

That read is not covered by an RCU read-side critical section, and it runs
in preemptible process context: both callers hold the wiphy mutex, reaching
it either from the ieee80211_ba_session_work() wiphy work or from
ieee80211_sta_tear_down_BA_sessions() during station teardown.
Softirqs can run in that window too, both from the local_bh_enable() that
ends ieee80211_agg_start_txq() and from any interrupt exit, so the RCU
callback can free tid_tx before the read.

Driving the function from a test module with the grace period forced into
that window, KASAN reports the read, and the free arrives on the ordinary
RCU softirq path:

  BUG: KASAN: slab-use-after-free in ieee80211_stop_tx_ba_cb+0x3cd/0x400
  Read of size 1 at addr ffff888002b9f52e by task kworker/0:1/10
  [...]
  Freed by task 57:
   __kasan_slab_free+0x47/0x70
   __rcu_free_sheaf_prepare+0x70/0x250
   rcu_free_sheaf_nobarn+0x18/0x40
   rcu_core+0x426/0x1310
   handle_softirqs+0x144/0x590
   __irq_exit_rcu+0xea/0x150
   irq_exit_rcu+0x9/0x20
   sysvec_apic_timer_interrupt+0x6b/0x80
   asm_sysvec_apic_timer_interrupt+0x1a/0x20

send_delba is only set when tx_stop is set, which happens for
AGG_STOP_LOCAL_REQUEST alone, so this is reached on local teardown -
session idle timeout, PTK rekey, suspend, HW reconfig - and not from a
peer's DELBA.

Read ndp into a local before the session is freed, while sta->lock is still
held. tid_tx->ndp has a single writer, in
ieee80211_tx_ba_session_handle_start(), which cannot run concurrently here:
both paths are serialised by the wiphy mutex, and the session is already
marked HT_AGG_STATE_STOPPING at this point. tid_tx->ndp is also the only
tid_tx dereference left after ieee80211_remove_tid_tx() in this function.

Fixes: 98acd4c1d9f7 ("wifi: mac80211: add support for NDP ADDBA/DELBA for S1G")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260728112156.96822-1-enderaoelyther@gmail.com
[move/change the comment a bit to be more general not just on ndp,
 initialize ndp directly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/agg-tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -915,6 +915,7 @@ void ieee80211_stop_tx_ba_cb(struct sta_
 			     struct tid_ampdu_tx *tid_tx)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool ndp = ndp = tid_tx->ndp;
 	bool send_delba = false;
 	bool start_txq = false;
 
@@ -934,6 +935,7 @@ void ieee80211_stop_tx_ba_cb(struct sta_
 		send_delba = true;
 
 	ieee80211_remove_tid_tx(sta, tid);
+	/* tid_tx is now invalid since ieee80211_remove_tid_tx() frees it */
 	start_txq = true;
 
  unlock_sta:
@@ -946,7 +948,7 @@ void ieee80211_stop_tx_ba_cb(struct sta_
 		ieee80211_send_delba(sdata, sta->sta.addr, tid,
 				     WLAN_BACK_INITIATOR,
 				     WLAN_REASON_QSTA_NOT_USE,
-				     tid_tx->ndp);
+				     ndp);
 }
 
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,


