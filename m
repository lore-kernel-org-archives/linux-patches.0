Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE47615CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326F7C433D6;
	Tue,  8 Nov 2022 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915304;
	bh=5cRPfngsaSxaGYvwlpHPS5LdaM6D4xSpkXwx185bp3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXh6Uxz5jK3+0XZLSuXAy5MPG1x1U7+ajmdznVkx+x35JPMZsqfhXz37azEqzoAw0
	 5ME6AT6+0ysrHqOb7YEmmQNMnT+Mjm136KxkuOhWN6zz2I1tYBuVAoJgL8sYpAPt2s
	 2cqmYT9+0vMz1VocRyqwe3vSlMLDWYQFJ/U85wTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/74] btrfs: fix inode list leak during backref walking at find_parent_nodes()
Date: Tue,  8 Nov 2022 14:38:51 +0100
Message-Id: <20221108133334.676187298@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

[ Upstream commit 92876eec382a0f19f33d09d2c939e9ca49038ae5 ]

During backref walking, at find_parent_nodes(), if we are dealing with a
data extent and we get an error while resolving the indirect backrefs, at
resolve_indirect_refs(), or in the while loop that iterates over the refs
in the direct refs rbtree, we end up leaking the inode lists attached to
the direct refs we have in the direct refs rbtree that were not yet added
to the refs ulist passed as argument to find_parent_nodes(). Since they
were not yet added to the refs ulist and prelim_release() does not free
the lists, on error the caller can only free the lists attached to the
refs that were added to the refs ulist, all the remaining refs get their
inode lists never freed, therefore leaking their memory.

Fix this by having prelim_release() always free any attached inode list
to each ref found in the rbtree, and have find_parent_nodes() set the
ref's inode list to NULL once it transfers ownership of the inode list
to a ref added to the refs ulist passed to find_parent_nodes().

Fixes: 86d5f9944252 ("btrfs: convert prelimary reference tracking to use rbtrees")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4809cc07a885..3cbca2ebdeb0 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -287,8 +287,10 @@ static void prelim_release(struct preftree *preftree)
 	struct prelim_ref *ref, *next_ref;
 
 	rbtree_postorder_for_each_entry_safe(ref, next_ref,
-					     &preftree->root.rb_root, rbnode)
+					     &preftree->root.rb_root, rbnode) {
+		free_inode_elem_list(ref->inode_list);
 		free_pref(ref);
+	}
 
 	preftree->root = RB_ROOT_CACHED;
 	preftree->count = 0;
@@ -1383,6 +1385,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				if (ret < 0)
 					goto out;
 				ref->inode_list = eie;
+				/*
+				 * We transferred the list ownership to the ref,
+				 * so set to NULL to avoid a double free in case
+				 * an error happens after this.
+				 */
+				eie = NULL;
 			}
 			ret = ulist_add_merge_ptr(refs, ref->parent,
 						  ref->inode_list,
@@ -1408,6 +1416,14 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				eie->next = ref->inode_list;
 			}
 			eie = NULL;
+			/*
+			 * We have transferred the inode list ownership from
+			 * this ref to the ref we added to the 'refs' ulist.
+			 * So set this ref's inode list to NULL to avoid
+			 * use-after-free when our caller uses it or double
+			 * frees in case an error happens before we return.
+			 */
+			ref->inode_list = NULL;
 		}
 		cond_resched();
 	}
-- 
2.35.1



