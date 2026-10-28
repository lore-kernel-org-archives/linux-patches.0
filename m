Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208021;
	b=VrzlNh2uKqOwERgKVwysW/oAGeakVO6ORLvKZPLr+xPbafPPuqWYxC3lpiRi4X3QWbrj
	 Um5nFUd+wtzgwXyw8didUpnK1+d4Fn7k+CidgM2gHKHSGOUogDW6XrjytvwlyCmNlKuXI
	 O3Qn7cEjghEShnOL4z2Gqn1197Fr9NSQ3xZWehQGnCpqm/9zAQzM4PPciG1kGzgR0SXJ0
	 jth+B2plx8hJZbgXPE6JAXuh8mQqd+jmq62taKFxZ9gNIJQ/KO2Fh8JiGCt68lJHroV39
	 aczL09AdrSwyK2iq3Wp8MqSEhU8Tv8FeofdDZQRiVZ8bEG66etJiZUqDKN94xPoMJmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ACmk1ZhALLOtHyrO+dbu0ezypEquOhMllbr35FODdBw=;
	b=qLMX+OlHDGqnQGQn7dQ/03bmOg7qkgcK7xQvccpjxo8S/Y9Z/Hs3YC6E4gRxwFz7wuzU
	 JB+WrRiFTyoaWeunma145n7ovZsUlELxSGLKl4h1i0kV8nI7gMvIAZ22hecB+GGUfLoOC
	 3y5aRuo2tXeMZWlUc2unqDzY95KAG9HrVoVEPHIJ/bSfEJBIpymk48fkqy/XsGTebRw7n
	 PCvmDfjBv2vsUyN9jrrD/V4210cWNQT9v12LIUjswSOyzje9bmNzswUaybF/4cKIyR++T
	 okDLj6wmdzd7nEzzKmXu/PHkgQ4xyUTE0Odq48SpW2i7cPjv1Sk1bTe3/6BZono92HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4ckf+KU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B87606A31C;
	Wed, 28 Oct 2026 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4ckf+KU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105171F01825;
	Wed, 28 Oct 2026 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208020;
	bh=ACmk1ZhALLOtHyrO+dbu0ezypEquOhMllbr35FODdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4ckf+KUVFVDQYDAOcNlRLpZnTZ7/5e/5ZeOKbHZYG4y4+40oTxC1vAk4+4PIB5s4
	 kiC3mklxdvnudAD40Msj1L0p1iscXKRLiPkayUrJ8QVM/epMXkPcRF3r0JCSn0HZRG
	 TgaQhU6FjSsP6gHayzs79pqW/UMYc0qTNtrYewCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/247] rose: clear the circuits of a neighbour that restarts the link
Date: Wed, 28 Oct 2026 17:59:41 +0100
Message-ID: <20261028165951.637330497@linuxfoundation.org>
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

A Restart Request is the X.25 way to say that every virtual circuit of
a link is gone. rose_link_rx_restart() only marks the neighbour as
restarted and answers with a Restart Confirmation: the sockets and the
through routes that used the link are left as they were.

That is harmless on a link coming up, nothing is established yet. It
is not when the other end restarts its AX.25 and ROSE stack while we
keep the link: the first thing it sends is a SABM, which resets our
AX.25 connection without bringing it down, then a Restart Request. Its
circuits are gone, ours stay in state 3 forever:

 - a frame for a logical channel that the other end does not know is
   dropped silently by rose_route_frame(), so no Clear Request ever
   comes back;
 - no timer watches the acknowledgement of data in state 3, and the
   idle timer is off by default;
 - the through routes stay in /proc/net/rose_routes and the remote
   ends of those calls are never told.

The stale entries are not just a leak. The restarted end allocates its
logical channel numbers afresh, so a new circuit can get the number of
a stale through route on the same link, and whatever still arrives on
the stale half is then relayed into the new circuit.

Seen on a live network: a node that restarts its stack from cron left,
on each of three neighbours, a data circuit with five unacknowledged
frames that never moved again, and five through routes on the node
that relays for the others.

Clear them when a Restart Request arrives on a link that is already
up: send a Clear Request to the other half of each through route and
drop the route, and disconnect the local sockets, as rose_link_failed()
does when the link goes down. The loop of rose_del_route_by_neigh() is
moved to a helper for that, since the caller here already holds
rose_route_list_lock. Nothing is sent to the restarting neighbour: it
has no circuit left, and a Clear Request could hit a call it has just
placed on a reused channel number.

