Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B75E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E378C433C8;
	Sun, 16 Jul 2023 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540963;
	bh=BbYdFmwxY7ChwXdDo8bXaKEVVf6wif1dYqUDdQpa79s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIlHyKme217pcbp5u07vR3eLwng0ygMyj8POaJ1Jns0kRgsj3u/6tpH06MoY0iOsj
	 9FbSxz7IzHG1pG/Z93ICkYS0yJ4JKGyoetFcQCVl+5k2JUM9mmYTuQSWQTIjwlNkRv
	 EF+VFR+85SxyXQjiKNCoGR10KBv3XiROCAmiV+2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 523/591] btrfs: do not BUG_ON() on tree mod log failure at balance_level()
Date: Sun, 16 Jul 2023 21:51:02 +0200
Message-ID: <20230716194937.403670948@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 39020d8abc7ec62c4de9b260e3d10d4a1c2478ce ]

At balance_level(), instead of doing a BUG_ON() in case we fail to record
tree mod log operations, do a transaction abort and return the error to
the callers. There's really no need for the BUG_ON() as we can release
all resources in this context, and we have to abort because other future
tree searches that use the tree mod log (btrfs_search_old_slot()) may get
inconsistent results if other operations modify the tree after that
failure and before the tree mod log based search.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -935,7 +935,12 @@ static noinline int balance_level(struct
 		}
 
 		ret = btrfs_tree_mod_log_insert_root(root->node, child, true);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_tree_unlock(child);
+			free_extent_buffer(child);
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 		rcu_assign_pointer(root->node, child);
 
 		add_root_to_dirty_list(root);
@@ -1017,7 +1022,10 @@ static noinline int balance_level(struct
 			btrfs_node_key(right, &right_key, 0);
 			ret = btrfs_tree_mod_log_insert_key(parent, pslot + 1,
 					BTRFS_MOD_LOG_KEY_REPLACE, GFP_NOFS);
-			BUG_ON(ret < 0);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto enospc;
+			}
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -1063,7 +1071,10 @@ static noinline int balance_level(struct
 		btrfs_node_key(mid, &mid_key, 0);
 		ret = btrfs_tree_mod_log_insert_key(parent, pslot,
 				BTRFS_MOD_LOG_KEY_REPLACE, GFP_NOFS);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
 	}


