Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33EC31DD97;
	Thu, 28 May 2026 20:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000344; cv=none; b=EqTzjH0qUoXmx8PHkdRzqcytJ+myyQu1qH9vD31aqt9MhHpBX84ry/s+h3JyN7vA2PkwPtbYAbmQjWnkC2smlLK9a+vNzuiB+GYodUv7viTREtgl8KqBQZE+Q7H9Ylas5cuLdjyhx1U+xuTl02k1KOXOfJR44BfZnoxTCsoSqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000344; c=relaxed/simple;
	bh=VzhX4lRKonJbeVIXqZ18HZ5XlvQtpwmXSO+7LIYNa9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXvvyRoCxQMS7Fmciol8MW/sHET9++t2U0eXUeOY+g6ucGlKwIdgBD/mT7zbx6zwnpZEIP767Lons1WygyFf4lnCvrWSb/mKWyrbEI/d2y4AkNzPpeRZv5/g6zUQ5+6fyRfipbGyEaEjXrGAszn3h0cttcMcQ/Cac/6p0tEsxH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O16fMfHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O16fMfHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D30D1F000E9;
	Thu, 28 May 2026 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000343;
	bh=VTJBsqAAvPv1xPTr1UhegGBplji63RH32MfJt/4AyXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O16fMfHzpawXU4EzH0EdSdo/lO2Qq/88IVqY+NgUeGjqoLURU8b99dRQ592+rGsp7
	 F3JepkIxyWed76TK8xNoOAYy9qWxJ7dhG1bIUg/av7dYZVaTAKMrcZVud3ys1G8fX+
	 VMY4WP1Af9livpqxD3oqklgKxzyxfyFApEzX8Lfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/272] mptcp: pm: ADD_ADDR rtx: free sk if last
Date: Thu, 28 May 2026 21:46:18 +0200
Message-ID: <20260528194629.505473515@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit b7b9a461569734d33d3259d58d2507adfac107ed upstream.

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
[ Applied to net/mptcp/pm_netlink.c instead of upstream's pm_kernel.c.
  Also, there were conflicts, because commit 30549eebc4d8 ("mptcp: make
  ADD_ADDR retransmission timeout adaptive") is not in this version and
  changed the context. Also, other conflicts were due to newer patches
  being backported with resolved conflicts before this one. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index be531df02c371..4ff6721ad5c7a 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -22,6 +22,7 @@ struct mptcp_pm_add_entry {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
 	u8			retrans_times;
+	bool			timer_done;
 	struct timer_list	add_timer;
 	struct mptcp_sock	*sock;
 	struct rcu_head		rcu;
@@ -294,22 +295,22 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
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
 
@@ -326,9 +327,8 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 		entry->retrans_times++;
 	}
 
-	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
-		sk_reset_timer(sk, timer,
-			       jiffies + timeout);
+	if (entry->retrans_times >= ADD_ADDR_RETRANS_MAX)
+		timeout = 0;
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -336,9 +336,13 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
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
@@ -402,6 +406,7 @@ bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->timer_done = false;
 	timeout = mptcp_get_add_addr_timeout(net);
 	if (timeout)
 		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
@@ -422,7 +427,8 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->pm.lock);
 
 	list_for_each_entry_safe(entry, tmp, &free_list, list) {
-		sk_stop_timer_sync(sk, &entry->add_timer);
+		if (!entry->timer_done)
+			sk_stop_timer_sync(sk, &entry->add_timer);
 		kfree_rcu(entry, rcu);
 	}
 }
-- 
2.53.0



