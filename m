Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0AB24A078;
	Tue, 21 Jul 2026 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664663; cv=none; b=C04eiVrE956BmIe+ccu0rgd4rM2YJHRj4AIL0VRklIp5eaV0sclFURHXVOty/8hDNv0vB5BmZ/8kKkHvP1SVq68i/k0ScFrdIY5wTmz7rBXQOkOG+AHvTF3A5nCipOIPyO9JA8F5cjKdYAHmZmW0GFxiu8I9cHidLif/4+DYLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664663; c=relaxed/simple;
	bh=rl5vTjYHRlOiyGTnW6Vpcz+FSVPN1PHkSuyKBILXGvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQUzSyXfza0H1goqNEVpoCy/Mad9jsW2kBamhp4HQZdI5puMQnBbuXND9T2q3EqJMOOBdvg1jMYXyssAPSRDqjPmOdJgWgKpRFYTo21S1O/sJ7/Y6ndmUF2wzFfYBGuqLeXXkwZz2eb6NQ/ilfae5Q1uVgpJt9HOKahu8aBjyCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuiONegt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuiONegt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707321F000E9;
	Tue, 21 Jul 2026 20:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664661;
	bh=a/BAz2np+LDYhF3NglvkYKDK9VnPIKfk3lh0JlBzWtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuiONegtYR67OZtebCqPGGBav86/kIdyN+zPnCoek0jDpMxNkcllJVU89BhtMeu1a
	 XIXRqf6roKGwZ21mVgHjF0bAQwUCL+1z1KBKQghDMlJz3aIQFStMESpWjfZdMCcwk8
	 mBdxbR3jS/iNDJZwEPoSa1j6vBMEQm5ugdY1u+pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0004/1266] ext4: get rid of ppath in get_ext_path()
Date: Tue, 21 Jul 2026 17:07:21 +0200
Message-ID: <20260721152441.890808114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

After getting rid of ppath in get_ext_path(), its caller may pass an error
pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
and ext4_ext_drop_refs() to skip the error pointer. No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-13-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c     |  5 +++--
 fs/ext4/move_extent.c | 34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a94798e23c1afb..9c2d23958146bf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -114,7 +114,7 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 {
 	int depth, i;
 
-	if (!path)
+	if (IS_ERR_OR_NULL(path))
 		return;
 	depth = path->p_depth;
 	for (i = 0; i <= depth; i++, path++) {
@@ -125,6 +125,8 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 
 void ext4_free_ext_path(struct ext4_ext_path *path)
 {
+	if (IS_ERR_OR_NULL(path))
+		return;
 	ext4_ext_drop_refs(path);
 	kfree(path);
 }
@@ -4242,7 +4244,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	path = ext4_find_extent(inode, map->m_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
-		path = NULL;
 		goto out;
 	}
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d5636a2a718a8d..96a84de321690d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -17,27 +17,23 @@
  * get_ext_path() - Find an extent path for designated logical block number.
  * @inode:	inode to be searched
  * @lblock:	logical block number to find an extent path
- * @ppath:	pointer to an extent path pointer (for output)
+ * @path:	pointer to an extent path
  *
- * ext4_find_extent wrapper. Return 0 on success, or a negative error value
- * on failure.
+ * ext4_find_extent wrapper. Return an extent path pointer on success,
+ * or an error pointer on failure.
  */
-static inline int
+static inline struct ext4_ext_path *
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **ppath)
+	     struct ext4_ext_path *path)
 {
-	struct ext4_ext_path *path = *ppath;
-
-	*ppath = NULL;
 	path = ext4_find_extent(inode, lblock, path, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
-		return PTR_ERR(path);
+		return path;
 	if (path[ext_depth(inode)].p_ext == NULL) {
 		ext4_free_ext_path(path);
-		return -ENODATA;
+		return ERR_PTR(-ENODATA);
 	}
-	*ppath = path;
-	return 0;
+	return path;
 }
 
 /**
@@ -95,9 +91,11 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 	int ret = 0;
 	ext4_lblk_t last = from + count;
 	while (from < last) {
-		*err = get_ext_path(inode, from, &path);
-		if (*err)
-			goto out;
+		path = get_ext_path(inode, from, path);
+		if (IS_ERR(path)) {
+			*err = PTR_ERR(path);
+			return ret;
+		}
 		ext = path[ext_depth(inode)].p_ext;
 		if (unwritten != ext4_ext_is_unwritten(ext))
 			goto out;
@@ -634,9 +632,11 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		int offset_in_page;
 		int unwritten, cur_len;
 
-		ret = get_ext_path(orig_inode, o_start, &path);
-		if (ret)
+		path = get_ext_path(orig_inode, o_start, path);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
 			goto out;
+		}
 		ex = path[path->p_depth].p_ext;
 		cur_blk = le32_to_cpu(ex->ee_block);
 		cur_len = ext4_ext_get_actual_len(ex);
-- 
2.53.0



