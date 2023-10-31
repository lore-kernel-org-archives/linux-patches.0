Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAF633D2
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F01u2Yvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E760C433C8;
	Tue, 31 Oct 2023 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698759555;
	bh=PTVyypYkgPSWQC7SIMh8c3Hxk11lQ+qDVUhEW2tvJGQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=F01u2Yvk5Pw/d0SmmYtHOMcE17bNndFszuu9vNPgxxZIm3IvJnivG+rh+Q5pKcgyk
	 1EDhzDTBsiJlAL8SgPhHh2DMUS9gf1w0BzLcvVmNZYas3EiKohQzVrzLWnbC+ELvYi
	 nhfZzjbAdCi/Kr5k+dsMZSd/PUaUiZuC2YHUZBQo=
Subject: Patch "ext4: fix BUG in ext4_mb_new_inode_pa() due to overflow" has been added to the 6.1-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,patches@lists.linux.dev,ritesh.list@gmail.com,sashal@kernel.org,stable@kernel.org,tytso@mit.edu,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Oct 2023 14:39:01 +0100
In-Reply-To: <20231028064749.833278-2-libaokun1@huawei.com>
Message-ID: <2023103100-riverbed-hatching-0740@gregkh>
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

    ext4: fix BUG in ext4_mb_new_inode_pa() due to overflow

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Sat Oct 28 08:43:23 2023
From: Baokun Li <libaokun1@huawei.com>
Date: Sat, 28 Oct 2023 14:47:48 +0800
Subject: ext4: fix BUG in ext4_mb_new_inode_pa() due to overflow
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>, <jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>, <yangerkun@huawei.com>, <libaokun1@huawei.com>, <stable@kernel.org>
Message-ID: <20231028064749.833278-2-libaokun1@huawei.com>

From: Baokun Li <libaokun1@huawei.com>

commit bc056e7163ac7db945366de219745cf94f32a3e6 upstream.

When we calculate the end position of ext4_free_extent, this position may
be exactly where ext4_lblk_t (i.e. uint) overflows. For example, if
ac_g_ex.fe_logical is 4294965248 and ac_orig_goal_len is 2048, then the
computed end is 0x100000000, which is 0. If ac->ac_o_ex.fe_logical is not
the first case of adjusting the best extent, that is, new_bex_end > 0, the
following BUG_ON will be triggered:

=========================================================
kernel BUG at fs/ext4/mballoc.c:5116!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 3 PID: 673 Comm: xfs_io Tainted: G E 6.5.0-rc1+ #279
RIP: 0010:ext4_mb_new_inode_pa+0xc5/0x430
Call Trace:
 <TASK>
 ext4_mb_use_best_found+0x203/0x2f0
 ext4_mb_try_best_found+0x163/0x240
 ext4_mb_regular_allocator+0x158/0x1550
 ext4_mb_new_blocks+0x86a/0xe10
 ext4_ext_map_blocks+0xb0c/0x13a0
 ext4_map_blocks+0x2cd/0x8f0
 ext4_iomap_begin+0x27b/0x400
 iomap_iter+0x222/0x3d0
 __iomap_dio_rw+0x243/0xcb0
 iomap_dio_rw+0x16/0x80
=========================================================

A simple reproducer demonstrating the problem:

	mkfs.ext4 -F /dev/sda -b 4096 100M
	mount /dev/sda /tmp/test
	fallocate -l1M /tmp/test/tmp
	fallocate -l10M /tmp/test/file
	fallocate -i -o 1M -l16777203M /tmp/test/file
	fsstress -d /tmp/test -l 0 -n 100000 -p 8 &
	sleep 10 && killall -9 fsstress
	rm -f /tmp/test/tmp
	xfs_io -c "open -ad /tmp/test/file" -c "pwrite -S 0xff 0 8192"

We simply refactor the logic for adjusting the best extent by adding
a temporary ext4_free_extent ex and use extent_logical_end() to avoid
overflow, which also simplifies the code.

Cc: stable@kernel.org # 6.4
Fixes: 93cdf49f6eca ("ext4: Fix best extent lstart adjustment logic in ext4_mb_new_inode_pa()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4652,8 +4652,11 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 	pa = ac->ac_pa;
 
 	if (ac->ac_b_ex.fe_len < ac->ac_g_ex.fe_len) {
-		int new_bex_start;
-		int new_bex_end;
+		struct ext4_free_extent ex = {
+			.fe_logical = ac->ac_g_ex.fe_logical,
+			.fe_len = ac->ac_g_ex.fe_len,
+		};
+		loff_t orig_goal_end = extent_logical_end(sbi, &ex);
 
 		/* we can't allocate as much as normalizer wants.
 		 * so, found space must get proper lstart
@@ -4672,29 +4675,23 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 		 *    still cover original start
 		 * 3. Else, keep the best ex at start of original request.
 		 */
-		new_bex_end = ac->ac_g_ex.fe_logical +
-			EXT4_C2B(sbi, ac->ac_g_ex.fe_len);
-		new_bex_start = new_bex_end - EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
-		if (ac->ac_o_ex.fe_logical >= new_bex_start)
-			goto adjust_bex;
+		ex.fe_len = ac->ac_b_ex.fe_len;
 
-		new_bex_start = ac->ac_g_ex.fe_logical;
-		new_bex_end =
-			new_bex_start + EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
-		if (ac->ac_o_ex.fe_logical < new_bex_end)
+		ex.fe_logical = orig_goal_end - EXT4_C2B(sbi, ex.fe_len);
+		if (ac->ac_o_ex.fe_logical >= ex.fe_logical)
 			goto adjust_bex;
 
-		new_bex_start = ac->ac_o_ex.fe_logical;
-		new_bex_end =
-			new_bex_start + EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
+		ex.fe_logical = ac->ac_g_ex.fe_logical;
+		if (ac->ac_o_ex.fe_logical < extent_logical_end(sbi, &ex))
+			goto adjust_bex;
 
+		ex.fe_logical = ac->ac_o_ex.fe_logical;
 adjust_bex:
-		ac->ac_b_ex.fe_logical = new_bex_start;
+		ac->ac_b_ex.fe_logical = ex.fe_logical;
 
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
 		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
-		BUG_ON(new_bex_end > (ac->ac_g_ex.fe_logical +
-				      EXT4_C2B(sbi, ac->ac_g_ex.fe_len)));
+		BUG_ON(extent_logical_end(sbi, &ex) > orig_goal_end);
 	}
 
 	/* preallocation can change ac_b_ex, thus we store actually


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-6.1/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-6.1/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-6.1/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
