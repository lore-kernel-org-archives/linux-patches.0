Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207497;
	b=1abHUMenjXHpWetIajT2S5/lHAB8HxWCTif95rIeFEurC72LWRpR42HFJv6K9KPrT/j0
	 wkNNXNswGjvPbg6j4M6zuC5t9esmqwVmfzLimhUxGd9RtpFcF6A8HgYclnE//GM8Oc51O
	 2RKiZuQ8nV6tdUMDdZfN9QDh67gqJ0ZLEb32P80EB3LTHkJArxHKt0xi1r6+MSH0bndSC
	 RzOxoz1upJoxDchK4rRoqehWPV2rbnPDXjRqv2Y2umlNyvD8AloVQW6rxFFAxJYwL+/7U
	 KsrfahR7+V9GkYbeo6NmESz9EpNBVkB5OxZJM5Dvth2pVR7FdHU8AytUPw2123KAghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5sSJzVLf9/6pCtcX+GvbxjpNPLLDKC29TM9SH4tAc8c=;
	b=LBV6z1UXPoIHKvRKkIjZaoC5pDkOgtKsSc43xEJeEEs3gJvJESwEPYelQ8LMGgxvOVMA
	 KzylmdqSjFbAKeYPbZQNjUtce6gLyMpbTZ1iPU1tV1l1If6ulzwuKiQPlEztPYKIi8FAM
	 tOoO7Mo4cGnhzkdGX4uxcRGiLTcOYFzMoDSF4xJIaA44Az1cYs+jlCUu5E2luXygeGEBq
	 PxGoVPtDzXbNSisSxZVwc7miliGIZxs354DED7f91WiSbQJ0rFXOMPN5h7/0HOAFN3E48
	 GqYbZvBrxye2zSwQVoRtjhe/m5fWSXC8+44Y/nfQT0x4ZM0BBEqg4YLQVhnK6MJUerQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPBtdytU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C100560A2612;
	Wed, 28 Oct 2026 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPBtdytU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB5C1F01828;
	Wed, 28 Oct 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207496;
	bh=5sSJzVLf9/6pCtcX+GvbxjpNPLLDKC29TM9SH4tAc8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPBtdytU+fzK8nE5ikBoMaUjPaLRm8S7rLG2/+/arS+IqTuFtioO0Z97aOaOzR/T0
	 mLQXalWyG/srW0LvLyGeaPumZmyUnu4zaudhN54kTbR/eXWkBdSD48LtjBJJl1v2v4
	 hyFoAaXWp3pIrwnxroe5nzV1Q52akVZjrBqPyW5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/247] rose: keep the route needed for routing loop detection
Date: Wed, 28 Oct 2026 17:56:49 +0100
Message-ID: <20261028165947.507728390@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_route_frame() walks the route list before parsing the Call Request
facilities.  When a CALL REQUEST arrives on a LCI that already belongs
to a route, the "Remove an existing unused route" branch deletes that
route with rose_remove_route() and breaks out of the walk, so that a
new call is able to reuse a stale LCI.

The routing loop detection that follows looks for a route recording the
same random number and the same pair of callsigns as the incoming call.
The route that has just been deleted is exactly the one it would have
matched, so a call coming back to us around a routing loop is not
detected: it is routed again, a new route is allocated, and the next
copy repeats the cycle.  Two nodes whose routes point at each other then
relay the same call to each other as fast as the CPU allows.

This was observed on an AX.25 network where two nodes each believed the
route to a third one went through the other.  The same CALL REQUEST,
carrying the same random number, was re-sent every 400 us, interleaved
with CLEAR REQUEST "Not obtainable", diagnostic 120, until the AX.25
link collapsed.  Over nine days one node emitted 204 million frames on
a link that normally carries a few frames per minute.  The outgoing LCI
stayed at 001 the whole time, because deleting the route freed it for
immediate reuse.

Parse the facilities before walking the route list, and in both
branches remove the route only when the incoming call differs from the
one it records.  When it is the same call, keep the route and clear the
call with diagnostic 120, which is what the loop detection would have
done.  The predicate is factored out as rose_same_call() and reused by
the loop detection itself.

Tested with two ROSE nodes routing a call back to each other.  Before
this change the kernel relayed 377 CALL REQUEST in ten seconds, never
emitted a CLEAR, and the AX.25 link dropped.  After it, the first call
is relayed once, the next copy is cleared with diagnostic 120, and the
link stays up.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit a7e80823ff751d751411f62770bbd61f01be81db)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 71 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 28746ae5a2582..000d7a8bf7535 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -851,6 +851,21 @@ void rose_link_device_down(struct net_device *dev)
 	}
 }
 
