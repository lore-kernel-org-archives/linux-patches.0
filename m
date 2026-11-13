Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590113;
	b=ob3VSo803ySdOU+y6dgShtRVp03AAuQp8AiC/dveJcUY1IAqobJgSpr1LWcmlqORrcRI
	 tpenrslSU98x/rkXXdqUKKtPXpO/5OePyLs7IPBx7erfBYSCWS2H5gQKQCZP6FpcM/onc
	 RX7dMsp96dEx/B2TC/tAVNxx5Guuo9tQwaSbDq5el1uPfAx5Nx3yFSXe3YOOkqXM5ojvw
	 ZEHCNsA19ZfQMd2sW0o9g5Z77d860TEcx9HIrfuc4Pm9hE1pABEjymeZqcSNjRZNYyL+W
	 Lmdjdak1nbfREo/7eKKUwQYaQTUYqOQw1tCitbJG3jvA6Jq7sN5km4XCLbqwtesbW2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+odR/H2DwcnwY9enR755UIWwAVnnIb5r6wNcQHOv6Q=;
	b=l1y+H12BIuDZ1CHcO/7y04bOk1irLULdLH/TU/ylg4BbDVyR8RB9aHsVlAf84HO09PD9
	 2WxKvgME31HLaHLCKvmvLpKA3gjhJWetByJN6HlSf4/ojuatjwf/JooxuAGdpvsLS5b0Z
	 RearVkHS58scPVrj4y16Y3/7eiDpZJlos8Q7DTum/k90GpbqJBIWWruvYUdIjI6ICUs6m
	 XUy72KSIcDv8ZUC9CbJXlunNOwt01DnheHqLY/NrDmeeuyii1qpxCnIOXYfIGSHt8Uw1i
	 QxB4BwkIUxmPMPNm+r6ItG1IPC3z/pWhHVoO7ofdcqeKTbW9CAWwb0ECEJH1kdvkRhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVXzCH52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECB606B226;
	Fri, 13 Nov 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVXzCH52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F61F000C4;
	Fri, 13 Nov 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590113;
	bh=Q+odR/H2DwcnwY9enR755UIWwAVnnIb5r6wNcQHOv6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVXzCH52x+MEHFCW2cICnRh6R7l7dXvi7PXbs3wgnKAP9BEnUYOsK/9w4YcIxBKud
	 bj8+vG5bh/ZW7wIP3AmlwZGP7U8xGCMaqhfqAItQXi8WBeSPUjAq+Ol4dnfYFSmDNH
	 vRW6Kzcv4QNI1Vpap6qkAA31DnnWBo7sTNSq/dUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/686] netrom: keep the selected route when a route of a node is removed
Date: Fri, 13 Nov 2026 10:44:26 -0500
Message-ID: <20261113153825.321036167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

A node has up to three routes, best first, and which selects the one in
use: nr_link_failed() moves it to the next route when the link to a
neighbour fails, and which >= count means that no route is left.

nr_dec_obs(), nr_del_node() and nr_rt_device_down() remove a route by
moving the routes after it up, but leave which alone. When the removed
route was before the selected one, which now selects the route after
it, or nothing at all: a node still reachable through its last route is
then dropped by nr_route_frame() as unreachable, until a NODES broadcast
happens to reset which.

nr_dec_obs() also moves on to the next index after removing a route, so
the route that has just moved up into that slot is skipped and its
obsolescence count is not decremented in this round.

Remove a route in one helper that moves the routes up and decrements
which when the removed route was before the selected one; if it was the
selected route, which now selects the next one, as after a link failure.
In the loops, only move on when the route stays.

Tested in a QEMU guest (6.12.94, KASAN, lockdep) whose KISS port leads
nowhere, so that every AX.25 link fails, with link_fails_count 1:

- node X through N1 (quality 200, obsolescence 1) and N2 (100, 6); a
  connect() to X makes the link to N1 fail and which select N2 (w 2 in
  /proc/net/nr_nodes); then SIOCNRDECOBS:
    before: "w 2 n 1", obsolescence of N2 still 6; a new connect() to X
            makes no attempt at all
    after:  "w 1 n 1", obsolescence 5; a new connect() opens a link to N2
