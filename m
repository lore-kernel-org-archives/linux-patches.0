Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F2A3E49E0;
	Mon, 17 Aug 2026 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975542; cv=none; b=eHorNhrHPqqLZelPgjv1pp9IXyypAcvLu1PSWr/EArMn1ENrjdfZU+Kv4ef6ZVMJLlW0QBIwgQbgiuoSfMSxkbKmSQdk/ikmsClMkBL8qL7hU9YAV9apT5mbWtS3mq+gVAKZseOs3LiAiJ8HGW9SLHF95rofA3GvEHiQawCNa6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975542; c=relaxed/simple;
	bh=3h0BID7q86hqUwJB3H6VKy2RuM4bCuAKMVsgKuEXn1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJbjkmdoWETRDVPjlnRunOXuzz6rdpLOr/iaglvA9/kIKYbUQFQq3eE4aTtWPgxLnoJGEhBBFmzcy9cD0Ea5pMt2OCz/emmIWp7/4noVncn22ZqE/mFPagh/9wdaBcVISfILGpznc0irqHU7QYFocl93ig5JwceX0ggTCLl/Fb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSynvOoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSynvOoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F186B1F000E9;
	Mon, 17 Aug 2026 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975541;
	bh=OStuMekjk5ALbupdgxnZrm3r2TBViJulcQbUP3dZae0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSynvOoAKNi7Wl9pixsdKnlnEVYmcj6F8sRm8wkXxUwwXvEQRmbyrYHmdMevEiAoP
	 6+hPcY9qISq4IMk26dGwJ42n4GL1LBEwOENQrApv6T8qQSgDpFmglXqkeqr03CkUuo
	 5ivh3w5Ry0I5gRurqyhLMA2qlU1goh9GGGmDVtdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/389] wifi: mac80211: free AP_VLAN bc_buf SKBs outside IRQ lock
Date: Mon, 17 Aug 2026 15:27:45 +0200
Message-ID: <20260817132539.956432649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f3858d5b1432098c1936e03d6e03dd0e33facf60 ]

ieee80211_do_stop() removes AP_VLAN packets from the parent AP
ps->bc_buf while holding ps->bc_buf.lock with IRQs disabled. It then
calls ieee80211_free_txskb() before dropping the lock.

ieee80211_free_txskb() is not just a passive SKB release. For SKBs with
TX status state it can report a dropped frame through cfg80211/nl80211,
and that path can reach netlink tap transmit. This is the same reason
the pending queue cleanup in ieee80211_do_stop() already unlinks SKBs
under the queue lock and frees them after IRQ state is restored.

The buggy scenario involves two paths, with each column showing the
order within that path:

AP_VLAN management TX:             AP_VLAN stop:
1. attach ACK-status state         1. clear the running state
2. queue a multicast SKB on        2. take ps->bc_buf.lock with IRQs
   parent ps->bc_buf                  disabled
                                   3. unlink the AP_VLAN SKB
                                   4. call ieee80211_free_txskb()

Unlink matching AP_VLAN SKBs from ps->bc_buf under the existing lock,
but move them to a local free queue. Drop the lock and restore IRQ state
before calling ieee80211_free_txskb().

WARNING: kernel/softirq.c:430 at __local_bh_enable_ip

Fixes: 397a7a24ef8c ("mac80211: free ps->bc_buf skbs on vlan device stop")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260706140841.581566-1-zzzccc427@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 644eabaf10e31e..9abec4f929ca0a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -492,6 +492,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/* remove all packets in parent bc_buf pointing to this dev */
+		__skb_queue_head_init(&freeq);
 		ps = &sdata->bss->ps;
 
 		spin_lock_irqsave(&ps->bc_buf.lock, flags);
@@ -499,10 +500,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			if (skb->dev == sdata->dev) {
 				__skb_unlink(skb, &ps->bc_buf);
 				local->total_ps_buffered--;
-				ieee80211_free_txskb(&local->hw, skb);
+				__skb_queue_tail(&freeq, skb);
 			}
 		}
 		spin_unlock_irqrestore(&ps->bc_buf.lock, flags);
+
+		skb_queue_walk_safe(&freeq, skb, tmp) {
+			__skb_unlink(skb, &freeq);
+			ieee80211_free_txskb(&local->hw, skb);
+		}
 	}
 
 	if (going_down)
-- 
2.53.0



