Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB83351121D;
	Wed, 30 Sep 2026 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784889; cv=none; b=Zi9FTDPX3BHLg+cTN96uXLwK3mJ4pG5v0y3r9ifE8TbuQPEU3ZVxkhB5q/zspGc5XhCvSrWsTwVlIYXfTOsiZ7c/lkvcZx3OUMDWqakgiGq3i6xgTLkaWK3j5/n7EHuAwg0CL8jQt6d//u1uY8R9kbyb++Btdsbq+l1RBIz+7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784889; c=relaxed/simple;
	bh=ps9DCZ0pJuithiCMC90jXt8J8MAEvOoD7XLhIbz7gO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgdBnYyuaA3i4s2lXkBZUXEQPrztAg+lQ9Q0Wt74lNMX+iNNSmF+jr+//2fOFBDBO9DSpdCNyaPi+DoI/cqumSAZpf6ZCzEya6vJvceCeVUn+1Bk8eDSSbPmUdP0Aj0am+3LXhK1AG4U/oPHxE6mEl/p4nxvHbpdjZmlussx8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdbJm/yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdbJm/yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C411F00893;
	Wed, 30 Sep 2026 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784884;
	bh=aLV8nbfbv9iwQ6nh5GDswtQZnuYLshq05XZZBb+HKEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdbJm/yqn0St1KvnOL9rsmJ7CV5hgHxO1D2ZV6u40KbmGYCmj27wusgx1tw2Wx3av
	 W237FoKwjSnou4cNJfbtQIISCUdKsJUCz+QYq5Oq6HxtMEqUUSQfqeoNHZMljfXpIx
	 InHmZq0xX4MqXy2CYBk/PsG5vGMqBIGPPGv0aAnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/982] af_unix: Unlink scc_entry in unix_del_edge().
Date: Wed, 30 Sep 2026 17:17:30 +0200
Message-ID: <20260930152423.563998369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 594d905195024b228c962627ae5ae7c17bd582a4 ]

Kyle Zeng reported that GC could free a dead SCC partially.

The scenario is as follows:

   1) Create two SCCs:

       X -.   A <-> B
       ^--'

   2) Run the following concurrently:

      2-1) send() sk-B to sk-B from sk-X
      2-2) close() both A and B

At 2-1), there is a small window where unix_add_edges()
publishes a new edge (B <-> B) to GC but its skb is not queued
by skb_queue_tail().

If 2-2) completes before skb_queue_tail() and GC is triggered,
it judges A <-> B as dead, but B is not freed because GC cannot
collect the not-yet-queued skb holding the B <-> B edge.

       X -.   A <-> B -. This edge is visible
       ^--'         ^..'  but skb is not

This itself is not a problem since the next GC run will judge
B as dead as well and free it finally.

       X -.   A <.> B -.
       ^--'         ^--'

However, X's SCC forces the next GC to call unix_walk_scc_fast(),
and it iterates over A through B's scc_entry.

Let's unlink scc_entry before freeing the vertex in unix_del_edge().

Fixes: 4090fa373f0e ("af_unix: Replace garbage collection algorithm.")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Fixes: 4090fa373f0e ("af_unix: Replace garbage collection algorithm.").
Link: https://patch.msgid.link/20260804002155.2233594-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index fa6983dc3181d..338769200065e 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -173,6 +173,7 @@ static void unix_del_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 	if (!vertex->out_degree) {
 		edge->predecessor->vertex = NULL;
 		list_move_tail(&vertex->entry, &fpl->vertices);
+		list_del(&vertex->scc_entry);
 	}
 }
 
-- 
2.53.0



