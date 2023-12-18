Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7A3789C;
	Mon, 18 Dec 2023 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JryDuWhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B366C433C8;
	Mon, 18 Dec 2023 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908275;
	bh=12JU2qGxIsCVYa5CU7ihXZlf1Z40nsoKy2hh4Sh+Bh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JryDuWhq84qWvKta+TwKZj8lEtqj8MqJAo8DcUoGT7/PbqxxR6mMPq+AkmmYwmYxM
	 b4nwkuo4TCHtBDPUAVgP97XHYgb2zkgU5//DivFdh4s5oJjYbdBi0Kf59qYu7mfakA
	 wmJsY768zaKAqiUiqf0/Gg47k+k4TpSf5xOUxmLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/166] rxrpc: Fix some minor issues with bundle tracing
Date: Mon, 18 Dec 2023 14:50:54 +0100
Message-ID: <20231218135108.934698009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0c3bd086d12d185650d095a906662593ec607bd0 ]

Fix some superficial issues with the tracing of rxrpc_bundle structs,
including:

 (1) Set the debug_id when the bundle is allocated rather than when it is
     set up so that the "NEW" trace line displays the correct bundle ID.

 (2) Show the refcount when emitting the "FREE" traceline.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_client.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 981ca5b98bcb9..1d95f8bc769fa 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -73,6 +73,7 @@ static void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local)
 static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_call *call,
 					       gfp_t gfp)
 {
+	static atomic_t rxrpc_bundle_id;
 	struct rxrpc_bundle *bundle;
 
 	bundle = kzalloc(sizeof(*bundle), gfp);
@@ -85,6 +86,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_call *call,
 		bundle->upgrade		= test_bit(RXRPC_CALL_UPGRADE, &call->flags);
 		bundle->service_id	= call->dest_srx.srx_service;
 		bundle->security_level	= call->security_level;
+		bundle->debug_id	= atomic_inc_return(&rxrpc_bundle_id);
 		refcount_set(&bundle->ref, 1);
 		atomic_set(&bundle->active, 1);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
@@ -105,7 +107,8 @@ struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle,
 
 static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 {
-	trace_rxrpc_bundle(bundle->debug_id, 1, rxrpc_bundle_free);
+	trace_rxrpc_bundle(bundle->debug_id, refcount_read(&bundle->ref),
+			   rxrpc_bundle_free);
 	rxrpc_put_peer(bundle->peer, rxrpc_peer_put_bundle);
 	key_put(bundle->key);
 	kfree(bundle);
@@ -239,7 +242,6 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
  */
 int rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t gfp)
 {
-	static atomic_t rxrpc_bundle_id;
 	struct rxrpc_bundle *bundle, *candidate;
 	struct rxrpc_local *local = call->local;
 	struct rb_node *p, **pp, *parent;
@@ -306,7 +308,6 @@ int rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t gfp)
 	}
 
 	_debug("new bundle");
-	candidate->debug_id = atomic_inc_return(&rxrpc_bundle_id);
 	rb_link_node(&candidate->local_node, parent, pp);
 	rb_insert_color(&candidate->local_node, &local->client_bundles);
 	call->bundle = rxrpc_get_bundle(candidate, rxrpc_bundle_get_client_call);
-- 
2.43.0



