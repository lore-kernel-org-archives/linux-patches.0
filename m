Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591174;
	b=KGfPMga0GpiOXvaL+sn6ejOxCxSiNTGQ0/Vatf/sCzaB2rEUqdCL/EpmKgr5RLaebu85
	 oewRxN4yRunEcIqn2CbDvlHE1jt4/gNpAfAfMCWk12n2cm2Vzm/nk5Bc5L9YyLZMYxsXX
	 mHuwDSbGCVWH16I+4H0ZyyMbOpB1i760sNzL7kYVnOnHksUGyb3DOCAE0caSypcsaKgC3
	 V0Zz76ngVwbW/XlXKaWa1Xj/m1ki0E9yuzd7ysh+iIhxNqb2jFXTrWKzS6hcV5UNJIzZw
	 dnMoEvt35uRNLs1ne5RG58vleUlGAoaPsSs1/fejIMqXZmol3bveN2ksXh9yitSaVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ew9kQy21AQnHujJWQplZpaD0ZqA5fYINdQbSWlj4u6I=;
	b=44lNkxgpcM+eWtPmkq7GMonLAsFVtmVFgViqIjtp/iv0uy+gKXUzsDLXHMxVQGzAy4Za
	 jVhxIuUnQ6oJOgiYYm5J/AW1iRrvSUnzyMRD9v+d2IhKQc7ZmzNWBODRQUMDGHEH2QbRr
	 BqoKATTv1bEsUlM4NsZ+AlkZ0S8leV+9YepTbT+Myawu5G9cZcN/V+Q365n1v5gxxm5hv
	 NRjL6zBSVx/cWQUQn+UTyy3gw79jWpopsC4L7x3Bo7yQjUiTFUxhGQWjGkGuUAMNFRf2B
	 yznGF8jEobFcD+YR7EZewBt6MEzfrOo2kxzBpH4RIzs45xp3TNql4MnD2IgwtGQVF5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkITTDQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9E6073FE1;
	Fri, 13 Nov 2026 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkITTDQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388C11F000C8;
	Fri, 13 Nov 2026 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591174;
	bh=ew9kQy21AQnHujJWQplZpaD0ZqA5fYINdQbSWlj4u6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkITTDQb3DRwI+xxfFHImW82ExaXPv9MqspwegJRY9vdYLcUB/SsALuL9L/s+62gO
	 SglduECEpdom/XVDYFstAY8ImtCMMb1sfnT0bgkWaw3etc9+JMX0x5YdkBpEvbKhY2
	 yLQ2uzDah81uc/5usI+Y0k0l8wTj72p0qHCYr3tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/670] net: restore refcount ordering for lockless socket access
Date: Fri, 13 Nov 2026 10:47:58 -0500
Message-ID: <20261113153822.542473891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 5b5d8f351dd96f56a58bb516a80e2d4d742fe4e2 ]

