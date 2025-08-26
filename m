Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADE1ADFFE;
	Tue, 26 Aug 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215225; cv=none; b=diqD54natp+BxMVgF428ynZyGITnKgKp/a67P+Pl1L1sj63riIej0Xyvedblu+pQfCMprG0G5H844bgz5ZIKqyU6Gf68QZgobdoBg3BQpHroaaXghkdr3gtveYU9AO7asCp9AF5ON5XxJlvlDtDCkcJpjYwPQf7ICjSa2VYlX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215225; c=relaxed/simple;
	bh=BnLjIobkcfxYaGyFq6uGY5v5ne9BmvKIK31gvrjJ+TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llyakRg6Xa+jsgVKJxw0BxvwmkF9zLloQor5SVBGIvPZCfmTMXFCvGNX7CwyF2E2a2vISNWE/QgsCv+0hSvc4CbGtKiAy8Eb5VU7TBvrTprpiWxW7cpV+zfukt+65rr0CmfyrG/gpSslVheTcfmpQJBqc5Z8mrrWxY26fKW4j10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdZjKHnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdZjKHnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558ADC4CEF1;
	Tue, 26 Aug 2025 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215225;
	bh=BnLjIobkcfxYaGyFq6uGY5v5ne9BmvKIK31gvrjJ+TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdZjKHnrRuXEC6lqDTP/SFG6YgJjuAvRBGMuZMWPMEo8icKY6eLU2yEI/xx2/0Nmm
	 7pBLMIYv9BVJ4hr8WjwAXQm20rPfCCoGN0TW1JVfNNM2ZQh6aO8t6c8eINPAKxdHze
	 UuD6VktGAniYe2iZwiM3F14SqSzN2dAQCkR1ZzgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 435/482] mptcp: disable add_addr retransmission when timeout is 0
Date: Tue, 26 Aug 2025 13:11:28 +0200
Message-ID: <20250826110941.577071436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit f5ce0714623cffd00bf2a83e890d09c609b7f50a ]

When add_addr_timeout was set to 0, this caused the ADD_ADDR to be
retransmitted immediately, which looks like a buggy behaviour. Instead,
interpret 0 as "no retransmissions needed".

The documentation is updated to explicitly state that setting the timeout
to 0 disables retransmission.

Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
Cc: stable@vger.kernel.org
Suggested-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-5-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Apply to net/mptcp/pm_netlink.c , structural changes in mptcp_pm_alloc_anno_list ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/mptcp-sysctl.rst |    2 ++
 net/mptcp/pm_netlink.c                    |   18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/Documentation/networking/mptcp-sysctl.rst
+++ b/Documentation/networking/mptcp-sysctl.rst
@@ -20,6 +20,8 @@ add_addr_timeout - INTEGER (seconds)
 	resent to an MPTCP peer that has not acknowledged a previous
 	ADD_ADDR message.
 
+	Do not retransmit if set to 0.
+
 	The default value matches TCP_RTO_MAX. This is a per-namespace
 	sysctl.
 
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -304,6 +304,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
+	unsigned int timeout;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -321,6 +322,10 @@ static void mptcp_pm_add_timer(struct ti
 		goto out;
 	}
 
+	timeout = mptcp_get_add_addr_timeout(sock_net(sk));
+	if (!timeout)
+		goto out;
+
 	spin_lock_bh(&msk->pm.lock);
 
 	if (!mptcp_pm_should_add_signal_addr(msk)) {
@@ -332,7 +337,7 @@ static void mptcp_pm_add_timer(struct ti
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
 		sk_reset_timer(sk, timer,
-			       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
+			       jiffies + timeout);
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -374,6 +379,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
+	unsigned int timeout;
 
 	lockdep_assert_held(&msk->pm.lock);
 
@@ -383,9 +389,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 		if (WARN_ON_ONCE(mptcp_pm_is_kernel(msk)))
 			return false;
 
-		sk_reset_timer(sk, &add_entry->add_timer,
-			       jiffies + mptcp_get_add_addr_timeout(net));
-		return true;
+		goto reset_timer;
 	}
 
 	add_entry = kmalloc(sizeof(*add_entry), GFP_ATOMIC);
@@ -399,8 +403,10 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
-	sk_reset_timer(sk, &add_entry->add_timer,
-		       jiffies + mptcp_get_add_addr_timeout(net));
+reset_timer:
+	timeout = mptcp_get_add_addr_timeout(net);
+	if (timeout)
+		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
 
 	return true;
 }


