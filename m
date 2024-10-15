Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8317F1D90DB;
	Tue, 15 Oct 2024 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992145; cv=none; b=cMKq004NhL9Fk/AHSNsgaDxbq8kRR+ZWQKkZPQaHf1RpBvKLlBc7afjnG+vfn4zloTxgSYglVVbQn7e7bwtQWzfXQ6BR4Xce+OcPNXteCbEgzw1lanWQ9cvZrWXPpPaY8xoOH1CuwN4nPUjys7xIrxoNibAuuFweuDqGIASZ5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992145; c=relaxed/simple;
	bh=mdBg2YwBHx9FdUGTHM5K/tBElYmEoMU/lZobCS4L9JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6GyTHdGkJWZEh/DQCJmspU0BgCaNoMr6c6ou98aZheyjJ5RIdI6qrVN7oC5XQOK+Afg3KNWiuTkKxhmv7q1F2XxPziEclFx9iHuBkkE8sZDkyRK0b85mpQlzUyIgAWQ8S5CTDZwEuZtqTh0QU1JvtJEm3AMd1iu/ugc5MEjbJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8NaAy0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8NaAy0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2899C4CEC6;
	Tue, 15 Oct 2024 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992145;
	bh=mdBg2YwBHx9FdUGTHM5K/tBElYmEoMU/lZobCS4L9JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8NaAy0caHLYrZbnMLsaTuX9EYGbSXd+lWtoAYLnCxezMrwTItpLMmuhZc+p3YQRF
	 NNmJcrHi1sj/+aSQnpvJNFL/J9Bxh3wOCcD3Wjy71fER7vp9PQMit0qpj+LWbKAPLz
	 X52NG6dkvTxyF43f5gWcmTIHAJTqFt7Il0ITdh4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+f3a31fb909db9b2a5c4d@syzkaller.appspotmail.com
Subject: [PATCH 5.15 031/691] mptcp: pm: Fix uaf in __timer_delete_sync
Date: Tue, 15 Oct 2024 13:19:39 +0200
Message-ID: <20241015112441.573088747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit b4cd80b0338945a94972ac3ed54f8338d2da2076 upstream.

There are two paths to access mptcp_pm_del_add_timer, result in a race
condition:

     CPU1				CPU2
     ====                               ====
     net_rx_action
     napi_poll                          netlink_sendmsg
     __napi_poll                        netlink_unicast
     process_backlog                    netlink_unicast_kernel
     __netif_receive_skb                genl_rcv
     __netif_receive_skb_one_core       netlink_rcv_skb
     NF_HOOK                            genl_rcv_msg
     ip_local_deliver_finish            genl_family_rcv_msg
     ip_protocol_deliver_rcu            genl_family_rcv_msg_doit
     tcp_v4_rcv                         mptcp_pm_nl_flush_addrs_doit
     tcp_v4_do_rcv                      mptcp_nl_remove_addrs_list
     tcp_rcv_established                mptcp_pm_remove_addrs_and_subflows
     tcp_data_queue                     remove_anno_list_by_saddr
     mptcp_incoming_options             mptcp_pm_del_add_timer
     mptcp_pm_del_add_timer             kfree(entry)

In remove_anno_list_by_saddr(running on CPU2), after leaving the critical
zone protected by "pm.lock", the entry will be released, which leads to the
occurrence of uaf in the mptcp_pm_del_add_timer(running on CPU1).

Keeping a reference to add_timer inside the lock, and calling
sk_stop_timer_sync() with this reference, instead of "entry->add_timer".

Move list_del(&entry->list) to mptcp_pm_del_add_timer and inside the pm lock,
do not directly access any members of the entry outside the pm lock, which
can avoid similar "entry->x" uaf.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+f3a31fb909db9b2a5c4d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f3a31fb909db9b2a5c4d
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/tencent_7142963A37944B4A74EF76CD66EA3C253609@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -361,15 +361,21 @@ mptcp_pm_del_add_timer(struct mptcp_sock
 {
 	struct mptcp_pm_add_entry *entry;
 	struct sock *sk = (struct sock *)msk;
+	struct timer_list *add_timer = NULL;
 
 	spin_lock_bh(&msk->pm.lock);
 	entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
-	if (entry && (!check_id || entry->addr.id == addr->id))
+	if (entry && (!check_id || entry->addr.id == addr->id)) {
 		entry->retrans_times = ADD_ADDR_RETRANS_MAX;
+		add_timer = &entry->add_timer;
+	}
+	if (!check_id && entry)
+		list_del(&entry->list);
 	spin_unlock_bh(&msk->pm.lock);
 
-	if (entry && (!check_id || entry->addr.id == addr->id))
-		sk_stop_timer_sync(sk, &entry->add_timer);
+	/* no lock, because sk_stop_timer_sync() is calling del_timer_sync() */
+	if (add_timer)
+		sk_stop_timer_sync(sk, add_timer);
 
 	return entry;
 }
@@ -1357,7 +1363,6 @@ static bool remove_anno_list_by_saddr(st
 
 	entry = mptcp_pm_del_add_timer(msk, addr, false);
 	if (entry) {
-		list_del(&entry->list);
 		kfree(entry);
 		return true;
 	}


