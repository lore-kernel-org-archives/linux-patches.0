Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EDC1D95A2;
	Tue, 15 Oct 2024 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993764; cv=none; b=WzHFI0PYtMzb0ys502ZAhxAlS5Cw6SOppdCVAlS/ayaBna5b4NRDtJLBtol8/q9MGUZBBiaRsQd0BknZne7sW13WKcSEKjlPnC40rciB/ENzzJAP6jABo+eag7Mtb4BImsiX3NlU6nxLpPcmHKxRADWC5EqiLdlCFNjOspb6FTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993764; c=relaxed/simple;
	bh=E7GmBccMJPGHzgdGHe1JBEDGIZfmO//rzhnIn6ZDZnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWg6Vfq3tz3y9d9mT5hxmIOZNf+xEcmB97ySj6fkEcQT/eMPEtsIVG097pWEfTZR8TO/yrItvtWLIUQqqdaO5J4gNj0qTrFqz/JZWkCLB1TtkWvLmyJDPRkM8Knm0dZQ9pkVshBV5LJK2tEjtWcv0LlA35/MomgP2EpMasuMefI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxWw6N61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxWw6N61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49151C4CEC6;
	Tue, 15 Oct 2024 12:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993763;
	bh=E7GmBccMJPGHzgdGHe1JBEDGIZfmO//rzhnIn6ZDZnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxWw6N61CB+H/966tWxVuoKsp371a1rK4/5+ESSNkxtYXUA/j58uilBI5SRFZYX8C
	 TVSCGbW6LakdO3eSTK41QZ+ijpCoZg4YnNNxV+IpC3t/yXFlAvRet+3bVexudT3PRx
	 VPh9/0l19lyZJMm0m4J9dzlQh4d/CqRWKsS/+7BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 508/691] ext4: drop ppath from ext4_ext_replay_update_ex() to avoid double-free
Date: Tue, 15 Oct 2024 13:27:36 +0200
Message-ID: <20241015112500.508059745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 5c0f4cc84d3a601c99bc5e6e6eb1cbda542cce95 upstream.

When calling ext4_force_split_extent_at() in ext4_ext_replay_update_ex(),
the 'ppath' is updated but it is the 'path' that is freed, thus potentially
triggering a double-free in the following process:

ext4_ext_replay_update_ex
  ppath = path
  ext4_force_split_extent_at(&ppath)
    ext4_split_extent_at
      ext4_ext_insert_extent
        ext4_ext_create_new_leaf
          ext4_ext_grow_indepth
            ext4_find_extent
              if (depth > path[0].p_maxdepth)
                kfree(path)                 ---> path First freed
                *orig_path = path = NULL    ---> null ppath
  kfree(path)                               ---> path double-free !!!

So drop the unnecessary ppath and use path directly to avoid this problem.
And use ext4_find_extent() directly to update path, avoiding unnecessary
memory allocation and freeing. Also, propagate the error returned by
ext4_find_extent() instead of using strange error codes.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-8-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5935,7 +5935,7 @@ out:
 int ext4_ext_replay_update_ex(struct inode *inode, ext4_lblk_t start,
 			      int len, int unwritten, ext4_fsblk_t pblk)
 {
-	struct ext4_ext_path *path = NULL, *ppath;
+	struct ext4_ext_path *path;
 	struct ext4_extent *ex;
 	int ret;
 
@@ -5951,30 +5951,29 @@ int ext4_ext_replay_update_ex(struct ino
 	if (le32_to_cpu(ex->ee_block) != start ||
 		ext4_ext_get_actual_len(ex) != len) {
 		/* We need to split this extent to match our extent first */
-		ppath = path;
 		down_write(&EXT4_I(inode)->i_data_sem);
-		ret = ext4_force_split_extent_at(NULL, inode, &ppath, start, 1);
+		ret = ext4_force_split_extent_at(NULL, inode, &path, start, 1);
 		up_write(&EXT4_I(inode)->i_data_sem);
 		if (ret)
 			goto out;
-		kfree(path);
-		path = ext4_find_extent(inode, start, NULL, 0);
+
+		path = ext4_find_extent(inode, start, &path, 0);
 		if (IS_ERR(path))
-			return -1;
-		ppath = path;
+			return PTR_ERR(path);
 		ex = path[path->p_depth].p_ext;
 		WARN_ON(le32_to_cpu(ex->ee_block) != start);
+
 		if (ext4_ext_get_actual_len(ex) != len) {
 			down_write(&EXT4_I(inode)->i_data_sem);
-			ret = ext4_force_split_extent_at(NULL, inode, &ppath,
+			ret = ext4_force_split_extent_at(NULL, inode, &path,
 							 start + len, 1);
 			up_write(&EXT4_I(inode)->i_data_sem);
 			if (ret)
 				goto out;
-			kfree(path);
-			path = ext4_find_extent(inode, start, NULL, 0);
+
+			path = ext4_find_extent(inode, start, &path, 0);
 			if (IS_ERR(path))
-				return -EINVAL;
+				return PTR_ERR(path);
 			ex = path[path->p_depth].p_ext;
 		}
 	}


