Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7C51D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP4VuQg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38DEC433C7;
	Wed,  4 Oct 2023 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443769;
	bh=pVdeHo4R3Axb0jU7oL94osvs5tDOw9Y9HLuF7SumVOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP4VuQg/MwK0tNB0InFJi1USjA+3H8YZmqtLIxHA7GuMVO72dPkUW3adHLRQM7jlR
	 VboPFyjnHCB7L8NCt5HQEbKoQwPRS5WJI5Wb1+0R7XM9xHEVhOyFqLiiODdApf9Zh7
	 QB9hSo6vcjlpmBRxCW7ZXDPpixrGITrF8G1bYQNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 014/321] btrfs: improve error message after failure to add delayed dir index item
Date: Wed,  4 Oct 2023 19:52:39 +0200
Message-ID: <20231004175229.854367992@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 91bfe3104b8db0310f76f2dcb6aacef24c889366 ]

If we fail to add a delayed dir index item because there's already another
item with the same index number, we print an error message (and then BUG).
However that message isn't very helpful to debug anything because we don't
know what's the index number and what are the values of index counters in
the inode and its delayed inode (index_cnt fields of struct btrfs_inode
and struct btrfs_delayed_node).

So update the error message to include the index number and counters.

We actually had a recent case where this issue was hit by a syzbot report
(see the link below).

Link: https://lore.kernel.org/linux-btrfs/00000000000036e1290603e097e0@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 2c58c3931ede ("btrfs: remove BUG() after failure to insert delayed dir index item")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0f147240ce9b8..1a050e48e0e57 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1511,9 +1511,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
-			  "err add delayed dir index item(name: %.*s) into the insertion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
-			  name_len, name, delayed_node->root->root_key.objectid,
-			  delayed_node->inode_id, ret);
+"error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %d",
+			  name_len, name, index, btrfs_root_id(delayed_node->root),
+			  delayed_node->inode_id, dir->index_cnt,
+			  delayed_node->index_cnt, ret);
 		BUG();
 	}
 	mutex_unlock(&delayed_node->mutex);
-- 
2.40.1



