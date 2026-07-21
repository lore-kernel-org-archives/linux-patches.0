Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DBB1474CC;
	Tue, 21 Jul 2026 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657554; cv=none; b=T5bixhM3ApZxgjqxWoNZUTtRM9G8oHsQEDMQuoVBiQ5QM/9H7hEa2JXSHK/CcKMafhO+cJb0LvaDjSB3SHrq/HgHP7t6zF9CRV3p6iLPcDeY8bj6W+/abaHSjObDAYVarAi5ZLY77p/EmEkjZzRb3Pje81Qdv1Pi3ViJCxCITdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657554; c=relaxed/simple;
	bh=T2A0W4ZuUk/6rzTwpzSfv6eoAj2rE/GGXr730OEd8W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZ0+F+ry0Lz3a4cJctPL2UH+JoDshvBCyzAoOTeWcKGnYzvLBqSilAvkaIOMgpmoZoqEmu9bH/lNvCTJyiKM8WVqfxfupaqoWcNzUBgfVNhXQToC0uOUJOLx1qyzBBkV8mBpamzrGKGRxj7TrS3gJGB55B9yqInZ7AlMkRDEq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PstIDEOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PstIDEOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444511F000E9;
	Tue, 21 Jul 2026 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657552;
	bh=m/kTZkF9sigvMk0+UeqwATQ3FvH/1lKNvA7f3edytQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PstIDEOx5nF9wToJhB1pgOGZK5yip3Qpge2dyq089tV5ShFqW6CijhA0EIJnfOuGG
	 bew9mFPGu4FS15PMg+Cm0UmCZUv+p58l9NoT4Fgx83Gwdo0H/+QzQydr4JqH+5Fuh6
	 v7gmnWkDuboEMQWS0ijX0ZBIoV3vRXBI/3P7G9A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0808/1611] sctp: hold socket lock when dumping endpoints in sctp_diag
Date: Tue, 21 Jul 2026 17:15:24 +0200
Message-ID: <20260721152533.562340664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 7d8297e26b4e20b5d1c3c3fe51fe81a1c7fbc823 ]

SCTP_DIAG endpoint dumping was traversing endpoint address lists without
holding lock_sock(), while those lists could change concurrently via
socket operations (e.g., bindx changes). This creates a race where
nla_reserve() counts addresses under RCU protection, but the subsequent
copy may see fewer entries, potentially leaking uninitialized memory to
userspace.

Fix this by:

- Taking a reference on each endpoint during hash traversal
- Moving socket operations (lock_sock()) outside read_lock_bh()
- Serializing address list access during dump
- Reworking sctp_for_each_endpoint() to support restart-based traversal
  with (net, pos) tracking

Also:

- Add WARN_ON_ONCE() for inconsistent address counts
- Fix idiag_states filtering for LISTEN vs association cases
- Skip dumping endpoints being freed (ep->base.dead)
- Move dump position tracking into iterator, removing cb->args[4] and
  its comment for sctp_ep_dump().,
- Update the comment for cb->args[4] and remove the comment for unused
  cb->args[5] for sctp_sock_dump().

Note: traversal is restart-based and may re-scan buckets multiple times,
but this is acceptable due to small bucket sizes and required to support
sleeping-safe callbacks.

This issue was reported by Nico Yip (@_cyeaa_) working with TrendAI Zero
Day Initiative.

Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/4c1b49ab87e0f7d552ebd8172b364b1994e913c9.1781552190.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h |  3 +-
 net/sctp/diag.c         | 67 ++++++++++++++++++++---------------------
 net/sctp/socket.c       | 29 +++++++++++++-----
 3 files changed, 56 insertions(+), 43 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index e96d1bd087f623..bf1e63d84159f4 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -112,7 +112,8 @@ int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *paddr, void *p, int dif);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
 				    struct net *net, int *pos, void *p);
-int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *), void *p);
+int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
+			   struct net *net, int *pos, void *p);
 int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 		       struct sctp_info *info);
 
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index d758f5c3e06e56..c2a0de2adf6fd1 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -92,6 +92,7 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 		if (!--addrcnt)
 			break;
 	}
+	WARN_ON_ONCE(addrcnt);
 	rcu_read_unlock();
 
 	return 0;
@@ -373,42 +374,39 @@ static int sctp_ep_dump(struct sctp_endpoint *ep, void *p)
 	struct sk_buff *skb = commp->skb;
 	struct netlink_callback *cb = commp->cb;
 	const struct inet_diag_req_v2 *r = commp->r;
-	struct net *net = sock_net(skb->sk);
 	struct inet_sock *inet = inet_sk(sk);
 	int err = 0;
 
-	if (!net_eq(sock_net(sk), net))
+	lock_sock(sk);
+	if (ep->base.dead)
 		goto out;
 
