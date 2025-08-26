Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E8428F935;
	Tue, 26 Aug 2025 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208648; cv=none; b=dlfe+gdtQUhVVgcGecJn5rGbxc+atD5hHEnu5jFQ1eCSIYfOAjXnY+qFkxXHdUffJpgz/Z5jgg3qwOhZbPv6nJ/BJq3nj14/juXxf0mFSpqqTrveGh/zv60EjbAWab0e38SHFjP1UWI9uaIi8J/Mg5FTsRSV1d2v2HUJaKQ3d6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208648; c=relaxed/simple;
	bh=3k8ve6bj3Vo4qOJnZnO5Gsf0CGofJ2wdEHl0GeyyCoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klyO0roHzV+b02tSae1Nk3cMFJMkG8bov9D6Uvzc3YHL8pE279AQigxn1QssYmRn6zwuaF5yhM5VXWu6HGrVKQfk2q9fuYkkxJXceiIVughLdrwmecCN85gbGjDtSq3IaBcm44nYQg/weQxOW4d/g0XfKfMLE3lf2oCALjpAnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7ADdR31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7ADdR31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED029C4CEF4;
	Tue, 26 Aug 2025 11:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208648;
	bh=3k8ve6bj3Vo4qOJnZnO5Gsf0CGofJ2wdEHl0GeyyCoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7ADdR31XvQ8LXLBJ6WGme3LEPIel+8PezG9p/GWOgCpFHOTq7wPpuXuANkkYGd8U
	 sw8SL8JUVkg/P2iNRhCca6O/xGrkN+vyVT3JxDk9x67HHL8YGt/BObG/ZJE3dMZdOf
	 U7Sfn1sWhjesFf7VDAvCbctZgsHGqhas86NDU49s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 191/322] mptcp: disable add_addr retransmission when timeout is 0
Date: Tue, 26 Aug 2025 13:10:06 +0200
Message-ID: <20250826110920.580955676@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit f5ce0714623cffd00bf2a83e890d09c609b7f50a upstream.

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
[ Before commit e4c28e3d5c09 ("mptcp: pm: move generic PM helpers to
  pm.c"), mptcp_pm_alloc_anno_list() was in pm_netlink.c. The same patch
  can be applied there without conflicts. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/mptcp-sysctl.rst |    2 ++
 net/mptcp/pm_netlink.c                    |   13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/Documentation/networking/mptcp-sysctl.rst
+++ b/Documentation/networking/mptcp-sysctl.rst
@@ -12,6 +12,8 @@ add_addr_timeout - INTEGER (seconds)
 	resent to an MPTCP peer that has not acknowledged a previous
 	ADD_ADDR message.
 
+	Do not retransmit if set to 0.
+
 	The default value matches TCP_RTO_MAX. This is a per-namespace
 	sysctl.
 
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -293,6 +293,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
+	unsigned int timeout;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -310,6 +311,10 @@ static void mptcp_pm_add_timer(struct ti
 		goto out;
 	}
 
+	timeout = mptcp_get_add_addr_timeout(sock_net(sk));
+	if (!timeout)
+		goto out;
+
 	spin_lock_bh(&msk->pm.lock);
 
 	if (!mptcp_pm_should_add_signal_addr(msk)) {
@@ -321,7 +326,7 @@ static void mptcp_pm_add_timer(struct ti
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
 		sk_reset_timer(sk, timer,
-			       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
+			       jiffies + timeout);
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -363,6 +368,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
+	unsigned int timeout;
 
 	lockdep_assert_held(&msk->pm.lock);
 
@@ -387,8 +393,9 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
-	sk_reset_timer(sk, &add_entry->add_timer,
-		       jiffies + mptcp_get_add_addr_timeout(net));
+	timeout = mptcp_get_add_addr_timeout(net);
+	if (timeout)
+		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
 
 	return true;
 }


