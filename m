Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709531C4609;
	Tue, 26 Aug 2025 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213859; cv=none; b=fcWLVC7KXUX33zIkkMf/Ki6a5QfdZS5eq6i2GT2ajxUv4Tl1PLWjs4bHlU9mdMKAiJHvGEnFoMWbOcSIol45tsi+kJrbe6bzIoTjdYcVsiVUU2jvQvtOuFr3HAY3HBU05FlOGiI16fmUIvFcgnbmzpKuCJ9rOvc2lC8KdMzeA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213859; c=relaxed/simple;
	bh=KOJfHWuDx3cmHxdt4+va6sDzU4f/KSi/nIrsQYy0+RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU0U3mwxqlPSoUhyrxmtZarkjo1TSOloN4tTr/bLoMQXXNdXCOoMETdQ5a/PNTJ0vdeDMwusVkXC/2wK4ZLFeK/4x6eshZPJeATeYe1nNYJRg2odtCZ6TX0PBalYUUosy4mb9hKB2LpXY95xxBQN2Y4btJdC4p/HFr7gqu4cb9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAJMrNQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAJMrNQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027B5C4CEF1;
	Tue, 26 Aug 2025 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213859;
	bh=KOJfHWuDx3cmHxdt4+va6sDzU4f/KSi/nIrsQYy0+RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAJMrNQl76oekNKTVn7ZOZWPFJWpi09/3ctyG8Ae36M2AT5YP0q+2+2LOD8V+OtJB
	 VIWb5dcIzjIWIMGu4d9Y93rBT4/5V60QbG/UCglpAM4/dGwmZ+/rrHrKRCXlVWV6Z+
	 sd1jt4ctXHWbg71uHa34UPBpFHbkxuuNh9P2IG/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 506/587] mptcp: disable add_addr retransmission when timeout is 0
Date: Tue, 26 Aug 2025 13:10:55 +0200
Message-ID: <20250826111005.858652260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -20,6 +20,8 @@ add_addr_timeout - INTEGER (seconds)
 	resent to an MPTCP peer that has not acknowledged a previous
 	ADD_ADDR message.
 
+	Do not retransmit if set to 0.
+
 	The default value matches TCP_RTO_MAX. This is a per-namespace
 	sysctl.
 
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -294,6 +294,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
+	unsigned int timeout;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -311,6 +312,10 @@ static void mptcp_pm_add_timer(struct ti
 		goto out;
 	}
 
+	timeout = mptcp_get_add_addr_timeout(sock_net(sk));
+	if (!timeout)
+		goto out;
+
 	spin_lock_bh(&msk->pm.lock);
 
 	if (!mptcp_pm_should_add_signal_addr(msk)) {
@@ -322,7 +327,7 @@ static void mptcp_pm_add_timer(struct ti
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
 		sk_reset_timer(sk, timer,
-			       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
+			       jiffies + timeout);
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -364,6 +369,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
+	unsigned int timeout;
 
 	lockdep_assert_held(&msk->pm.lock);
 
@@ -388,8 +394,9 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
-	sk_reset_timer(sk, &add_entry->add_timer,
-		       jiffies + mptcp_get_add_addr_timeout(net));
+	timeout = mptcp_get_add_addr_timeout(net);
+	if (timeout)
+		sk_reset_timer(sk, &add_entry->add_timer, jiffies + timeout);
 
 	return true;
 }


