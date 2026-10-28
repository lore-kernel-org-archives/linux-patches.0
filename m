Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209617;
	b=HQQSco5Zr+TFcu/z3Hkys4Odv8rrYIg3ZKG0SC+plmVRkX7pzMzMdWDo2TNmeZfqppWQ
	 CYYt9GJ68Ht3Q54uIM2TFy5jB+3VMDGz/bNbiIG4uJyk0BoND3Ocww6fCuBTKpSZy3/Uv
	 TYi75ia05cuU1zkm46VCtGPfpwo6wXonESUzxqBOVjRdnji4e7RftHLjuf7Fvaaio4c+z
	 7lIbrOAfNILUbVLyV5spNDcLIcwC1UQ23t0J8xSrFaCQ5xcjm/TcpiKahIYtDwpWmS+Sn
	 jGbkDMAW0I7kkFlnJtHBbxwpf8D2NDaBg4gjGr64BcBvmfcWaO0t+iQg4YooTolFfOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxOVPn1PKvRRVOHRYxfHjQMD4ndJtYwVeDitP52Ei8k=;
	b=GOpNtiEQkS2d/Juk+sjzaRiPyRlVQwycACKBclsaL4YsfyxixBNkTt+M/rFKKOco81NR
	 iOlmA7Wh5jzqnmlg1XVMLz8MbG/kPcqfxRegQ98xsZVmahugNS1f81Kxiv9PXsTW2Xj89
	 pOuEJTTzPsNaJCyyGTwkALeodi8K4/vyrQAEYz60eoR6aowZ+TvjYb21S5G/9w52aa/wf
	 kqheFTEsVDB9Yr6c60LM4/VuRsJY2m/13i6Qx4QutLszRNgal+ATrVa2n/SWpkSB0a3sF
	 edw45NeiqdWtM5iV+B4U4B9ld5a+CEB+FSGrfxveogG//N1wtggDVv6nXNcweVrPCvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmkCwUcD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9F4606A31A;
	Wed, 28 Oct 2026 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmkCwUcD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAB91F01825;
	Wed, 28 Oct 2026 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209616;
	bh=kxOVPn1PKvRRVOHRYxfHjQMD4ndJtYwVeDitP52Ei8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmkCwUcDZDn8ynMED6QTAsrLwrEBvin0D/o0eT1isk8jkrQE0nH7amooF6NU/BsJl
	 yDsbE46W6m2fBCP19y89/zuS2IZJuAuuM5QQR+1GpyHu9UKbiPwttWkQVUkekyctDj
	 bzzKI1Xdg2D/KY6I55D/pC+z6u4DsvNxSM8rypvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/109] rose: clear through routes when a neighbour is removed from the tables
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028165942.795585588@linuxfoundation.org>
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

When the last route using a neighbour is deleted (SIOCDELRT) or all
routes are cleared (SIOCRSCLRRT), rose_del_node() and
rose_clear_routes() take the neighbour out of rose_neigh_list, but the
through routes in rose_route_list that still use it are left alone.
No frame can reach them any more, so they stay in the table for ever,
holding their neighbour references, and neither end of the relayed
connection is told: the caller and the called station keep a circuit
that goes nowhere. rose_clear_routes() even says it keeps neighbours
with active connections, which it does not.

This shows up on every node that relays traffic when its routing
daemon restarts: FPAC clears and reloads the routes, the neighbours are
recreated under new numbers, and the old through routes remain listed
with neighbours that no longer exist.

Clear them when the neighbour is removed, as rose_link_failed() does
when a link fails, but send the CLEAR to both halves since the removed
neighbour's link may still be up, and cut the local connections using
it. rose_route_list_lock is taken under rose_node_list_lock and
rose_neigh_list_lock, the order rose_route_frame() and
rose_link_failed() already use.

Tested in QEMU with a lockdep and KASAN kernel, three nodes A - B - C
with A calling C through B: before, the through route stays on B after
SIOCDELRT or SIOCRSCLRRT and A is never told; after, the entry is gone
and both A and C get a CLEAR (cause 0x09) within a second. No lockdep,
KASAN or refcount report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 065ae03f519c147d5ee7b87acb2d21fe93ae0007)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 49 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index fd196f2e2fd64..87844cc195f8d 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -285,6 +285,49 @@ static void rose_remove_route(struct rose_route *rose_route)
 	}
 }
 
+/*
+ *	A neighbour is being removed from the tables while its link may still
+ *	be up (route deleted or routes cleared by the configuration). Clear the
+ *	through routes using it, on both sides since both can still be reached,
+ *	instead of leaving them in rose_route_list for ever: no frame can reach
+ *	them once the neighbour is gone. Local connections using it are cut too,
+ *	as rose_link_failed() does.
+ *
+ *	Caller is holding rose_node_list_lock and rose_neigh_list_lock, taken
+ *	before rose_route_list_lock as in rose_route_frame() and
+ *	rose_link_failed().
+ */
+static void rose_neigh_clear_routes(struct rose_neigh *rose_neigh)
+{
+	struct rose_route *rose_route, *s;
+
+	spin_lock_bh(&rose_route_list_lock);
+
+	rose_route = rose_route_list;
+	while (rose_route != NULL) {
+		s = rose_route->next;
+
+		if (rose_route->neigh1 == rose_neigh ||
+		    rose_route->neigh2 == rose_neigh) {
+			if (rose_route->neigh1 != NULL)
+				rose_transmit_clear_request(rose_route->neigh1,
+							    rose_route->lci1,
+							    ROSE_OUT_OF_ORDER, 0);
+			if (rose_route->neigh2 != NULL)
+				rose_transmit_clear_request(rose_route->neigh2,
+							    rose_route->lci2,
+							    ROSE_OUT_OF_ORDER, 0);
+			rose_remove_route(rose_route);
+		}
+
+		rose_route = s;
+	}
+
+	spin_unlock_bh(&rose_route_list_lock);
+
+	rose_kill_by_neigh(rose_neigh);
+}
+
 /*
  *	"Delete" a node. Strictly speaking remove a route to a node. The node
  *	is only deleted if no routes are left to it.
@@ -333,6 +376,7 @@ static int rose_del_node(struct rose_route_struct *rose_route,
 			rose_neigh_put(rose_neigh);
 
 			if (rose_neigh->count == 0) {
+				rose_neigh_clear_routes(rose_neigh);
 				rose_remove_neigh(rose_neigh);
 				rose_neigh_put(rose_neigh);
 			}
@@ -547,8 +591,8 @@ void rose_route_device_down(struct net_device *dev)
 #endif
 
 /*
- *	Clear all nodes and neighbours out, except for neighbours with
- *	active connections going through them.
+ *	Clear all nodes and neighbours out, with the through routes and
+ *	connections using those neighbours.
  *  Do not clear loopback neighbour and nodes.
  */
 static int rose_clear_routes(void)
@@ -579,6 +623,7 @@ static int rose_clear_routes(void)
 		rose_neigh = rose_neigh->next;
 
 		if (!s->loopback) {
+			rose_neigh_clear_routes(s);
 			rose_remove_neigh(s);
 			rose_neigh_put(s);
 		}
-- 
2.53.0



