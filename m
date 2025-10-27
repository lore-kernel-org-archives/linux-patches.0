Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1CA32D440;
	Mon, 27 Oct 2025 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593299; cv=none; b=haS+X0yUIKpt9Yn2Sv/7ql0h3Vc92sMRK7M6qqdqjkHPe1EV45Q5txb/qgRp9o3Q5r9vbAv+DD5WrE8mgg5mjbtFDdOQGdrfNgwUnknwZw6UFBEnBqxjfhVQSp0PYu6RMmOyeLEcNRVnNf+FKl6Os/qEn+XbPzopD5/gkMoV2M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593299; c=relaxed/simple;
	bh=EfbbByxmdnfhrsECSHo36lYmE6aPWNzjPFwItyE6Vtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz2hvLzkkVGaghaXM3jNVE4U/m2ddJKKWxI3EDvxL8g6uZz0uLU+3ZFY1UPM+9oVhtaItoFdiCN2BZAxvQm+1FGLsvj5sQP9hE1i+F8fjqq8YaY5sWiXf8lBC24V7UqixZgvf0GqJfRVPqXBoCYDv7Vy42HcY/JZqJ3Oj36XShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvhExuMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvhExuMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8E2C4CEF1;
	Mon, 27 Oct 2025 19:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593298;
	bh=EfbbByxmdnfhrsECSHo36lYmE6aPWNzjPFwItyE6Vtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvhExuMM6Xp8V4t9u2sVewVL1leZr/B1lEFdC8IYqmfsUQhUr5qPDsw+ytNIZKGh4
	 q7PtSBuHAASlDG4J+u32E3Jb2D9FimOBssX6XoS++52JUNKHBm5yw5+GZy2iP4J4Cu
	 rrKap+JQrJMhoOZ9NR45XQzh3V6tAMhexUBUUp24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Ting-Chang Hou <tchou@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 072/184] btrfs: send: fix duplicated rmdir operations when using extrefs
Date: Mon, 27 Oct 2025 19:35:54 +0100
Message-ID: <20251027183516.833443499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Chang Hou <tchou@synology.com>

commit 1fabe43b4e1a97597ec5d5ffcd2b7cf96e654b8f upstream.

Commit 29d6d30f5c8a ("Btrfs: send, don't send rmdir for same target
multiple times") has fixed an issue that a send stream contained a rmdir
operation for the same directory multiple times. After that fix we keep
track of the last directory for which we sent a rmdir operation and
compare with it before sending a rmdir for the parent inode of a deleted
hardlink we are processing. But there is still a corner case that in
between rmdir dir operations for the same inode we find deleted hardlinks
for other parent inodes, so tracking just the last inode for which we sent
a rmdir operation is not enough.

Hardlinks of a file in the same directory are stored in the same INODE_REF
item, but if the number of hardlinks is too large and can not fit in a
leaf, we use INODE_EXTREF items to store them. The key of an INODE_EXTREF
item is (inode_id, INODE_EXTREF, hash[name, parent ino]), so between two
hardlinks for the same parent directory, we can find others for other
parent directories. For example for the reproducer below we get the
following (from a btrfs inspect-internal dump-tree output):

    item 0 key (259 INODE_EXTREF 2309449) itemoff 16257 itemsize 26
            index 6925 parent 257 namelen 8 name: foo.6923
    item 1 key (259 INODE_EXTREF 2311350) itemoff 16231 itemsize 26
            index 6588 parent 258 namelen 8 name: foo.6587
    item 2 key (259 INODE_EXTREF 2457395) itemoff 16205 itemsize 26
            index 6611 parent 257 namelen 8 name: foo.6609
    (...)

So tracking the last directory's inode number does not work in this case
since we process a link for parent inode 257, then for 258 and then back
again for 257, and that second time we process a deleted link for 257 we
think we have not yet sent a rmdir operation.

Fix this by using a rbtree to keep track of all the directories for which
we have already sent rmdir operations, and add those directories to the
'check_dirs' ref list in process_recorded_refs() only if the directory is
not yet in the rbtree, otherwise skip it since it means we have already
sent a rmdir operation for that directory.

The following test script reproduces the problem:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  mkdir $MNT/a $MNT/b

  echo 123 > $MNT/a/foo
  for ((i = 1; i <= 1000; i++)); do
     ln $MNT/a/foo $MNT/a/foo.$i
     ln $MNT/a/foo $MNT/b/foo.$i
  done

  btrfs subvolume snapshot -r $MNT $MNT/snap1
  btrfs send $MNT/snap1 -f /tmp/base.send

  rm -r $MNT/a $MNT/b

  btrfs subvolume snapshot -r $MNT $MNT/snap2
  btrfs send -p $MNT/snap1 $MNT/snap2 -f /tmp/incremental.send

  umount $MNT
  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  btrfs receive $MNT -f /tmp/base.send
  btrfs receive $MNT -f /tmp/incremental.send

  rm -f /tmp/base.send /tmp/incremental.send

  umount $MNT

When running it, it fails like this:

  $ ./test.sh
  (...)
  At subvol snap1
  At snapshot snap2
  ERROR: rmdir o257-9-0 failed: No such file or directory

CC: <stable@vger.kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Ting-Chang Hou <tchou@synology.com>
[ Updated changelog ]
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 8 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4148,6 +4148,48 @@ out:
 	return ret;
 }
 
