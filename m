Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84881C294;
	Wed,  3 Jan 2024 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNcPVwjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECBDC433C7;
	Wed,  3 Jan 2024 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302071;
	bh=E4fQMDUf5orl6WL+46VduCunoxX5GyOCo3YCG6uEpAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNcPVwjh0KrHs1ND+721trxN7zJvB02JwJRddYbtOpthec0DZhF+Efja9hZxuPYLs
	 ivo8B8lBdD2J4ymsj5iWlzqyQwbwSjJDyVeHe3CBLdGISB0KCmbiPWHaJ7b0dq+L1y
	 LlQhxqTrzf5TBmg/7JSMf91Lj8Nc8MWNdYoIG5+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 37/49] maple_tree: do not preallocate nodes for slot stores
Date: Wed,  3 Jan 2024 17:55:57 +0100
Message-ID: <20240103164840.753225160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

commit 4249f13c11be8b8b7bf93204185e150c3bdc968d upstream.

mas_preallocate() defaults to requesting 1 node for preallocation and then
,depending on the type of store, will update the request variable.  There
isn't a check for a slot store type, so slot stores are preallocating the
default 1 node.  Slot stores do not require any additional nodes, so add a
check for the slot store case that will bypass node_count_gfp().  Update
the tests to reflect that slot stores do not require allocations.

User visible effects of this bug include increased memory usage from the
unneeded node that was allocated.

Link: https://lkml.kernel.org/r/20231213205058.386589-1-sidhartha.kumar@oracle.com
Fixes: 0b8bb544b1a7 ("maple_tree: update mas_preallocate() testing")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c                 | 11 +++++++++++
 tools/testing/radix-tree/maple.c |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index bb24d84a4922..684689457d77 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5501,6 +5501,17 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 
 	mas_wr_end_piv(&wr_mas);
 	node_size = mas_wr_new_end(&wr_mas);
+
+	/* Slot store, does not require additional nodes */
+	if (node_size == wr_mas.node_end) {
+		/* reuse node */
+		if (!mt_in_rcu(mas->tree))
+			return 0;
+		/* shifting boundary */
+		if (wr_mas.offset_end - mas->offset == 1)
+			return 0;
+	}
+
 	if (node_size >= mt_slots[wr_mas.type]) {
 		/* Split, worst case for now. */
 		request = 1 + mas_mt_height(mas) * 2;
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index e5da1cad70ba..76a8990bb14e 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35538,7 +35538,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1);
+	MT_BUG_ON(mt, allocated != 0);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
-- 
2.43.0



