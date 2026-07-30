Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7842D3769FD;
	Thu, 30 Jul 2026 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426889; cv=none; b=PTyPJnyh9znNVES4rXvRsNoTo6AEJOYDPBPrNNHcBu2XmuvRa+nQDt5X3zOmz9wS7YRFJ5ZcTCL/O+3+NhdjQdj6foYRaeXSXClKw8PAduezv1aEe1do7V70GFqXxl0YmIk20Dhfz2TMMMtR9AnYUSRUToGwyR6nGPAo3TBvgtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426889; c=relaxed/simple;
	bh=dCZ0jK7TOsKpyt5XZDMRoELwyAhrQVAbDKlnd2/CuFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AutTU0zNBrCP02815PIymtQvGa9GmV37Hrbj+hEAbobxDEjwQvAuDc26SAvRcTdPeNkbyyc3RMXLFZkCQNIOigS9lX1rGUgTeR6AzVs7N8jqIB3oii1kBMJ4k4gSqWWte5YO7PCqFeyw8IjRQhmmgi+RcUAbbmus5fJ55CK5nPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiHXPch7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiHXPch7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25401F00A3A;
	Thu, 30 Jul 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426887;
	bh=O2zfxBi+aZw0Wkq0I6E7PUVe/lrpbceV7cFt6pOxbD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiHXPch78D/6Wg+PdADHbarBW8caHghdQsmmYG0Do4VQQSRInwWshj9lUO6rpWWRu
	 eKPMUwr/fkoWMj2vr0d6PaTfoL2bGsuU9O8uUWW6qbo2iY/QX97Zsx7kfy+qaalK+n
	 iuhSdKAAuQlvFx+zRloQ31tQfKA5DnXt1hodR42Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/602] afs: Use the per-peer app data provided by rxrpc
Date: Thu, 30 Jul 2026 16:16:10 +0200
Message-ID: <20260730141448.197725998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 40e8b52fe8c8ab6920ea5f59c5469b6918cce624 ]

Make use of the per-peer application data that rxrpc now allows the
application to store on the rxrpc_peer struct to hold a back pointer to the
afs_server record that peer represents an endpoint for.

