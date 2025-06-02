Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60170226D04;
	Mon,  2 Jun 2025 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874271; cv=none; b=LQiYM1T/7ou4TU2CUcGNIpPpZfqhFDIkggRu7u7qSUjtz4FM1LcUnOP9PayLokuXxoyulug/oLtja4ylUGNOoW+To1sI93WlYsZMsyDDlowb1uG4Fl8QzhiD4t2udWRxjj0wxdcwys8nFf0lKsGQFE+WTlFqH5Y1Apt8Cc9gEuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874271; c=relaxed/simple;
	bh=8p6rR8+AkXTc6Ta7WmbVcY56hAVBo7Ut8e82Ao1BoVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0hzuG90dWMKRi5VDKGb2Ea3JX9Dwn8xlEoWAlyKfhtl9RcIxpkmOsnj3262EEVxhw+5FCynSx2Wk2IhjH9KFhIDPYTuPCAfpLPVDm1bnQBzTFDLiHfYOxMsNJDMJNBCtaAiTFCNY4qnTZls2OTQ4SjtCxjMdwizikh9I+EdDIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RF7p/rRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RF7p/rRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1BAC4CEEB;
	Mon,  2 Jun 2025 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874271;
	bh=8p6rR8+AkXTc6Ta7WmbVcY56hAVBo7Ut8e82Ao1BoVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RF7p/rRj+bL/9camZpLACfq3XTyWLG6oCh3gYzofcN721Zo9/sGHScsA/FkkYDl5/
	 /D8PScp5UHrCB+c09SX41SUV8rdvuppr3G3aq09f3+yaqKers63XewYe+lVhf6egKZ
	 E/oCR4BqXpdxoM5DKwAP4ZOtu5tB/9U611XfT0jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 415/444] af_unix: Remove lock dance in unix_peek_fds().
Date: Mon,  2 Jun 2025 15:47:59 +0200
Message-ID: <20250602134357.782001486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 118f457da9ed58a79e24b73c2ef0aa1987241f0e upstream.

In the previous GC implementation, the shape of the inflight socket
graph was not expected to change while GC was in progress.

MSG_PEEK was tricky because it could install inflight fd silently
and transform the graph.

Let's say we peeked a fd, which was a listening socket, and accept()ed
some embryo sockets from it.  The garbage collection algorithm would
have been confused because the set of sockets visited in scan_inflight()
would change within the same GC invocation.

That's why we placed spin_lock(&unix_gc_lock) and spin_unlock() in
unix_peek_fds() with a fat comment.

In the new GC implementation, we no longer garbage-collect the socket
if it exists in another queue, that is, if it has a bridge to another
SCC.  Also, accept() will require the lock if it has edges.

Thus, we need not do the complicated lock dance.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240401173125.92184-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 -
 net/unix/af_unix.c    |   42 ------------------------------------------
 net/unix/garbage.c    |    2 +-
 3 files changed, 1 insertion(+), 44 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -17,7 +17,6 @@ static inline struct unix_sock *unix_get
 }
 #endif
 
-extern spinlock_t unix_gc_lock;
 extern unsigned int unix_tot_inflight;
 void unix_add_edges(struct scm_fp_list *fpl, struct unix_sock *receiver);
 void unix_del_edges(struct scm_fp_list *fpl);
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1796,48 +1796,6 @@ static void unix_detach_fds(struct scm_c
 static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
 {
 	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
-
-	/*
-	 * Garbage collection of unix sockets starts by selecting a set of
-	 * candidate sockets which have reference only from being in flight
-	 * (total_refs == inflight_refs).  This condition is checked once during
-	 * the candidate collection phase, and candidates are marked as such, so
-	 * that non-candidates can later be ignored.  While inflight_refs is
-	 * protected by unix_gc_lock, total_refs (file count) is not, hence this
-	 * is an instantaneous decision.
-	 *
-	 * Once a candidate, however, the socket must not be reinstalled into a
-	 * file descriptor while the garbage collection is in progress.
-	 *
-	 * If the above conditions are met, then the directed graph of
-	 * candidates (*) does not change while unix_gc_lock is held.
-	 *
-	 * Any operations that changes the file count through file descriptors
-	 * (dup, close, sendmsg) does not change the graph since candidates are
-	 * not installed in fds.
-	 *
-	 * Dequeing a candidate via recvmsg would install it into an fd, but
-	 * that takes unix_gc_lock to decrement the inflight count, so it's
-	 * serialized with garbage collection.
-	 *
-	 * MSG_PEEK is special in that it does not change the inflight count,
-	 * yet does install the socket into an fd.  The following lock/unlock
-	 * pair is to ensure serialization with garbage collection.  It must be
-	 * done between incrementing the file count and installing the file into
-	 * an fd.
-	 *
-	 * If garbage collection starts after the barrier provided by the
-	 * lock/unlock, then it will see the elevated refcount and not mark this
-	 * as a candidate.  If a garbage collection is already in progress
-	 * before the file count was incremented, then the lock/unlock pair will
-	 * ensure that garbage collection is finished before progressing to
-	 * installing the fd.
-	 *
-	 * (*) A -> B where B is on the queue of A or B is on the queue of C
-	 * which is on the queue of listening socket A.
-	 */
-	spin_lock(&unix_gc_lock);
-	spin_unlock(&unix_gc_lock);
 }
 
 static void unix_destruct_scm(struct sk_buff *skb)
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -183,7 +183,7 @@ static void unix_free_vertices(struct sc
 	}
 }
 
-DEFINE_SPINLOCK(unix_gc_lock);
+static DEFINE_SPINLOCK(unix_gc_lock);
 unsigned int unix_tot_inflight;
 
 void unix_add_edges(struct scm_fp_list *fpl, struct unix_sock *receiver)