Before commit fb041bb7c0a9 ("locking/refcount: Consolidate implementations
of refcount_t"), default builds implemented refcount_inc_not_zero() using
atomic_add_unless(), which provided full memory ordering on success. The
commit removed that ordering on weakly ordered architectures, allowing
accesses after a successful reference acquisition to be reordered before
it.

Use refcount_inc_not_zero_acquire() in the IPv4 and IPv6 established
lookups and in inet_twsk_purge(), where the socket is validated again
after taking a reference.

bpf_sk_assign() can receive a socket pointer obtained through BTF
without a reference. Use acquire ordering when it takes its own reference
for a refcounted socket.

Use refcount_set_release() when setting refcounts in the SYN cookie,
TCP Fast Open, request migration, and TIME_WAIT paths. Keep the existing
TIME_WAIT smp_wmb(), which separately orders the refcount store before
ehash publication.

Fixes: fb041bb7c0a9 ("locking/refcount: Consolidate implementations of refcount_t")
Fixes: 27e5203bd9c5 ("bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261029214219.1035176-3-imv4bel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c               | 2 +-
 net/ipv4/inet_connection_sock.c | 6 +++---
 net/ipv4/inet_hashtables.c      | 2 +-
 net/ipv4/inet_timewait_sock.c   | 4 ++--
 net/ipv4/syncookies.c           | 2 +-
 net/ipv4/tcp_fastopen.c         | 2 +-
 net/ipv6/inet6_hashtables.c     | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5ec9954b94542..2d6e2f772a600 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7625,7 +7625,7 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 	if (sk_unhashed(sk))
 		return -EOPNOTSUPP;
 	if (sk_is_refcounted(sk) &&
-	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+	    unlikely(!refcount_inc_not_zero_acquire(&sk->sk_refcnt)))
 		return -ENOENT;
 
 	skb_orphan(skb);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 2cb125bbfb9db..61fbcaa913b35 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1105,8 +1105,8 @@ static void reqsk_timer_handler(struct timer_list *t)
 		 * hold another count to prevent use-after-free and
 		 * call reqsk_put() just before return.
 		 */
-		refcount_set(&nreq->rsk_refcnt, 2 + 1);
 		timer_setup(&nreq->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
+		refcount_set_release(&nreq->rsk_refcnt, 2 + 1);
 		reqsk_queue_migrated(&inet_csk(nsk)->icsk_accept_queue, req);
 
 		req = nreq;
@@ -1465,7 +1465,7 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 				goto child_put;
 			}
 
-			refcount_set(&nreq->rsk_refcnt, 1);
+			refcount_set_release(&nreq->rsk_refcnt, 1);
 			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
 				__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQSUCCESS);
 				reqsk_migrate_reset(req);
@@ -1519,7 +1519,7 @@ void inet_csk_listen_stop(struct sock *sk)
 		if (nsk) {
 			nreq = inet_reqsk_clone(req, nsk);
 			if (nreq) {
-				refcount_set(&nreq->rsk_refcnt, 1);
+				refcount_set_release(&nreq->rsk_refcnt, 1);
 
 				rcu_read_lock();
 				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e8adf8530596c..e7b312f7cd98f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -510,7 +510,7 @@ struct sock *__inet_lookup_established(const struct net *net,
 		if (sk->sk_hash != hash)
 			continue;
 		if (likely(inet_match(net, sk, acookie, ports, dif, sdif))) {
-			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero_acquire(&sk->sk_refcnt)))
 				goto out;
 			if (unlikely(hlist_nulls_unhashed_lockless(&sk->sk_nulls_node) ||
 				     !inet_match(net, sk, acookie, ports, dif,
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 74b84ac418e93..e34deccdcb30f 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -139,7 +139,7 @@ void inet_twsk_hashdance_schedule(struct inet_timewait_sock *tw,
 	 * Also note that after this point, we lost our implicit reference
 	 * so we are not allowed to use tw anymore.
 	 */
-	refcount_set(&tw->tw_refcnt, 3);
+	refcount_set_release(&tw->tw_refcnt, 3);
 
 	/* Ensure tw_refcnt has been set before tw is published.
 	 * smp_wmb() provides the necessary memory barrier to enforce this
@@ -324,7 +324,7 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo)
 			if (refcount_read(&sock_net(sk)->ns.count))
 				continue;
 
-			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero_acquire(&sk->sk_refcnt)))
 				continue;
 
 			if (refcount_read(&sock_net(sk)->ns.count)) {
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 16361ce3e8062..43cf33f282c15 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -204,7 +204,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	child = icsk->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
 						 NULL, &own_req, NULL);
 	if (child) {
-		refcount_set(&req->rsk_refcnt, 1);
+		refcount_set_release(&req->rsk_refcnt, 1);
 		sock_rps_save_rxhash(child, skb);
 
 		if (rsk_drop_req(req)) {
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 5378ef3b6ab53..fbcd7d8c8d99e 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -278,7 +278,7 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
 	inet_csk_reset_xmit_timer(child, ICSK_TIME_RETRANS,
 				  req->timeout, TCP_RTO_MAX);
 
-	refcount_set(&req->rsk_refcnt, 2);
+	refcount_set_release(&req->rsk_refcnt, 2);
 
 	sk_mark_napi_id_set(child, skb);
 
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 70633fed6e6af..dee00ba290f69 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -71,7 +71,7 @@ struct sock *__inet6_lookup_established(const struct net *net,
 			continue;
 		if (!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))
 			continue;
-		if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		if (unlikely(!refcount_inc_not_zero_acquire(&sk->sk_refcnt)))
 			goto out;
 
 		if (unlikely(hlist_nulls_unhashed_lockless(&sk->sk_nulls_node) ||
-- 
2.53.0



