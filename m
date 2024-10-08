Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098B71CF297;
	Tue,  8 Oct 2024 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390564; cv=none; b=g8WN1sOOPQ96rI8VwmHPvf8zI97B3mRLq7ZoegsAwCBMPSWJk7TLZIk0paoOz0pKRrTga2IJFAYDPcMT8mMk7cOhJjD6EYd8+c2Yyge3cbP7S98m21OptwctGoqcy04rOZziwdyLJLy+cccnQcHlX2zD1Ec2//e3LGV2qaR134c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390564; c=relaxed/simple;
	bh=5gcultbOprj8jAfM9IxOhRi5k8GliqwUSg3XnypZfpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfYB63AwzimxerItaeCJeTp6Z7cmpzuY05Jpg2z0EmyRn3KRyB8BbDE0RNgalDp1EuNC7DPNspWnrOxNyimNI7yivsiiSIpWj606n1TLLIAaudbr0IDXrieZtg2wR9zIyQXo79Xr7WnOl0cynBeTUwcWHS5T+bg7ybs58HhG9Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5ec9AYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5ec9AYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB7BC4CEC7;
	Tue,  8 Oct 2024 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390563;
	bh=5gcultbOprj8jAfM9IxOhRi5k8GliqwUSg3XnypZfpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5ec9AYJKRY2jRAe1PMi31/AMiZL+JipNWur0TMzp3gmZJ0vx5z/NPq5DWxku9y0X
	 tMoRWFZ00UByBryVXQdiOff9dGHsvxcj3UySuXcIykW1QDb+p1yaCmY0O4yDFN4fgd
	 nzaMVNgj6k8pqbUOnYF/18z2lsNON7P1VOlgD0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.10 324/482] ext4: fix slab-use-after-free in ext4_split_extent_at()
Date: Tue,  8 Oct 2024 14:06:27 +0200
Message-ID: <20241008115701.178007055@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit c26ab35702f8cd0cdc78f96aa5856bfb77be798f upstream.

We hit the following use-after-free:

==================================================================
BUG: KASAN: slab-use-after-free in ext4_split_extent_at+0xba8/0xcc0
Read of size 2 at addr ffff88810548ed08 by task kworker/u20:0/40
CPU: 0 PID: 40 Comm: kworker/u20:0 Not tainted 6.9.0-dirty #724
Call Trace:
 <TASK>
 kasan_report+0x93/0xc0
 ext4_split_extent_at+0xba8/0xcc0
 ext4_split_extent.isra.0+0x18f/0x500
 ext4_split_convert_extents+0x275/0x750
 ext4_ext_handle_unwritten_extents+0x73e/0x1580
 ext4_ext_map_blocks+0xe20/0x2dc0
 ext4_map_blocks+0x724/0x1700
 ext4_do_writepages+0x12d6/0x2a70
[...]

Allocated by task 40:
 __kmalloc_noprof+0x1ac/0x480
 ext4_find_extent+0xf3b/0x1e70
 ext4_ext_map_blocks+0x188/0x2dc0
 ext4_map_blocks+0x724/0x1700
 ext4_do_writepages+0x12d6/0x2a70
[...]

Freed by task 40:
 kfree+0xf1/0x2b0
 ext4_find_extent+0xa71/0x1e70
 ext4_ext_insert_extent+0xa22/0x3260
 ext4_split_extent_at+0x3ef/0xcc0
 ext4_split_extent.isra.0+0x18f/0x500
 ext4_split_convert_extents+0x275/0x750
 ext4_ext_handle_unwritten_extents+0x73e/0x1580
 ext4_ext_map_blocks+0xe20/0x2dc0
 ext4_map_blocks+0x724/0x1700
 ext4_do_writepages+0x12d6/0x2a70
[...]
==================================================================

The flow of issue triggering is as follows:

ext4_split_extent_at
  path = *ppath
  ext4_ext_insert_extent(ppath)
    ext4_ext_create_new_leaf(ppath)
      ext4_find_extent(orig_path)
        path = *orig_path
        read_extent_tree_block
          // return -ENOMEM or -EIO
        ext4_free_ext_path(path)
          kfree(path)
        *orig_path = NULL
  a. If err is -ENOMEM:
  ext4_ext_dirty(path + path->p_depth)
  // path use-after-free !!!
  b. If err is -EIO and we have EXT_DEBUG defined:
  ext4_ext_show_leaf(path)
    eh = path[depth].p_hdr
    // path also use-after-free !!!

So when trying to zeroout or fix the extent length, call ext4_find_extent()
to update the path.

In addition we use *ppath directly as an ext4_ext_show_leaf() input to
avoid possible use-after-free when EXT_DEBUG is defined, and to avoid
unnecessary path updates.

Fixes: dfe5080939ea ("ext4: drop EXT4_EX_NOFREE_ON_ERR from rest of extents handling code")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-4-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3230,6 +3230,25 @@ static int ext4_split_extent_at(handle_t
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
+	/*
+	 * Update path is required because previous ext4_ext_insert_extent()
+	 * may have freed or reallocated the path. Using EXT4_EX_NOFAIL
+	 * guarantees that ext4_find_extent() will not return -ENOMEM,
+	 * otherwise -ENOMEM will cause a retry in do_writepages(), and a
+	 * WARN_ON may be triggered in ext4_da_update_reserve_space() due to
+	 * an incorrect ee_len causing the i_reserved_data_blocks exception.
+	 */
+	path = ext4_find_extent(inode, ee_block, ppath,
+				flags | EXT4_EX_NOFAIL);
+	if (IS_ERR(path)) {
+		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
+				 split, PTR_ERR(path));
+		return PTR_ERR(path);
+	}
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	*ppath = path;
+
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
 		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
 			if (split_flag & EXT4_EXT_DATA_VALID1) {
@@ -3282,7 +3301,7 @@ fix_extent_len:
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
 out:
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 	return err;
 }
 