A link that is not up yet is left alone: nothing can be established
over it, and the sockets found there are calls waiting in neigh->queue
for the restart to complete.

Tested with three QEMU guests in a line, A - B - C, on a kernel with
lockdep and KASAN. A calls C through B and B calls C, both circuits
stay open, then C destroys and recreates its AX.25 interface, reloads
its routes and calls B. Before: both circuits are still open a minute
later, B keeps the through route, nobody is told. After: A and B get
the circuit cleared (cause 0x09) within a second of the Restart
Request, B has no through route left, and the new call from C goes
through at the first attempt. Four runs, no lockdep, KASAN or refcount
report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 34de1b990c7c690c19594a49ee5b9a74883baf2b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/rose_link.c  |  8 ++++++++
 net/rose/rose_route.c | 44 +++++++++++++++++++++++++++++++++----------
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 6ce065480a4e6..2820b7e4697e6 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -269,6 +269,7 @@ struct rose_neigh *rose_get_neigh(rose_address *, unsigned char *,
 				  unsigned char *, int);
 int rose_rt_ioctl(unsigned int, void __user *);
 void rose_link_failed(ax25_cb *, int);
+void rose_link_restarted(struct rose_neigh *);
 int rose_route_frame(struct sk_buff *, ax25_cb *);
 void rose_rt_free(void);
 
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 64ae309441a74..76032148a95eb 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -142,6 +142,14 @@ void rose_link_rx_restart(struct sk_buff *skb, struct rose_neigh *neigh, unsigne
 
 	switch (frametype) {
 	case ROSE_RESTART_REQUEST:
+		/*
+		 * A Restart Request on a link that is already up means that
+		 * the other end has lost its virtual circuits, clear ours.
+		 * Nothing is established over a link that is not up yet, and
+		 * the calls waiting in neigh->queue must be left alone.
+		 */
+		if (neigh->restarted)
+			rose_link_restarted(neigh);
 		rose_stop_t0timer(neigh);
 		neigh->restarted = 1;
 		neigh->dce_mode  = (skb->data[3] == ROSE_DTE_ORIGINATED);
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 883b204121566..68a4f2385277b 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -827,19 +827,15 @@ int rose_rt_ioctl(unsigned int cmd, void __user *arg)
 	return 0;
 }
 
-static void rose_del_route_by_neigh(struct rose_neigh *rose_neigh)
+/*
+ *	Blow away the through routes using this neighbour: the half on the
+ *	neighbour is dropped and the other half is told with a Clear Request.
+ *	The caller holds rose_route_list_lock.
+ */
+static void rose_clear_routes_by_neigh(struct rose_neigh *rose_neigh)
 {
 	struct rose_route *rose_route, *s;
 
-	rose_neigh->restarted = 0;
-
-	rose_stop_t0timer(rose_neigh);
-	rose_start_ftimer(rose_neigh);
-
-	skb_queue_purge(&rose_neigh->queue);
-
-	spin_lock_bh(&rose_route_list_lock);
-
 	rose_route = rose_route_list;
 
 	while (rose_route != NULL) {
@@ -866,9 +862,37 @@ static void rose_del_route_by_neigh(struct rose_neigh *rose_neigh)
 
 		rose_route = rose_route->next;
 	}
+}
+
+static void rose_del_route_by_neigh(struct rose_neigh *rose_neigh)
+{
+	rose_neigh->restarted = 0;
+
+	rose_stop_t0timer(rose_neigh);
+	rose_start_ftimer(rose_neigh);
+
+	skb_queue_purge(&rose_neigh->queue);
+
+	spin_lock_bh(&rose_route_list_lock);
+	rose_clear_routes_by_neigh(rose_neigh);
 	spin_unlock_bh(&rose_route_list_lock);
 }
 
+/*
+ *	The neighbour has restarted a link that was up: it has lost every
+ *	virtual circuit that ran over it. Blow away the through routes and
+ *	the connections using this neighbour, the link itself stays up.
+ *	Called from rose_route_frame() with rose_neigh_list_lock and
+ *	rose_route_list_lock held.
+ */
+void rose_link_restarted(struct rose_neigh *rose_neigh)
+{
+	lockdep_assert_held(&rose_route_list_lock);
+
+	rose_clear_routes_by_neigh(rose_neigh);
+	rose_kill_by_neigh(rose_neigh);
+}
+
 /*
  * 	A level 2 link has timed out, therefore it appears to be a poor link,
  *	then don't use that neighbour until it is reset. Blow away all through
-- 
2.53.0



