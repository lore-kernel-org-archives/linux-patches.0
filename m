Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209651;
	b=wluKcqFUCPCub+JLbKMpTk2y2Up5Hcb5B9Xi+Jo+EDjxshRqTGtkIjQYU4/Cjywb8FXI
	 ONnQni5kUJFqsYPUqemKRAxS7OWh2OlHRKx5Luns3yRkoBeYJYkungVnShjY1zLwEtxJ5
	 1Pqsmltc2odqX5vd/aU4YulkXdpGhcI+7XMAduoYrnspofWaimDPFyvl1OQnoKwuLzxOL
	 jFniAWUXwyf5muptJnhMyAQ6R3zpMKPjpsNEQM83jSGJMIZBDBEKk8fmlcs0vA3ud3ygd
	 DutmCXPIeQTOYHvazZ93xmLphNpycjwgPJAUcyTW0ttWHzB1tyTkBSdpjWeeXzuh9+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tkmJjGoQZc9db14g4HhXr8v7dqtlyPC9r6hPRLjPzxc=;
	b=3tt3CP7jntK36NYLS/gXKx9BmNSsuJcyrxSMk/dX/HKNnodgkU4yaatzXuw0Pyz41+z4
	 lF3pqXsfekLhpiddMHq0+IRxiTJdxlW74rfWfJePKQDxS9e5NaurPwCYSgzBt7k1dr/Mq
	 dBQzAFm4Dwoi65XCF+7K8OZQZkqsVh1z5ZrJtgIm0WZaWw/kL3ZFIw9CoPJqX2Ieet0bF
	 GaYsZSlRo9aTGEM3Bf0C60KagHEr05LHaS+pwEZmYB4DGmbg2YxSqB3Ao69SELkgYOeQQ
	 QHo/azW6n53ubTgtzvCpZkCE9VkYPtM7Ior8kKXV1jJG0dJiMUpsQZSz1i/mvvo1vqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqujmoYo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D3A606A322;
	Wed, 28 Oct 2026 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqujmoYo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C7E1F031E2;
	Wed, 28 Oct 2026 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209651;
	bh=tkmJjGoQZc9db14g4HhXr8v7dqtlyPC9r6hPRLjPzxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqujmoYontbSeb84mKPOWzU3bg5yAun3zzkTCbcwG8ysdoJgmkYwus0w0pskQ0fGF
	 GeQcHpOV7pjz8NO3xjrVXRUJxuaOpIFmkr/RtiwdPe5HDoguaK5M8cQbxQK2bgTraK
	 nW8IOuwlUXFbNhIlIvxTPsL9y+72QyY1hi4zn6I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/109] rose: bring up the link of the preferred route passed over by a connect request
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028165943.048811234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

For a connect request rose_get_neigh() walks the routes that match the
address, from the most specific to the least specific, and takes the
first neighbour whose link is restarted. A neighbour whose link is down
is only used when no matching route at all has a restarted neighbour.

A node that has both an exact route to a neighbouring node and a wide
route through a relay therefore never uses the exact route once its
link is down: the relay is restarted, it is always found first, and
since no frame is ever sent over the direct link nothing brings it up
again. The calls keep going through the relay, which may have no route
other than back to the calling node and then clears them. Seen on a node
whose White Pages daemon calls an adjacent node: every call goes to the
relay and comes back as CLEAR REQUEST "not obtainable", for as long as
the node runs.

Keep sending the call to the restarted neighbour, so that a call never
waits for a link that may not answer, but when a neighbour of a more
specific route, or an earlier neighbour of the same route, was passed
over because its link is down, start the restart procedure on that link.
If the other end answers, the next call finds the link restarted and
uses it. A link that has just failed is left alone for
link_fail_timeout, and nothing is done while a restart is under way.

Frames in transit are handled as before.

Tested in QEMU with a lockdep and KASAN kernel, three nodes A - B - C
where B has an exact route to C over their direct link and a wide route
through A, and the link B - A is restarted while B - C is not. Before,
every call from B to C goes to A and is cleared there, and the direct
link stays down. After, the first call still goes to A, the direct link
is restarted within 20 ms and the following calls go through it. With C
switched off no call waits: they all go to A at once, the restart is
attempted once, and after the AX.25 connection gives up the link is left
alone for link_fail_timeout. A call from A to C in transit through B
gets the same answer before and after. No lockdep, KASAN or refcount
report.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit cdf5a2eba2bc4f79dabb013a3a935f54aedb85e9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/rose_link.c  | 14 ++++++++++++++
 net/rose/rose_route.c | 14 ++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/rose.h b/include/net/rose.h
index 2820b7e4697e6..2fa0331e36f09 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -240,6 +240,7 @@ void rose_link_rx_restart(struct sk_buff *, struct rose_neigh *,
 void rose_transmit_clear_request(struct rose_neigh *, unsigned int,
 				 unsigned char, unsigned char);
 void rose_link_restart(struct rose_neigh *neigh);
+void rose_link_bring_up(struct rose_neigh *neigh);
 void rose_transmit_link(struct sk_buff *, struct rose_neigh *);
 
 /* rose_loopback.c */
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index f2d9e5ffa4ea6..1fe48d58726f5 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -287,6 +287,20 @@ void rose_link_restart(struct rose_neigh *neigh)
 	rose_start_t0timer(neigh);
 }
 
+/*
+ * Start the restart procedure on a link that is down without waiting for
+ * a frame to send over it. Nothing is done while a restart is under way.
+ */
+void rose_link_bring_up(struct rose_neigh *neigh)
+{
+	if (neigh->loopback || neigh->restarted || rose_t0timer_running(neigh))
+		return;
+
+	rose_transmit_restart_request(neigh);
+	neigh->dce_mode = 0;
+	rose_start_t0timer(neigh);
+}
+
 void rose_transmit_link(struct sk_buff *skb, struct rose_neigh *neigh)
 {
 	unsigned char *dptr;
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 68a4f2385277b..6a1de0055e28b 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -741,6 +741,7 @@ struct rose_neigh *rose_get_neigh(rose_address *addr, unsigned char *cause,
 	unsigned char *diagnostic, int route_frame)
 {
 	struct rose_neigh *res = NULL;
+	struct rose_neigh *down = NULL;
 	struct rose_node *node;
 	int failed = 0;
 	int i;
@@ -752,8 +753,21 @@ struct rose_neigh *rose_get_neigh(rose_address *addr, unsigned char *cause,
 				if (node->neighbour[i]->restarted) {
 					res = node->neighbour[i];
 					rose_neigh_hold(node->neighbour[i]);
+					/*
+					 * A neighbour of a more specific route
+					 * was passed over because its link is
+					 * down: this call does not wait for it,
+					 * but have the link brought up for the
+					 * next ones.
+					 */
+					if (down)
+						rose_link_bring_up(down);
 					goto out;
 				}
+				/* The first one is the preferred one. */
+				if (!route_frame && !down &&
+				    !rose_ftimer_running(node->neighbour[i]))
+					down = node->neighbour[i];
 			}
 		}
 	}
-- 
2.53.0



