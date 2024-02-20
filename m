Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B216D612D7;
	Tue, 20 Feb 2024 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463887; cv=none; b=DgEHP0HgWaITNUpdTZsbw3nUymvoKfX4UC0djP/qXIBUJhS8XDuG1ckbXhHDPu/Vk/6xe+Rsy+1tOvmLVLQbjwosValagV0ujlsOj0FIxlYp5x42BV2WqjJN7yn3M6vsGf/6DA5c4l4bqtBx0VBzmaww+LnP/nGwtTZBSX9E1Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463887; c=relaxed/simple;
	bh=Nv42b75NUqwm69nOKKEfgaUKElPK0Z82S+3cHsV0p4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR7R6EVwSFU10IExU3oOUCsvzlDlkz77bvFxklynmMUrnpOlig8Um9eafXKAM4GQZNEnbZlnbP5l5GAxWV3Dvkud887nnFyJq5+PWoWUKZbdLElHU1D+ZhwtaVsxIoTnNgv+r0yQMW9hLj1tLwPeHML/Q1ANnoyGP6RgYofCwSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxGbyU5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxGbyU5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F5C433C7;
	Tue, 20 Feb 2024 21:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463887;
	bh=Nv42b75NUqwm69nOKKEfgaUKElPK0Z82S+3cHsV0p4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxGbyU5axNeNzNnsuwv6mFVsnQYrTFe7zM+gHae1XRldC6bhfTauq0SLHnrCb8HmT
	 SO1xqX/ydqLn85LMrH2RQ1exLDISznxuQBsNshtE8FYgDLFgt5xDBGKCIbBQtMaJUl
	 TJyw1V6MH6vhIjEyZZLeVbGME/qDcr//YLeVB1Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	xingwei lee <xrivendell7@gmail.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 146/331] ext4: fix double-free of blocks due to wrong extents moved_len
Date: Tue, 20 Feb 2024 21:54:22 +0100
Message-ID: <20240220205642.130113956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
@@ -619,6 +619,7 @@ ext4_move_extents(struct file *o_filp, s
 		goto out;
 	o_end = o_start + len;
 
+	*moved_len = 0;
 	while (o_start < o_end) {
 		struct ext4_extent *ex;
 		ext4_lblk_t cur_blk, next_blk;
@@ -673,7 +674,7 @@ ext4_move_extents(struct file *o_filp, s
 		 */
 		ext4_double_up_write_data_sem(orig_inode, donor_inode);
 		/* Swap original branches with new branches */
-		move_extent_per_page(o_filp, donor_inode,
+		*moved_len += move_extent_per_page(o_filp, donor_inode,
 				     orig_page_index, donor_page_index,
 				     offset_in_page, cur_len,
 				     unwritten, &ret);
@@ -683,9 +684,6 @@ ext4_move_extents(struct file *o_filp, s
 		o_start += cur_len;
 		d_start += cur_len;
 	}
-	*moved_len = o_start - orig_blk;
-	if (*moved_len > len)
-		*moved_len = len;
 
 out:
 	if (*moved_len) {