Then, when a call comes in to the AFS cache manager, this can be used to
map it to the correct server record rather than having to use a
UUID-to-server mapping table and having to do an additional lookup.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20250224234154.2014840-14-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20250310094206.801057-10-dhowells@redhat.com/ # v4
Stable-dep-of: 330e2c514823 ("afs: Fix dynamic lookup to fail on cell lookup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/addr_list.c         |   50 +++++++++++++++++++++++++
 fs/afs/cmservice.c         |   87 +++++++++------------------------------------
 fs/afs/fs_probe.c          |   32 +++++++++++-----
 fs/afs/internal.h          |    9 +++-
 fs/afs/proc.c              |   10 ++++-
 fs/afs/rxrpc.c             |    6 +++
 fs/afs/server.c            |   46 ++++++-----------------
 include/trace/events/afs.h |    4 --
 net/rxrpc/peer_object.c    |    4 +-
 9 files changed, 125 insertions(+), 123 deletions(-)

--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -362,3 +362,53 @@ int afs_merge_fs_addr6(struct afs_net *n
 	alist->nr_addrs++;
 	return 0;
 }
+
+/*
+ * Set the app data on the rxrpc peers an address list points to
+ */
+void afs_set_peer_appdata(struct afs_server *server,
+			  struct afs_addr_list *old_alist,
+			  struct afs_addr_list *new_alist)
+{
+	unsigned long data = (unsigned long)server;
+	int n = 0, o = 0;
+
+	if (!old_alist) {
+		/* New server.  Just set all. */
+		for (; n < new_alist->nr_addrs; n++)
+			rxrpc_kernel_set_peer_data(new_alist->addrs[n].peer, data);
+		return;
+	}
+	if (!new_alist) {
+		/* Dead server.  Just remove all. */
+		for (; o < old_alist->nr_addrs; o++)
+			rxrpc_kernel_set_peer_data(old_alist->addrs[o].peer, 0);
+		return;
+	}
+
+	/* Walk through the two lists simultaneously, setting new peers and
+	 * clearing old ones.  The two lists are ordered by pointer to peer
+	 * record.
+	 */
+	while (n < new_alist->nr_addrs && o < old_alist->nr_addrs) {
+		struct rxrpc_peer *pn = new_alist->addrs[n].peer;
+		struct rxrpc_peer *po = old_alist->addrs[o].peer;
+
+		if (pn == po)
+			continue;
+		if (pn < po) {
+			rxrpc_kernel_set_peer_data(pn, data);
+			n++;
+		} else {
+			rxrpc_kernel_set_peer_data(po, 0);
+			o++;
+		}
+	}
+
+	if (n < new_alist->nr_addrs)
+		for (; n < new_alist->nr_addrs; n++)
+			rxrpc_kernel_set_peer_data(new_alist->addrs[n].peer, data);
+	if (o < old_alist->nr_addrs)
+		for (; o < old_alist->nr_addrs; o++)
+			rxrpc_kernel_set_peer_data(old_alist->addrs[o].peer, 0);
+}
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -139,49 +139,6 @@ bool afs_cm_incoming_call(struct afs_cal
 }
 
 /*
- * Find the server record by peer address and record a probe to the cache
- * manager from a server.
- */
-static int afs_find_cm_server_by_peer(struct afs_call *call)
-{
-	struct sockaddr_rxrpc srx;
-	struct afs_server *server;
-	struct rxrpc_peer *peer;
-
-	peer = rxrpc_kernel_get_call_peer(call->net->socket, call->rxcall);
-
-	server = afs_find_server(call->net, peer);
-	if (!server) {
-		trace_afs_cm_no_server(call, &srx);
-		return 0;
-	}
-
-	call->server = server;
-	return 0;
-}
-
-/*
- * Find the server record by server UUID and record a probe to the cache
- * manager from a server.
- */
-static int afs_find_cm_server_by_uuid(struct afs_call *call,
-				      struct afs_uuid *uuid)
-{
-	struct afs_server *server;
-
-	rcu_read_lock();
-	server = afs_find_server_by_uuid(call->net, call->request);
-	rcu_read_unlock();
-	if (!server) {
-		trace_afs_cm_no_server_u(call, call->request);
-		return 0;
-	}
-
-	call->server = server;
-	return 0;
-}
-
-/*
  * Clean up a cache manager call.
  */
 static void afs_cm_destructor(struct afs_call *call)
@@ -322,10 +279,7 @@ static int afs_deliver_cb_callback(struc
 
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
-
-	/* we'll need the file server record as that tells us which set of
-	 * vnodes to operate upon */
-	return afs_find_cm_server_by_peer(call);
+	return 0;
 }
 
 /*
@@ -349,18 +303,10 @@ static void SRXAFSCB_InitCallBackState(s
  */
 static int afs_deliver_cb_init_call_back_state(struct afs_call *call)
 {
-	int ret;
-
 	_enter("");
 
 	afs_extract_discard(call, 0);
-	ret = afs_extract_data(call, false);
-	if (ret < 0)
-		return ret;
-
-	/* we'll need the file server record as that tells us which set of
-	 * vnodes to operate upon */
-	return afs_find_cm_server_by_peer(call);
+	return afs_extract_data(call, false);
 }
 
 /*
@@ -373,8 +319,6 @@ static int afs_deliver_cb_init_call_back
 	__be32 *b;
 	int ret;
 
-	_enter("");
-
 	_enter("{%u}", call->unmarshall);
 
 	switch (call->unmarshall) {
@@ -420,9 +364,18 @@ static int afs_deliver_cb_init_call_back
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
 
-	/* we'll need the file server record as that tells us which set of
-	 * vnodes to operate upon */
-	return afs_find_cm_server_by_uuid(call, call->request);
+	if (!call->server) {
+		trace_afs_cm_no_server_u(call, call->request);
+		return 0;
+	}
+
+	if (memcmp(call->request, &call->server->_uuid, sizeof(call->server->_uuid)) != 0) {
+		pr_notice("Callback UUID does not match fileserver UUID\n");
+		trace_afs_cm_no_server_u(call, call->request);
+		return 0;
+	}
+
+	return 0;
 }
 
 /*
@@ -454,7 +407,7 @@ static int afs_deliver_cb_probe(struct a
 
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
-	return afs_find_cm_server_by_peer(call);
+	return 0;
 }
 
 /*
@@ -531,7 +484,7 @@ static int afs_deliver_cb_probe_uuid(str
 
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
-	return afs_find_cm_server_by_peer(call);
+	return 0;
 }
 
 /*
@@ -591,7 +544,7 @@ static int afs_deliver_cb_tell_me_about_
 
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
-	return afs_find_cm_server_by_peer(call);
+	return 0;
 }
 
 /*
@@ -665,9 +618,5 @@ static int afs_deliver_yfs_cb_callback(s
 
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
-
-	/* We'll need the file server record as that tells us which set of
-	 * vnodes to operate upon.
-	 */
-	return afs_find_cm_server_by_peer(call);
+	return 0;
 }
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -235,20 +235,20 @@ out:
  * Probe all of a fileserver's addresses to find out the best route and to
  * query its capabilities.
  */
