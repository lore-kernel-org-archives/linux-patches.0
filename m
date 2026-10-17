Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2473148B4;
	Sat, 17 Oct 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253995; cv=none; b=MswIJSsxP1WzBbNPVvmoUlEhjkmhdlFTYpKfqaRXyMiYDSi7/AlC9nYBUhGkl50wyiHYmvsp5TaAuhvdmo8HOaKF+kiwxzisSKErYXNNQ4LyfDtNddMP6TAFO2Jxv07+X1rW6eGRGVls4QZvGFnKp2U2tUDmtf3O6s1trJBRbX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253995; c=relaxed/simple;
	bh=7vXpwwmynf22oOvIuQLDUjXzMiUfJTEHl3obW5w9Jw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ95zkb8dOjrO+I3IroTe2NU2v1yHtQrLOGTdVtge+STavs4XqHCbgjE/mVm9htncBLcYQGUG7vhO0Zc6kbtds4oko3f/tBW6cPQx2cuMXu9cQy/CLch+u02sWEKHHUiVbkMANhy7dt3gcx4aqo4NpRYFRMbxPIEtB+ovBncQK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFbVrM8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFbVrM8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6481C1F000C4;
	Sat, 17 Oct 2026 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253993;
	bh=3nc6jqOTgHLZrKHJEXmTMYMluX7A56pcLADRA9qY9S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFbVrM8Qwqx31kiqEoBgTZElSndN2mKGOKe6nFqTIpbaryjOEa4skmikd1cPjnNzf
	 kyyZeRANAe/g2NESWx4ZvmwjyrWq96Kp/EPtPm0DY2zIneHH+FRp1inxuJzUw92l/N
	 YsdctpjsdpuPOpCX1AJNZbERgpmISVBStF4i39O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/869] netfilter: nf_tables: use list_del_rcu for netlink hooks
Date: Sat, 17 Oct 2026 17:52:23 +0200
Message-ID: <20261017160044.817456549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f30c4d8029e0c..d6745e9b63370 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -350,7 +350,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
-			list_del(&hook->list);
+			list_del_rcu(&hook->list);
 			kfree_rcu(hook, rcu);
 		}
 	}
@@ -8498,7 +8498,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
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



