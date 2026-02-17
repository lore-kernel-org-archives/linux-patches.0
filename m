Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7F377563;
	Tue, 17 Feb 2026 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360952; cv=none; b=tSaXrUoj4PyA/tZSbKrncPc4i43UUTMSe7HWTyzwJu43WUOgxM5R4fRISNCM8SMCY196bWW/omCvK5s6f6Jmx7PM6dAMgWHtmxhwJpqxR9l+OFTPl0PJLg+9NZnjaQ7DBw8gdAoJ7KQ5BpX/p/hZmEONnE8TYNRUnPu//SBo68c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360952; c=relaxed/simple;
	bh=QAULLIIeL6kDo1xY06WdBMC2o3WIN+xK7ZspELDQ8SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riCuXT2lfXTFe/qwjdzRf/7+d7oW7cIz1guR5sSfqA7GdY4N0tWgEF4nso6n2mnR78twtenKvyKp2FMqzefzGO6q7B+DMi+hErUxC6XAHwYiAi3q5Z9SJQzn0KUI+7jSyiAwkYwQHaCXVhcnRozfHQhbx9oH6j/OJ9PGYPTroLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb7lWGRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb7lWGRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE30C4CEF7;
	Tue, 17 Feb 2026 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360952;
	bh=QAULLIIeL6kDo1xY06WdBMC2o3WIN+xK7ZspELDQ8SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb7lWGRWdT6G1xW+Ux9oxwi+f3+NAteGAxC4SmPhJWIJAn7eg6+4IsGjgXzREqk7I
	 SkCFeDTYNlOL2LnaCcVNst3EbVBGtjSdoSG/woQibH/8pOMdUyWOIzqJmx7To1uLzX
	 +fgRAKXY7ZfQMfXJLLiWX9NbVoyNAMRnJ7MC9Bkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+b4444e3c972a7a124187@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/24] f2fs: fix to avoid UAF in f2fs_write_end_io()
Date: Tue, 17 Feb 2026 21:31:36 +0100
Message-ID: <20260217200001.609203814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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
@@ -379,14 +379,20 @@ static void f2fs_write_end_io(struct bio
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
 		clear_cold_data(page);
 		end_page_writeback(page);
 	}
-	if (!get_pages(sbi, F2FS_WB_CP_DATA) &&
-				wq_has_sleeper(&sbi->cp_wait))
-		wake_up(&sbi->cp_wait);
 
 	bio_put(bio);
 }


