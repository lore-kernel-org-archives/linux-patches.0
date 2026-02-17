Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC502773E4;
	Tue, 17 Feb 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361351; cv=none; b=pCCbsuQ59Av2TNnbwlLQsDZEfFe7rx8TTA98gwvFqi8u9O2StUqdAgdg5X7sDd5boF3M2CsucrAZiBSn18Y0IHyc5lWufLWbCiZBLwzyiFuuXlsq9fGM+k/95aAamkde1qT4m6YiDJ5pppbjdbHogGpIy/gLGkVer1g6tzYf19M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361351; c=relaxed/simple;
	bh=e51fEvyXuNpZmy/a1qJH07lUDLFViMeggR57ywjXqcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQD+daeGdXzT8GqgIJRGJrseZDKQzfFW0wner9SL8+Xll1ND74lkwpfVAVjmLg96/bU1GsX36mn55vKtbhB7xoHK0hC38lPiCMtT3+1VaCsNhbTrE1PvUulHdpIijOOfzG7kpPkaD6hep4X083fjzQAvdSur2t6AJRDYT6LzJZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orilhQ6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orilhQ6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F749C4CEF7;
	Tue, 17 Feb 2026 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361351;
	bh=e51fEvyXuNpZmy/a1qJH07lUDLFViMeggR57ywjXqcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orilhQ6NiS6bM1bECt67vf5TkrLKRttZ/7rAGvb/nLch6//LIDHhf8jn+L1nQUFOq
	 egOul4b1xXqIk0jGNZjQe9EBakyL0SOkDO7VUVdT+IVL7fKeupN72LdZE1XyrsOT/H
	 kN0DtIB4PaSqQgq6o05jqS1iS2Jr1PuFxCDlqA6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+b4444e3c972a7a124187@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.19 10/18] f2fs: fix to avoid UAF in f2fs_write_end_io()
Date: Tue, 17 Feb 2026 21:32:06 +0100
Message-ID: <20260217200003.087485020@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit ce2739e482bce8d2c014d76c4531c877f382aa54 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -356,14 +356,20 @@ static void f2fs_write_end_io(struct bio
 				folio->index != nid_of_node(folio));
 
 		dec_page_count(sbi, type);
+
+		/*
+		 * we should access sbi before folio_end_writeback() to
+		 * avoid racing w/ kill_f2fs_super()
+		 */
+		if (type == F2FS_WB_CP_DATA && !get_pages(sbi, type) &&
+				wq_has_sleeper(&sbi->cp_wait))
+			wake_up(&sbi->cp_wait);
+
 		if (f2fs_in_warm_node_list(sbi, folio))
 			f2fs_del_fsync_node_entry(sbi, folio);
 		folio_clear_f2fs_gcing(folio);
 		folio_end_writeback(folio);
 	}
-	if (!get_pages(sbi, F2FS_WB_CP_DATA) &&
-				wq_has_sleeper(&sbi->cp_wait))
-		wake_up(&sbi->cp_wait);
 
 	bio_put(bio);
 }


