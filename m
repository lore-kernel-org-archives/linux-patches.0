Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050116;
	b=RCG0Aw41zI8OpX9TFk1naqsAvDNxfx9fWTtoObvrlCuUxuTJrucK1vUB8wezvp6CoRSm
	 f+5n3aJxPLuJSN+CZ8aTBRibYx6ZhkG+Azem0IdcRWasUzrdIJPPx7NKzLegB38o7tJsQ
	 8+xju4j+swV2fWsmt/nGqD6FUyqnNJF9XaqpQVZkmpRI32JQHGMzeUPQsbneJV1JRNkNB
	 aZVfoArIuHPpKCNpIKDGpnMNdjY6PlZMun71b/6zjjNIh2XIeM86Tv9THUDpWc58cOI/r
	 ZapLX86B9ivJJFnO+Tirdx0VGw8Hd13+CdGUL9DOvBWpsQkyFQiA886Nwi1gyikt2tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhVj0hvwWdxrfo/6opTI6JjEM5KOSQS27jISGIgg3TM=;
	b=ui86GXIkMPuMFCm2j+XuSDJDrYf3pcTOo/QCZddcjNTmhWawWtAme2zU8U4Fl2wsDq5w
	 zrGroLBWNNOVwqugzQLkiOXyyNUWn/+sCd4cprTgyz5oTaEiyKDh7MmNlumzAmP3WcDwp
	 VX91USDRfienzlILQgtV+mEayCtd8K07aWZ3eiUCCV/7MjCToZrJ0Lcz13Hz6iFM4TEy1
	 i6LJQlyp8oYvrA1EGHsHBM/dAfg1U9bPqYVgOXjG4YYa4D6MewLmaPnZpigIabblMd9gi
	 kvydvKy4auP1JAf/Efd68lOiqj4yAYQyzls+Y7yMIo55m+icoPr6EkF/9/jdrivntNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JC73APHG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB763606A33E;
	Thu, 19 Nov 2026 01:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JC73APHG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F42B1F000C4;
	Thu, 19 Nov 2026 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050116;
	bh=PhVj0hvwWdxrfo/6opTI6JjEM5KOSQS27jISGIgg3TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JC73APHG/wcEBicuY8AvLWUmrKHHi+6/FDY73AUDClM0ToB6c1giHlfunsTkbQJbj
	 De+a3sZZy9NkANzKthNBC5sfb6Ymr6oTgBGcE4KL0ylnjFzhyoh2A7qBn8HlMkaELF
	 o3dkcIDuqtBvAuw/9FTF/dV0kEcFKjNvSV8B6ZUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2594/2857] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150334.935259401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

[ Upstream commit 9836164821a46af07428bb2a5e14137bf0c7bd6e ]

When early-drop scan is enabled, gc_worker() reads tmp->ct_net, resolves
cnet with nf_ct_pernet(), and reads cnet->count with RCU read lock held but
before acquiring a reference to tmp.

Its unlikely but possible that the worker gets preempted before reading
cnet->count while nf_conntrack_cleanup_net_list manages to unlink all
conntracks and returns in the mean time.
This allows for the pernet memory to get free'd.

On resume, use after free would occur when the worker reads cnet->count.

This can be solved either via another synchronize_rcu() in
nf_conntrack_cleanup_net_list or via cheaper flush_work().  If work
wasn't running no race can happen as next call cannot observe
already-unlinked conntrack objects.

This is an LLM finding with no reproducer, but it appears to be correct.

Fixes: c6dd940b1f74 ("netfilter: allow early drop of assured conntracks")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2b9943f4d88cc..0f6d82a1fa72e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2643,6 +2643,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
+	/* must wait for current scan loop, worker also looks at
+	 * struct nf_conntrack_net, which is about to be free'd.
+	 */
+	flush_work(&conntrack_gc_work.dwork.work);
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
-- 
2.53.0



