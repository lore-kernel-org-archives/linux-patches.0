Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207881;
	b=iNbY8a+duyGqxRQVJ2duKdyNR1vjlNWVQ9dzNWCp7f988YEtdfH3klUH8vOv+FC9ZDoa
	 YudDu1KNghzIpISSOrQab0E0w02i9CzOJ4rELQ0hUAMj+G8PcNis8uZtTaC3Q3oPOq/lc
	 Ck8tjRFFVg5jAEymcXODE7UuqGMOUf2Xe6QjCfjLDgbwjICKAaQrX7PKz27IwBzeVGaUQ
	 5e1fQrYtsk+YsY3C0NK7Xr4SP/usP4L9my6OkLMJv4IQjrUQcDXnht4V+0WMx9S+TGYQH
	 waR2doeJ1qHEpjkOJGTSxKMTsG+rEdOwqxLcURnQ5wf5+hfmcCaTH1uL3nBZWrLdAqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7eZT2FWlOrjmKw7YOF1j+IjPh1NjkgO31w8g+msSLeo=;
	b=1bLTXkW7kDyxt52+GERXgwzyLLvqjMHg7W2BPRXT/VX/4dSyCb7RY7GPn1g+RkDTAmVP
	 wWLav23eZqEGAORvFyAMvbECCVgamnkkxymW567N+8bOsGu0VdlHk3thEc+O1R47/AzML
	 5iOlZf1HkB7T21UK6JTvPyjgX4MN9+pvQJVL3e41AjyQ1biLyfu4TUUwexB/P9c2X1Pa4
	 DHIdeGdoNGLfcxGrtuhM+Zcfum2trR5AB0+8YSa7oEOH9IfRugyPkl/eIfXWWg91skhxs
	 3odNtDudu87TQyS6aXZwnqRSbdydYYdcC3B00J5CviG+VguRF/jIvx7f3d03AHz+/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL8EzFuX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE8060A2617;
	Wed, 28 Oct 2026 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL8EzFuX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372F41F01825;
	Wed, 28 Oct 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207880;
	bh=7eZT2FWlOrjmKw7YOF1j+IjPh1NjkgO31w8g+msSLeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL8EzFuX0uhLrWhc38gvIPCdgWQCaq9D505KkFzCOZrxK60Gc5DR5w0xnwFhFz9DR
	 ygY/Q8wqDxdweM1SELJOgA0BrZqt3L81OAaI6yNfyG+J+zP/Yn3Jv+MQj+7aXTSgEu
	 DzGeeDQ6lCWQVE0x70/SvDqmToO3mBs4a0l7JP40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/247] rose: restart the link of a neighbour created over a live AX.25 connection
Date: Wed, 28 Oct 2026 17:59:33 +0100
Message-ID: <20261028165951.448526668@linuxfoundation.org>
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

A new neighbour starts with restarted == 0 and waits for the first frame
sent to it to start the restart procedure. But when a neighbour is
removed from the routing tables and added back (SIOCDELRT then
SIOCADDRT, or SIOCRSCLRRT followed by a reload of the routes), the AX.25
connection to it outlives the old entry. The other end has seen nothing:
it still regards the link as restarted and will not restart it. On this
end rose_get_neigh() only hands out restarted neighbours to through
calls, so no frame is ever sent to the new neighbour and nothing starts
the restart either. Every call relayed through that neighbour is then
refused until one of the two ends happens to originate a call of its own
over the link, or the AX.25 connection drops.

This happens on a relay node each time its routing daemon restarts: FPAC
clears and reloads the routes, the neighbours come back as "restart no"
while /proc/net/ax25 still shows their connections established.

When rose_add_node() creates a neighbour and an AX.25 connection to it
already exists, send the RESTART REQUEST right away and start T0, as
rose_transmit_link() does for the first frame. Nothing changes when
there is no connection yet: the link is still brought up on demand.

Tested in QEMU with a lockdep and KASAN kernel, three nodes A - B - C
with A calling C through B, then B removing and re-adding its route to
C (or clearing and reloading all its routes): before, the neighbour
stays "restart no" on B and A's calls to C are refused for as long as
the test runs; after, the neighbour is restarted within three seconds
and the first call goes through. No lockdep, KASAN or refcount report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 411b950c8862277a53f4afc6c6c5b3ab00b814be)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  1 +
 net/rose/rose_link.c  | 20 ++++++++++++++++++++
 net/rose/rose_route.c | 10 ++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/net/rose.h b/include/net/rose.h
index 49140668b3dd0..f5b23c8a11e4d 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -237,6 +237,7 @@ void rose_link_rx_restart(struct sk_buff *, struct rose_neigh *,
 			  unsigned short);
 void rose_transmit_clear_request(struct rose_neigh *, unsigned int,
 				 unsigned char, unsigned char);
+void rose_link_restart(struct rose_neigh *neigh);
 void rose_transmit_link(struct sk_buff *, struct rose_neigh *);
 
 /* rose_loopback.c */
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index cbfb11fc3ac52..64ae309441a74 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -259,6 +259,26 @@ void rose_transmit_clear_request(struct rose_neigh *neigh, unsigned int lci, uns
 		kfree_skb(skb);
 }
 
+/*
+ * A neighbour has just been created while an AX.25 connection to it is
+ * already up, e.g. it was removed from the routing tables and added back.
+ * The other end still regards the link as restarted and will not restart it,
+ * and through calls only use restarted neighbours, so nothing would ever
+ * restart it from this end either: do it now.
+ */
+void rose_link_restart(struct rose_neigh *neigh)
+{
+	if (neigh->loopback || neigh->restarted || rose_t0timer_running(neigh))
+		return;
+
+	if (!rose_link_up(neigh))
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
index 87844cc195f8d..7ae3552c19267 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -53,6 +53,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 {
 	struct rose_node  *rose_node, *rose_tmpn, *rose_tmpp;
 	struct rose_neigh *rose_neigh;
+	bool new_neigh = false;
 	int i, res = 0;
 
 	spin_lock_bh(&rose_node_list_lock);
@@ -125,6 +126,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 
 		rose_neigh->next = rose_neigh_list;
 		rose_neigh_list  = rose_neigh;
+		new_neigh        = true;
 	}
 
 	/*
@@ -192,6 +194,14 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 	}
 
 out:
+	/*
+	 * The AX.25 connection of a neighbour that was removed from the tables
+	 * outlives it. If it is still there, the other end will not restart
+	 * the link: do it from here.
+	 */
+	if (new_neigh && res == 0)
+		rose_link_restart(rose_neigh);
+
 	spin_unlock_bh(&rose_neigh_list_lock);
 	spin_unlock_bh(&rose_node_list_lock);
 
-- 
2.53.0



