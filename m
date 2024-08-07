Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BC66F2F7;
	Wed,  7 Aug 2024 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042951; cv=none; b=nNG/56XJjHb+XTqskP1nnoditIj9KKSxVNBcqZNQs72Z0m13+s8BSqpQIZxnlzIXi8D6Qvc0yK5WWrmj2azFX7vnTOq+N59xiOKvFeJVmoa7b/8GHFTREEupJoIbG6OziaZkjPpoeqxko9uvIa9+a7YLQV1Jl99ycMV+kDPgyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042951; c=relaxed/simple;
	bh=7klVwnkXbLsPPTFtzRwtWgkgT3NW2c5tPyIaREncCWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQKgigxUly9CSKlt8dlkov5z2lDJXlDu4Wn5BkNuTkj3rgt0EABfV2Qg9YrFMP1D5fN9RogQKVilVdbdF9V2rmDaPxxWBNUI6t5N/oPz0gfxB0j8PoZ+a2pFIocuRB00L9J38quuRt1zyOctfkMDgrD/RfUgk8EFnCbHqmg4NIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Emg4iVnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Emg4iVnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E925FC32781;
	Wed,  7 Aug 2024 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042951;
	bh=7klVwnkXbLsPPTFtzRwtWgkgT3NW2c5tPyIaREncCWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Emg4iVnjwa14MNA8kXr5JzwPaxNZyZFt7MY/ETWVgC2zWQSi3nogSjt9RnWYihhMX
	 BLf0b4mp9gp0Z19txXf1YxGptA+aHWgnNX4pWBIYLXd7OIgHXPoDJBDLECL3vJ1JYj
	 t553EDhOG8jHgZXy8HX8eNL71kDJrp2WvL1Ng3a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 007/123] ext4: check the extent status again before inserting delalloc block
Date: Wed,  7 Aug 2024 16:58:46 +0200
Message-ID: <20240807150021.054622903@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 0ea6560abb3bac1ffcfa4bf6b2c4d344fdc27b3c ]

ext4_da_map_blocks looks up for any extent entry in the extent status
tree (w/o i_data_sem) and then the looks up for any ondisk extent
mapping (with i_data_sem in read mode).

If it finds a hole in the extent status tree or if it couldn't find any
entry at all, it then takes the i_data_sem in write mode to add a da
entry into the extent status tree. This can actually race with page
mkwrite & fallocate path.

Note that this is ok between
1. ext4 buffered-write path v/s ext4_page_mkwrite(), because of the
   folio lock
2. ext4 buffered write path v/s ext4 fallocate because of the inode
   lock.

But this can race between ext4_page_mkwrite() & ext4 fallocate path

ext4_page_mkwrite()             ext4_fallocate()
 block_page_mkwrite()
  ext4_da_map_blocks()
   //find hole in extent status tree
                                 ext4_alloc_file_blocks()
                                  ext4_map_blocks()
                                   //allocate block and unwritten extent
   ext4_insert_delayed_block()
    ext4_da_reserve_space()
     //reserve one more block
    ext4_es_insert_delayed_block()
     //drop unwritten extent and add delayed extent by mistake

Then, the delalloc extent is wrong until writeback and the extra
reserved block can't be released any more and it triggers below warning:

 EXT4-fs (pmem2): Inode 13 (00000000bbbd4d23): i_reserved_data_blocks(1) not cleared!

Fix the problem by looking up extent status tree again while the
i_data_sem is held in write mode. If it still can't find any entry, then
we insert a new da entry into the extent status tree.

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240517124005.347221-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 168819b4db019..4b0d64a76e88e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1737,6 +1737,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		if (ext4_es_is_hole(&es))
 			goto add_delayed;
 
+found:
 		/*
 		 * Delayed extent could be allocated by fallocate.
 		 * So we need to check it.
@@ -1781,6 +1782,26 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 add_delayed:
 	down_write(&EXT4_I(inode)->i_data_sem);
+	/*
+	 * Page fault path (ext4_page_mkwrite does not take i_rwsem)
+	 * and fallocate path (no folio lock) can race. Make sure we
+	 * lookup the extent status tree here again while i_data_sem
+	 * is held in write mode, before inserting a new da entry in
+	 * the extent status tree.
+	 */
+	if (ext4_es_lookup_extent(inode, iblock, NULL, &es)) {
+		if (!ext4_es_is_hole(&es)) {
+			up_write(&EXT4_I(inode)->i_data_sem);
+			goto found;
+		}
+	} else if (!ext4_has_inline_data(inode)) {
+		retval = ext4_map_query_blocks(NULL, inode, map);
+		if (retval) {
+			up_write(&EXT4_I(inode)->i_data_sem);
+			return retval;
+		}
+	}
+
 	retval = ext4_insert_delayed_block(inode, map->m_lblk);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (retval)
-- 
2.43.0



