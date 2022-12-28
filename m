Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E5F23AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C01C433D2;
	Wed, 28 Dec 2022 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246758;
	bh=5oPTivXNEIef2elxsMKezyAj3RzRWXnOAyExgScXi6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp93rSp71UG+BJpjfJ1O3cMN7CSN2ufgG9N/dNAd33ipFa98fNAuO8VblXqgn/yzb
	 Qgh6PBMa9CmWjjrPboBI+/a2UmbnpcBGIjojZlU1EDcoLZdsMQnVZHpJKS/gvoii4t
	 fru+xuFyYzhxA4iOYvgThQdZUteU22vwTeSa6pXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 1128/1146] maple_tree: fix mas_spanning_rebalance() on insufficient data
Date: Wed, 28 Dec 2022 15:44:27 +0100
Message-Id: <20221228144400.782418391@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam Howlett <liam.howlett@oracle.com>

commit 0abb964aae3da746ea2fd4301599a6fa26da58db upstream.

Mike Rapoport contacted me off-list with a regression in running criu.
Periodic tests fail with an RCU stall during execution.  Although rare, it
is possible to hit this with other uses so this patch should be backported
to fix the regression.

This patchset adds the fix and a test case to the maple tree test
suite.


This patch (of 2):

An insufficient node was causing an out-of-bounds access on the node in
mas_leaf_max_gap().  The cause was the faulty detection of the new node
being a root node when overwriting many entries at the end of the tree.

Fix the detection of a new root and ensure there is sufficient data prior
to entering the spanning rebalance loop.

Link: https://lkml.kernel.org/r/20221219161922.2708732-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20221219161922.2708732-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Mike Rapoport <rppt@kernel.org>
Tested-by: Mike Rapoport <rppt@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2989,7 +2989,9 @@ static int mas_spanning_rebalance(struct
 	mast->free = &free;
 	mast->destroy = &destroy;
 	l_mas.node = r_mas.node = m_mas.node = MAS_NONE;
-	if (!(mast->orig_l->min && mast->orig_r->max == ULONG_MAX) &&
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 


