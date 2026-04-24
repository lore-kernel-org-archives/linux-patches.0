Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBE3563D4;
	Fri, 24 Apr 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038192; cv=none; b=q/wggQkgIJOUcO8OoSb9AC517d9/tX274IV+rygqws7nti3DiNsfGNvrCs6fbnaClIfziJQVoO/NMTydXCjlpZWUVaR4rawzrdXQMH+1jJD03Zps+yhwk3ps7x7yvAIr9V0ucSDOiIK0tEDVYJURZrZuWhDz16zr8lJV+Oi7yeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038192; c=relaxed/simple;
	bh=dwFhy7mJI28lYmA1bU4x3DrfJ6vlmWmCG1lwVzSohCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqGJobaM6TBgfkwqKwQ0Nx439QVXdM48uRmFYD8j877/Ou0qFGYQiBFos2kcPlACsmfKEFxrT8wan8Tx7dSxTFyyBtkt1hNraYS59upFqwfudnMmkqfMiirkORSWUik8Y6S3cMDA1Qba5ajaqZl99H0wWwqhrkyDVFZzpyUNdCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAzrnGXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAzrnGXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB15AC19425;
	Fri, 24 Apr 2026 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038192;
	bh=dwFhy7mJI28lYmA1bU4x3DrfJ6vlmWmCG1lwVzSohCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAzrnGXfxGUc58qkecmybzehub3vnpWua4dwL7F7kVOh6K0/Ful3270ZJjI/9mnnX
	 UbvOYEEz7FPxvi3KeP+iTHokQhlLn+nkUmFztOgVVL3aMjWGxl/xGy+vsEOf5gGJfP
	 B1m4nkf81rGGGEo67apsPuIYvrIQM7DPXBLT7oEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+6e4cb1cac5efc96ea0ca@syzkaller.appspotmail.com,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 28/55] f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()
Date: Fri, 24 Apr 2026 15:31:07 +0200
Message-ID: <20260424132435.863868097@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 2d9c4a4ed4eef1f82c5b16b037aee8bad819fd53 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -363,6 +363,8 @@ static void f2fs_write_end_io(struct bio
 				folio->index, NODE_TYPE_REGULAR, true);
 			f2fs_bug_on(sbi, folio->index != nid_of_node(folio));
 		}
+		if (f2fs_in_warm_node_list(sbi, folio))
+			f2fs_del_fsync_node_entry(sbi, folio);
 
 		dec_page_count(sbi, type);
 
@@ -374,8 +376,6 @@ static void f2fs_write_end_io(struct bio
 				wq_has_sleeper(&sbi->cp_wait))
 			wake_up(&sbi->cp_wait);
 
-		if (f2fs_in_warm_node_list(sbi, folio))
-			f2fs_del_fsync_node_entry(sbi, folio);
 		folio_clear_f2fs_gcing(folio);
 		folio_end_writeback(folio);
 	}


