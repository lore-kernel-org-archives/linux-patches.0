Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4779CD;
	Sat, 30 Dec 2023 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RrByXde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F27C433C7;
	Sat, 30 Dec 2023 12:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937699;
	bh=yPD/RtU46Y7xernfCfWHg671bNCnJnxbjZfSxte1Gzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RrByXde9PPrMWoWoqposVIGGPuJEBfjs/hda/V6/xvBVEgjF7vdxaPU3TQdzcsui
	 WsKVYPWo8iRXX5AaNl54DvM5V/4rnnIKpQqtQ7jHlL8Ej+OwBuQ1HWIYjFcjT7LilU
	 A/S4CTH0b8ew0o0+AtZEFAzQdKPR2r3Psi8qO1Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/156] btrfs: free qgroup pertrans reserve on transaction abort
Date: Sat, 30 Dec 2023 11:57:40 +0000
Message-ID: <20231230115812.552644190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit b321a52cce062ec7ed385333a33905d22159ce36 ]

If we abort a transaction, we never run the code that frees the pertrans
qgroup reservation. This results in warnings on unmount as that
reservation has been leaked. The leak isn't a huge issue since the fs is
read-only, but it's better to clean it up when we know we can/should. Do
it during the cleanup_transaction step of aborting.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c     | 28 ++++++++++++++++++++++++++++
 fs/btrfs/qgroup.c      |  5 +++--
 fs/btrfs/transaction.c |  2 --
 fs/btrfs/transaction.h |  3 +++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 71efb6883f307..b79781df70714 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4836,6 +4836,32 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 	}
 }
 
+static void btrfs_free_all_qgroup_pertrans(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *gang[8];
+	int i;
+	int ret;
+
+	spin_lock(&fs_info->fs_roots_radix_lock);
+	while (1) {
+		ret = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
+						 (void **)gang, 0,
+						 ARRAY_SIZE(gang),
+						 BTRFS_ROOT_TRANS_TAG);
+		if (ret == 0)
+			break;
+		for (i = 0; i < ret; i++) {
+			struct btrfs_root *root = gang[i];
+
+			btrfs_qgroup_free_meta_all_pertrans(root);
+			radix_tree_tag_clear(&fs_info->fs_roots_radix,
+					(unsigned long)root->root_key.objectid,
+					BTRFS_ROOT_TRANS_TAG);
+		}
+	}
+	spin_unlock(&fs_info->fs_roots_radix_lock);
+}
+
 void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 				   struct btrfs_fs_info *fs_info)
 {
@@ -4864,6 +4890,8 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 				     EXTENT_DIRTY);
 	btrfs_destroy_pinned_extent(fs_info, &cur_trans->pinned_extents);
 
+	btrfs_free_all_qgroup_pertrans(fs_info);
+
 	cur_trans->state =TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0d2212fa0ce85..a006f5160e6b4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4124,8 +4124,9 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 
 		qgroup_rsv_release(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PREALLOC);
-		qgroup_rsv_add(fs_info, qgroup, num_bytes,
-				BTRFS_QGROUP_RSV_META_PERTRANS);
+		if (!sb_rdonly(fs_info->sb))
+			qgroup_rsv_add(fs_info, qgroup, num_bytes,
+				       BTRFS_QGROUP_RSV_META_PERTRANS);
 
 		list_for_each_entry(glist, &qgroup->groups, next_group)
 			qgroup_iterator_add(&qgroup_list, glist->group);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c780d37294636..0ac2d191cd34f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -37,8 +37,6 @@
 
 static struct kmem_cache *btrfs_trans_handle_cachep;
 
-#define BTRFS_ROOT_TRANS_TAG 0
-
 /*
  * Transaction states and transitions
  *
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 93869cda6af99..238a0ab85df9b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -12,6 +12,9 @@
 #include "ctree.h"
 #include "misc.h"
 
+/* Radix-tree tag for roots that are part of the trasaction. */
+#define BTRFS_ROOT_TRANS_TAG			0
+
 enum btrfs_trans_state {
 	TRANS_STATE_RUNNING,
 	TRANS_STATE_COMMIT_PREP,
-- 
2.43.0



