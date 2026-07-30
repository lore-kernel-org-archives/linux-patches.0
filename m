Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D3E3947A4;
	Thu, 30 Jul 2026 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428030; cv=none; b=sm96pRSn2hoZ0B7h4fFiPwacCUih4NiYAAKcml7lT/n1yn0SPhOefaZmHYU4VI3qnrh882g/EEiLq8ebKQIJR3L+Nv9NWtXdIDte8DkkYK7+loOgRZOx2JsCXSMrdqWrllZRUznODpRi788jx5u3cAdn5faKKFxY/z7dPRBtReY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428030; c=relaxed/simple;
	bh=l5twz9ZDeAHafbOCeTqAvajBgun7rF3cDaKXepiBZG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNjS2ebhfTI72eax9eRZkEAqEQgUZODxnBtJ7QOS0Z0VGhNL6nN2eBLZ0qhim320cEHVzCY+eOcuhn265FCRg8cIGXZJtvLl3gh45e/7Y/N2oZCR3saXnZqvxUsfzlg5PeUqsQFyppAM2r2QANHMYErujHUxSUbXHnCjBsmNMB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdBzpFcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdBzpFcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655151F00A3D;
	Thu, 30 Jul 2026 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428027;
	bh=foC50XA3xWlefOuZxAOTNFnv/3YWT/WMfcpxBTupvi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdBzpFcDmIs5rR9lfYz1LDLWiLwo6csaI35/6StHBF+ZrpogPgTkI8v5OXu6dzClu
	 gzS3xp9HwZ9QbhvG3VTKe5z3b5jJnBAlhyPk9CysxqOr32JKntMmadYbya7va/2TAQ
	 HlbvOs/NwWciR+zpje4/NDSDu0w1RmfrTuRQoN5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 379/484] afs: Turn the afs_addr_list address array into an array of structs
Date: Thu, 30 Jul 2026 16:14:36 +0200
Message-ID: <20260730141431.706470315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 07f3502b33a260f873e35708d2fa693eb52225cb ]

