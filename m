Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465FE3E3D8F;
	Mon,  4 May 2026 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904871; cv=none; b=RzwJg15qgP5n0mupcNWKPNGdyshH6mlzYRijG//XldrcA4LRduT70jlcJY4bkaqe94CY1dEGGaQVi5hJjsD/V459NyCJ6cw5Bg1y9/Ro/HFo5DEXkt5bwWkaRr5ZPZ2UFyb1y7XPTLmkmhQ5yecfDqcmvUYkgUKDVJi4uF939fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904871; c=relaxed/simple;
	bh=kPoDmjoyScaVAYznQs9yrP7VRiOZdZ29AMH5AJaL/yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR2+Z6SuZ23Fk9KYbYg0t0j/W1R9hZLIdjZJK9uU4/aJprQhcqyjQRq6Jo+5awVA+K6GovAc55ekOQZeF8jdEQZNAUJ3VMuSmh0pKLxHAN+ypZrmzYTC4qwjp3VH+9aneYCP6rOIqrxcRlgesP2opfzKeOli9EdLQhXbKTLmIyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQY14o+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQY14o+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E88C2BCB8;
	Mon,  4 May 2026 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904871;
	bh=kPoDmjoyScaVAYznQs9yrP7VRiOZdZ29AMH5AJaL/yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQY14o+xqnF0cig6hstoyFhv2zDVzetWfDXOTkDFOYyQfO+P3nezVcmmZLlzejvnE
	 DVuM01j7g7rCnqEdD8V8gCwGfYLNxSiQDo6Mm3u+9eo9GY2bWgY0nT2LlXUAqX3IiK
	 LRfF2I1YYRIW2Wh9bfM1VaVaO6F3TBon7xwlLWUo=
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
Subject: [PATCH 6.12 174/215] f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()
Date: Mon,  4 May 2026 15:53:13 +0200
Message-ID: <20260504135136.551763603@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,6 +355,8 @@ static void f2fs_write_end_io(struct bio
 
 		f2fs_bug_on(sbi, page->mapping == NODE_MAPPING(sbi) &&
 				page_folio(page)->index != nid_of_node(page));
+		if (f2fs_in_warm_node_list(sbi, page))
+			f2fs_del_fsync_node_entry(sbi, page);
 
 		dec_page_count(sbi, type);
 
@@ -366,8 +368,6 @@ static void f2fs_write_end_io(struct bio
 				wq_has_sleeper(&sbi->cp_wait))
 			wake_up(&sbi->cp_wait);
 
-		if (f2fs_in_warm_node_list(sbi, page))
-			f2fs_del_fsync_node_entry(sbi, page);
 		clear_page_private_gcing(page);
 		end_page_writeback(page);
 	}


