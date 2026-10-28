Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207872;
	b=iyJvuUEzMw5YcpttNUfMFQBdlSrhflQX5PDn1NFJB8Uok8YHxY3qUXN4uYcxX/sYmiRV
	 SJFXDYlTT0pvXWPuyXTHjwBpuFbDss3zUeQfPNPg6mpNOmpV006DBFsUWEtx1wjklE21O
	 pNhgk2ZOiWCMCsw0RTRbR1vKTdxEC2o59ksDR0bBmbRDhms8aGKaCR7/xUlI4qikh5vA4
	 5Nyhkr1OlUBSBDVUiw8UfszHP0k5Tz0UnqFh+kbr0oqNhRNjBP7QJ5u09vucp96uS072b
	 fKhdZ61aEgEfjKaFYopwMRFEcL+gCK/JOaQom01scCxIrRg+78FljlCRK4IdPT4wNUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ZBC2awo5nv9PZCMQt8sNKfYjqRz39tkW0zqvU/vtjw=;
	b=aVSCXp6ah/91qlbuw1qAlbXRHFOkG/4Sm3Rnz84b9Ia/cd3MYNLBbJwfhgbwg6+vGIGi
	 AjWJQYawxTdszjtaRGH6StnraVWZl2OtEFXWnTZkjpB08JNJVHLi8XKNOzDs+y3W5uaWT
	 eiZg43gof//bJwZZTtDhk6Q082/ghRciwmq7if7xyshJLlpLtImfHMrWv8GRrthhN5frh
	 VNYp2pzwquQ/WFX5FqVAaefkHdz8HzZlISDn8k7z8SfpGt/HYlQf4gkTtEiZ2Ok8IssgI
	 Xj95z5H9oJ+9kbbinTHLqho9QqUIZTFplxxBjKufwg5GwflxA1DzIrWR+Zh41E0vurw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNOSNdYy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EC5606A33F;
	Wed, 28 Oct 2026 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNOSNdYy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E9D1F01825;
	Wed, 28 Oct 2026 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207872;
	bh=5ZBC2awo5nv9PZCMQt8sNKfYjqRz39tkW0zqvU/vtjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNOSNdYyUb/pwthyy+A3hrLmDHfVU+0b/VveCyaBRApGfaO3vI+g85ST2Oznuwyoc
	 gUXCc1NNzxV5NwIDSPpOEGi6QIeyfBuAifVpnN8mZCcVjhjw/PxeRq8XcmaRKbXPqC
	 I5ctH55wvciaa/JEtUv5u+x2fq76ziUDvHSKFljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/247] netrom: clear nr_neigh->ax25 under the routing lock in nr_link_failed()
Date: Wed, 28 Oct 2026 17:59:30 +0100
Message-ID: <20261028165951.375112897@linuxfoundation.org>
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

nr_route_frame() swaps nr_neigh->ax25 for the ax25_cb returned by
ax25_send_frame() and puts the old one while holding nr_route_lock.
nr_link_failed(), called by AX.25 when that link fails, looks the
neighbour up under the lock but then clears nr_neigh->ax25, puts the
ax25_cb and bumps nr_neigh->failed after dropping it. If a frame is
routed to the same neighbour at that moment, both paths can see the
same ax25_cb and put it twice.

Do the whole of nr_link_failed() in one critical section. The
neighbour no longer needs a temporary reference, since it cannot be
unlinked while the lock is held.

This depends on "netrom: use a single lock for the node and neighbour
lists".

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 6e6f80bff5c901f317c3750cdf375766800ecc1a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 67d9ed0006b40..98ba317ada637 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -715,34 +715,35 @@ void nr_link_failed(ax25_cb *ax25, int reason)
 	struct nr_neigh *s, *nr_neigh = NULL;
 	struct nr_node  *nr_node = NULL;
 
+	/*
+	 * nr_route_frame() replaces nr_neigh->ax25 under nr_route_lock;
+	 * clear it and drop its reference under the same lock, so that the
+	 * two paths cannot both put the same ax25_cb.
+	 */
 	spin_lock_bh(&nr_route_lock);
 	nr_neigh_for_each(s, &nr_neigh_list) {
 		if (s->ax25 == ax25) {
-			nr_neigh_hold(s);
 			nr_neigh = s;
 			break;
 		}
 	}
-	spin_unlock_bh(&nr_route_lock);
 
 	if (nr_neigh == NULL)
-		return;
+		goto out;
 
 	nr_neigh->ax25 = NULL;
 	ax25_cb_put(ax25);
 
-	if (++nr_neigh->failed < READ_ONCE(sysctl_netrom_link_fails_count)) {
-		nr_neigh_put(nr_neigh);
-		return;
-	}
-	spin_lock_bh(&nr_route_lock);
+	if (++nr_neigh->failed < READ_ONCE(sysctl_netrom_link_fails_count))
+		goto out;
+
 	nr_node_for_each(nr_node, &nr_node_list) {
 		if (nr_node->which < nr_node->count &&
 		    nr_node->routes[nr_node->which].neighbour == nr_neigh)
 			nr_node->which++;
 	}
+out:
 	spin_unlock_bh(&nr_route_lock);
-	nr_neigh_put(nr_neigh);
 }
 
 /*
-- 
2.53.0



