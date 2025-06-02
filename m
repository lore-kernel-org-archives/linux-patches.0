Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A4122A7E3;
	Mon,  2 Jun 2025 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877492; cv=none; b=M8RWQfRs15Jh+dcVT02SnKXZPTCgrBcDmN+daXfg4fXa1WTBh8qxwMT7UDMA2Ij2b3I1swRl+uo04V88BTP34YmUdQyY+eMcM/PvmVbaGVMbYzjS1jhDDZZnSZo3dbnFE5yG3+i7XdGQ8QHljmjb4NMCcZIyP7Iu1lYMcJX0Rfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877492; c=relaxed/simple;
	bh=UgXNus/fmwSAp9CFlV3RGejxKaovbXT+FOjGyNnhtaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzk7fJMTIJQKVElc37gLAMBPwiOvsXfNQZ5Y3tVwHG6gW7+ZG4jKfFwYVtq4rrK0n41Dtw3yrVRlMjJQl7HdprBLLtHrQK/d2tMmGNmqeXr8/4rMl3p6iM6UimrdyCF7lIzklGv1Isp1PmkYR5HDoHxYr1Sf44urr1XxUga6PYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvyYccn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvyYccn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFC9C4CEEB;
	Mon,  2 Jun 2025 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877492;
	bh=UgXNus/fmwSAp9CFlV3RGejxKaovbXT+FOjGyNnhtaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvyYccn+8Ty9ayF7xyhjLE4bJWGq5+2iQkfxVryE6X+sAjZKBr57XWBYVWD3tDkSw
	 kYVBhRh91iALO/UbtqqbW29Zv7VUl4ddS7OtdMtJfGeSspbI7KmNv7KilivMgdJCkM
	 kXWr7xY3eGxKauImQZAsHeuJ0aB/oE2n6KQljEzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 294/325] af_unix: Save listener for embryo socket.
Date: Mon,  2 Jun 2025 15:49:30 +0200
Message-ID: <20250602134331.848558755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit aed6ecef55d70de3762ce41c561b7f547dbaf107 upstream.

This is a prep patch for the following change, where we need to
fetch the listening socket from the successor embryo socket
during GC.

We add a new field to struct unix_sock to save a pointer to a
listening socket.

We set it when connect() creates a new socket, and clear it when
accept() is called.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-8-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 +
 net/unix/af_unix.c    |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -83,6 +83,7 @@ struct unix_sock {
 	struct path		path;
 	struct mutex		iolock, bindlock;
 	struct sock		*peer;
+	struct sock		*listener;
 	struct unix_vertex	*vertex;
 	struct list_head	link;
 	unsigned long		inflight;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -954,6 +954,7 @@ static struct sock *unix_create1(struct
 	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
+	u->listener = NULL;
 	u->inflight = 0;
 	u->vertex = NULL;
 	u->path.dentry = NULL;
@@ -1558,6 +1559,7 @@ restart:
 	newsk->sk_type		= sk->sk_type;
 	init_peercred(newsk);
 	newu = unix_sk(newsk);
+	newu->listener = other;
 	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
 	otheru = unix_sk(other);
 
@@ -1651,8 +1653,8 @@ static int unix_accept(struct socket *so
 		       bool kern)
 {
 	struct sock *sk = sock->sk;
-	struct sock *tsk;
 	struct sk_buff *skb;
+	struct sock *tsk;
 	int err;
 
 	err = -EOPNOTSUPP;
@@ -1677,6 +1679,7 @@ static int unix_accept(struct socket *so
 	}
 
 	tsk = skb->sk;
+	unix_sk(tsk)->listener = NULL;
 	skb_free_datagram(sk, skb);
 	wake_up_interruptible(&unix_sk(sk)->peer_wait);
 


