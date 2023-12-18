Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582FC3A1AC;
	Mon, 18 Dec 2023 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzZBI4tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF93C433C7;
	Mon, 18 Dec 2023 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908305;
	bh=5zDgYUz71PEcairtxQffB4yvTbeCfi3J1/CKITqztdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzZBI4tbTgZ6A7XNSY1VTm9fVN3Ae8nxGsiRJhcYVb+Mkg5C/Pqmhum5ffF/jUlDC
	 M47BFPzyD3BfRdX3G9zn/f9VeKuhz/a/XJfx2oAgvy8bPOiFPmsgcdf6Qk1MCZzS8m
	 k2d+FEf8NZg6Mu32l7mxg9j8ysSUcGW6HSi8Tqf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 129/166] ext4: prevent the normalized size from exceeding EXT_MAX_BLOCKS
Date: Mon, 18 Dec 2023 14:51:35 +0100
Message-ID: <20231218135110.854898401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 2dcf5fde6dffb312a4bfb8ef940cea2d1f402e32 upstream.

For files with logical blocks close to EXT_MAX_BLOCKS, the file size
predicted in ext4_mb_normalize_request() may exceed EXT_MAX_BLOCKS.
This can cause some blocks to be preallocated that will not be used.
And after [Fixes], the following issue may be triggered:

=========================================================
 kernel BUG at fs/ext4/mballoc.c:4653!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 CPU: 1 PID: 2357 Comm: xfs_io 6.7.0-rc2-00195-g0f5cc96c367f
 Hardware name: linux,dummy-virt (DT)
 pc : ext4_mb_use_inode_pa+0x148/0x208
 lr : ext4_mb_use_inode_pa+0x98/0x208
 Call trace:
  ext4_mb_use_inode_pa+0x148/0x208
  ext4_mb_new_inode_pa+0x240/0x4a8
  ext4_mb_use_best_found+0x1d4/0x208
  ext4_mb_try_best_found+0xc8/0x110
  ext4_mb_regular_allocator+0x11c/0xf48
  ext4_mb_new_blocks+0x790/0xaa8
  ext4_ext_map_blocks+0x7cc/0xd20
  ext4_map_blocks+0x170/0x600
  ext4_iomap_begin+0x1c0/0x348
=========================================================

Here is a calculation when adjusting ac_b_ex in ext4_mb_new_inode_pa():

	ex.fe_logical = orig_goal_end - EXT4_C2B(sbi, ex.fe_len);
	if (ac->ac_o_ex.fe_logical >= ex.fe_logical)
		goto adjust_bex;

The problem is that when orig_goal_end is subtracted from ac_b_ex.fe_len
it is still greater than EXT_MAX_BLOCKS, which causes ex.fe_logical to
overflow to a very small value, which ultimately triggers a BUG_ON in
ext4_mb_new_inode_pa() because pa->pa_free < len.

The last logical block of an actual write request does not exceed
EXT_MAX_BLOCKS, so in ext4_mb_normalize_request() also avoids normalizing
the last logical block to exceed EXT_MAX_BLOCKS to avoid the above issue.

The test case in [Link] can reproduce the above issue with 64k block size.

Link: https://patchwork.kernel.org/project/fstests/list/?series=804003
Cc:  <stable@kernel.org> # 6.4
Fixes: 93cdf49f6eca ("ext4: Fix best extent lstart adjustment logic in ext4_mb_new_inode_pa()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231127063313.3734294-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4489,6 +4489,10 @@ ext4_mb_normalize_request(struct ext4_al
 	start = max(start, rounddown(ac->ac_o_ex.fe_logical,
 			(ext4_lblk_t)EXT4_BLOCKS_PER_GROUP(ac->ac_sb)));
 
+	/* avoid unnecessary preallocation that may trigger assertions */
+	if (start + size > EXT_MAX_BLOCKS)
+		size = EXT_MAX_BLOCKS - start;
+
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
 		size -= ar->lleft + 1 - start;


