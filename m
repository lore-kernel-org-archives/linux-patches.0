Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42822874E6;
	Thu, 20 Aug 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238512; cv=none; b=L9Q9tXwGEXxidH0q4WlMGQXvZmulsx5ngF+VJEBAvvfZKEylOOzFSjSEYernX84oTqU02tScRQ/YFCypf35/YxPJ3xOl67cHNQ7/Ahft9oqa6URxHL01Kd0LHORHheBuPj8uuXoq6xHmM/d9q+V0oaZ9MLRnweXQmBc2mcHdzpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238512; c=relaxed/simple;
	bh=oyIt0cFEmTP2S3JP+atXzgszRa/PD3Lfi/zaNrjOF+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzmS4Z47I5NL0uu0X70hpY+XFXTO//6KCA3fFgfqkM135yQiLHRgV2CVMZeW63SbEXwjUsk/mOMgYgJmSV+it6S+ZZKDs6JrOno+h9gucdroHf7pSMvPS5f5DsDWYD3dqHrO7kXGzqX6zObMK4WIJbSgNR9sb2l4dOj3JoNtzxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp/1H+6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp/1H+6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2891F000E9;
	Thu, 20 Aug 2026 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238510;
	bh=DrrlJ4+RmRzUKWI2dDfE8ILUJN1sUZBDA1ohOtzulG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qp/1H+6yfbpEEz9oaNKIHKu4zFUCjBUyvrV5cct6OyoeqsAYnCgv2wb+TA/Ww/10T
	 MWwk6IcLW5GHdLxuM2sCebBs1nLHTtBfA/R80lUi90OfqpBuR39UMZvS1ic2Y8URnt
	 43Qk513qp2UInJgtAB9/ozVyHKKkMJB8m3G+KaoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 172/228] af_unix: Unlink scc_entry in unix_del_edge().
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145249.920685524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0783555e25266..9fcaaf55cba5d 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -186,6 +186,7 @@ static void unix_del_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 	if (!vertex->out_degree) {
 		edge->predecessor->vertex = NULL;
 		list_move_tail(&vertex->entry, &fpl->vertices);
+		list_del(&vertex->scc_entry);
 	}
 }
 
-- 
2.53.0