+static int rbtree_check_dir_ref_comp(const void *k, const struct rb_node *node)
+{
+	const struct recorded_ref *data = k;
+	const struct recorded_ref *ref = rb_entry(node, struct recorded_ref, node);
+
+	if (data->dir > ref->dir)
+		return 1;
+	if (data->dir < ref->dir)
+		return -1;
+	if (data->dir_gen > ref->dir_gen)
+		return 1;
+	if (data->dir_gen < ref->dir_gen)
+		return -1;
+	return 0;
+}
+
+static bool rbtree_check_dir_ref_less(struct rb_node *node, const struct rb_node *parent)
+{
+	const struct recorded_ref *entry = rb_entry(node, struct recorded_ref, node);
+
+	return rbtree_check_dir_ref_comp(entry, parent) < 0;
+}
+
+static int record_check_dir_ref_in_tree(struct rb_root *root,
+			struct recorded_ref *ref, struct list_head *list)
+{
+	struct recorded_ref *tmp_ref;
+	int ret;
+
+	if (rb_find(ref, root, rbtree_check_dir_ref_comp))
+		return 0;
+
+	ret = dup_ref(ref, list);
+	if (ret < 0)
+		return ret;
+
+	tmp_ref = list_last_entry(list, struct recorded_ref, list);
+	rb_add(&tmp_ref->node, root, rbtree_check_dir_ref_less);
+	tmp_ref->root = root;
+	return 0;
+}
+
 static int rename_current_inode(struct send_ctx *sctx,
 				struct fs_path *current_path,
 				struct fs_path *new_path)
@@ -4175,11 +4217,11 @@ static int process_recorded_refs(struct
 	struct recorded_ref *cur;
 	struct recorded_ref *cur2;
 	LIST_HEAD(check_dirs);
+	struct rb_root rbtree_check_dirs = RB_ROOT;
 	struct fs_path *valid_path = NULL;
 	u64 ow_inode = 0;
 	u64 ow_gen;
 	u64 ow_mode;
-	u64 last_dir_ino_rm = 0;
 	bool did_overwrite = false;
 	bool is_orphan = false;
 	bool can_rename = true;
@@ -4483,7 +4525,7 @@ static int process_recorded_refs(struct
 					goto out;
 			}
 		}
-		ret = dup_ref(cur, &check_dirs);
+		ret = record_check_dir_ref_in_tree(&rbtree_check_dirs, cur, &check_dirs);
 		if (ret < 0)
 			goto out;
 	}
@@ -4511,7 +4553,7 @@ static int process_recorded_refs(struct
 		}
 
 		list_for_each_entry(cur, &sctx->deleted_refs, list) {
-			ret = dup_ref(cur, &check_dirs);
+			ret = record_check_dir_ref_in_tree(&rbtree_check_dirs, cur, &check_dirs);
 			if (ret < 0)
 				goto out;
 		}
@@ -4521,7 +4563,7 @@ static int process_recorded_refs(struct
 		 * We have a moved dir. Add the old parent to check_dirs
 		 */
 		cur = list_first_entry(&sctx->deleted_refs, struct recorded_ref, list);
-		ret = dup_ref(cur, &check_dirs);
+		ret = record_check_dir_ref_in_tree(&rbtree_check_dirs, cur, &check_dirs);
 		if (ret < 0)
 			goto out;
 	} else if (!S_ISDIR(sctx->cur_inode_mode)) {
@@ -4555,7 +4597,7 @@ static int process_recorded_refs(struct
 				if (is_current_inode_path(sctx, cur->full_path))
 					fs_path_reset(&sctx->cur_inode_path);
 			}
-			ret = dup_ref(cur, &check_dirs);
+			ret = record_check_dir_ref_in_tree(&rbtree_check_dirs, cur, &check_dirs);
 			if (ret < 0)
 				goto out;
 		}
@@ -4598,8 +4640,7 @@ static int process_recorded_refs(struct
 			ret = cache_dir_utimes(sctx, cur->dir, cur->dir_gen);
 			if (ret < 0)
 				goto out;
-		} else if (ret == inode_state_did_delete &&
-			   cur->dir != last_dir_ino_rm) {
+		} else if (ret == inode_state_did_delete) {
 			ret = can_rmdir(sctx, cur->dir, cur->dir_gen);
 			if (ret < 0)
 				goto out;
@@ -4611,7 +4652,6 @@ static int process_recorded_refs(struct
 				ret = send_rmdir(sctx, valid_path);
 				if (ret < 0)
 					goto out;
-				last_dir_ino_rm = cur->dir;
 			}
 		}
 	}