-	if (cb->args[4] < cb->args[1])
-		goto next;
-
-	if (!(r->idiag_states & TCPF_LISTEN) && !list_empty(&ep->asocs))
-		goto next;
+	/* Skip eps with assocs if non-LISTEN states were requested, since
+	 * they'll be dumped by sctp_sock_dump() during assoc traversal.
+	 */
+	if ((r->idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)) &&
+	    !list_empty(&ep->asocs))
+		goto out;
 
 	if (r->sdiag_family != AF_UNSPEC &&
 	    sk->sk_family != r->sdiag_family)
-		goto next;
+		goto out;
 
 	if (r->id.idiag_sport != inet->inet_sport &&
 	    r->id.idiag_sport)
-		goto next;
+		goto out;
 
 	if (r->id.idiag_dport != inet->inet_dport &&
 	    r->id.idiag_dport)
-		goto next;
-
-	if (inet_sctp_diag_fill(sk, NULL, skb, r,
-				sk_user_ns(NETLINK_CB(cb->skb).sk),
-				NETLINK_CB(cb->skb).portid,
-				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				cb->nlh, commp->net_admin) < 0) {
-		err = 2;
 		goto out;
-	}
-next:
-	cb->args[4]++;
+
+	err = inet_sctp_diag_fill(sk, NULL, skb, r,
+				  sk_user_ns(NETLINK_CB(cb->skb).sk),
+				  NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				  cb->nlh, commp->net_admin);
 out:
+	release_sock(sk);
 	return err;
 }
 
@@ -479,41 +477,40 @@ static void sctp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		.r = r,
 		.net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN),
 	};
-	int pos = cb->args[2];
+	int pos;
 
 	/* eps hashtable dumps
 	 * args:
 	 * 0 : if it will traversal listen sock
 	 * 1 : to record the sock pos of this time's traversal
-	 * 4 : to work as a temporary variable to traversal list
 	 */
 	if (cb->args[0] == 0) {
-		if (!(idiag_states & TCPF_LISTEN))
-			goto skip;
-		if (sctp_for_each_endpoint(sctp_ep_dump, &commp))
-			goto done;
-skip:
+		if (idiag_states & TCPF_LISTEN) {
+			pos = cb->args[1];
+			if (sctp_for_each_endpoint(sctp_ep_dump, net, &pos,
+						   &commp)) {
+				cb->args[1] = pos;
+				return;
+			}
+		}
 		cb->args[0] = 1;
 		cb->args[1] = 0;
-		cb->args[4] = 0;
 	}
 
+	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
+		return;
+
 	/* asocs by transport hashtable dump
 	 * args:
 	 * 1 : to record the assoc pos of this time's traversal
 	 * 2 : to record the transport pos of this time's traversal
 	 * 3 : to mark if we have dumped the ep info of the current asoc
-	 * 4 : to work as a temporary variable to traversal list
-	 * 5 : to save the sk we get from travelsing the tsp list.
+	 * 4 : to track position within ep->asocs list in sctp_sock_dump()
 	 */
-	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
-		goto done;
-
+	pos = cb->args[2];
 	sctp_transport_traverse_process(sctp_sock_filter, sctp_sock_dump,
 					net, &pos, &commp);
 	cb->args[2] = pos;
-
-done:
 	cb->args[1] = cb->args[4];
 	cb->args[4] = 0;
 }
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8a2622da56d23e..7a641cb8473840 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5310,24 +5310,39 @@ struct sctp_transport *sctp_transport_get_idx(struct net *net,
 }
 
 int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
-			   void *p) {
-	int err = 0;
-	int hash = 0;
-	struct sctp_endpoint *ep;
+			   struct net *net, int *pos, void *p) {
+	int err, hash = 0, idx = 0, start;
 	struct sctp_hashbucket *head;
+	struct sctp_endpoint *ep;
 
 	for (head = sctp_ep_hashtable; hash < sctp_ep_hashsize;
 	     hash++, head++) {
+		start = idx;
+again:
 		read_lock_bh(&head->lock);
 		sctp_for_each_hentry(ep, &head->chain) {
-			err = cb(ep, p);
-			if (err)
+			if (sock_net(ep->base.sk) != net)
+				continue;
+			if (idx++ >= *pos) {
+				sctp_endpoint_hold(ep);
 				break;
+			}
 		}
 		read_unlock_bh(&head->lock);
+
+		if (ep) {
+			err = cb(ep, p);
+			sctp_endpoint_put(ep);
+			if (err)
+				return err;
+			(*pos)++;
+
+			idx = start;
+			goto again;
+		}
 	}
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(sctp_for_each_endpoint);
 
-- 
2.53.0



