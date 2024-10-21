Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4AB1F4FD0;
	Mon, 21 Oct 2024 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507709; cv=none; b=l9saO8ehQNWqyhP+f6DAVNlIfJgHOF1C00nNOpZNkOa4Cs5vxz1fMSE7nYWeqD+dXGO9R0MMpzOAdOsRIWA0eFVIz1GHupLdtliUDrCGxl9oT5G9rORhH1g3toVga4og3hvt8tZMH8V3UPVZ5GNyEvGe5xciWGLZfb44RbxB0wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507709; c=relaxed/simple;
	bh=kFWbeLvXWJ4fsDMWHjwrupe76APZJ7lC77ZR/JmLXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmPlK4ZJs7T84xis5peS/NXrNQpSobVxghT5M4Hd/viTCyBIgbaKXzsFTtUixUGOvCF0KOCYUj0RdS5d159ZYoDK2l5Zk9J0AOOv6D+tBE6Na4j1nQuWDaTQsAJFljl1NZG68T4OvM29giP34grDBVKACBJic7c3XI+lSsJs7mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF1rs0oF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF1rs0oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAEDC4CEE6;
	Mon, 21 Oct 2024 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507708;
	bh=kFWbeLvXWJ4fsDMWHjwrupe76APZJ7lC77ZR/JmLXSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF1rs0oFd6XBmP20X3y5d7iIIxnHod6ozJV7I35dDIdwX1RtJMr3eBMSr21KsGFoV
	 SjIihb2GLNbAY85idFrMc/mwzYGnC83oSUFnj4/pAxh+QmftgvYJP3+sc/vM5xJTw3
	 dZodj/clB9so3ucR4A6D5a8frNVxa6wOEnH6tYDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 74/82] mptcp: track and update contiguous data status
Date: Mon, 21 Oct 2024 12:25:55 +0200
Message-ID: <20241021102250.143761710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit 0530020a7c8f2204e784f0dbdc882bbd961fdbde upstream.

This patch adds a new member allow_infinite_fallback in mptcp_sock,
which is initialized to 'true' when the connection begins and is set
to 'false' on any retransmit or successful MP_JOIN. Only do infinite
mapping fallback if there is a single subflow AND there have been no
retransmissions AND there have never been any MP_JOINs.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
[ Conflicts in protocol.c, because commit 3e5014909b56 ("mptcp: cleanup
  MPJ subflow list handling") is not in this version. This commit is
  linked to a new feature, changing the context around. The new line
  can still be added at the same place.
  Conflicts in protocol.h, because commit 4f6e14bd19d6 ("mptcp: support
  TCP_CORK and TCP_NODELAY") is not in this version. This commit is
  linked to a new feature, changing the context around. The new line can
  still be added at the same place.
  Conflicts in subflow.c, because commit 0348c690ed37 ("mptcp: add the
  fallback check") is not in this version. This commit is linked to a
  new feature, changing the context around. The new line can still be
  added at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +++
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |    4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2472,6 +2472,7 @@ static void __mptcp_retrans(struct sock
 		dfrag->already_sent = max(dfrag->already_sent, info.sent);
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
+		WRITE_ONCE(msk->allow_infinite_fallback, false);
 	}
 
 	release_sock(ssk);
@@ -2549,6 +2550,7 @@ static int __mptcp_init_sock(struct sock
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
+	WRITE_ONCE(msk->allow_infinite_fallback, true);
 	msk->recovery = false;
 
 	mptcp_pm_data_init(msk);
@@ -3299,6 +3301,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	if (parent_sock && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, parent_sock);
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
+	WRITE_ONCE(msk->allow_infinite_fallback, false);
 out:
 	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 	return true;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -249,6 +249,7 @@ struct mptcp_sock {
 	bool		rcv_fastclose;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	bool		csum_enabled;
+	bool		allow_infinite_fallback;
 	spinlock_t	join_list_lock;
 	int		keepalive_cnt;
 	int		keepalive_idle;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1219,7 +1219,8 @@ no_data:
 fallback:
 	/* RFC 8684 section 3.7. */
 	if (subflow->send_mp_fail) {
-		if (mptcp_has_another_subflow(ssk)) {
+		if (mptcp_has_another_subflow(ssk) ||
+		    !READ_ONCE(msk->allow_infinite_fallback)) {
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
 				sk_eat_skb(ssk, skb);
 		}
@@ -1481,6 +1482,7 @@ int __mptcp_subflow_connect(struct sock
 	/* discard the subflow socket */
 	mptcp_sock_graft(ssk, sk->sk_socket);
 	iput(SOCK_INODE(sf));
+	WRITE_ONCE(msk->allow_infinite_fallback, false);
 	return err;
 
 failed_unlink:


