Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF01AF0B1;
	Tue, 15 Oct 2024 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998200; cv=none; b=TI65HLoZrvZMJ6wukbda3pnOwpJ/DocrWdu91B73sQzUBXWDCwAyFnX1mulDCWBWqIq8XJbcGS8slI+AadcOQcN0l40WRtcJqR93hdVAEBLUYM3lDc3uIUhSTaAkAU72SnpG1glWza1s6OnHFJ1cOp/ikpO+NeN5pygCSABXzYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998200; c=relaxed/simple;
	bh=f/AOzR1dU0OfOx1iYyX1HLaK7+W0dj9BvCJvn2HtFI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUbFMXxmI/THxwPYvI1uUGEEdH16cM0yedYW/DWj1Tpxvb1gxmRzrbjPlEy9/CTtPqEnHr5oVFzqm20TTINXFYYFzCcE+m8PwiG62mOBi8B8B/rV+SUbG84l3aXYl1mL7Rn/BzApu5iJIVPqegBhlvkMlnMQCCyjFxP4CYVxPQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucMROakB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucMROakB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF81C4CEC6;
	Tue, 15 Oct 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998200;
	bh=f/AOzR1dU0OfOx1iYyX1HLaK7+W0dj9BvCJvn2HtFI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucMROakBSZufVZ0XDhyYhfQo+fuN0j8hDFzbE9g6GkVFwwLlvNYEsKMPebXwfPlNd
	 wDmXbBoLjXublr+DhiYYJFGCdXZnReFMkY0mfnCS10zRA/GGllbOvC6CDcuojGtGx+
	 CSOOnwpW1n5pHnNZI8XV8dHW2uhmiik4JE4Xd/rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 376/518] ext4: fix double brelse() the buffer of the extents path
Date: Tue, 15 Oct 2024 14:44:40 +0200
Message-ID: <20241015123931.484263339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit dcaa6c31134c0f515600111c38ed7750003e1b9c upstream.

In ext4_ext_try_to_merge_up(), set path[1].p_bh to NULL after it has been
released, otherwise it may be released twice. An example of what triggers
this is as follows:

  split2    map    split1
|--------|-------|--------|

ext4_ext_map_blocks
 ext4_ext_handle_unwritten_extents
  ext4_split_convert_extents
   // path->p_depth == 0
   ext4_split_extent
     // 1. do split1
     ext4_split_extent_at
       |ext4_ext_insert_extent
       |  ext4_ext_create_new_leaf
       |    ext4_ext_grow_indepth
       |      le16_add_cpu(&neh->eh_depth, 1)
       |    ext4_find_extent
       |      // return -ENOMEM
       |// get error and try zeroout
       |path = ext4_find_extent
       |  path->p_depth = 1
       |ext4_ext_try_to_merge
       |  ext4_ext_try_to_merge_up
       |    path->p_depth = 0
       |    brelse(path[1].p_bh)  ---> not set to NULL here
       |// zeroout success
     // 2. update path
     ext4_find_extent
     // 3. do split2
     ext4_split_extent_at
       ext4_ext_insert_extent
         ext4_ext_create_new_leaf
           ext4_ext_grow_indepth
             le16_add_cpu(&neh->eh_depth, 1)
           ext4_find_extent
             path[0].p_bh = NULL;
             path->p_depth = 1
             read_extent_tree_block  ---> return err
             // path[1].p_bh is still the old value
             ext4_free_ext_path
               ext4_ext_drop_refs
                 // path->p_depth == 1
                 brelse(path[1].p_bh)  ---> brelse a buffer twice

Finally got the following WARRNING when removing the buffer from lru:

============================================
VFS: brelse: Trying to free free buffer
WARNING: CPU: 2 PID: 72 at fs/buffer.c:1241 __brelse+0x58/0x90
CPU: 2 PID: 72 Comm: kworker/u19:1 Not tainted 6.9.0-dirty #716
RIP: 0010:__brelse+0x58/0x90
Call Trace:
 <TASK>
 __find_get_block+0x6e7/0x810
 bdev_getblk+0x2b/0x480
 __ext4_get_inode_loc+0x48a/0x1240
 ext4_get_inode_loc+0xb2/0x150
 ext4_reserve_inode_write+0xb7/0x230
 __ext4_mark_inode_dirty+0x144/0x6a0
 ext4_ext_insert_extent+0x9c8/0x3230
 ext4_ext_map_blocks+0xf45/0x2dc0
 ext4_map_blocks+0x724/0x1700
 ext4_do_writepages+0x12d6/0x2a70
[...]
============================================

Fixes: ecb94f5fdf4b ("ext4: collapse a single extent tree block into the inode if possible")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-9-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1867,6 +1867,7 @@ static void ext4_ext_try_to_merge_up(han
 	path[0].p_hdr->eh_max = cpu_to_le16(max_root);
 
 	brelse(path[1].p_bh);
+	path[1].p_bh = NULL;
 	ext4_free_blocks(handle, inode, NULL, blk, 1,
 			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
 }


