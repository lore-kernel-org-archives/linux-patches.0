Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852D54734C1;
	Tue, 25 Aug 2026 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666035; cv=none; b=g77BuUshP3vdyLRvjwzHMrYPo2f8y6Fiokm2SgwFxIsT+fOl56WkkGv92UP0wI+KNApujAW5dkufO9qOrS7LyKVxY0ur2k5k6pJzChjjOblCPhOOC4HHhLp8xUQ0inJSm1D7cyWs6euyhSy8wqaWqNvaVJ3DX2p4C81619Z3lNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666035; c=relaxed/simple;
	bh=Hwnx7pE4jMSiwWEjgU6TJEFxzUcj3niMnldQo3J/DH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQpC5yTKtf6uFrNYyFWW30EBboL6x87TQH+1OOdHR2TevJt372IXnJp6mTNjq6+Y43rv9ITpjzpyKLR3JfQSALLD4P1bMS4ucCE6lXyUSEeAvHpbYS+/GothdU6lZHtJ4VXbSbEnouHEbgR9CzAZhf08UsX6lkpldgAibibMaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsaYz7cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsaYz7cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E6C1F000E9;
	Tue, 25 Aug 2026 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666034;
	bh=7NcHI6kzWe8pP+yUb/KxrbToSi2JGwGQjFLBm20rRCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsaYz7cws6kcaFY0aAauL7eWAI9Uc721DlAYbBNWYAHA6jzJlev37J8pqkq4oDuUz
	 Tx5jygWZa4rUh4xUhyPJ9txDdEcYNTAXbLy57cjfzHe6Rqn4+VUJNXZYVM9j8wUrqN
	 8N7WX9KdczN4RUP3DOY6LyJEoB4TFkZUt8sjW3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/79] mptcp: pm: ADD_ADDR rtx: free sk if last
Date: Tue, 25 Aug 2026 15:26:43 +0200
Message-ID: <20260825132544.146524606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit b7b9a461569734d33d3259d58d2507adfac107ed ]

When an ADD_ADDR is retransmitted, the sk is held in sk_reset_timer(),
and released at the end.

If at that moment, it was the last reference being held, the sk would
not be freed. sock_put() should then be called instead of __sock_put().

But that's not enough: if it is the last reference, sock_put() will call
sk_free(), which will end up calling sk_stop_timer_sync() on the same
timer, and waiting indefinitely to finish. So it is needed to mark that
the timer is done at the end of the timer handler when it has not been
rescheduled, not to call sk_stop_timer_sync() on "itself".

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-5-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7aad5b69d3b ("mptcp: pm: fix data race in add_addr timer callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -28,6 +28,7 @@ struct mptcp_pm_add_entry {
 	struct timer_list	add_timer;
 	struct mptcp_sock	*sock;
 	u8			retrans_times;
+	bool			timer_done;
 	struct rcu_head		rcu;
 };
 
@@ -305,22 +306,22 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
-	unsigned int timeout;
+	unsigned int timeout = 0;
 
 	pr_debug("msk=%p\n", msk);
 
+	bh_lock_sock(sk);
 	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
-		goto exit;
+		goto out;
 
-	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
-		sk_reset_timer(sk, timer, jiffies + HZ / 20);
+		timeout = HZ / 20;
 		goto out;
 	}
 
 	if (mptcp_pm_should_add_signal_addr(msk)) {
-		sk_reset_timer(sk, timer, jiffies + HZ);
+		timeout = HZ;
 		goto out;
 	}
 
@@ -343,9 +344,8 @@ static void mptcp_pm_add_timer(struct ti
 		entry->retrans_times++;
 	}
 
-	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
-		sk_reset_timer(sk, timer,
-			       jiffies + timeout);
+	if (entry->retrans_times >= ADD_ADDR_RETRANS_MAX)
+		timeout = 0;
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -353,9 +353,13 @@ static void mptcp_pm_add_timer(struct ti
 		mptcp_pm_subflow_established(msk);
 
 out:
+	if (timeout)
+		sk_reset_timer(sk, timer, jiffies + timeout);
+	else
+		/* if sock_put calls sk_free: avoid waiting for this timer */
+		entry->timer_done = true;
 	bh_unlock_sock(sk);
-exit:
-	__sock_put(sk);
+	sock_put(sk);
 }
 
 struct mptcp_pm_add_entry *
@@ -423,6 +427,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->timer_done = false;
 	timeout = mptcp_get_add_addr_timeout(net);
 	if (timeout)
 		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
@@ -443,7 +448,8 @@ void mptcp_pm_free_anno_list(struct mptc
 	spin_unlock_bh(&msk->pm.lock);
 
 	list_for_each_entry_safe(entry, tmp, &free_list, list) {
-		sk_stop_timer_sync(sk, &entry->add_timer);
+		if (!entry->timer_done)
+			sk_stop_timer_sync(sk, &entry->add_timer);
 		kfree_rcu(entry, rcu);
 	}
 }


