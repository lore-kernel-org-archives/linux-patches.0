Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA89344DBD;
	Sat, 12 Sep 2026 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241631; cv=none; b=mmqmsSv7ov1j16lG7dbBB2JMKqR4iLZtxXoUETv+XpjO2lI12gSNisotgu25ysEfYEk7Y72HvmzHpEb4CvtoF88qLNnMfkQi4yS1YBe5KyXtMQKRcrgCLjg9PU1y8MIn4GwdBBfh9mDG+NhW+jcofD47UhnFIgy94yZsrccSxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241631; c=relaxed/simple;
	bh=rD3UdxKV76qO9/9DkhqbAdmF8lv69RgoHerE2wedFCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TueDhw0yQFqYH+bzL1SBOIke/sABemIiVNVwT/LKFZ8v5Pj1Pod9aZk/2RKYtpa1iiomRIcPqOKcI5aBM7ZRrioNWjHlUD3pn7B5BDWmrMRs3NZ46gHX1cJ1sdQtKdlXEAIzuqQIbukMCwBy2C4GTPolni3ChYoE68y5DyWcmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjA3XDvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjA3XDvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B71F000FF;
	Sat, 12 Sep 2026 19:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241629;
	bh=Xa1SP+KRZSMRrwSpBYgkNGJg4/jqVzDsme6Ybn/OxgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjA3XDvgdvejkw6VTdcE4Wehy7QRK2Ib6lrT8/V9p9saj7Ris7ZqyYsQby7jH5YU0
	 xsJX2dfqpKBcIRi32OnzD8dVJXrTFhTSJCV7TRKIzmpI9GgnkxAGsYks2LPvj5ORT6
	 8rlVtex0L9/EnIoOxqhUneUeeYp8LmEWLuXxwAFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/798] mptcp: pm: ADD_ADDR rtx: free sk if last
Date: Sat, 12 Sep 2026 08:56:43 +0200
Message-ID: <20260912065521.028023114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
[ Karl Mehltretter: applied to pm_netlink.c and retained v5.10's fixed
  retransmission delays while centralizing timer rearming. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index aee3a8dd9287a..89570f83f96b0 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -34,6 +34,7 @@ struct mptcp_pm_add_entry {
 	struct timer_list	add_timer;
 	struct mptcp_sock	*sock;
 	u8			retrans_times;
+	bool			timer_done;
 	struct rcu_head		rcu;
 };
 
@@ -214,24 +215,25 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
+	unsigned int timeout = 0;
 
 	pr_debug("msk=%p\n", msk);
 
+	bh_lock_sock(sk);
 	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
-		goto exit;
+		goto out;
 
 	if (!entry->addr.id)
-		goto exit;
+		goto out;
 
-	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
-		sk_reset_timer(sk, timer, jiffies + HZ / 20);
+		timeout = HZ / 20;
 		goto out;
 	}
 
 	if (mptcp_pm_should_add_signal(msk)) {
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		timeout = TCP_RTO_MAX / 8;
 		goto out;
 	}
 
@@ -244,14 +246,18 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	}
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX);
+		timeout = TCP_RTO_MAX;
 
 	spin_unlock_bh(&msk->pm.lock);
 
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
@@ -304,6 +310,7 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
+	add_entry->timer_done = false;
 	sk_reset_timer(sk, &add_entry->add_timer, jiffies + TCP_RTO_MAX);
 
 	return true;
@@ -322,7 +329,8 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
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