- node Y through M1 (obsolescence 1) and M2 (2); after one SIOCNRDECOBS:
    before: M2 still at 2
    after:  M2 at 1

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 9957ac8b7a8af9cb48dd9758ee910e5b70935422)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 71 ++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 821697f222d6a..8397a319932c1 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -344,6 +344,24 @@ static void nr_remove_neigh_locked(struct nr_neigh *nr_neigh)
 	nr_neigh_put(nr_neigh);
 }
 
+/*
+ * Remove route i of a node: move the routes after it up, and keep which on
+ * the route it selected. If that route is the one removed, which now
+ * selects the next one, as after a link failure. The caller drops the
+ * route's use of its neighbour. Called with nr_route_lock held.
+ */
+static void nr_node_remove_route_locked(struct nr_node *nr_node, int i)
+{
+	lockdep_assert_held(&nr_route_lock);
+
+	if (i < nr_node->which)
+		nr_node->which--;
+
+	nr_node->count--;
+	for (; i < nr_node->count; i++)
+		nr_node->routes[i] = nr_node->routes[i + 1];
+}
+
 /*
  *	"Delete" a node. Strictly speaking remove a route to a node. The node
  *	is only deleted if no routes are left to it.
@@ -373,22 +391,10 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 			nr_neigh_route_put_locked(nr_neigh);
 			nr_neigh_put(nr_neigh);
 
-			nr_node->count--;
+			nr_node_remove_route_locked(nr_node, i);
 
-			if (nr_node->count == 0) {
+			if (nr_node->count == 0)
 				nr_remove_node_locked(nr_node);
-			} else {
-				switch (i) {
-				case 0:
-					nr_node->routes[0] = nr_node->routes[1];
-					fallthrough;
-				case 1:
-					nr_node->routes[1] = nr_node->routes[2];
-					fallthrough;
-				case 2:
-					break;
-				}
-			}
 			/* Drop the reference taken by __nr_node_get() */
 			nr_node_put(nr_node);
 			ret = 0;
@@ -472,34 +478,24 @@ static int nr_dec_obs(void)
 
 	spin_lock_bh(&nr_route_lock);
 	nr_node_for_each_safe(s, nodet, &nr_node_list) {
-		for (i = 0; i < s->count; i++) {
+		/* i only moves on when route i stays: the next one moves up */
+		for (i = 0; i < s->count; ) {
 			switch (s->routes[i].obs_count) {
 			case 0:		/* A locked entry */
+				i++;
 				break;
 
 			case 1:		/* From 1 -> 0 */
 				nr_neigh = s->routes[i].neighbour;
 
 				nr_neigh_route_put_locked(nr_neigh);
-
-				s->count--;
-
-				switch (i) {
-				case 0:
-					s->routes[0] = s->routes[1];
-					fallthrough;
-				case 1:
-					s->routes[1] = s->routes[2];
-					break;
-				case 2:
-					break;
-				}
+				nr_node_remove_route_locked(s, i);
 				break;
 
 			default:
 				s->routes[i].obs_count--;
+				i++;
 				break;
-
 			}
 		}
 
@@ -525,23 +521,14 @@ void nr_rt_device_down(struct net_device *dev)
 	nr_neigh_for_each_safe(s, nodet, &nr_neigh_list) {
 		if (s->dev == dev) {
 			nr_node_for_each_safe(t, node2t, &nr_node_list) {
-				for (i = 0; i < t->count; i++) {
+				for (i = 0; i < t->count; ) {
 					if (t->routes[i].neighbour == s) {
 						s->count--;
 						nr_neigh_put(s);
 
-						t->count--;
-
-						switch (i) {
-						case 0:
-							t->routes[0] = t->routes[1];
-							fallthrough;
-						case 1:
-							t->routes[1] = t->routes[2];
-							break;
-						case 2:
-							break;
-						}
+						nr_node_remove_route_locked(t, i);
+					} else {
+						i++;
 					}
 				}
 
-- 
2.53.0



