Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F080BF0;
	Mon, 15 Apr 2024 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191679; cv=none; b=lU1ZcygLkKQuQgzYrTVgruMuhg3M4D4HU/rGWcIlKjE+x0o24lWmk600WlSphseJHZuF41pB8vU4bP0leZBGNmGkqetH0culAQb7sKlQHv1n2x1hnI1KWz2HvBJ+cur5EtiHS55mbmDwuL6IQlhE1JWfD+ULDNRd6C6gXgP4sh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191679; c=relaxed/simple;
	bh=8+qWHD1af2MUK8hq0PiHbQtOnwSTjJSNCPrlTW+K+SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A09crvoK9KgT8alN2JygmqklHQu1pCYSWknD+WTE2IITf1L019k7YlHiwVddlLcQuZ2o9D4Dk+8IXqWigqUVNRgsfoySkUpD9cpBMp3StciK8MhtHtanDrfSXmQJS6glP7tMH4S1bocGPEt5IhfH7uTX8yQbMRLzL0Na7g29rXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIfA/3L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIfA/3L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948B9C113CC;
	Mon, 15 Apr 2024 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191679;
	bh=8+qWHD1af2MUK8hq0PiHbQtOnwSTjJSNCPrlTW+K+SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIfA/3L7i1s49ph1o8VEGXyNIOyiRfnIW3H9LUnqxxbPWRq68nLxwE5SJpFKMiqyj
	 NDKABbDqbPkJwfBoJ1AiLvKtGs8KhBS79D6fcvZ3qdFloxyqR6u1OIvZu++aiZkCLq
	 8Qh6dX6Oy6WfFhsXFFo38oIyy1C9OupCzSoDOj9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f7f201cc2668a8fd169@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/122] af_unix: Clear stale u->oob_skb.
Date: Mon, 15 Apr 2024 16:20:08 +0200
Message-ID: <20240415141954.659206081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b46f4eaa4f0ec38909fb0072eea3aeddb32f954e ]

syzkaller started to report deadlock of unix_gc_lock after commit
4090fa373f0e ("af_unix: Replace garbage collection algorithm."), but
it just uncovers the bug that has been there since commit 314001f0bf92
("af_unix: Add OOB support").

The repro basically does the following.

  from socket import *
  from array import array

  c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
  c1.sendmsg([b'a'], [(SOL_SOCKET, SCM_RIGHTS, array("i", [c2.fileno()]))], MSG_OOB)
  c2.recv(1)  # blocked as no normal data in recv queue

  c2.close()  # done async and unblock recv()
  c1.close()  # done async and trigger GC

A socket sends its file descriptor to itself as OOB data and tries to
receive normal data, but finally recv() fails due to async close().

The problem here is wrong handling of OOB skb in manage_oob().  When
recvmsg() is called without MSG_OOB, manage_oob() is called to check
if the peeked skb is OOB skb.  In such a case, manage_oob() pops it
out of the receive queue but does not clear unix_sock(sk)->oob_skb.
This is wrong in terms of uAPI.

Let's say we send "hello" with MSG_OOB, and "world" without MSG_OOB.
The 'o' is handled as OOB data.  When recv() is called twice without
MSG_OOB, the OOB data should be lost.

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM, 0)
  >>> c1.send(b'hello', MSG_OOB)  # 'o' is OOB data
  5
  >>> c1.send(b'world')
  5
  >>> c2.recv(5)  # OOB data is not received
  b'hell'
  >>> c2.recv(5)  # OOB date is skipped
  b'world'
  >>> c2.recv(5, MSG_OOB)  # This should return an error
  b'o'

In the same situation, TCP actually returns -EINVAL for the last
recv().

Also, if we do not clear unix_sk(sk)->oob_skb, unix_poll() always set
EPOLLPRI even though the data has passed through by previous recv().

To avoid these issues, we must clear unix_sk(sk)->oob_skb when dequeuing
it from recv queue.

The reason why the old GC did not trigger the deadlock is because the
old GC relied on the receive queue to detect the loop.

When it is triggered, the socket with OOB data is marked as GC candidate
because file refcount == inflight count (1).  However, after traversing
all inflight sockets, the socket still has a positive inflight count (1),
thus the socket is excluded from candidates.  Then, the old GC lose the
chance to garbage-collect the socket.

With the old GC, the repro continues to create true garbage that will
never be freed nor detected by kmemleak as it's linked to the global
inflight list.  That's why we couldn't even notice the issue.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot+7f7f201cc2668a8fd169@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f7f201cc2668a8fd169
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240405221057.2406-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 510b1d6758db7..ac3d4b540c100 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2589,7 +2589,9 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 				}
 			} else if (!(flags & MSG_PEEK)) {
 				skb_unlink(skb, &sk->sk_receive_queue);
-				consume_skb(skb);
+				WRITE_ONCE(u->oob_skb, NULL);
+				if (!WARN_ON_ONCE(skb_unref(skb)))
+					kfree_skb(skb);
 				skb = skb_peek(&sk->sk_receive_queue);
 			}
 		}
-- 
2.43.0



