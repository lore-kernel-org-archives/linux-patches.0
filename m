Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C5333F5B4;
	Thu, 28 May 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998361; cv=none; b=a/TEnEsmT+5cc+shOtZEahK9ygWQjSp/i+tGPfiQn19SOEaldE9qJqTrVhq9zExBwSZHqwZIuIuu66zIuw1W2ccijVaoFmHc3wMCVHXXibir7Nnx0BUFqYXgZIjmVKwIMM96LJS+TlJtvJ7PKTqOW36rgXB9acTDrGCP7MYpLnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998361; c=relaxed/simple;
	bh=chl9WOBnWLu/L5wjDkQUC8Fz9j9ExTrDYQCEshEarcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+ZZTlBGXz0+oJTneIxVLH20kvffZbjX7NQDPDaoGIA7bHViUJXUyNXqynYQzTNfux/y//GADHR2Pp59Fvp0LyhW0ebjcs9Kk8m48y4S1RRInZ+va1EBuKViqa6y3aFRMto5PSKlU2yxLeActUn3OcGJwLbRi6Y+gPb9n8gUPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzWwoSTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzWwoSTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEE01F000E9;
	Thu, 28 May 2026 19:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998360;
	bh=N+72baT9qcZCza0zQFPrbLrdr9Mem0eppc9G99/ZdOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzWwoSTdGZDSeIwxcD+h4LOk+gbmoUAV7GTFbDS4BMFyVKX9bdMO/82Bx9f4v+luh
	 CKHMkrHt9dqTirB/vzJ/hS3XRXY4AkqV0jYi5MDJ9ap2wlUkVbGQfIrTHx36Ffie4F
	 hH2kvywMyOgxPQBRwWBiNpchG74vxuts4YNgND3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 145/461] batman-adv: mcast: fix use-after-free in orig_node RCU release
Date: Thu, 28 May 2026 21:44:34 +0200
Message-ID: <20260528194651.212445564@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -835,8 +835,6 @@ static void batadv_orig_node_free_rcu(st
 
 	orig_node = container_of(rcu, struct batadv_orig_node, rcu);
 
-	batadv_mcast_purge_orig(orig_node);
-
 	batadv_frag_purge_orig(orig_node, NULL);
 
 	kfree(orig_node->tt_buff);
@@ -887,6 +885,8 @@ void batadv_orig_node_release(struct kre
 	}
 	spin_unlock_bh(&orig_node->vlan_list_lock);
 
+	batadv_mcast_purge_orig(orig_node);
+
 	call_rcu(&orig_node->rcu, batadv_orig_node_free_rcu);
 }
 


