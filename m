Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258B337699;
	Thu, 30 Jul 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423678; cv=none; b=EMdYt9M5AgIFVLRPuG1ydda5to+fmqKhFzq+D7ICzw136IbtXjqZsMfwI9SzTXl9BRCCAt2Ow9xDKZ42gvTwFze0+uGL4WT6xJKXdV1CWQVeFLXMftOIx2iFYAG8NwAHhWj4j+p/RX7s13P5MHNoXkfFXiBstaDax/uh8n8GWgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423678; c=relaxed/simple;
	bh=E3V4pruoDhJldOk4pdZSCYfY8kfMwyNDqCNnSKiJWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8p8jnkMDzamt1sclatNqq3freL2DYpKbscogkjCrTrN7Nrebs2SwCxkM8TZGbKToseHYYu1bEioi7aBXLGKLEeL1vGZiH68xNCU6KnzJ6gq5aRukwE1/YZ7PThz1oi6aJUwR3WWDGwOi1AAJCFJ62GA5kCuMm4hz+k5QVBWDA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZdJE9AP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZdJE9AP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E793E1F000E9;
	Thu, 30 Jul 2026 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423677;
	bh=Fkz/MKnjyHQern9OCFk3slkLdfadXNpCDyjytM3I1EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZdJE9APPLFBODbzToANbWR6jWMNVrvoyAVXlkZoK7Kdy4MEKJGm3W9yA+3Dx/QVS
	 ZOHZv4gZZjTxHiz6U3bz9ZeAv7/FKRAT6cpk6yb3bmp6x23oz+zvdJ7kIrf7nvxGkV
	 mJNMakOFUtlzf4R8pj0SyocBKYhlXZXFWqhFq/Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/675] wifi: mac80211: free AP_VLAN bc_buf SKBs outside IRQ lock
Date: Thu, 30 Jul 2026 16:06:53 +0200
Message-ID: <20260730141446.896343988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 72c129478da088..499126317a914c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -581,6 +581,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/* remove all packets in parent bc_buf pointing to this dev */
+		__skb_queue_head_init(&freeq);
 		ps = &sdata->bss->ps;
 
 		spin_lock_irqsave(&ps->bc_buf.lock, flags);
@@ -588,10 +589,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
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



