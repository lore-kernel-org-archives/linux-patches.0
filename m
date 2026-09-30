Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251683D4135;
	Wed, 30 Sep 2026 19:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794888; cv=none; b=ZYY9Z4/+QHamQH1WRMx9u8px/2sPPX66kZFw/oBPqo0q+AWN0H5n725319hnoZjFgsVqZhKfrriuh7Xbp7CVGFVoPZlQ/+xjukssONDBvSUJoGD4idmV95KJP6z3OpnPCSBp19W6HyeVqkC7IklRRWyGJfA+v57BeJEIJkNKhKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794888; c=relaxed/simple;
	bh=ZZfir6xHVnglDBffgMQ0oqxaite5+TQQm+LNmhkW2iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG/QPCkuNm5wqcpoIHe2usaSPBxeiBE1+9BaNPaCp9S7IFdZUWTsbUcdwV2uOmmMrjBbKMcC6RW9NdX6AZ4MEd0nOZHO90ZxHe0GNryCLZuC8hu+r9+TVAoJ548YMn4qeP4qxyX5EytPhZgOH0rF0BlXxw4q0VVqI0ih3sfPFuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkqKkVbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkqKkVbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F60C1F000FF;
	Wed, 30 Sep 2026 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794887;
	bh=86CoXW/Uu9A19ub8uMctTSDvr+gsiCoE8mu7pxQYE0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkqKkVbB0fqfnRggRkVoajka7iagr5UbUgp02Bxe9K+HouEorkY7jhLqdDe21OPF4
	 YHmLCzAPaSxRuNMXfon1VE4aJIrQ9rwF6dN2+k32ZqYgIvxVylYnogPJcrfOtumCGL
	 DCtNFxR7aI8hkis4HxOzxOYtco4rGI+rzdXNdgm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0366/1193] af_unix: Unlink scc_entry in unix_del_edge().
Date: Wed, 30 Sep 2026 17:17:30 +0200
Message-ID: <20260930152442.308801609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



