Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A593D7D9D;
	Tue, 16 Jun 2026 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636505; cv=none; b=Yvi603BNdzRGpYnDv1yqd4EZoJBTxfJKwsPWV6xl7XSBCbsU0iSPDyDtvY7S0Q+ObBEaKuRZNsVTyPZi2BxrZsejrCrRF3e2l2/6/pSY2q3t6c9w2fBjozIDdWHOx6Dxss8mekepD8OI/kzN7sp+lh6+i9yd8gErg4Wryf8r74c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636505; c=relaxed/simple;
	bh=Pz295hyBv1VLXYWF7lGVeIk6E0vC/9s32aX5+W7qJYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeidHRmaFrzhOsNkycwCreanzufwHCkJ2TRS6I4MN3OUdLLHHZypF+PjcjPOYcM3FAQqZFgMKAZps6ZwV9NTuOQgeRTNqayJ1Rdh7PyfZ5bQkArdUjiAHaU4B1zpM6GD8OSnkgo6Dik2hiSxl6Z1Vw/mMJ/fkmVQHvkSV4XVmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExOF7O0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExOF7O0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAECB1F000E9;
	Tue, 16 Jun 2026 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636503;
	bh=rkyyGT/1pUBDoinSVNtvGuawLBSBnQu5cRi7HJ9h9xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExOF7O0Jn51rC1qyTWID+Ryv7uzVHRdS9IKYjbpGi+n0tayBBTSUp7UWa9oFegA/K
	 bVOZ+7CWLUXWVXT5KaiPezakSqau4nsTuDVdh983tp/zEwai1W3VHC5T3NA7MAG2Di
	 ZJ7UehU0i9HvNK8RKnjqBL+e3qVJCMDUdHYJ+EHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+6e4cb1cac5efc96ea0ca@syzkaller.appspotmail.com,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/342] f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()
Date: Tue, 16 Jun 2026 20:28:34 +0530
Message-ID: <20260616145058.350791848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 2d9c4a4ed4eef1f82c5b16b037aee8bad819fd53 ]

The xfstests case "generic/107" and syzbot have both reported a NULL
pointer dereference.

The concurrent scenario that triggers the panic is as follows:

F2FS_WB_CP_DATA write callback          umount
                                        - f2fs_write_checkpoint
                                         - f2fs_wait_on_all_pages(sbi, F2FS_WB_CP_DATA)
- blk_mq_end_request
 - bio_endio
  - f2fs_write_end_io
   : dec_page_count(sbi, F2FS_WB_CP_DATA)
   : wake_up(&sbi->cp_wait)
                                        - kill_f2fs_super
                                         - kill_block_super
                                          - f2fs_put_super
                                           : iput(sbi->node_inode)
                                           : sbi->node_inode = NULL
   : f2fs_in_warm_node_list
    - is_node_folio // sbi->node_inode is NULL and panic

The root cause is that f2fs_put_super() calls iput(sbi->node_inode) and
sets sbi->node_inode to NULL after sbi->nr_pages[F2FS_WB_CP_DATA] is
decremented to zero. As a result, f2fs_in_warm_node_list() may
dereference a NULL node_inode when checking whether a folio belongs to
the node inode, leading to a panic.

This patch fixes the issue by calling f2fs_in_warm_node_list() before
decrementing sbi->nr_pages[F2FS_WB_CP_DATA], thus preventing the
use-after-free condition.

Cc: stable@kernel.org
Fixes: 50fa53eccf9f ("f2fs: fix to avoid broken of dnode block list")
Reported-by: syzbot+6e4cb1cac5efc96ea0ca@syzkaller.appspotmail.com
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ folio => page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -377,6 +377,8 @@ static void f2fs_write_end_io(struct bio
 
 		f2fs_bug_on(sbi, page->mapping == NODE_MAPPING(sbi) &&
 					page->index != nid_of_node(page));
+		if (f2fs_in_warm_node_list(sbi, page))
+			f2fs_del_fsync_node_entry(sbi, page);
 
 		dec_page_count(sbi, type);
 
@@ -388,8 +390,6 @@ static void f2fs_write_end_io(struct bio
 				wq_has_sleeper(&sbi->cp_wait))
 			wake_up(&sbi->cp_wait);
 
-		if (f2fs_in_warm_node_list(sbi, page))
-			f2fs_del_fsync_node_entry(sbi, page);
 		clear_cold_data(page);
 		end_page_writeback(page);
 	}


