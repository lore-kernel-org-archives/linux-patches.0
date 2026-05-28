Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E499223328;
	Thu, 28 May 2026 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000657; cv=none; b=smX+RuvkT9jfE+HFvhUvtJ9VULOAWgA/a/s4fy3bwmFsbIHU6s1URYPShwBGeWCSqG+DjjDcbYfUDAuTx4FRQBB6QydlF+2Vm/oVmT3PpnIPiRfrFddVV0jZk0qrw18MGoT2XgyFXP4NUOtrxCuKoVO2CgrhQ1PsBsANETjEZyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000657; c=relaxed/simple;
	bh=SUmVYHpBCPuvmhc5+YSU8kCI8p8r7xdsr5YDk5pDudM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksWZbxeUYG55KV9zbtpgRHsmVlTY50DT493IpvCpetp4cQjMjhLVhzRTZj62pD//avZxwJLmHrQ5ptTBmnsA6GtyMxo6x0f+yflBrupIoY4zbw09cmiEpQqaT+otz1m9ZFQdikkK0du5rLIcU+gcrQm+Iii3p+uEhTphD3wWFT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjMbdZDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjMbdZDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967011F000E9;
	Thu, 28 May 2026 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000656;
	bh=YPo6U5MiiAJCnclikJHL/NTrBowTVVDEHUtBiEVstgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjMbdZDapIgl+7EKs/fSch5kGQvm+DjEjqQQ8WA46TOZBnRcgpcYi+BC/eoyTImpW
	 KvXfr4AKtnnw6zBCn60J9UfiGcAcK9A0ir84EJh0AzxU6Mrn2LBRylUe6DA5yyCCbf
	 2G31/lIIIrCtOhCvFET3pTn+c0i3cqnM6qXbSoeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 121/272] batman-adv: mcast: fix use-after-free in orig_node RCU release
Date: Thu, 28 May 2026 21:48:15 +0200
Message-ID: <20260528194632.767355030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -850,8 +850,6 @@ static void batadv_orig_node_free_rcu(st
 
 	orig_node = container_of(rcu, struct batadv_orig_node, rcu);
 
-	batadv_mcast_purge_orig(orig_node);
-
 	batadv_frag_purge_orig(orig_node, NULL);
 
 	kfree(orig_node->tt_buff);
@@ -905,6 +903,8 @@ void batadv_orig_node_release(struct kre
 	/* Free nc_nodes */
 	batadv_nc_purge_orig(orig_node->bat_priv, orig_node, NULL);
 
+	batadv_mcast_purge_orig(orig_node);
+
 	call_rcu(&orig_node->rcu, batadv_orig_node_free_rcu);
 }
 


