Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7B79DAE;
	Wed, 21 Feb 2024 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524695; cv=none; b=HogPHQcUrSRPJu01BDQnY/Xju+bnvOitxbhMXbDHADJE4P3ZIOdCOUd+YVthL/fvYR3lZFIUqFjTVMLKH8jmjhlTYz1wbT9Rs6TAQzwOR55vVevBaSmoHGCAOqn4MOcrOk+S+Z2pwr2KXMwAQSL9Yfj7MskXVI5eK8+JxxCPA7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524695; c=relaxed/simple;
	bh=Mtb2DUwpXrnBpboYG2Pdy4HGqkRy02jU/YlYQ/XAV2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7BXDf8WajRAqAzhCwIJ7oPmSMJVW3RDe0VTrvAsaDKvKlCxJNnGBGPuSndc4d0MM35UMD8IM3qLZ+GLh5BMRvyaA8jvzLDg78Ce66q/Ko144s0l4vIcf3ixsClhvtRrdvEGorjrF5iydXUSinezGZyFShpYeKsIj+NXgG6kOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNQYsJK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNQYsJK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A9C433C7;
	Wed, 21 Feb 2024 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524695;
	bh=Mtb2DUwpXrnBpboYG2Pdy4HGqkRy02jU/YlYQ/XAV2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNQYsJK1eUn5LLjkACpQe9tyui31AsHmZNliuXj9cNquCDTEzNeeRj9f0kVXBnNeL
	 FJAMWRb1q1fyxVx5fGNFepvsoECfVt2tFrqXBputtVNYD1baFfIFctDa1YLT1381ut
	 cdEikjfi4bCEDFwch18dETspQUO+YJj6JtGeDKxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	xingwei lee <xrivendell7@gmail.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 321/379] ext4: fix double-free of blocks due to wrong extents moved_len
Date: Wed, 21 Feb 2024 14:08:20 +0100
Message-ID: <20240221130004.440944441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

commit 55583e899a5357308274601364741a83e78d6ac4 upstream.

In ext4_move_extents(), moved_len is only updated when all moves are
successfully executed, and only discards orig_inode and donor_inode
preallocations when moved_len is not zero. When the loop fails to exit
after successfully moving some extents, moved_len is not updated and
remains at 0, so it does not discard the preallocations.

If the moved extents overlap with the preallocated extents, the
overlapped extents are freed twice in ext4_mb_release_inode_pa() and
ext4_process_freed_data() (as described in commit 94d7c16cbbbd ("ext4:
Fix double-free of blocks with EXT4_IOC_MOVE_EXT")), and bb_free is
incremented twice. Hence when trim is executed, a zero-division bug is
triggered in mb_update_avg_fragment_size() because bb_free is not zero
and bb_fragments is zero.

Therefore, update move_len after each extent move to avoid the issue.

Reported-by: Wei Chen <harperchen1110@gmail.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Closes: https://lore.kernel.org/r/CAO4mrferzqBUnCag8R3m2zf897ts9UEuhjFQGPtODT92rYyR2Q@mail.gmail.com
Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
CC:  <stable@vger.kernel.org> # 3.18
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/move_extent.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -615,6 +615,7 @@ ext4_move_extents(struct file *o_filp, s
 		goto out;
 	o_end = o_start + len;
 
+	*moved_len = 0;
 	while (o_start < o_end) {
 		struct ext4_extent *ex;
 		ext4_lblk_t cur_blk, next_blk;
@@ -670,7 +671,7 @@ ext4_move_extents(struct file *o_filp, s
 		 */
 		ext4_double_up_write_data_sem(orig_inode, donor_inode);
 		/* Swap original branches with new branches */
-		move_extent_per_page(o_filp, donor_inode,
+		*moved_len += move_extent_per_page(o_filp, donor_inode,
 				     orig_page_index, donor_page_index,
 				     offset_in_page, cur_len,
 				     unwritten, &ret);
@@ -680,9 +681,6 @@ ext4_move_extents(struct file *o_filp, s
 		o_start += cur_len;
 		d_start += cur_len;
 	}
-	*moved_len = o_start - orig_blk;
-	if (*moved_len > len)
-		*moved_len = len;
 
 out:
 	if (*moved_len) {


