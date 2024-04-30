Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE312C462;
	Tue, 30 Apr 2024 11:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475127; cv=none; b=Qlo4Corfhre7xmm/t65Nym0j0aF5VoZpJd4Wf0Zlwmg35PaqJfjPlYqn4AOBTvKApbRNXcOOaB7d0LTfvc8bIDclmaRoKzSx1lGS6LXc2MhHNchfbY3aj053S414GqUr+iydLTdCMrAG6zPjOREYJGculMx1UHfFXCPqeCa0GWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475127; c=relaxed/simple;
	bh=IEAA24vLsShFCqaBaZKJWAJLj1Zdbfq+CDBVV2mrRrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or9UhzWNhwJ3BKj0yicE+6y4ifgMVoWLaJSugle6eR8e7gjM2kS1d/PboRVPfPy0f5Z4VmxGwJAeOHqM/UHkPJSdBG2ZlgCtOgqcMcyKzaoF0D22Xph7vmRsvaPdyRbSaAXJuyQfo3nwp3xvkLJyaIMKSY6nQFlhkZl509PxKoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLend8aD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLend8aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B554C2BBFC;
	Tue, 30 Apr 2024 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475126;
	bh=IEAA24vLsShFCqaBaZKJWAJLj1Zdbfq+CDBVV2mrRrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLend8aD0YqO/NCcw8W68wq/THp7MTm934cOAU46u5B/QgXdmOdVN6MBxFYnjf1Nu
	 RQ54h8CLEBYCePxAN9qlNmHq7jcmvaOL3tgL5CHQn/7MbmKhcix1baKxrn7BaQxyp3
	 QofVRIYtqIPyBdBUQutsiJfg2TajTNbkILO7Uljg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Zhengchao Shao <shaozhengchao@huawei.com>
Subject: [PATCH 5.10 127/138] tcp: Fix NEW_SYN_RECV handling in inet_twsk_purge()
Date: Tue, 30 Apr 2024 12:40:12 +0200
Message-ID: <20240430103053.142536727@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 1c4e97dd2d3c9a3e84f7e26346aa39bc426d3249 upstream.

inet_twsk_purge() uses rcu to find TIME_WAIT and NEW_SYN_RECV
objects to purge.

These objects use SLAB_TYPESAFE_BY_RCU semantic and need special
care. We need to use refcount_inc_not_zero(&sk->sk_refcnt).

Reuse the existing correct logic I wrote for TIME_WAIT,
because both structures have common locations for
sk_state, sk_family, and netns pointer.

If after the refcount_inc_not_zero() the object fields longer match
the keys, use sock_gen_put(sk) to release the refcount.

Then we can call inet_twsk_deschedule_put() for TIME_WAIT,
inet_csk_reqsk_queue_drop_and_put() for NEW_SYN_RECV sockets,
with BH disabled.

Then we need to restart the loop because we had drop rcu_read_lock().

Fixes: 740ea3c4a0b2 ("tcp: Clean up kernel listener's reqsk in inet_twsk_purge()")
Link: https://lore.kernel.org/netdev/CANn89iLvFuuihCtt9PME2uS1WJATnf5fKjDToa1WzVnRzHnPfg@mail.gmail.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240308200122.64357-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[shaozhengchao: resolved conflicts in 5.10]
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_timewait_sock.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -254,12 +254,12 @@ void __inet_twsk_schedule(struct inet_ti
 }
 EXPORT_SYMBOL_GPL(__inet_twsk_schedule);
 
+/* Remove all non full sockets (TIME_WAIT and NEW_SYN_RECV) for dead netns */
 void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
 {
-	struct inet_timewait_sock *tw;
-	struct sock *sk;
 	struct hlist_nulls_node *node;
 	unsigned int slot;
+	struct sock *sk;
 
 	for (slot = 0; slot <= hashinfo->ehash_mask; slot++) {
 		struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
@@ -268,38 +268,35 @@ restart_rcu:
 		rcu_read_lock();
 restart:
 		sk_nulls_for_each_rcu(sk, node, &head->chain) {
-			if (sk->sk_state != TCP_TIME_WAIT) {
-				/* A kernel listener socket might not hold refcnt for net,
-				 * so reqsk_timer_handler() could be fired after net is
-				 * freed.  Userspace listener and reqsk never exist here.
-				 */
-				if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
-					     hashinfo->pernet)) {
-					struct request_sock *req = inet_reqsk(sk);
-
-					inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
-				}
+			int state = inet_sk_state_load(sk);
 
+			if ((1 << state) & ~(TCPF_TIME_WAIT |
+					     TCPF_NEW_SYN_RECV))
 				continue;
-			}
 
-			tw = inet_twsk(sk);
-			if ((tw->tw_family != family) ||
-				refcount_read(&twsk_net(tw)->count))
+			if (sk->sk_family != family ||
+			    refcount_read(&sock_net(sk)->count))
 				continue;
 
-			if (unlikely(!refcount_inc_not_zero(&tw->tw_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				continue;
 
-			if (unlikely((tw->tw_family != family) ||
-				     refcount_read(&twsk_net(tw)->count))) {
-				inet_twsk_put(tw);
+			if (unlikely(sk->sk_family != family ||
+				     refcount_read(&sock_net(sk)->count))) {
+				sock_gen_put(sk);
 				goto restart;
 			}
 
 			rcu_read_unlock();
 			local_bh_disable();
-			inet_twsk_deschedule_put(tw);
+			if (state == TCP_TIME_WAIT) {
+				inet_twsk_deschedule_put(inet_twsk(sk));
+			} else {
+				struct request_sock *req = inet_reqsk(sk);
+
+				inet_csk_reqsk_queue_drop_and_put(req->rsk_listener,
+								  req);
+			}
 			local_bh_enable();
 			goto restart_rcu;
 		}


