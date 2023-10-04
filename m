Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC601D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDrq7AK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF4FC433C7;
	Wed,  4 Oct 2023 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443517;
	bh=0c8UtNBP5Pw0khjtvPFODBUTIaVprmyjVjV1rLGVmho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDrq7AK/sMVXryg/oFCQ3MhNqkeazUg2ZrA9guTqyWxEU6ztdH9nPqVhfIqfmaHY2
	 QgflrPxtTQr//TnUCQ1YpWNqn7racaRWWwgzbPb3Hhlb4SAsAZPkJzI6+n/gaUzzlm
	 7GSUYs5J/OPU6I/kyNRdGU7L5R70hWiJ9034b8lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/259] btrfs: assert delayed node locked when removing delayed item
Date: Wed,  4 Oct 2023 19:55:30 +0200
Message-ID: <20231004175224.501970475@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a57c2d4e46f519b24558ae0752c17eec416ac72a ]

When removing a delayed item, or releasing which will remove it as well,
we will modify one of the delayed node's rbtrees and item counter if the
delayed item is in one of the rbtrees. This require having the delayed
node's mutex locked, otherwise we will race with other tasks modifying
the rbtrees and the counter.

This is motivated by a previous version of another patch actually calling
btrfs_release_delayed_item() after unlocking the delayed node's mutex and
against a delayed item that is in a rbtree.

So assert at __btrfs_remove_delayed_item() that the delayed node's mutex
is locked.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 9dacf72a75d0e..1331e56e8e84f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -407,6 +407,7 @@ static void finish_one_item(struct btrfs_delayed_root *delayed_root)
 
 static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 {
+	struct btrfs_delayed_node *delayed_node = delayed_item->delayed_node;
 	struct rb_root_cached *root;
 	struct btrfs_delayed_root *delayed_root;
 
@@ -414,18 +415,21 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 	if (RB_EMPTY_NODE(&delayed_item->rb_node))
 		return;
 
-	delayed_root = delayed_item->delayed_node->root->fs_info->delayed_root;
+	/* If it's in a rbtree, then we need to have delayed node locked. */
+	lockdep_assert_held(&delayed_node->mutex);
+
+	delayed_root = delayed_node->root->fs_info->delayed_root;
 
 	BUG_ON(!delayed_root);
 
 	if (delayed_item->type == BTRFS_DELAYED_INSERTION_ITEM)
-		root = &delayed_item->delayed_node->ins_root;
+		root = &delayed_node->ins_root;
 	else
-		root = &delayed_item->delayed_node->del_root;
+		root = &delayed_node->del_root;
 
 	rb_erase_cached(&delayed_item->rb_node, root);
 	RB_CLEAR_NODE(&delayed_item->rb_node);
-	delayed_item->delayed_node->count--;
+	delayed_node->count--;
 
 	finish_one_item(delayed_root);
 }
-- 
2.40.1



