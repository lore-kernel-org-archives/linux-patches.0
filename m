Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C546330307;
	Thu, 28 May 2026 20:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001291; cv=none; b=mhtTdfxL2/Qbl2xhO/SlReFKiBB8nOAoHLXE3xx8NgWNRkWPWxp+QO4D4U/M+EMIkr9wnN3EL/qRaRZrhwTabJPJUJ6rq5I+401+RySDpY+CBdcbwq8g/bikp3Eig+92umprljIzGdymevFNMqu9kXrbvjEsV5wQ3zsqi2FEF0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001291; c=relaxed/simple;
	bh=718orzA1cqvD8wUpVhvTeI72hTEAUGaK97s4G+i021o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4UmNi/sCpA2IzXSafLdQmrWl2jwLemo1lh+G7kuXu8qBMsJWhFjzY+aMEjaTpxvlJtHcBnRoyYBbLw9h7op3mAB3xECPsQk4d/FKaBaHvXRHnw1aR3NULXEGVNGTX6/FjPR1XFtxRVri0Oi46sAPb/ZA4b2iQJ7Q6MEqa5MsrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3Ia8i3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3Ia8i3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD61F000E9;
	Thu, 28 May 2026 20:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001290;
	bh=iCtqcWYRY4tB3XVcK9r6eQQF/1hzLZXA+IWQJx2GSYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3Ia8i3/pGwUsyGl4CjuBepRzN8/XopBQbmPFYf4h7wKqDRtv+GCEot8zcA1UMEa6
	 /W8/Oz6CNOXqy1Yuh8eNLkf+XkjGleRrYv1joLT4qncBqyE1Div8c/v4NZTAC3j2Qv
	 Kbsoo+TX7GNAiNmaPVfaXVGemIJf6E6qvjd8Rex4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 076/186] batman-adv: mcast: fix use-after-free in orig_node RCU release
Date: Thu, 28 May 2026 21:49:16 +0200
Message-ID: <20260528194930.989393438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 20c2d6a20ca936f5aaa6dd40f73f262ac45c87cc upstream.

batadv_mcast_purge_orig() removes entries from RCU-protected hlists but
does not wait for an RCU grace period before returning. Concurrent RCU
readers may still accesses references to those entries at the point of
removal. RCU-protected readers trying to operate on entries like
orig->mcast_want_all_ipv6_node will then access already freed memory.

Fix this by moving batadv_mcast_purge_orig() to batadv_orig_node_release(),
just before the call_rcu() invocation. This ensures RCU readers that were
active at purge time have drained before the orig_node memory is reclaimed.

Cc: stable@kernel.org
Fixes: ab49886e3da7 ("batman-adv: Add IPv4 link-local/IPv6-ll-all-nodes multicast support")
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -823,8 +823,6 @@ static void batadv_orig_node_free_rcu(st
 
 	orig_node = container_of(rcu, struct batadv_orig_node, rcu);
 
-	batadv_mcast_purge_orig(orig_node);
-
 	batadv_frag_purge_orig(orig_node, NULL);
 
 	kfree(orig_node->tt_buff);
@@ -878,6 +876,8 @@ void batadv_orig_node_release(struct kre
 	/* Free nc_nodes */
 	batadv_nc_purge_orig(orig_node->bat_priv, orig_node, NULL);
 
+	batadv_mcast_purge_orig(orig_node);
+
 	call_rcu(&orig_node->rcu, batadv_orig_node_free_rcu);
 }
 


