Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C18477E33;
	Tue, 16 Jun 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634376; cv=none; b=MQiRUrgvN/S83SwKRlpPJRHhbvj16B00ItQBJMTryz9p0u11Fe95Bmd4SgEsnpZ0oE57JOKII/St1TSvP8JnbLbCWQ5eFN9Evmew8NNRRrSZqDQZRhdS1E9L/RhtV+9M5SJuIjRxLy+lMZJhkTtatQG4ZFAwuXitcdQnEbhbC0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634376; c=relaxed/simple;
	bh=AL4vWMi92ZDakokQTDL2jpOdJL0JuF3eSPqiMeRmMmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQ1Yt4gFpitEABt8YvVOt7vhkE8KO6+nCJ0YxgqHYJkc68Z/hBrzua3wkwmxq5axpwVBOmCzwJaEzOJliYS3lax0j9VLB/6f2IniHreRwUdm+ZxoQ2F9VTyobDsnjeM0URm+UjAXNrAzKGz2f7BibYIFD+c3pWYbUUwmQy6PSG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDS547TP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDS547TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8347E1F000E9;
	Tue, 16 Jun 2026 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634375;
	bh=75M0BV8WtNiYCQQulGvQpyNpTpfQc1aKhFOWxVvxivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDS547TPSUfY0JsCC6lY2vdWQdEG2BBbh9+0EMZ13iMscDNkjH4033ViLytxC5S0l
	 Z+0Vlr80/slYZl/zSdTOP3lAhU2VwiPx7QPv4rZZVOqZBEpH//lZPAVesWmqzuNRIh
	 gUu5wovGHXwud9H//PRE7acnrByzDit+Kv/6kaDo=
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
Subject: [PATCH 5.15 252/411] f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()
Date: Tue, 16 Jun 2026 20:28:10 +0530
Message-ID: <20260616145114.387704917@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -339,6 +339,8 @@ static void f2fs_write_end_io(struct bio
 
 		f2fs_bug_on(sbi, page->mapping == NODE_MAPPING(sbi) &&
 					page->index != nid_of_node(page));
+		if (f2fs_in_warm_node_list(sbi, page))
+			f2fs_del_fsync_node_entry(sbi, page);
 
 		dec_page_count(sbi, type);
 
@@ -350,8 +352,6 @@ static void f2fs_write_end_io(struct bio
 				wq_has_sleeper(&sbi->cp_wait))
 			wake_up(&sbi->cp_wait);
 
-		if (f2fs_in_warm_node_list(sbi, page))
-			f2fs_del_fsync_node_entry(sbi, page);
 		clear_page_private_gcing(page);
 		end_page_writeback(page);
 	}


