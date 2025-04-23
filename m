Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3C628469E;
	Wed, 23 Apr 2025 15:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421692; cv=none; b=Hsb7RKkWbrHk0c6joPF4iZaZJ+8oyqk0+mIfljWyUouk3+O867MRAWRFjQulD7fidpcOm/XjwSjKQ0oUT0AZ1scr/JinAxYSdUtgtoU8gLkwyLimL+rh4EsP5UtY+bIS+flQrWRV9DOoCdChhCCHz5J3EbKlT6CoSaHX/iul5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421692; c=relaxed/simple;
	bh=RSbTabnEbDk5StqJD529ahtXkFKfvA2wEAn/hzN7JJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aoov7T9TiGF5AM6QaLmFYgqNCAyJpn7FM4BEQy64Ml/WOfv8mhUYwpMGf3DUSCjhq2vYPgq2xirOhsYy/EVTms85oS/J0FAjD7GjmNhLB+O89UpHuYtdajUCX9DcWe9eHknB1JDp8Mbh9UFomTA0fR4pp2xKTEyHnB+QyhgiHaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksl+z6C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksl+z6C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F63C4CEE3;
	Wed, 23 Apr 2025 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421692;
	bh=RSbTabnEbDk5StqJD529ahtXkFKfvA2wEAn/hzN7JJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksl+z6C+nXjX3uy3pXA/EJE4r5ZWIvgqP3Zk8RB0FrfXl8VH6/FGFvVSidze0sXk8
	 XlPcRAGFLjiBaTEzhmwS5wJS19YSREnczdPq1KrzekZuOHXIz0eagt9K9Ep6MEywSt
	 HowmtbA0gpzIJalnMdQWQme66Q2mSM7V1vqqBI8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/291] wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()
Date: Wed, 23 Apr 2025 16:42:36 +0200
Message-ID: <20250423142631.215708009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit a104042e2bf6528199adb6ca901efe7b60c2c27f ]

The ieee80211 skb control block key (set when skb was queued) could have
been removed before ieee80211_tx_dequeue() call. ieee80211_tx_dequeue()
already called ieee80211_tx_h_select_key() to get the current key, but
the latter do not update the key in skb control block in case it is
NULL. Because some drivers actually use this key in their TX callbacks
(e.g. ath1{1,2}k_mac_op_tx()) this could lead to the use after free
below:

  BUG: KASAN: slab-use-after-free in ath11k_mac_op_tx+0x590/0x61c
  Read of size 4 at addr ffffff803083c248 by task kworker/u16:4/1440

  CPU: 3 UID: 0 PID: 1440 Comm: kworker/u16:4 Not tainted 6.13.0-ge128f627f404 #2
  Hardware name: HW (DT)
  Workqueue: bat_events batadv_send_outstanding_bcast_packet
  Call trace:
   show_stack+0x14/0x1c (C)
   dump_stack_lvl+0x58/0x74
   print_report+0x164/0x4c0
   kasan_report+0xac/0xe8
   __asan_report_load4_noabort+0x1c/0x24
   ath11k_mac_op_tx+0x590/0x61c
   ieee80211_handle_wake_tx_queue+0x12c/0x1c8
   ieee80211_queue_skb+0xdcc/0x1b4c
   ieee80211_tx+0x1ec/0x2bc
   ieee80211_xmit+0x224/0x324
   __ieee80211_subif_start_xmit+0x85c/0xcf8
   ieee80211_subif_start_xmit+0xc0/0xec4
   dev_hard_start_xmit+0xf4/0x28c
   __dev_queue_xmit+0x6ac/0x318c
   batadv_send_skb_packet+0x38c/0x4b0
   batadv_send_outstanding_bcast_packet+0x110/0x328
   process_one_work+0x578/0xc10
   worker_thread+0x4bc/0xc7c
   kthread+0x2f8/0x380
   ret_from_fork+0x10/0x20

  Allocated by task 1906:
   kasan_save_stack+0x28/0x4c
   kasan_save_track+0x1c/0x40
   kasan_save_alloc_info+0x3c/0x4c
   __kasan_kmalloc+0xac/0xb0
   __kmalloc_noprof+0x1b4/0x380
   ieee80211_key_alloc+0x3c/0xb64
   ieee80211_add_key+0x1b4/0x71c
   nl80211_new_key+0x2b4/0x5d8
   genl_family_rcv_msg_doit+0x198/0x240
  <...>

  Freed by task 1494:
   kasan_save_stack+0x28/0x4c
   kasan_save_track+0x1c/0x40
   kasan_save_free_info+0x48/0x94
   __kasan_slab_free+0x48/0x60
   kfree+0xc8/0x31c
   kfree_sensitive+0x70/0x80
   ieee80211_key_free_common+0x10c/0x174
   ieee80211_free_keys+0x188/0x46c
   ieee80211_stop_mesh+0x70/0x2cc
   ieee80211_leave_mesh+0x1c/0x60
   cfg80211_leave_mesh+0xe0/0x280
   cfg80211_leave+0x1e0/0x244
  <...>

Reset SKB control block key before calling ieee80211_tx_h_select_key()
to avoid that.

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/06aa507b853ca385ceded81c18b0a6dd0f081bc8.1742833382.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 62b2817df2ba9..7c1e81e15865c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3800,6 +3800,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



