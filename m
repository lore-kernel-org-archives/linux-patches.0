Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9079A6A8D2;
	Tue, 17 Feb 2026 20:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360861; cv=none; b=cqe65iPBl2nYgm6MGa9ilzWg/ID+X9vEDvKAaDc0n8miD+ZYat4r4ybd6JYDyxTe113xfAzZVaa2zlKkPjOOabT0p09EQhwPB3irR6hR4ElEMhECYcg5ENJOSrSi08p8BPHMSXSvShqjy8+Tac6d3lrZBFqmUHMFFfi82d90OzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360861; c=relaxed/simple;
	bh=luVIYf8Bnsu+WNLjGsv86miZKvT9cphpJKcTEm+lpNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFe9e1ROVzVDiP2oOOC27WFbnt9j+RxlpSIiA5ZizFoaiMS1TL4XxrCY6/+gzOSWoK/PdBL66fYOXa/27DSAOIvGKNJliCoijj0As9O0lyqeccSCO3v8oOVjUKJthTxErRQjchdIAw3PMKqbtJmuMxVNo0yWDW7nTnl5hngBJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j71YBxod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j71YBxod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFFCC4CEF7;
	Tue, 17 Feb 2026 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360861;
	bh=luVIYf8Bnsu+WNLjGsv86miZKvT9cphpJKcTEm+lpNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j71YBxodVZvcwplZR1oG7PRDj/Xj1QB23KySsbjyvBr9lKZuabU7VFljPv711rs2j
	 9uiqi6toKRGCTKMhz4cCnKTOnfWsUFtFYDchRp79wBN/oYypBgXQ2K4HuubIobMPtP
	 axW0BICQ8ZI8bwYZxfoRxi3q6LJJEVpIMSTSl8yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+b4444e3c972a7a124187@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/39] f2fs: fix to avoid UAF in f2fs_write_end_io()
Date: Tue, 17 Feb 2026 21:30:57 +0100
Message-ID: <20260217200005.557692741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit ce2739e482bce8d2c014d76c4531c877f382aa54 ]

As syzbot reported an use-after-free issue in f2fs_write_end_io().

It is caused by below race condition:

loop device				umount
- worker_thread
 - loop_process_work
  - do_req_filebacked
   - lo_rw_aio
    - lo_rw_aio_complete
     - blk_mq_end_request
      - blk_update_request
       - f2fs_write_end_io
        - dec_page_count
        - folio_end_writeback
					- kill_f2fs_super
					 - kill_block_super
					  - f2fs_put_super
					 : free(sbi)
       : get_pages(, F2FS_WB_CP_DATA)
         accessed sbi which is freed

In kill_f2fs_super(), we will drop all page caches of f2fs inodes before
call free(sbi), it guarantee that all folios should end its writeback, so
it should be safe to access sbi before last folio_end_writeback().

Let's relocate ckpt thread wakeup flow before folio_end_writeback() to
resolve this issue.

Cc: stable@kernel.org
Fixes: e234088758fc ("f2fs: avoid wait if IO end up when do_checkpoint for better performance")
Reported-by: syzbot+b4444e3c972a7a124187@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b4444e3c972a7a124187
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ folio => page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -358,14 +358,20 @@ static void f2fs_write_end_io(struct bio
 					page->index != nid_of_node(page));
 
 		dec_page_count(sbi, type);
+
+		/*
+		 * we should access sbi before end_page_writeback() to
+		 * avoid racing w/ kill_f2fs_super()
+		 */
+		if (type == F2FS_WB_CP_DATA && !get_pages(sbi, type) &&
+				wq_has_sleeper(&sbi->cp_wait))
+			wake_up(&sbi->cp_wait);
+
 		if (f2fs_in_warm_node_list(sbi, page))
 			f2fs_del_fsync_node_entry(sbi, page);
 		clear_page_private_gcing(page);
 		end_page_writeback(page);
 	}
-	if (!get_pages(sbi, F2FS_WB_CP_DATA) &&
-				wq_has_sleeper(&sbi->cp_wait))
-		wake_up(&sbi->cp_wait);
 
 	bio_put(bio);
 }


