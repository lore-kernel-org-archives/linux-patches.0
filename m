Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053667;
	b=IwMUQgUhXLKDcjgbs7LxZdPpUli93QGUjszX+NDXMdwknCb3Mvk1YRD492YZ/nqZ4qpa
	 RYfjpOl2giTMnSURzZNY2QjOdLUZP4ZguSaAFV2ilcxz94A9HAcz1pxD3pY8ytC+eswwe
	 057KMjnOtM0SHVHKDbSM7xvpHMtqWPkgShOz0/OSbLQyqi2eneEFFdQfh+ruz77SzyLZH
	 ZPR/5/BEB3FLbnCBKHqsm2rO55XMz58qv0lPXaY0oLdJZmKD/yuzYKgfpfhs1+jtjpkTC
	 Gf3Ukzpk5RgvPmImBC2dpa7X86aAe2ka02QlnQeyCyNqWl1m1C/ndQIQyzQsTN7ROQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m4KdwTp4cL+3NE79J9tPYi2gyQJN72YDUMRxkXxB/Zo=;
	b=fDPvZdWe2aHacvLKzE9pFAsCJJ6VKbHAclOiXQLs9RZyQNmzl9Ljih3wNqBFAYUmATm6
	 xyvV3Bi5H4FrTCEH7mQRBDnSVslsa+E8SZd/f+PZKXeak89bcWWtEoQ5O7bpc2HdKMshQ
	 2Xsbfas/1OAoDMxJF4w+1AESypNm7UNGZ4392h/XegBHifj0t8FcMTIoxQfI3os59X78j
	 1fNRTc/QaxMrcEpgxp7I/3/o9+in+YqDcgz+0WFwdr0mUO4Raqu3DiiSnNMLW1ll4IfRJ
	 g6u6HlQ0I9fHifRjTzeV1pvWOeeOrIgxfkv7Tn2P4vskxOf/mLgYxk/FQYtJdm/UQEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4W06m9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB29606A320;
	Thu, 19 Nov 2026 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4W06m9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3751F000C4;
	Thu, 19 Nov 2026 02:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053667;
	bh=m4KdwTp4cL+3NE79J9tPYi2gyQJN72YDUMRxkXxB/Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4W06m9VRqWv/yufygCg4H8VMf23YVslKBQsUZ4jDlLb5CC5SwDVmsJSyVKklRFg+
	 jh7nwSS1CcovUTROnsYhrM4VvvwLSmK6kr+8D0rhhHXfQMViDLVrTpjkBNY7ikXbfU
	 m3YU5bxsqWop/lt81pTflZZ8G2C1W38oAvm0xuyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Lu <llfamsec@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Tamir Awad <security@auth.ink>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1000/2214] af_unix: Clear oob_skb in scan_inflight()
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118150052.390620036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

Embryo socket is not queued in gc_candidates, so we can't drop
a reference held by its oob_skb.

Let's say we create listener and embryo sockets, send the
listener's fd to the embryo as OOB data, and close() them
without recv()ing the OOB data.

There is a self-reference cycle like

  listener -> embryo.oob_skb -> listener

, so this must be cleaned up by GC.  Otherwise, the listener's
refcnt is not released and sockets are leaked:

  # unshare -n
  # cat /proc/net/protocols | grep UNIX-STREAM
  UNIX-STREAM 1024      0      -1   NI       0   yes  kernel ...

  # python3
  >>> from array import array
  >>> from socket import *
  >>>
  >>> s = socket(AF_UNIX, SOCK_STREAM)
  >>> s.bind('\0test\0')
  >>> s.listen()
  >>>
  >>> c = socket(AF_UNIX, SOCK_STREAM)
  >>> c.connect(s.getsockname())
  >>> c.sendmsg([b'x'], [(SOL_SOCKET, SCM_RIGHTS, array('i', [s.fileno()]))], MSG_OOB)
  1
  >>> quit()

  # cat /proc/net/protocols | grep UNIX-STREAM
  UNIX-STREAM 1024      3      -1   NI       0   yes  kernel ...
                        ^^^
                        3 sockets still in use after FDs are close()d

Let's drop the embryo socket's oob_skb ref in scan_inflight().

This also fixes a racy access to oob_skb that commit 9841991a446c
("af_unix: Update unix_sk(sk)->oob_skb under sk_receive_queue
lock.") fixed for the new Tarjan's algo-based GC.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Link: https://lore.kernel.org/all/20250304030149.82265-1-kuniyu@amazon.com/
Reported-by: Lei Lu <llfamsec@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Tamir Awad <security@auth.ink>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index d2fc795394a52..a733d0d5f1f5f 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -102,13 +102,14 @@ static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
 			/* Process the descriptors of this socket */
 			int nfd = UNIXCB(skb).fp->count;
 			struct file **fp = UNIXCB(skb).fp->fp;
+			struct unix_sock *u;
 
 			while (nfd--) {
 				/* Get the socket the fd matches if it indeed does so */
 				struct sock *sk = unix_get_socket(*fp++);
 
 				if (sk) {
-					struct unix_sock *u = unix_sk(sk);
+					u = unix_sk(sk);
 
 					/* Ignore non-candidates, they could
 					 * have been added to the queues after
@@ -122,6 +123,13 @@ static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
 				}
 			}
 			if (hit && hitlist != NULL) {
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+				u = unix_sk(x);
+				if (u->oob_skb) {
+					WARN_ON_ONCE(skb_unref(u->oob_skb));
+					u->oob_skb = NULL;
+				}
+#endif
 				__skb_unlink(skb, &x->sk_receive_queue);
 				__skb_queue_tail(hitlist, skb);
 			}
@@ -299,17 +307,9 @@ void unix_gc(void)
 	 * which are creating the cycle(s).
 	 */
 	skb_queue_head_init(&hitlist);
-	list_for_each_entry(u, &gc_candidates, link) {
+	list_for_each_entry(u, &gc_candidates, link)
 		scan_children(&u->sk, inc_inflight, &hitlist);
 
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-		if (u->oob_skb) {
-			kfree_skb(u->oob_skb);
-			u->oob_skb = NULL;
-		}
-#endif
-	}
-
 	/* not_cycle_list contains those sockets which do not make up a
 	 * cycle.  Restore these to the inflight list.
 	 */
-- 
2.53.0



