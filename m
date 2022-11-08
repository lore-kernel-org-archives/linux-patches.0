Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B432D15CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1944AC433C1;
	Tue,  8 Nov 2022 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915609;
	bh=Wxe1ty7/rmOxH7UInaGIGq+r90TSkiWhJRA/U71+A2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVTfzyA2ZNfMagQBH6MOBN1hOp3buaxG7h1LFV6i5xohbMXSH9kIgDP5yDtoap5R9
	 oG47b3PYWJ24fNSoA5WnwzXRYwhss3fDjsAU92CxGVLD/JbriX3gZbWS8Pv72f7hkT
	 QZGC5xRfaEuQbkd6CW/Ibhm21uEf4F+OFdoZ5rtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/118] btrfs: fix inode list leak during backref walking at resolve_indirect_refs()
Date: Tue,  8 Nov 2022 14:38:37 +0100
Message-Id: <20221108133342.364979542@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5614dc3a47e3310fbc77ea3b67eaadd1c6417bf1 ]

During backref walking, at resolve_indirect_refs(), if we get an error
we jump to the 'out' label and call ulist_free() on the 'parents' ulist,
which frees all the elements in the ulist - however that does not free
any inode lists that may be attached to elements, through the 'aux' field
of a ulist node, so we end up leaking lists if we have any attached to
the unodes.

Fix this by calling free_leaf_list() instead of ulist_free() when we exit
from resolve_indirect_refs(). The static function free_leaf_list() is
moved up for this to be possible and it's slightly simplified by removing
unnecessary code.

Fixes: 3301958b7c1d ("Btrfs: add inodes before dropping the extent lock in find_all_leafs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 92cb16c0e5ee..70c1c15266d6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -647,6 +647,18 @@ unode_aux_to_inode_list(struct ulist_node *node)
 	return (struct extent_inode_elem *)(uintptr_t)node->aux;
 }
 
+static void free_leaf_list(struct ulist *ulist)
+{
+	struct ulist_node *node;
+	struct ulist_iterator uiter;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((node = ulist_next(ulist, &uiter)))
+		free_inode_elem_list(unode_aux_to_inode_list(node));
+
+	ulist_free(ulist);
+}
+
 /*
  * We maintain three separate rbtrees: one for direct refs, one for
  * indirect refs which have a key, and one for indirect refs which do not
@@ -761,7 +773,11 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		cond_resched();
 	}
 out:
-	ulist_free(parents);
+	/*
+	 * We may have inode lists attached to refs in the parents ulist, so we
+	 * must free them before freeing the ulist and its refs.
+	 */
+	free_leaf_list(parents);
 	return ret;
 }
 
@@ -1413,24 +1429,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void free_leaf_list(struct ulist *blocks)
-{
-	struct ulist_node *node = NULL;
-	struct extent_inode_elem *eie;
-	struct ulist_iterator uiter;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((node = ulist_next(blocks, &uiter))) {
-		if (!node->aux)
-			continue;
-		eie = unode_aux_to_inode_list(node);
-		free_inode_elem_list(eie);
-		node->aux = 0;
-	}
-
-	ulist_free(blocks);
-}
-
 /*
  * Finds all leafs with a reference to the specified combination of bytenr and
  * offset. key_list_head will point to a list of corresponding keys (caller must
-- 
2.35.1



