Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6A4F392F;
	Thu, 17 Sep 2026 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668652; cv=none; b=ZV2G7tJCql85BrxnMcIEdzZmmb9pipxetHsdZ+f3yexwtU+QEVQjrqt+XwahJ3eci7tCFxfPZ43OU0sVdWDeV9uqVYi5XDg5hXi1DvLmiXQ7+HHDkjKzazQS0QEzKNfv6BNZCBqw1PiHn7tPG7GhZf0hNEN706zwYm2BIg1AQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668652; c=relaxed/simple;
	bh=I4IS+uVW95EXsOYDJOXRpxOf4AzEJ+rbpyOt/VOcPdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7w45oLinV74jHeG14lsXoAGs+c3rpAMWVXYFrIT+uSHCCKshYWfWm3jPc7QBbyqur+VUVwSzpTQDK2Zpd7ZkdZ1Bu6n2kTX4g6J9UYBdZTWvGhIs6dJYCoRWlhZW5j2rgcw3x5DB+h04m7KRDc7EXg+ra6EMOlChGgFd68Mb88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEhoGMK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEhoGMK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33D31F00893;
	Thu, 17 Sep 2026 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668651;
	bh=p79MlsE3oLoS62G2N90IW9hBfiyNnuuAkBh/6epOtlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEhoGMK83AnEG53pTwqcUigxg1RP+n67A8U+D8h5qGSJIhJtAx7kyC0OgNnYIeBg0
	 xu0f0tKOmbjp0ogdQJgqlBan4ROCvEkajwh9pFs3SYZFPxIwcA0GP+7iDxY5YIevJ/
	 Vji8UgVFInJx9+5vab5mL0OMewJlcqhh3ESq9KnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0495/1102] af_unix: Unlink scc_entry in unix_del_edge().
Date: Thu, 17 Sep 2026 16:07:18 +0100
Message-ID: <20260917151552.148376793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



