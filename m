Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C392F25E4;
	Tue, 21 Jul 2026 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665096; cv=none; b=opmSBnQrurJv7pqrEJL+TDTPk8Ykdl5u1/OttlEMji0T3cKL0TY1y/nP5HilxgX5iXXGroMBvF4EmNVzqcQAZ8MQxkrf/WRq90Az67z99Fzb4yf6GKY01qJIoGlRT7Q2biuGYc0Vbv/KXmitfI4ju2juCxrQnIEsLkR/yGkJkV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665096; c=relaxed/simple;
	bh=qsHKJLbJi90uFvuB8FhvW4W5h3Y1gtZ74WjI+rZq+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbWmq0z7n9+fC1B9hNLs/ZJxzo9avF9YReQbtSaAxxzEH0l7uC+Zww8mBm4FB4k972/Um7qxivhv+sSgbDmIgamQVU1yeDtbZmdC0bGJvy7+nnIN8fZ6WU32Gg54xllF6vM3s3jtkmpLv5sL91WL/eHLGcxunOD+x5ecbtwexeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfbEtaQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfbEtaQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A63A1F00A3A;
	Tue, 21 Jul 2026 20:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665095;
	bh=ASWJCH53WTEvmTPH1Nbo+AvZoFlGoY4B1hoBWsPUdNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfbEtaQwQMNTnRduEGwvnOjr8ckEoVTDdcPaYEnV5chfW8Op5ycjxtYZei37duF2h
	 HWssxFu8IAnZRz+BuNes1UTC2eqg8Lou6qb9bOl7Hs1v6v96z7GP7vIMRcSbNzCn1r
	 RQtTtzd4nJxNjFJMkFQ+76yvhH47OMZZB/sAqNCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+674ff7e4d7fdfd572afc@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0173/1266] Bluetooth: fix UAF in bt_accept_dequeue()
Date: Tue, 21 Jul 2026 17:10:10 +0200
Message-ID: <20260721152445.677001117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit 4bd0b274054f2679f28b70222b607bb0afc3ab9a upstream.

bt_accept_get() takes a temporary reference before dropping the accept
queue lock. bt_accept_dequeue() currently drops that reference before
bt_accept_unlink(), leaving only the queue reference.

bt_accept_unlink() drops the queue reference. The subsequent
sock_hold() therefore accesses freed memory if it was the final
reference, as observed by KASAN during listening L2CAP socket cleanup.

Retain the temporary queue-walk reference through unlink and hand it to
the caller on success. Drop it explicitly on the closed and
not-yet-connected paths.

Fixes: ab1513597c6c ("Bluetooth: fix UAF in l2cap_sock_cleanup_listen() vs l2cap_conn_del()")
Reported-by: syzbot+674ff7e4d7fdfd572afc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=674ff7e4d7fdfd572afc
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |   17 +++--------------
 net/bluetooth/l2cap_sock.c   |    4 ++--
 2 files changed, 5 insertions(+), 16 deletions(-)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -305,7 +305,7 @@ struct sock *bt_accept_dequeue(struct so
 
 restart:
 	for (sk = bt_accept_get(parent, NULL); sk; sk = next) {
-		/* Prevent early freeing of sk due to unlink and sock_kill */
+		/* The reference from bt_accept_get() keeps sk alive. */
 		lock_sock(sk);
 
 		/* Check sk has not already been unlinked via
@@ -321,13 +321,11 @@ restart:
 
 		next = bt_accept_get(parent, sk);
 
-		/* sk is safely in the parent list so reduce reference count */
-		sock_put(sk);
-
 		/* FIXME: Is this check still needed */
 		if (sk->sk_state == BT_CLOSED) {
 			bt_accept_unlink(sk);
 			release_sock(sk);
+			sock_put(sk);
 			continue;
 		}
 
@@ -337,16 +335,6 @@ restart:
 			if (newsock)
 				sock_graft(sk, newsock);
 
-			/* Hand the caller a reference taken while sk is
-			 * still locked.  bt_accept_unlink() just dropped
-			 * the accept-queue reference; without this hold a
-			 * concurrent teardown (e.g. l2cap_conn_del() ->
-			 * l2cap_sock_kill()) could free sk between
-			 * release_sock() and the caller using it.  Every
-			 * caller drops this with sock_put() when done.
-			 */
-			sock_hold(sk);
-
 			release_sock(sk);
 			if (next)
 				sock_put(next);
@@ -354,6 +342,7 @@ restart:
 		}
 
 		release_sock(sk);
+		sock_put(sk);
 	}
 
 	return NULL;
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1448,8 +1448,8 @@ static void l2cap_sock_cleanup_listen(st
 
 	/* Close not yet accepted channels.
 	 *
-	 * bt_accept_dequeue() now returns sk with an extra reference held
-	 * (taken while sk was still locked) so a concurrent l2cap_conn_del()
+	 * bt_accept_dequeue() returns sk with its temporary queue-walk
+	 * reference held, so a concurrent l2cap_conn_del()
 	 * -> l2cap_sock_kill() cannot free sk under us.
 	 *
 	 * cleanup_listen() runs under the parent sk lock, so unlike


