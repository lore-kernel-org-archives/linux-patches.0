Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215029;
	b=L+1Mn9quFZa7tZBJq7dPHuEUyJWmrLQgLx2I2H0jdmkfsffzpGwoborSKO1pdtGBtsgr
	 WU+7GI6JRnJz8rLa/AMUglw2VN6Ry73EM7hLavK9c9NL4T7A7haQL+Qr4vY9jdDdGXcEG
	 sR8V95RucI763y/o9XXBJIMp91rFjL4lUNv2gIcuBJarszu7Rx+Ue0kL1/5lpu29gBLj0
	 m8tEZFDk4EvA6xsdDT95t7LRRmd3rlqlvVinJym9ImKd8iJSF8H+Oj0NWEuWRwpzu14eo
	 xYQn5GRjlFSIdqsKCD/7Z0C910DwFpLJb7jB9VZTA6UZmy85kNYTaWB/0dRDAxDANCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UddEvTeuh+V1jhUHZW2MUSAA2bXGJv/LRCfaZzj5Mls=;
	b=arbrahEgqpiVQCZ8lKL6VnpTbubimCITuLcwN6Gc4ANfU4WvNDQLDIkBDXYfopKp66Eh
	 SzYjOfKPBZ0ZJgdI0WKOF+EzPP2IB5Ca/Y9m8zCXV+aYYeFEH6EWI/GQ9KUihuPayML5W
	 wDqZ4tnfOYouvRS35NHCFBYW/4ADUhcaabFlGdfgpQJmCPUpbfCPGcq9xyLuoVkugzSjD
	 zi0UNCvoByjxnmdP9QEwEebqtJ2cndHiYnwmV/JIWICpguunFY5CL3OgfolyPVuOooSXD
	 FfYwEap4Etk7FjQUq7CUx2yJGdfNriuuJBuxBZaAZDBiDZ8rVEWCdE4EVex6/o4oC8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dG5EPX4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1703860A2602;
	Wed, 28 Oct 2026 19:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dG5EPX4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696521F01825;
	Wed, 28 Oct 2026 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215028;
	bh=UddEvTeuh+V1jhUHZW2MUSAA2bXGJv/LRCfaZzj5Mls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dG5EPX4lHEFpq4mv7aerKUEu1vpbJEhas727A+EU2Q2u/hWAfZEaVvYPsecU+Ay8m
	 pU2r5D6cJFKqyeyoTa91paWR1dMkozYWtOpBQ8Qf+0LlBBve2ga7ZTdssNqNK20DA2
	 wW1DQ7iGzBF2lhjtuzGxxH+HkEpVHaBEa7iQC5jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1067/1887] netfilter: nf_tables: use list_del_rcu for netlink hooks
Date: Wed, 28 Oct 2026 17:52:43 +0100
Message-ID: <20261028170523.689961261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 226fedc7477b1..df5573b2babd5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -308,7 +308,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
-			list_del(&hook->list);
+			list_del_rcu(&hook->list);
 			kfree_rcu(hook, rcu);
 		}
 	}
@@ -8101,7 +8101,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
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



