Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A19460;
	Sat, 17 Oct 2026 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258843; cv=none; b=P+dNJQp2t1HfJmP42LmGV6TCxEvp5lvo2tlrw/R3PZzbsQpGxWMGSs9RoFhcttpsqb4olSqmAsXsP8JQuybEYv+SKjR2AtVP4EqmzeUBC0S95pPXZc/JsQyHqnaDNOIxnc9yHqxPs2oHq7NQXvDf3N7QrTefcqwH183uNZE8rcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258843; c=relaxed/simple;
	bh=pl+X3hEPeAlHP6iZY4N+HfbD8XIv4DMjdt8zaNzsVJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwBsuFuud0WypoKl6ATdZ5Yllbe1rB8DAxAcD6M6IOyZ2o9bX5gfAf9Hn+tIapOeD+Tcv02JcR1D/T7FNEJT+O0GL0CTXiCbBtc9MuWZKdZFFrY7vRN+rK9PSsNLm+dVoVnDuqpveCIVpBqfC6PcNxwy5O3OYfbVZk/uuUODIMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsyAEOKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsyAEOKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A285F1F000C4;
	Sat, 17 Oct 2026 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258842;
	bh=8YiPSzfZ0YPxKJU5dhz69MCCLsRJ+uGk47w5Hfii+Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsyAEOKqOJstR4g9D0O+pcd4fqajcP3GLSJ/5dPJwBw+sa0YIIkgxOcN1r0K3Tuol
	 gimyx/opNsQIoGIKbHX/ZHcIcBQKhss9R+COrls/bKmXsG/fh0N+bi9UJNzQ4GKYL6
	 Jxwb3yUOhCXVNB7TfhlYLIO8J1tE5NDOIG0VhW2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0977/1674] netfilter: nf_tables: use list_del_rcu for netlink hooks
Date: Sat, 17 Oct 2026 17:54:09 +0200
Message-ID: <20261017160456.202094848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f3224ee463f8f6f6ced7dcdf6081add4f8128527 ]

nft_netdev_unregister_hooks and __nft_unregister_flowtable_net_hooks need
to use list_del_rcu(), this list can be walked by concurrent dumpers.

Add a new helper and use it consistently.

Fixes: f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ecdbb0d7a6c4c..8ebef1cff1d79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -334,7 +334,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
-			list_del(&hook->list);
+			list_del_rcu(&hook->list);
 			kfree_rcu(hook, rcu);
 		}
 	}
@@ -8416,7 +8416,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		if (release_netdev) {
-			list_del(&hook->list);
+			list_del_rcu(&hook->list);
 			kfree_rcu(hook, rcu);
 		}
 	}
-- 
2.53.0



