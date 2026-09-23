Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ACD470121;
	Wed, 23 Sep 2026 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173565; cv=none; b=rc4qor7rEqQ0xUpZj/Xcm8/7eWVp5sRb7QOa1gG8bvG90ZNJQ70FCvvGH3C46mqyqKeRZCq3wwXXOKJjIc/KRbz4RChRJS5Uc9u/frCAM5ByNpfY0C7TSsToPHwE9ipoPUtpNcO29MwbY6W/69ehgYrSu2UwCcLiSP75/qIorc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173565; c=relaxed/simple;
	bh=kJEsir04UzekK72Tit4okIj4hR7h4HfVH+d03207+8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glX7LSF9HWWwVLzVwp3y5j/BVNgs2jKAVZ66QTFsGwzszJklusPnQa62wdnLArnqAT0sOw/0kNwcW8QZyIwVhwg4qreQeRzysq0RNoNOUzZ1vFoWNOmrXqjIFTgY0M54LDnLUbn7q4esPXVvZIDO884VdEWaeEuJA7eqPRTCj/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfGtOx2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfGtOx2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A551F000FF;
	Wed, 23 Sep 2026 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173563;
	bh=PZk5wf46M5juLc6Slw+yiRmyXyNa6APopmXl5nyrfbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfGtOx2iuY/eZOs4MaKij4Xl52c+LjZt2Y+BAieV/Szmj8uwDdlZIYYxuJKBQVQZe
	 2vRUuEE5/+XT10ZpjwS7XAStLLA3IJLB+gqTEjljKw6f/HGqXw2skmHYjat93AIgOI
	 0dULzxgPTibvh8t3C6++HN8GZUc3ntG35zk6x4c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 285/438] btrfs: clear free space tree creation state on rebuild failure
Date: Wed, 23 Sep 2026 16:05:06 +0200
Message-ID: <20260923140652.161125571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

commit 3565893cc72cdf6b795cf6a33e7ff9605322334d upstream.

btrfs_rebuild_free_space_tree() sets BTRFS_FS_CREATING_FREE_SPACE_TREE
before rebuilding the free space tree.  Several error paths return
without clearing this flag.

The transaction restart failure path can leave the flag set on a live
filesystem, causing delayed reference processing to be skipped. Clear it
on all free space tree rebuild failure paths. Keep
BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED set, since a failed rebuild leaves
the free space tree untrusted. Callers must fall back to extent-tree
caching.

Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")
CC: stable@vger.kernel.org # 6.14+
Assisted-by: LLM
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1353,7 +1353,7 @@ int btrfs_rebuild_free_space_tree(struct
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
-		return ret;
+		goto out_clear;
 	}
 
 	node = rb_first_cached(&fs_info->block_group_cache_tree);
@@ -1371,14 +1371,16 @@ int btrfs_rebuild_free_space_tree(struct
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
-			return ret;
+			goto out_clear;
 		}
 next:
 		if (btrfs_should_end_transaction(trans)) {
 			btrfs_end_transaction(trans);
 			trans = btrfs_start_transaction(free_space_root, 1);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto out_clear;
+			}
 		}
 		node = rb_next(node);
 	}
@@ -1390,6 +1392,10 @@ next:
 	ret = btrfs_commit_transaction(trans);
 	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	return ret;
+
+out_clear:
+	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	return ret;
 }
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,


