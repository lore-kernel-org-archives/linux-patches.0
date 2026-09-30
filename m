Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0E451B16D;
	Wed, 30 Sep 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790763; cv=none; b=WnaO9KqJFSCMW9FEup4+O/VUjtS+arOaLcECstat6ms99B0ozZUkG8UjpD4l+NaKm/kalEtqmO95bvhbbofHGzlUxGZ7/kmoouttlSlGrW1ndgiuHiVR7ThQrrZrJIO4tLxNgOt4pCtYOZWmK//zwcdhB14+f5iUHe+x7n9PbhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790763; c=relaxed/simple;
	bh=VdhMCtufCsQnBx9Dm6hgoAxXg4HL7UMyAxG60n8aPeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUBIdloleSQ3gYcD+pGBpWXyocW3ZMhJwGY65ey0oqN7q519Vf5FJCiT+bK1YclGeVBpo3awd+PL7SK35pVNauWyEESXEahslYzu0dza7doNOdYNZZkFNPLyCU3XUAIsgY6X31leZCWR6zain4636krYaYeEoKIJVvhHSGvvon4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHaiLK2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHaiLK2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6361F000FF;
	Wed, 30 Sep 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790762;
	bh=s2HPAjrZNtcN1cs/nkQ0OhBKkw19MZhsBP/rNDEW1cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHaiLK2CdB+j2VNUeTpVYaldqJ6XSsKtxbB4VtmIPLAYZTMBBVEbLLbpbSh2q8pqu
	 2LB6dN3WdAPby9o8Z/mzg6UiY3bllcwBKXG32rRi6Kpe7rZVf9do6d/pk3ngRarxQz
	 ZPiDgwWdXayGy9CYRAWsON7mB2cVhHsVFrszlfPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/752] rds: filter RDS_INFO_* getsockopt by callers netns
Date: Wed, 30 Sep 2026 17:18:54 +0200
Message-ID: <20260930152359.544074072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit c96a5209dda666004b8ee1ed7f0d493d09a4f200 ]

The RDS_INFO_* family of getsockopt(2) options reads several
file-scope global lists that are not per-netns:

  rds_sock_info / rds6_sock_info,
  rds_sock_inc_info / rds6_sock_inc_info        -> rds_sock_list
  rds_tcp_tc_info / rds6_tcp_tc_info            -> rds_tcp_tc_list
  rds_conn_info / rds6_conn_info,
  rds_conn_message_info_cmn (for the *_SEND_MESSAGES and
  *_RETRANS_MESSAGES variants),
  rds_for_each_conn_info (for RDS_INFO_IB_CONNECTIONS)
                                                -> rds_conn_hash[]

The handlers do not filter by the caller's network namespace.
rds_info_getsockopt() has no netns or capable() check, and
rds_create() has no capable() check, so AF_RDS is reachable from
an unprivileged user namespace. As a result, an unprivileged
caller in a fresh user_ns plus netns can read the bound address
and sock inode of every RDS socket on the host, the peer address
of incoming messages on every RDS socket on the host, the peer
address and TCP sequence numbers of every rds-tcp connection on
the host, and the peer address and RDS sequence numbers of every
RDS connection on the host.

The rds-tcp transport is reachable from a non-initial netns (see
rds_set_transport()), so a one-shot init_net gate at
rds_info_getsockopt() would deny legitimate per-netns visibility
to rds-tcp callers. Instead, filter at each handler by comparing
the netns of the caller's socket to the netns of the list entry,
or to rds_conn_net(conn) for connection paths. Only copy entries
whose netns matches the caller. Counters (RDS_INFO_COUNTERS) are
aggregate statistics and remain global.

Reproducer (KASAN VM, rds and rds_tcp loaded): an AF_RDS socket
binds 127.0.0.1:4242 in init_net as root. A child process enters
a fresh user_ns plus netns and opens AF_RDS there, then calls
getsockopt(SOL_RDS, RDS_INFO_SOCKETS). Before this change, the
child sees the init_net socket. After this change, the child
sees zero entries.

Drop the rds_sock_count, rds_tcp_tc_count, and rds6_tcp_tc_count
globals. v2 used them for the size precheck and lens->nr; v3
replaced the precheck with a per-ns count from a first pass over
the list, so the globals have no remaining readers. The matching
increments and decrements in rds_create()/rds_destroy_sock() and
rds_tcp_set_callbacks()/rds_tcp_restore_callbacks() go away with
them. Reported by the kernel test robot under clang W=1.

Suggested-by: Allison Henderson <achender@kernel.org>
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Allison Henderson <achender@kernel.org>
Co-developed-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
Signed-off-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260520084236.2724349-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c     | 59 ++++++++++++++++++++++++++++++++++-------
 net/rds/connection.c | 13 +++++++++
 net/rds/tcp.c        | 63 ++++++++++++++++++++++++++++----------------
 3 files changed, 104 insertions(+), 31 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index ca1b52372ab29..9165d054e8e35 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -43,7 +43,6 @@
 
 /* this is just used for stats gathering :/ */
 static DEFINE_SPINLOCK(rds_sock_lock);
