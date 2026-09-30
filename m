Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559AF51C06C;
	Wed, 30 Sep 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793825; cv=none; b=JMEWssHkJqPc5NZ4fvdLomXyBfexyxkxMGco9/cNzH4gzXzfj7NeHpAmUpUVre2qDxSfQtfX6xk/2f0//OQ1LMDmDUWlfJTHyQ/0sUs1yulftdeP9eZSL23ORAiZuT56tUFWKGSlNI/BDXK6Ra+PXSzp1EAm5zzLy6CCayAYcV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793825; c=relaxed/simple;
	bh=MxaZDRQsIrrAKRuuMqLFpkBBdNvMESurEWTxbE6vTMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQNy4ppot035rXiyj2A1iPso4drvQIVWK1SEYocAwCELdV0o9ymigdVkauI+IwXYw6zH4PTfreZsZDEoudhI5yD14Ms5dZBDU3dtx9p6kWEWeVp6gj3Kr5WLy2/frh6tN08LMHptkm9G43v8z6CQx6o5yP1jptfiJbcz34n6IZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aylgdd1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aylgdd1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE401F000FF;
	Wed, 30 Sep 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793824;
	bh=rUN2aQWQvemPT2mWOTSPFQOdGaJyl5Aa8F9Scl43YJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aylgdd1Z8j7m5l2BkYS6JLrGQL2bxCW4C6U4fH2Dvk5WPbsVf5jLct3GrUDmogmAK
	 c8QfznYlonXD7rghsqQXF0yCo8wTKDBPeNgdpxNOIGQDRFcVvOK3i6JGxFQDN/YBtK
	 56YUqYOxQHx7yGR+GKeCx4V7mO3ODpL0XT+HOqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 391/395] rose: keep the route needed for routing loop detection
Date: Wed, 30 Sep 2026 17:30:53 +0200
Message-ID: <20260930152349.185638774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_route.c |   71 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 15 deletions(-)

--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -852,6 +852,21 @@ void rose_link_device_down(struct net_de
 }
 
 /*
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
+/*
  *	Route a frame to an appropriate AX.25 connection.
  *	A NULL ax25_cb indicates an internally generated frame.
  */
@@ -961,6 +976,16 @@ int rose_route_frame(struct sk_buff *skb
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
@@ -969,7 +994,21 @@ int rose_route_frame(struct sk_buff *skb
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
@@ -990,7 +1029,21 @@ int rose_route_frame(struct sk_buff *skb
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
@@ -1021,24 +1074,12 @@ int rose_route_frame(struct sk_buff *skb
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


