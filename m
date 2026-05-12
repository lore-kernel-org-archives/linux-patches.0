Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D845F36AB5B;
	Tue, 12 May 2026 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609612; cv=none; b=j/KruD+jItMDReaCvooJrU/47T900NxCVz/jMD/u7sc764XoypLTTyGrY1WmJekUI8lCuDJ/+DbykKjk8RF/mpMqcJcKJ83qeo6agnmiYIhlHgYN5s4T9z6f5SIuqt42wUlHlLn/c1OwzcYW4smlud0ZWuZPjBK/7E4jekqaz5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609612; c=relaxed/simple;
	bh=wpO64XlLvXIsxhdajreedEXb67MX5mxkzKtdjp+5TWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTI1rZRuQssaD/Kch8PePQTXLICqE1u+1lHVJY9ajYuF5nrqsQdoiqMKb0PFZ/jxnTpia45oTC+JnM49GpOMgRVZ/Lq8yPDHlQ9/YXD9jai7UmnrfOH8DxnG3RdSVTL1VBqCfm5Tvj24/IJX1AIPkapxCagbkA+YBsD/UtRvlFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szpgkeJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szpgkeJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F068C2BCB0;
	Tue, 12 May 2026 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609612;
	bh=wpO64XlLvXIsxhdajreedEXb67MX5mxkzKtdjp+5TWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szpgkeJrhm5inCbg+KMptOXyF2p9FEfd1Rf1RmufXE+mJ76YNCC3E0IJEOD6TBWKz
	 BX/DVv8G0Dgy0YKdlgy5R5Ebv6HjuFNq9CjO5d6ZXBVWC/fbPql2GsAg64ctXPIcNJ
	 ufIoVuTNuMvfwfA6p3s/o+4JGYaayb2akANfR3WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 264/307] mptcp: pm: ADD_ADDR rtx: free sk if last
Date: Tue, 12 May 2026 19:40:59 +0200
Message-ID: <20260512173945.701582490@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -16,6 +16,7 @@ struct mptcp_pm_add_entry {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
 	u8			retrans_times;
+	bool			timer_done;
 	struct timer_list	add_timer;
 	struct mptcp_sock	*sock;
 	struct rcu_head		rcu;
@@ -340,22 +341,22 @@ static void mptcp_pm_add_timer(struct ti
 							      add_timer);
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
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		timeout = TCP_RTO_MAX / 8;
 		goto out;
 	}
 
@@ -373,8 +374,9 @@ static void mptcp_pm_add_timer(struct ti
 	}
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
-		sk_reset_timer(sk, timer,
-			       jiffies + (timeout << entry->retrans_times));
+		timeout <<= entry->retrans_times;
+	else
+		timeout = 0;
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -382,9 +384,13 @@ static void mptcp_pm_add_timer(struct ti
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
@@ -447,6 +453,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->timer_done = false;
 	timeout = mptcp_adjust_add_addr_timeout(msk);
 	if (timeout)
 		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
@@ -467,7 +474,8 @@ static void mptcp_pm_free_anno_list(stru
 	spin_unlock_bh(&msk->pm.lock);
 
 	list_for_each_entry_safe(entry, tmp, &free_list, list) {
-		sk_stop_timer_sync(sk, &entry->add_timer);
+		if (!entry->timer_done)
+			sk_stop_timer_sync(sk, &entry->add_timer);
 		kfree_rcu(entry, rcu);
 	}
 }