+/*
+ *	Is this Call Request the very same call as the one an existing route
+ *	was built for?  Both the loop detection and the reuse of a stale LCI
+ *	below rely on this test.
+ */
+static bool rose_same_call(const struct rose_route *rose_route,
+			   const rose_address *src_addr,
+			   const struct rose_facilities_struct *facilities)
+{
+	return rose_route->rand == facilities->rand &&
+	       rosecmp(src_addr, &rose_route->src_addr) == 0 &&
+	       ax25cmp(&facilities->dest_call, &rose_route->src_call) == 0 &&
+	       ax25cmp(&facilities->source_call, &rose_route->dest_call) == 0;
+}
+
 /*
  *	Route a frame to an appropriate AX.25 connection.
  *	A NULL ax25_cb indicates an internally generated frame.
@@ -961,6 +976,16 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		goto out;
 	}
 
+	memset(&facilities, 0x00, sizeof(struct rose_facilities_struct));
+
+	if (frametype == ROSE_CALL_REQUEST &&
+	    !rose_parse_facilities(skb->data + ROSE_CALL_REQ_FACILITIES_OFF,
+				   skb->len - ROSE_CALL_REQ_FACILITIES_OFF,
+				   &facilities)) {
+		rose_transmit_clear_request(rose_neigh, lci, ROSE_INVALID_FACILITY, 76);
+		goto out;
+	}
+
 	/*
 	 *	Route it to the next in line if we have an entry for it.
 	 */
@@ -969,7 +994,21 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		if (rose_route->lci1 == lci &&
 		    rose_route->neigh1 == rose_neigh) {
 			if (frametype == ROSE_CALL_REQUEST) {
-				/* F6FBB - Remove an existing unused route */
+				if (rose_same_call(rose_route, src_addr,
+						   &facilities)) {
+					/*
+					 *	The very same call coming back
+					 *	to us: a routing loop.  Keep
+					 *	the route, the loop detection
+					 *	below is what matches on it.
+					 */
+					rose_transmit_clear_request(rose_neigh,
+								    lci,
+								    ROSE_NOT_OBTAINABLE,
+								    120);
+					goto out;
+				}
+				/* Remove an existing unused route */
 				rose_remove_route(rose_route);
 				break;
 			} else if (rose_route->neigh2 != NULL) {
@@ -990,7 +1029,21 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		if (rose_route->lci2 == lci &&
 		    rose_route->neigh2 == rose_neigh) {
 			if (frametype == ROSE_CALL_REQUEST) {
-				/* F6FBB - Remove an existing unused route */
+				if (rose_same_call(rose_route, src_addr,
+						   &facilities)) {
+					/*
+					 *	The very same call coming back
+					 *	to us: a routing loop.  Keep
+					 *	the route, the loop detection
+					 *	below is what matches on it.
+					 */
+					rose_transmit_clear_request(rose_neigh,
+								    lci,
+								    ROSE_NOT_OBTAINABLE,
+								    120);
+					goto out;
+				}
+				/* Remove an existing unused route */
 				rose_remove_route(rose_route);
 				break;
 			} else if (rose_route->neigh1 != NULL) {
@@ -1021,24 +1074,12 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		goto out;
 	}
 
-	memset(&facilities, 0x00, sizeof(struct rose_facilities_struct));
-
-	if (!rose_parse_facilities(skb->data + ROSE_CALL_REQ_FACILITIES_OFF,
-				   skb->len - ROSE_CALL_REQ_FACILITIES_OFF,
-				   &facilities)) {
-		rose_transmit_clear_request(rose_neigh, lci, ROSE_INVALID_FACILITY, 76);
-		goto out;
-	}
-
 	/*
 	 *	Check for routing loops.
 	 */
 	rose_route = rose_route_list;
 	while (rose_route != NULL) {
-		if (rose_route->rand == facilities.rand &&
-		    rosecmp(src_addr, &rose_route->src_addr) == 0 &&
-		    ax25cmp(&facilities.dest_call, &rose_route->src_call) == 0 &&
-		    ax25cmp(&facilities.source_call, &rose_route->dest_call) == 0) {
+		if (rose_same_call(rose_route, src_addr, &facilities)) {
 			rose_transmit_clear_request(rose_neigh, lci, ROSE_NOT_OBTAINABLE, 120);
 			goto out;
 		}
-- 
2.53.0