Turn the afs_addr_list address array into an array of structs, thereby
allowing per-address (such as RTT) info to be added.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Stable-dep-of: dc175389b18c ("rxrpc: serialize kernel accept preallocation with socket teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/addr_list.c |   10 +++++-----
 fs/afs/fs_probe.c  |    6 +++---
 fs/afs/internal.h  |    6 +++++-
 fs/afs/proc.c      |    4 ++--
 fs/afs/rotate.c    |    2 +-
 fs/afs/rxrpc.c     |    4 ++--
 fs/afs/server.c    |    4 ++--
 fs/afs/vl_alias.c  |    4 ++--
 fs/afs/vl_probe.c  |    6 +++---
 fs/afs/vl_rotate.c |    2 +-
 10 files changed, 26 insertions(+), 22 deletions(-)

--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -45,7 +45,7 @@ struct afs_addr_list *afs_alloc_addrlist
 	alist->max_addrs = nr;
 
 	for (i = 0; i < nr; i++) {
-		struct sockaddr_rxrpc *srx = &alist->addrs[i];
+		struct sockaddr_rxrpc *srx = &alist->addrs[i].srx;
 		srx->srx_family			= AF_RXRPC;
 		srx->srx_service		= service;
 		srx->transport_type		= SOCK_DGRAM;
@@ -281,7 +281,7 @@ void afs_merge_fs_addr4(struct afs_addr_
 		return;
 
 	for (i = 0; i < alist->nr_ipv4; i++) {
-		struct sockaddr_in *a = &alist->addrs[i].transport.sin;
+		struct sockaddr_in *a = &alist->addrs[i].srx.transport.sin;
 		u32 a_addr = ntohl(a->sin_addr.s_addr);
 		u16 a_port = ntohs(a->sin_port);
 
@@ -298,7 +298,7 @@ void afs_merge_fs_addr4(struct afs_addr_
 			alist->addrs + i,
 			sizeof(alist->addrs[0]) * (alist->nr_addrs - i));
 
-	srx = &alist->addrs[i];
+	srx = &alist->addrs[i].srx;
 	srx->srx_family = AF_RXRPC;
 	srx->transport_type = SOCK_DGRAM;
 	srx->transport_len = sizeof(srx->transport.sin);
@@ -321,7 +321,7 @@ void afs_merge_fs_addr6(struct afs_addr_
 		return;
 
 	for (i = alist->nr_ipv4; i < alist->nr_addrs; i++) {
-		struct sockaddr_in6 *a = &alist->addrs[i].transport.sin6;
+		struct sockaddr_in6 *a = &alist->addrs[i].srx.transport.sin6;
 		u16 a_port = ntohs(a->sin6_port);
 
 		diff = memcmp(xdr, &a->sin6_addr, 16);
@@ -338,7 +338,7 @@ void afs_merge_fs_addr6(struct afs_addr_
 			alist->addrs + i,
 			sizeof(alist->addrs[0]) * (alist->nr_addrs - i));
 
-	srx = &alist->addrs[i];
+	srx = &alist->addrs[i].srx;
 	srx->srx_family = AF_RXRPC;
 	srx->transport_type = SOCK_DGRAM;
 	srx->transport_len = sizeof(srx->transport.sin6);
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -153,12 +153,12 @@ responded:
 	if (call->service_id == YFS_FS_SERVICE) {
 		server->probe.is_yfs = true;
 		set_bit(AFS_SERVER_FL_IS_YFS, &server->flags);
-		alist->addrs[index].srx_service = call->service_id;
+		alist->addrs[index].srx.srx_service = call->service_id;
 	} else {
 		server->probe.not_yfs = true;
 		if (!server->probe.is_yfs) {
 			clear_bit(AFS_SERVER_FL_IS_YFS, &server->flags);
-			alist->addrs[index].srx_service = call->service_id;
+			alist->addrs[index].srx.srx_service = call->service_id;
 		}
 		cap0 = ntohl(call->tmp);
 		if (cap0 & AFS3_VICED_CAPABILITY_64BITFILES)
@@ -182,7 +182,7 @@ out:
 	spin_unlock(&server->probe_lock);
 
 	_debug("probe %pU [%u] %pISpc rtt=%u ret=%d",
-	       &server->uuid, index, &alist->addrs[index].transport,
+	       &server->uuid, index, &alist->addrs[index].srx.transport,
 	       rtt_us, ret);
 
 	return afs_done_one_fs_probe(call->net, server);
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -87,7 +87,9 @@ struct afs_addr_list {
 	enum dns_lookup_status	status:8;
 	unsigned long		failed;		/* Mask of addrs that failed locally/ICMP */
 	unsigned long		responded;	/* Mask of addrs that responded */
-	struct sockaddr_rxrpc	addrs[] __counted_by(max_addrs);
+	struct {
+		struct sockaddr_rxrpc	srx;
+	} addrs[] __counted_by(max_addrs);
 #define AFS_MAX_ADDRESSES ((unsigned int)(sizeof(unsigned long) * 8))
 };
 
@@ -972,6 +974,8 @@ extern void afs_put_addrlist(struct afs_
 extern struct afs_vlserver_list *afs_parse_text_addrs(struct afs_net *,
 						      const char *, size_t, char,
 						      unsigned short, unsigned short);
+bool afs_addr_list_same(const struct afs_addr_list *a,
+			const struct afs_addr_list *b);
 extern struct afs_vlserver_list *afs_dns_query(struct afs_cell *, time64_t *);
 extern bool afs_iterate_addresses(struct afs_addr_cursor *);
 extern int afs_end_cursor(struct afs_addr_cursor *);
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -307,7 +307,7 @@ static int afs_proc_cell_vlservers_show(
 		for (i = 0; i < alist->nr_addrs; i++)
 			seq_printf(m, " %c %pISpc\n",
 				   alist->preferred == i ? '>' : '-',
-				   &alist->addrs[i].transport);
+				   &alist->addrs[i].srx.transport);
 	}
 	seq_printf(m, " info: fl=%lx rtt=%d\n", vlserver->flags, vlserver->rtt);
 	seq_printf(m, " probe: fl=%x e=%d ac=%d out=%d\n",
@@ -399,7 +399,7 @@ static int afs_proc_servers_show(struct
 		   alist->version, alist->responded, alist->failed);
 	for (i = 0; i < alist->nr_addrs; i++)
 		seq_printf(m, "    [%x] %pISpc%s\n",
-			   i, &alist->addrs[i].transport,
+			   i, &alist->addrs[i].srx.transport,
 			   alist->preferred == i ? "*" : "");
 	return 0;
 }
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -409,7 +409,7 @@ iterate_address:
 
 	_debug("address [%u] %u/%u %pISp",
 	       op->index, op->ac.index, op->ac.alist->nr_addrs,
-	       &op->ac.alist->addrs[op->ac.index].transport);
+	       &op->ac.alist->addrs[op->ac.index].srx.transport);
 
 	_leave(" = t");
 	return true;
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -302,7 +302,7 @@ static void afs_notify_end_request_tx(st
  */
 void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 {
-	struct sockaddr_rxrpc *srx = &ac->alist->addrs[ac->index];
+	struct sockaddr_rxrpc *srx = &ac->alist->addrs[ac->index].srx;
 	struct rxrpc_call *rxcall;
 	struct msghdr msg;
 	struct kvec iov[1];
@@ -474,7 +474,7 @@ static void afs_log_error(struct afs_cal
 		max = m + 1;
 		pr_notice("kAFS: Peer reported %s failure on %s [%pISp]\n",
 			  msg, call->type->name,
-			  &call->alist->addrs[call->addr_ix].transport);
+			  &call->alist->addrs[call->addr_ix].srx.transport);
 	}
 }
 
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -43,7 +43,7 @@ struct afs_server *afs_find_server(struc
 			hlist_for_each_entry_rcu(server, &net->fs_addresses6, addr6_link) {
 				alist = rcu_dereference(server->addresses);
 				for (i = alist->nr_ipv4; i < alist->nr_addrs; i++) {
-					b = &alist->addrs[i].transport.sin6;
+					b = &alist->addrs[i].srx.transport.sin6;
 					diff = ((u16 __force)a->sin6_port -
 						(u16 __force)b->sin6_port);
 					if (diff == 0)
@@ -59,7 +59,7 @@ struct afs_server *afs_find_server(struc
 			hlist_for_each_entry_rcu(server, &net->fs_addresses4, addr4_link) {
 				alist = rcu_dereference(server->addresses);
 				for (i = 0; i < alist->nr_ipv4; i++) {
-					b = &alist->addrs[i].transport.sin;
+					b = &alist->addrs[i].srx.transport.sin;
 					diff = ((u16 __force)a->sin_port -
 						(u16 __force)b->sin_port);
 					if (diff == 0)
--- a/fs/afs/vl_alias.c
+++ b/fs/afs/vl_alias.c
@@ -94,8 +94,8 @@ static int afs_compare_fs_alists(const s
 	lb = rcu_dereference(server_b->addresses);
 
 	while (a < la->nr_addrs && b < lb->nr_addrs) {
-		const struct sockaddr_rxrpc *srx_a = &la->addrs[a];
-		const struct sockaddr_rxrpc *srx_b = &lb->addrs[b];
+		const struct sockaddr_rxrpc *srx_a = &la->addrs[a].srx;
+		const struct sockaddr_rxrpc *srx_b = &lb->addrs[b].srx;
 		int diff = afs_compare_addrs(srx_a, srx_b);
 
 		if (diff < 0) {
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -106,12 +106,12 @@ responded:
 	if (call->service_id == YFS_VL_SERVICE) {
 		server->probe.flags |= AFS_VLSERVER_PROBE_IS_YFS;
 		set_bit(AFS_VLSERVER_FL_IS_YFS, &server->flags);
-		alist->addrs[index].srx_service = call->service_id;
+		alist->addrs[index].srx.srx_service = call->service_id;
 	} else {
 		server->probe.flags |= AFS_VLSERVER_PROBE_NOT_YFS;
 		if (!(server->probe.flags & AFS_VLSERVER_PROBE_IS_YFS)) {
 			clear_bit(AFS_VLSERVER_FL_IS_YFS, &server->flags);
-			alist->addrs[index].srx_service = call->service_id;
+			alist->addrs[index].srx.srx_service = call->service_id;
 		}
 	}
 
@@ -131,7 +131,7 @@ out:
 	spin_unlock(&server->probe_lock);
 
 	_debug("probe [%u][%u] %pISpc rtt=%u ret=%d",
-	       server_index, index, &alist->addrs[index].transport, rtt_us, ret);
+	       server_index, index, &alist->addrs[index].srx.transport, rtt_us, ret);
 
 	afs_done_one_vl_probe(server, have_result);
 }
--- a/fs/afs/vl_rotate.c
+++ b/fs/afs/vl_rotate.c
@@ -249,7 +249,7 @@ iterate_address:
 
 	_debug("VL address %d/%d", vc->ac.index, vc->ac.alist->nr_addrs);
 
-	_leave(" = t %pISpc", &vc->ac.alist->addrs[vc->ac.index].transport);
+	_leave(" = t %pISpc", &vc->ac.alist->addrs[vc->ac.index].srx.transport);
 	return true;
 
 next_server:


