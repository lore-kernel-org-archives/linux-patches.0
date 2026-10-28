Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207599;
	b=n5cF2wIRIhWdE9fyYGxcLN7Ir1lIdkxWWHdd+Jha0tXifD7hhETMWNDFyWLP19MNbPr0
	 K+aabb8/jeZTUCnzaNndXEeGkC4fGMQGz08py3H6Zh1eDjTgIpeucEwY0Qrw+IJSLPLH2
	 oj/O3nQaMdV/R8RNnFThBCYbrGkk8oKUxSD5io246ElQ7+r1/K/aDdQ9KW3RvqM9qUIOb
	 QMe8fRqlbGrnvSnVVMU51HQlffpJFBrd2UP8Qesmkn/25QYLM65ssc38vj3ArUT9O0gGf
	 Js3JgivFW99FBMr3YGrU+24SLKZO03bkrQi9Ae53p3vTFPOOypYkImPAeQXJMlXSM4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UovAEBgG6X1O5NhuLURKRXXPgDdYmVd9xwDy+n6EIto=;
	b=SwTLkvY4/QsgpBj06MN29AHzdbnn4StEozCHYNSxEHa+MnxZj2eDg398sHT7842X035n
	 ZSl5AyBQWVAL6zK3RXX/3suB8FpzUVC680stWB8rOWWpdy6xuNWC965CYwj8WOdBkXjzv
	 kNwqSTcdsaOtbVjGkoPawuvVk+pBTvg2bWcrC268LpubYkDz4v1x4Jxbha4lMT3jyoGA+
	 C+8v2FXlfqdg7ZHyWZ414ln1YNmxv2KUY1wGlp1XXLbh4gZhg0355XYO5CVePqjQ4IA3Z
	 lMrviumpZKcORncBLK+6Kxt4KSrKoqBO4SsDeqmb+082x8nWn8hv4aRhSH8e0eEG2eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TH6ARIm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77059606A31A;
	Wed, 28 Oct 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TH6ARIm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3111F01825;
	Wed, 28 Oct 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207599;
	bh=UovAEBgG6X1O5NhuLURKRXXPgDdYmVd9xwDy+n6EIto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TH6ARIm4+rxjW7ZDQnSiS+byoLz1T5VMT1i2gaD7tQpCm+6iDZvJyLfB4ldRzCS2j
	 vs369qm/X18VsFLVQ3SVEk+o50i0oeCDgjTpM7sMO674U/PqdYH15UJN0uPQg/k08w
	 nedn/F0LxGTGHbLNmdBneCgejgG1/aV90Kz1N9lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 072/247] net: rds: fix uninitialized trans dereference in CM event handler
Date: Wed, 28 Oct 2026 17:57:55 +0100
Message-ID: <20261028165949.098383837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Aohan Mei <henrymei@tencent.com>

commit 492ba6ac1b1ffb8a06ff52db0825c1af2cdb28c8 upstream.

rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
the event switch dereferences it: unconditionally in the
RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
and (with a connection context) in the ROUTE_RESOLVED and
ESTABLISHED cases.

An RDS listener on an iWARP device therefore crashes the kernel as
soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
the wild load becomes a NULL dereference at offset 0xa0
(&trans->cm_handle_connect) in the iw_cm_wq workqueue.

GCC masks the bug in default builds by folding the uninitialized
load into &rds_ib_transport; Clang-built kernels take the real
uninitialized path and oops.

The active side can land on a non-IB device too: the id that
rds_ib_conn_path_connect() creates is not restricted to a node type,
so rdma_resolve_addr() binds it to whichever device serves the local
address, and an iWARP RNIC on the same netdev qualifies.  The crash
there is different: resolving a route on an iWARP id never fills in
cm_id->route.path_rec, and the ROUTE_RESOLVED case writes
path_rec[0].sl before it calls into the transport.

The iWARP transport was dropped long ago and IB is the only
transport left, so make that explicit: initialize trans to
&rds_ib_transport at declaration, drop the conditional assignment,
reject a connect request that arrives on a non-IB device, and drop a
connection whose address resolved to one instead of resolving a
route on it.  The rejection is limited to RDMA_CM_EVENT_CONNECT_REQUEST
on purpose: a non-zero return from the handler makes rdma_cm destroy
the id the event was delivered on, which is right for the request's
freshly created id but would free a connection id that RDS still owns
for any other event.  On the active side the id stays ic->i_cm_id and
the connection's shutdown destroys it, so that case returns 0.

Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794@gmail.com/
Link: https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
[achender: reject only on RDMA_CM_EVENT_CONNECT_REQUEST instead of
 bailing out for every event on a non-IB device, so that rdma_cm does
 not destroy connection ids RDS still tracks; drop a connection whose
 address resolved to a non-IB device before a route is resolved on it;
 changelog adjusted]
Assisted-by: LLM
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261003163408.250568-2-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma_transport.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -52,7 +52,7 @@ static int rds_rdma_cm_event_handler_cmn
 {
 	/* this can be null in the listening path */
 	struct rds_connection *conn = cm_id->context;
-	struct rds_transport *trans;
+	struct rds_transport *trans = &rds_ib_transport;
 	int ret = 0;
 	int *err;
 	u8 len;
@@ -60,9 +60,6 @@ static int rds_rdma_cm_event_handler_cmn
 	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
 		 event->event, rdma_event_msg(event->event));
 
-	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
-		trans = &rds_ib_transport;
-
 	/* Prevent shutdown from tearing down the connection
 	 * while we're executing. */
 	if (conn) {
@@ -82,11 +79,32 @@ static int rds_rdma_cm_event_handler_cmn
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
+		/* Only the IB transport is supported, but RDS listens on
+		 * every RDMA device: reject a request that arrived on any
+		 * other kind.  A non-zero return has rdma_cm destroy the
+		 * request's id, which is what we want here and only here.
+		 */
+		if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
+			ret = 1;
+			break;
+		}
 		ret = trans->cm_handle_connect(cm_id, event, isv6);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		if (conn) {
+			/* The address resolved to a device RDS has no
+			 * transport for.  Do not go on to resolve a route:
+			 * an iWARP route leaves cm_id->route.path_rec
+			 * unset, which the ROUTE_RESOLVED case below
+			 * dereferences.  Drop the connection instead; the
+			 * id is still ic->i_cm_id, so return 0 and let the
+			 * shutdown destroy it.
+			 */
+			if (cm_id->device->node_type != RDMA_NODE_IB_CA) {
+				rds_conn_drop(conn);
+				break;
+			}
 			rdma_set_service_type(cm_id, conn->c_tos);
 			rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
 			ret = rdma_resolve_route(cm_id,


