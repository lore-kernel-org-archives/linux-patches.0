Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7CF14279
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEEAC433C9;
	Wed,  9 Aug 2023 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580687;
	bh=41bZCjSz/OuQ2oZFqlzCjb3ucHDkiENyUy3xYji7nOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjGNVHdUZ3GGpEqbBjxJnfLVozp6x06kO3QXOmDbKnqGkcsnu1LWFR0juZ7SxYQ7q
	 mNkzsUlns9Hzb8JOuB1JdAxwGELL0coGq8OsV4dKNwavv9EnTmYlL/EfAQp4UldmMN
	 /VPzG1RtB+xDSpfSY/xqZRRdXFSS+wGnJpkSc504=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	David Sterba <dsterba@suse.com>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 084/154] btrfs: qgroup: remove one-time use variables for quota_root checks
Date: Wed,  9 Aug 2023 12:41:55 +0200
Message-ID: <20230809103639.774172433@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit e3b0edd29737d44137fc7583a9c185abda6e23b8 upstream.

Remove some variables that are set only to be checked later, and never
used.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1395,7 +1395,6 @@ int btrfs_add_qgroup_relation(struct btr
 			      u64 dst)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *parent;
 	struct btrfs_qgroup *member;
 	struct btrfs_qgroup_list *list;
@@ -1411,8 +1410,7 @@ int btrfs_add_qgroup_relation(struct btr
 		return -ENOMEM;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root) {
+	if (!fs_info->quota_root) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1459,7 +1457,6 @@ static int __del_qgroup_relation(struct
 				 u64 dst)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *parent;
 	struct btrfs_qgroup *member;
 	struct btrfs_qgroup_list *list;
@@ -1472,8 +1469,7 @@ static int __del_qgroup_relation(struct
 	if (!tmp)
 		return -ENOMEM;
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root) {
+	if (!fs_info->quota_root) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1539,11 +1535,11 @@ int btrfs_create_qgroup(struct btrfs_tra
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root) {
+	if (!fs_info->quota_root) {
 		ret = -EINVAL;
 		goto out;
 	}
+	quota_root = fs_info->quota_root;
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (qgroup) {
 		ret = -EEXIST;
@@ -1568,14 +1564,12 @@ out:
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *list;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root) {
+	if (!fs_info->quota_root) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1617,7 +1611,6 @@ int btrfs_limit_qgroup(struct btrfs_tran
 		       struct btrfs_qgroup_limit *limit)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
 	/* Sometimes we would want to clear the limit on this qgroup.
@@ -1627,8 +1620,7 @@ int btrfs_limit_qgroup(struct btrfs_tran
 	const u64 CLEAR_VALUE = -1;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root) {
+	if (!fs_info->quota_root) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2734,10 +2726,9 @@ cleanup:
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
 
-	if (!quota_root)
+	if (!fs_info->quota_root)
 		return ret;
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -3000,7 +2991,6 @@ static bool qgroup_check_limits(const st
 static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 			  enum btrfs_qgroup_rsv_type type)
 {
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
@@ -3019,8 +3009,7 @@ static int qgroup_reserve(struct btrfs_r
 		enforce = false;
 
 	spin_lock(&fs_info->qgroup_lock);
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
+	if (!fs_info->quota_root)
 		goto out;
 
 	qgroup = find_qgroup_rb(fs_info, ref_root);
@@ -3087,7 +3076,6 @@ void btrfs_qgroup_free_refroot(struct bt
 			       u64 ref_root, u64 num_bytes,
 			       enum btrfs_qgroup_rsv_type type)
 {
-	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -3105,8 +3093,7 @@ void btrfs_qgroup_free_refroot(struct bt
 	}
 	spin_lock(&fs_info->qgroup_lock);
 
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
+	if (!fs_info->quota_root)
 		goto out;
 
 	qgroup = find_qgroup_rb(fs_info, ref_root);
@@ -3997,7 +3984,6 @@ void __btrfs_qgroup_free_meta(struct btr
 static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 				int num_bytes)
 {
-	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -4005,7 +3991,7 @@ static void qgroup_convert_meta(struct b
 
 	if (num_bytes == 0)
 		return;
-	if (!quota_root)
+	if (!fs_info->quota_root)
 		return;
 
 	spin_lock(&fs_info->qgroup_lock);