-void afs_fs_probe_fileserver(struct afs_net *net, struct afs_server *server,
-			     struct afs_addr_list *new_alist, struct key *key)
+int afs_fs_probe_fileserver(struct afs_net *net, struct afs_server *server,
+			    struct afs_addr_list *new_alist, struct key *key)
 {
 	struct afs_endpoint_state *estate, *old;
-	struct afs_addr_list *alist;
+	struct afs_addr_list *old_alist = NULL, *alist;
 	unsigned long unprobed;
 
 	_enter("%pU", &server->uuid);
 
 	estate = kzalloc(sizeof(*estate), GFP_KERNEL);
 	if (!estate)
-		return;
+		return -ENOMEM;
 
-	refcount_set(&estate->ref, 1);
+	refcount_set(&estate->ref, 2);
 	estate->server_id = server->debug_id;
 	estate->rtt = UINT_MAX;
 
@@ -256,21 +256,31 @@ void afs_fs_probe_fileserver(struct afs_
 
 	old = rcu_dereference_protected(server->endpoint_state,
 					lockdep_is_held(&server->fs_lock));
-	estate->responsive_set = old->responsive_set;
-	estate->addresses = afs_get_addrlist(new_alist ?: old->addresses,
-					     afs_alist_trace_get_estate);
+	if (old) {
+		estate->responsive_set = old->responsive_set;
+		if (!new_alist)
+			new_alist = old->addresses;
+	}
+
+	if (old_alist != new_alist)
+		afs_set_peer_appdata(server, old_alist, new_alist);
+
+	estate->addresses = afs_get_addrlist(new_alist, afs_alist_trace_get_estate);
 	alist = estate->addresses;
 	estate->probe_seq = ++server->probe_counter;
 	atomic_set(&estate->nr_probing, alist->nr_addrs);
 
+	if (new_alist)
+		server->addr_version = new_alist->version;
 	rcu_assign_pointer(server->endpoint_state, estate);
-	set_bit(AFS_ESTATE_SUPERSEDED, &old->flags);
 	write_unlock(&server->fs_lock);
+	if (old)
+		set_bit(AFS_ESTATE_SUPERSEDED, &old->flags);
 
 	trace_afs_estate(estate->server_id, estate->probe_seq, refcount_read(&estate->ref),
 			 afs_estate_trace_alloc_probe);
 
-	afs_get_address_preferences(net, alist);
+	afs_get_address_preferences(net, new_alist);
 
 	server->probed_at = jiffies;
 	unprobed = (1UL << alist->nr_addrs) - 1;
@@ -293,6 +303,8 @@ void afs_fs_probe_fileserver(struct afs_
 	}
 
 	afs_put_endpoint_state(old, afs_estate_trace_put_probe);
+	afs_put_endpoint_state(estate, afs_estate_trace_put_probe);
+	return 0;
 }
 
 /*
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1004,6 +1004,9 @@ extern int afs_merge_fs_addr4(struct afs
 			      __be32 xdr, u16 port);
 extern int afs_merge_fs_addr6(struct afs_net *net, struct afs_addr_list *addr,
 			      __be32 *xdr, u16 port);
+void afs_set_peer_appdata(struct afs_server *server,
+			  struct afs_addr_list *old_alist,
+			  struct afs_addr_list *new_alist);
 
 /*
  * addr_prefs.c
@@ -1190,8 +1193,8 @@ struct afs_endpoint_state *afs_get_endpo
 						  enum afs_estate_trace where);
 void afs_put_endpoint_state(struct afs_endpoint_state *estate, enum afs_estate_trace where);
 extern void afs_fileserver_probe_result(struct afs_call *);
-void afs_fs_probe_fileserver(struct afs_net *net, struct afs_server *server,
-			     struct afs_addr_list *new_addrs, struct key *key);
+int afs_fs_probe_fileserver(struct afs_net *net, struct afs_server *server,
+			    struct afs_addr_list *new_alist, struct key *key);
 int afs_wait_for_fs_probes(struct afs_operation *op, struct afs_server_state *states, bool intr);
 extern void afs_probe_fileserver(struct afs_net *, struct afs_server *);
 extern void afs_fs_probe_dispatcher(struct work_struct *);
@@ -1474,7 +1477,7 @@ extern void __exit afs_clean_up_permit_c
  */
 extern spinlock_t afs_server_peer_lock;
 
-extern struct afs_server *afs_find_server(struct afs_net *, const struct rxrpc_peer *);
+struct afs_server *afs_find_server(const struct rxrpc_peer *peer);
 extern struct afs_server *afs_find_server_by_uuid(struct afs_net *, const uuid_t *);
 extern struct afs_server *afs_lookup_server(struct afs_cell *, struct key *, const uuid_t *, u32);
 extern struct afs_server *afs_get_server(struct afs_server *, enum afs_server_trace);
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -444,8 +444,6 @@ static int afs_proc_servers_show(struct
 	}
 
 	server = list_entry(v, struct afs_server, proc_link);
-	estate = rcu_dereference(server->endpoint_state);
-	alist = estate->addresses;
 	seq_printf(m, "%pU %3d %3d %s\n",
 		   &server->uuid,
 		   refcount_read(&server->ref),
@@ -455,10 +453,16 @@ static int afs_proc_servers_show(struct
 		   server->flags, server->rtt);
 	seq_printf(m, "  - probe: last=%d\n",
 		   (int)(jiffies - server->probed_at) / HZ);
+
+	estate = rcu_dereference(server->endpoint_state);
+	if (!estate)
+		goto out;
 	failed = estate->failed_set;
 	seq_printf(m, "  - ESTATE pq=%x np=%u rsp=%lx f=%lx\n",
 		   estate->probe_seq, atomic_read(&estate->nr_probing),
 		   estate->responsive_set, estate->failed_set);
+
+	alist = estate->addresses;
 	seq_printf(m, "  - ALIST v=%u ap=%u\n",
 		   alist->version, alist->addr_pref_version);
 	for (i = 0; i < alist->nr_addrs; i++) {
@@ -471,6 +475,8 @@ static int afs_proc_servers_show(struct
 			   rxrpc_kernel_get_srtt(addr->peer),
 			   addr->last_error, addr->prio);
 	}
+
+out:
 	return 0;
 }
 
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -791,8 +791,14 @@ static void afs_rx_discard_new_call(stru
 static void afs_rx_new_call(struct sock *sk, struct rxrpc_call *rxcall,
 			    unsigned long user_call_ID)
 {
+	struct afs_call *call = (struct afs_call *)user_call_ID;
 	struct afs_net *net = afs_sock2net(sk);
 
+	call->peer = rxrpc_kernel_get_call_peer(sk->sk_socket, call->rxcall);
+	call->server = afs_find_server(call->peer);
+	if (!call->server)
+		trace_afs_cm_no_server(call, rxrpc_kernel_remote_srx(call->peer));
+
 	if (net->live)
 		queue_work(afs_wq, &net->charge_preallocation_work);
 }
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -21,42 +21,13 @@ static void __afs_put_server(struct afs_
 /*
  * Find a server by one of its addresses.
  */
-struct afs_server *afs_find_server(struct afs_net *net, const struct rxrpc_peer *peer)
+struct afs_server *afs_find_server(const struct rxrpc_peer *peer)
 {
-	const struct afs_endpoint_state *estate;
-	const struct afs_addr_list *alist;
-	struct afs_server *server = NULL;
-	unsigned int i;
-	int seq = 1;
-
-	rcu_read_lock();
-
-	do {
-		if (server)
-			afs_unuse_server_notime(net, server, afs_server_trace_unuse_find_rsq);
-		server = NULL;
-		seq++; /* 2 on the 1st/lockless path, otherwise odd */
-		read_seqbegin_or_lock(&net->fs_addr_lock, &seq);
-
-		hlist_for_each_entry_rcu(server, &net->fs_addresses, addr_link) {
-			estate = rcu_dereference(server->endpoint_state);
-			alist = estate->addresses;
-			for (i = 0; i < alist->nr_addrs; i++)
-				if (alist->addrs[i].peer == peer)
-					goto found;
-		}
+	struct afs_server *server = (struct afs_server *)rxrpc_kernel_get_peer_data(peer);
 
-		server = NULL;
-		continue;
-	found:
-		server = afs_maybe_use_server(server, afs_server_trace_use_by_addr);
-
-	} while (need_seqretry(&net->fs_addr_lock, seq));
-
-	done_seqretry(&net->fs_addr_lock, seq);
-
-	rcu_read_unlock();
-	return server;
+	if (!server)
+		return NULL;
+	return afs_maybe_use_server(server, afs_server_trace_use_cm_call);
 }
 
 /*
@@ -469,9 +440,16 @@ static void afs_give_up_callbacks(struct
  */
 static void afs_destroy_server(struct afs_net *net, struct afs_server *server)
 {
+	struct afs_endpoint_state *estate;
+
 	if (test_bit(AFS_SERVER_FL_MAY_HAVE_CB, &server->flags))
 		afs_give_up_callbacks(net, server);
 
+	/* Unbind the rxrpc_peer records from the server. */
+	estate = rcu_access_pointer(server->endpoint_state);
+	if (estate)
+		afs_set_peer_appdata(server, estate->addresses, NULL);
+
 	afs_put_server(net, server, afs_server_trace_destroy);
 }
 
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -140,12 +140,10 @@ enum yfs_cm_operation {
 	EM(afs_server_trace_see_expired,	"SEE expd ") \
 	EM(afs_server_trace_unuse_call,		"UNU call ") \
 	EM(afs_server_trace_unuse_create_fail,	"UNU cfail") \
-	EM(afs_server_trace_unuse_find_rsq,	"UNU f-rsq") \
 	EM(afs_server_trace_unuse_slist,	"UNU slist") \
 	EM(afs_server_trace_unuse_slist_isort,	"UNU isort") \
 	EM(afs_server_trace_unuse_uuid_rsq,	"PUT u-req") \
 	EM(afs_server_trace_update,		"UPDATE   ") \
-	EM(afs_server_trace_use_by_addr,	"USE addr ") \
 	EM(afs_server_trace_use_by_uuid,	"USE uuid ") \
 	EM(afs_server_trace_use_cm_call,	"USE cm-cl") \
 	EM(afs_server_trace_use_get_caps,	"USE gcaps") \
@@ -1119,7 +1117,7 @@ TRACE_EVENT(afs_bulkstat_error,
 	    );
 
 TRACE_EVENT(afs_cm_no_server,
-	    TP_PROTO(struct afs_call *call, struct sockaddr_rxrpc *srx),
+	    TP_PROTO(struct afs_call *call, const struct sockaddr_rxrpc *srx),
 
 	    TP_ARGS(call, srx),
 
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -451,7 +451,7 @@ void rxrpc_destroy_all_peers(struct rxrp
 			continue;
 
 		hlist_for_each_entry(peer, &rxnet->peer_hash[i], hash_link) {
-			pr_err("Leaked peer %u {%u} %pISp\n",
+			pr_err("Leaked peer %x {%u} %pISp\n",
 			       peer->debug_id,
 			       refcount_read(&peer->ref),
 			       &peer->srx.transport);
@@ -468,7 +468,7 @@ void rxrpc_destroy_all_peers(struct rxrp
  */
 struct rxrpc_peer *rxrpc_kernel_get_call_peer(struct socket *sock, struct rxrpc_call *call)
 {
-	return call->peer;
+	return rxrpc_get_peer(call->peer, rxrpc_peer_get_application);
 }
 EXPORT_SYMBOL(rxrpc_kernel_get_call_peer);
 


