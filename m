Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D18175A6D;
	Thu, 30 Jul 2026 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423061; cv=none; b=aHlebQBkSg3phNy/ftpH6ftr6r+kdFVsrSTnoCB0YMLV/8HEsvYihGBGozYW/FDfYMU7M5VMmyG9uSdt/BgqQxLz9zNXAAZXV8pKLQGenmVM+/rgPR58GYSKmLep5vVr2pcyuTkKyTVVjzzFSxBYnQi2usq83CaiK3fU8BJqNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423061; c=relaxed/simple;
	bh=9BERfODaGYLHK7M0/w0lk47ERKmG0pJAtj/TzxFbhB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQllBk4Fmmd20uPkTGlAHBSlUjVp00x3V4qLG0Nw3m9RkbE9zbwgmm8zqBAiaKlclG53cg0E5l5NlwUPCLSUGcnfwZeSJwOcZk0x8evE0MqQ9WPbiATs552TFEP2+cBvGI1+ESAY85M0+uGtXxPLIsmEGdg1Lam01qJ9tAF/w7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6d8HXAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6d8HXAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3900B1F00A3D;
	Thu, 30 Jul 2026 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423059;
	bh=86NnP+RIBAE+dB7AfIY6rjiuJIeLz47oCqlfvpWVx5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6d8HXAHwDZ+L1UgA6sggVxVjTCW960vENzbWsnlRS1w7iZKvHG+MAPOG+4NK6T6B
	 /f2QJk4jAvSVzSFyZVpVjISe+7LGw++7SRvk02cc1vNYc7RKQlYHv57jsHihuou+9b
	 yaOrgJfqrj3Jtomng6ETX1981d9wBOqaQUaWRghY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kalpan Jani <kalpan.jani@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 608/744] mptcp: fix stale skb->sk reference on subflow close
Date: Thu, 30 Jul 2026 16:14:41 +0200
Message-ID: <20260730141457.197665297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalpan Jani <kalpan.jani@mpiricsoftware.com>

commit bd7aae448f6ee9d82599a4474664de1e6e91a535 upstream.

The backlog list is updated by mptcp_data_ready() under
mptcp_data_lock(). The cleanup of backlog references to a closing
subflow, however, was performed in mptcp_close_ssk(), before
__mptcp_close_ssk() acquires the ssk lock, and while holding neither
the ssk lock nor mptcp_data_lock().

Because that traversal ran without mptcp_data_lock(), concurrent softirq
RX processing on another CPU (subflow_data_ready() -> mptcp_data_ready()
-> __mptcp_add_backlog(), under mptcp_data_lock()) could add a backlog
entry referencing the ssk while the cleanup loop was in progress. Such
an entry could be missed by the cleanup, or the concurrent list update
could corrupt the traversal, leaving skb->sk pointing at the ssk after
it is freed.

A later mptcp_backlog_purge() then dereferences the stale pointer,
triggering a warning in inet_sock_destruct() (ssk->sk_rmem_alloc != 0)
followed by a use-after-free in mptcp_backlog_purge().

Fix this by moving the backlog cleanup into __mptcp_close_ssk(), after
subflow->closing is set to 1 and while the ssk lock is still held,
serialized under mptcp_data_lock(). The cleanup runs only on the push
path (MPTCP_CF_PUSH), where backlog references accumulate; on other
teardown paths the caller already handles cleanup.

With subflow->closing set and mptcp_data_lock() held across the purge,
any concurrent mptcp_data_ready() either completes its enqueue before
the purge runs and is caught, or observes closing=1 and bails out. Once
mptcp_data_unlock() is reached, no new skb referencing the ssk can be
enqueued, so the cleanup is exhaustive.

Remove the unprotected traversal from mptcp_close_ssk() entirely.

Fixes: ee458a3f314e ("mptcp: introduce mptcp-level backlog")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reported-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/621
Signed-off-by: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260722-net-mptcp-misc-fixes-7-2-rc5-v1-3-6fb595bc86ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2545,6 +2545,22 @@ static void __mptcp_subflow_disconnect(s
 	}
 }
 
+static void mptcp_cleanup_ssk_backlog(struct sock *sk, struct sock *ssk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sk_buff *skb;
+
+	mptcp_data_lock(sk);
+	list_for_each_entry(skb, &msk->backlog_list, list) {
+		if (skb->sk != ssk)
+			continue;
+
+		atomic_sub(skb->truesize, &skb->sk->sk_rmem_alloc);
+		skb->sk = NULL;
+	}
+	mptcp_data_unlock(sk);
+}
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -2568,6 +2584,9 @@ static void __mptcp_close_ssk(struct soc
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 	subflow->closing = 1;
 
+	if (flags & MPTCP_CF_PUSH)
+		mptcp_cleanup_ssk_backlog(sk, ssk);
+
 	/* Borrow the fwd allocated page left-over; fwd memory for the subflow
 	 * could be negative at this point, but will be reach zero soon - when
 	 * the data allocated using such fragment will be freed.
@@ -2659,9 +2678,6 @@ out:
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct sk_buff *skb;
-
 	/* The first subflow can already be closed or disconnected */
 	if (subflow->close_event_done || READ_ONCE(subflow->local_id) < 0)
 		return;
@@ -2671,17 +2687,6 @@ void mptcp_close_ssk(struct sock *sk, st
 	if (sk->sk_state == TCP_ESTABLISHED)
 		mptcp_event(MPTCP_EVENT_SUB_CLOSED, mptcp_sk(sk), ssk, GFP_KERNEL);
 
-	/* Remove any reference from the backlog to this ssk; backlog skbs consume
-	 * space in the msk receive queue, no need to touch sk->sk_rmem_alloc
-	 */
-	list_for_each_entry(skb, &msk->backlog_list, list) {
-		if (skb->sk != ssk)
-			continue;
-
-		atomic_sub(skb->truesize, &skb->sk->sk_rmem_alloc);
-		skb->sk = NULL;
-	}
-
 	/* subflow aborted before reaching the fully_established status
 	 * attempt the creation of the next subflow
 	 */