-static unsigned long rds_sock_count;
 static LIST_HEAD(rds_sock_list);
 DECLARE_WAIT_QUEUE_HEAD(rds_poll_waitq);
 
@@ -82,7 +81,6 @@ static int rds_release(struct socket *sock)
 
 	spin_lock_bh(&rds_sock_lock);
 	list_del_init(&rs->rs_item);
-	rds_sock_count--;
 	spin_unlock_bh(&rds_sock_lock);
 
 	rds_trans_put(rs->rs_transport);
@@ -695,7 +693,6 @@ static int __rds_create(struct socket *sock, struct sock *sk, int protocol)
 
 	spin_lock_bh(&rds_sock_lock);
 	list_add_tail(&rs->rs_item, &rds_sock_list);
-	rds_sock_count++;
 	spin_unlock_bh(&rds_sock_lock);
 
 	return 0;
@@ -736,6 +733,7 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 			      struct rds_info_iterator *iter,
 			      struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_sock *rs;
 	struct rds_incoming *inc;
 	unsigned int total = 0;
@@ -745,6 +743,9 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 	spin_lock_bh(&rds_sock_lock);
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		/* This option only supports IPv4 sockets. */
 		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
 			continue;
@@ -775,6 +776,7 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
 			       struct rds_info_iterator *iter,
 			       struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_incoming *inc;
 	unsigned int total = 0;
 	struct rds_sock *rs;
@@ -784,6 +786,9 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
 	spin_lock_bh(&rds_sock_lock);
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		read_lock(&rs->rs_recv_lock);
 
 		list_for_each_entry(inc, &rs->rs_recv_queue, i_item) {
@@ -807,7 +812,9 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_info_socket sinfo;
+	unsigned int copied = 0;
 	unsigned int cnt = 0;
 	struct rds_sock *rs;
 
@@ -815,12 +822,24 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 
 	spin_lock_bh(&rds_sock_lock);
 
-	if (len < rds_sock_count) {
-		cnt = rds_sock_count;
-		goto out;
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
+		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
+			continue;
+		cnt++;
 	}
 
+	if (len < cnt)
+		goto out;
+
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (copied >= cnt)
+			break;
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		/* This option only supports IPv4 sockets. */
 		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
 			continue;
@@ -833,8 +852,13 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 		sinfo.inum = sock_i_ino(rds_rs_to_sk(rs));
 
 		rds_info_copy(iter, &sinfo, sizeof(sinfo));
-		cnt++;
+		copied++;
 	}
+	/* A concurrent rds_bind() can change rs_bound_addr between the
+	 * two passes without holding rds_sock_lock, so copied may be
+	 * less than cnt. Report what was actually copied.
+	 */
+	cnt = copied;
 
 out:
 	lens->nr = cnt;
@@ -848,17 +872,32 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 			   struct rds_info_iterator *iter,
 			   struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds6_info_socket sinfo6;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	struct rds_sock *rs;
 
 	len /= sizeof(struct rds6_info_socket);
 
 	spin_lock_bh(&rds_sock_lock);
 
-	if (len < rds_sock_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
+		cnt++;
+	}
+
+	if (len < cnt)
 		goto out;
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (copied >= cnt)
+			break;
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		sinfo6.sndbuf = rds_sk_sndbuf(rs);
 		sinfo6.rcvbuf = rds_sk_rcvbuf(rs);
 		sinfo6.bound_addr = rs->rs_bound_addr;
@@ -868,10 +907,12 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 		sinfo6.inum = sock_i_ino(rds_rs_to_sk(rs));
 
 		rds_info_copy(iter, &sinfo6, sizeof(sinfo6));
+		copied++;
 	}
+	cnt = copied;
 
  out:
-	lens->nr = rds_sock_count;
+	lens->nr = cnt;
 	lens->each = sizeof(struct rds6_info_socket);
 
 	spin_unlock_bh(&rds_sock_lock);
diff --git a/net/rds/connection.c b/net/rds/connection.c
index cd41f83863c89..beecd408e93ab 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -540,6 +540,7 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
 				      struct rds_info_lengths *lens,
 				      int want_send, bool isv6)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct list_head *list;
 	struct rds_connection *conn;
@@ -562,6 +563,9 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
 			struct rds_conn_path *cp;
 			int npaths;
 
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
 			if (!isv6 && conn->c_isv6)
 				continue;
 
@@ -660,6 +664,7 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 			  u64 *buffer,
 			  size_t item_len)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
