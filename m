Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D299446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7613C433C8;
	Sun, 13 Aug 2023 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963154;
	bh=L3IiUJk596A6kxY65cnUz2UMDCa4rpuQz3JcimFiwcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVPlzc/RvQS0eFqGQtUh3o42V6F4BIu6Q5wfLfAtB3wBl/YqSWMLouP/QFMGuAfje
	 KRjiW/p1w8WVoafpOINvm5hPF06jeGzzlc+el6FNLI6PQt+C7L91mJAojxDaRLgMwZ
	 j/qGlT+0dv8TLeAaf75AMw17PsVOGgGLo2QvXaTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae97a827ae1c3336bbb4@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 72/89] btrfs: reject invalid reloc tree root keys with stack dump
Date: Sun, 13 Aug 2023 23:20:03 +0200
Message-ID: <20230813211712.933704756@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit 6ebcd021c92b8e4b904552e4d87283032100796d upstream.

[BUG]
Syzbot reported a crash that an ASSERT() got triggered inside
prepare_to_merge().

That ASSERT() makes sure the reloc tree is properly pointed back by its
subvolume tree.

[CAUSE]
After more debugging output, it turns out we had an invalid reloc tree:

  BTRFS error (device loop1): reloc tree mismatch, root 8 has no reloc root, expect reloc root key (-8, 132, 8) gen 17

Note the above root key is (TREE_RELOC_OBJECTID, ROOT_ITEM,
QUOTA_TREE_OBJECTID), meaning it's a reloc tree for quota tree.

But reloc trees can only exist for subvolumes, as for non-subvolume
trees, we just COW the involved tree block, no need to create a reloc
tree since those tree blocks won't be shared with other trees.

Only subvolumes tree can share tree blocks with other trees (thus they
have BTRFS_ROOT_SHAREABLE flag).

Thus this new debug output proves my previous assumption that corrupted
on-disk data can trigger that ASSERT().

[FIX]
Besides the dedicated fix and the graceful exit, also let tree-checker to
check such root keys, to make sure reloc trees can only exist for subvolumes.

CC: stable@vger.kernel.org # 5.15+
Reported-by: syzbot+ae97a827ae1c3336bbb4@syzkaller.appspotmail.com
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c      |    3 ++-
 fs/btrfs/tree-checker.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1437,7 +1437,8 @@ static int btrfs_init_fs_root(struct btr
 		goto fail;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID &&
-	    !btrfs_is_data_reloc_root(root)) {
+	    !btrfs_is_data_reloc_root(root) &&
+	    is_fstree(root->root_key.objectid)) {
 		set_bit(BTRFS_ROOT_SHAREABLE, &root->state);
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -442,6 +442,20 @@ static int check_root_key(struct extent_
 	btrfs_item_key_to_cpu(leaf, &item_key, slot);
 	is_root_item = (item_key.type == BTRFS_ROOT_ITEM_KEY);
 
+	/*
+	 * Bad rootid for reloc trees.
+	 *
+	 * Reloc trees are only for subvolume trees, other trees only need
+	 * to be COWed to be relocated.
+	 */
+	if (unlikely(is_root_item && key->objectid == BTRFS_TREE_RELOC_OBJECTID &&
+		     !is_fstree(key->offset))) {
+		generic_err(leaf, slot,
+		"invalid reloc tree for root %lld, root id is not a subvolume tree",
+			    key->offset);
+		return -EUCLEAN;
+	}
+
 	/* No such tree id */
 	if (unlikely(key->objectid == 0)) {
 		if (is_root_item)


