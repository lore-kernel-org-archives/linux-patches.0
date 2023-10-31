Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C2733D2
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8AV9gt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74038C433C8;
	Tue, 31 Oct 2023 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698759525;
	bh=082MlEjKRp92CbtKuPuCGJUCsLWB7wec9V4hVNuyuVI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=D8AV9gt7vLRvHTAttTq7m8YvkOXGbDfhbzhaUzxur7XV2KtrTjZ2pshEuNy40dG/5
	 u1y7g+y0Mpl6TDAgkp5y5ZRVC0YuUvivkLmnfHv5+Cve85DxiqDSNmhMjQfFGC/fW/
	 Z60u35+tyqcvEJKRxUVlj0qM0CmMqqH6aSvER5DI=
Subject: Patch "ext4: add two helper functions extent_logical_end() and pa_logical_end()" has been added to the 5.15-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,patches@lists.linux.dev,ritesh.list@gmail.com,sashal@kernel.org,tytso@mit.edu,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Oct 2023 14:38:43 +0100
In-Reply-To: <20231028064749.833278-1-libaokun1@huawei.com>
Message-ID: <2023103142-daydream-kitten-0f0a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ext4: add two helper functions extent_logical_end() and pa_logical_end()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Sat Oct 28 08:43:22 2023
From: Baokun Li <libaokun1@huawei.com>
Date: Sat, 28 Oct 2023 14:47:47 +0800
Subject: ext4: add two helper functions extent_logical_end() and pa_logical_end()
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>, <jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>, <yangerkun@huawei.com>, <libaokun1@huawei.com>
Message-ID: <20231028064749.833278-1-libaokun1@huawei.com>

From: Baokun Li <libaokun1@huawei.com>

commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.

When we use lstart + len to calculate the end of free extent or prealloc
space, it may exceed the maximum value of 4294967295(0xffffffff) supported
by ext4_lblk_t and cause overflow, which may lead to various problems.

Therefore, we add two helper functions, extent_logical_end() and
pa_logical_end(), to limit the type of end to loff_t, and also convert
lstart to loff_t for calculation to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    7 +++----
 fs/ext4/mballoc.h |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4079,7 +4079,7 @@ ext4_mb_normalize_request(struct ext4_al
 
 	/* first, let's learn actual file size
 	 * given current request is allocated */
-	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
+	size = extent_logical_end(sbi, &ac->ac_o_ex);
 	size = size << bsbits;
 	if (size < i_size_read(ac->ac_inode))
 		size = i_size_read(ac->ac_inode);
@@ -4419,8 +4419,7 @@ ext4_mb_use_preallocated(struct ext4_all
 		/* all fields in this condition don't change,
 		 * so we can skip locking for them */
 		if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
-		    ac->ac_o_ex.fe_logical >= (pa->pa_lstart +
-					       EXT4_C2B(sbi, pa->pa_len)))
+		    ac->ac_o_ex.fe_logical >= pa_logical_end(sbi, pa))
 			continue;
 
 		/* non-extent files can't have physical blocks past 2^32 */
@@ -5241,7 +5240,7 @@ static void ext4_mb_group_or_file(struct
 
 	group_pa_eligible = sbi->s_mb_group_prealloc > 0;
 	inode_pa_eligible = true;
-	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
+	size = extent_logical_end(sbi, &ac->ac_o_ex);
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -219,6 +219,20 @@ static inline ext4_fsblk_t ext4_grp_offs
 		(fex->fe_start << EXT4_SB(sb)->s_cluster_bits);
 }
 
+static inline loff_t extent_logical_end(struct ext4_sb_info *sbi,
+					struct ext4_free_extent *fex)
+{
+	/* Use loff_t to avoid end exceeding ext4_lblk_t max. */
+	return (loff_t)fex->fe_logical + EXT4_C2B(sbi, fex->fe_len);
+}
+
+static inline loff_t pa_logical_end(struct ext4_sb_info *sbi,
+				    struct ext4_prealloc_space *pa)
+{
+	/* Use loff_t to avoid end exceeding ext4_lblk_t max. */
+	return (loff_t)pa->pa_lstart + EXT4_C2B(sbi, pa->pa_len);
+}
+
 typedef int (*ext4_mballoc_query_range_fn)(
 	struct super_block		*sb,
 	ext4_group_t			agno,


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.15/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.15/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