@@ -672,6 +677,9 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 	for (i = 0, head = rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
 	     i++, head++) {
 		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
 
 			/* Zero the per-item buffer before handing it to the
 			 * visitor so any field the visitor does not write -
@@ -705,6 +713,7 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 				    u64 *buffer,
 				    size_t item_len)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
@@ -719,6 +728,10 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 			struct rds_conn_path *cp;
 
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
+
 			/* XXX We only copy the information from the first
 			 * path for now.  The problem is that if there are
 			 * more than one underlying paths, we cannot report
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index f66cbf0b9895f..f6bbde2c34776 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -46,14 +46,6 @@
 static DEFINE_SPINLOCK(rds_tcp_tc_list_lock);
 static LIST_HEAD(rds_tcp_tc_list);
 
-/* rds_tcp_tc_count counts only IPv4 connections.
- * rds6_tcp_tc_count counts both IPv4 and IPv6 connections.
- */
-static unsigned int rds_tcp_tc_count;
-#if IS_ENABLED(CONFIG_IPV6)
-static unsigned int rds6_tcp_tc_count;
-#endif
-
 /* Track rds_tcp_connection structs so they can be cleaned up */
 static DEFINE_SPINLOCK(rds_tcp_conn_lock);
 static LIST_HEAD(rds_tcp_conn_list);
@@ -109,11 +101,6 @@ void rds_tcp_restore_callbacks(struct socket *sock,
 	/* done under the callback_lock to serialize with write_space */
 	spin_lock(&rds_tcp_tc_list_lock);
 	list_del_init(&tc->t_list_item);
-#if IS_ENABLED(CONFIG_IPV6)
-	rds6_tcp_tc_count--;
-#endif
-	if (!tc->t_cpath->cp_conn->c_isv6)
-		rds_tcp_tc_count--;
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	tc->t_sock = NULL;
@@ -200,11 +187,6 @@ void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp)
 	/* done under the callback_lock to serialize with write_space */
 	spin_lock(&rds_tcp_tc_list_lock);
 	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
-#if IS_ENABLED(CONFIG_IPV6)
-	rds6_tcp_tc_count++;
-#endif
-	if (!tc->t_cpath->cp_conn->c_isv6)
-		rds_tcp_tc_count++;
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	/* accepted sockets need our listen data ready undone */
@@ -232,20 +214,37 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
 			    struct rds_info_iterator *iter,
 			    struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(rds_sock->sk);
 	struct rds_info_tcp_socket tsinfo;
 	struct rds_tcp_connection *tc;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
 
-	if (len / sizeof(tsinfo) < rds_tcp_tc_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
+		if (tc->t_cpath->cp_conn->c_isv6)
+			continue;
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+		cnt++;
+	}
+
+	if (len / sizeof(tsinfo) < cnt)
 		goto out;
 
 	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
 		struct inet_sock *inet = inet_sk(tc->t_sock->sk);
 
+		if (copied >= cnt)
+			break;
 		if (tc->t_cpath->cp_conn->c_isv6)
 			continue;
+		/* Only show connections in the caller's netns. */
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
 
 		tsinfo.local_addr = inet->inet_saddr;
 		tsinfo.local_port = inet->inet_sport;
@@ -260,10 +259,12 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
 		tsinfo.tos = tc->t_cpath->cp_conn->c_tos;
 
 		rds_info_copy(iter, &tsinfo, sizeof(tsinfo));
+		copied++;
 	}
+	cnt = copied;
 
 out:
-	lens->nr = rds_tcp_tc_count;
+	lens->nr = cnt;
 	lens->each = sizeof(tsinfo);
 
 	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
@@ -278,19 +279,35 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 			     struct rds_info_iterator *iter,
 			     struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds6_info_tcp_socket tsinfo6;
 	struct rds_tcp_connection *tc;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
 
-	if (len / sizeof(tsinfo6) < rds6_tcp_tc_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+		cnt++;
+	}
+
+	if (len / sizeof(tsinfo6) < cnt)
 		goto out;
 
 	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
 		struct sock *sk = tc->t_sock->sk;
 		struct inet_sock *inet = inet_sk(sk);
 
+		if (copied >= cnt)
+			break;
+		/* Only show connections in the caller's netns. */
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+
 		tsinfo6.local_addr = sk->sk_v6_rcv_saddr;
 		tsinfo6.local_port = inet->inet_sport;
 		tsinfo6.peer_addr = sk->sk_v6_daddr;
@@ -303,10 +320,12 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 		tsinfo6.last_seen_una = tc->t_last_seen_una;
 
 		rds_info_copy(iter, &tsinfo6, sizeof(tsinfo6));
+		copied++;
 	}
+	cnt = copied;
 
 out:
-	lens->nr = rds6_tcp_tc_count;
+	lens->nr = cnt;
 	lens->each = sizeof(tsinfo6);
 
 	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
-- 
2.53.0



