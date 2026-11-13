Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585930;
	b=QxbeiU280jXElYOFdEaujkH5hdsEyRmiMwUZ2QVZ/mt1yYIZjbtNk9qFH4h8lUMJTaee
	 z2ksAuP1DGoQfrQRzsjRizxBMYMW8Lj8tfSV15goerEmWsY1F7G4nfZNhUbPQ1kc2zxfj
	 k69pXM5JjPCkFmFtjCZ5DQt4Je4ZzI7B+94wCmJSV5+462++3jGCTFhCtVx3FvPLxWIr3
	 auPduLHUwZbikoRqP64GWcKTAejPjqxSohtKWzZ9W5wW5HuYuqnC8RyaORBKXVE6Vmrax
	 VA06BFTqwZNRZ3+SRY/VhBjPbafjK7TsXUc2aGIfpVQjqTnGBsdzcSSS4wCnVSZtxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHPWFtLAbewQOF3Cfewnc8D7VINlPn27nPvOnVA0EbE=;
	b=SCQnCCeFfcC9Elii8gHmmtsW9mYB+NBQj937X2bI7J8vTWwQuKgPoIqAIcbtzldX4TZV
	 X2cKRowm+dh8bn1uh2hS0lWCu6vo/H0fpchGZl9pnQL8R833IuIK40qT0g2tA/vv2uac0
	 lrcUSll7TcVMYumcIB+PQ4HPlCY2RELAum5odsHJvvDBiudprnJRJm3xFHHF6lwnhzW2+
	 nwpFncO4bSQe/9oKsHCvkc8rmEiSvgLYJ9jgVPiNQzsGLRhEGUxOzFeZUs6aSIqx39AhQ
	 g7HEHG7AYKYHvkagwdoutpN5otKSwK4NcV/zh3ZYmWcyoQmLE4kOO/f0XPE87ft4AHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XX3C4XN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504A46070235;
	Fri, 13 Nov 2026 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XX3C4XN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA4F1F000C4;
	Fri, 13 Nov 2026 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585930;
	bh=dHPWFtLAbewQOF3Cfewnc8D7VINlPn27nPvOnVA0EbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XX3C4XN6vI9fKopPb8xokHqQqSEu5U0HtCc5wehEBdmhCF5Myx7uiKFIJBFzOcIIO
	 +U2To7Sfg72uvqRyGRvIMfY6YXlPnvoX5g5aCWfTpEOHdFu9niLtwTdZYx/BBFyQ1F
	 7mKZ94r/FR9HaExhHQiDoFO7TgqdR1V3dbhTd/K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 488/507] f2fs: fix to invalidate curseg if change_curseg() fails
Date: Fri, 13 Nov 2026 10:53:12 -0500
Message-ID: <20261113153813.613939581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e74476ad8162c1facc74b74ce2d1372492df872e ]

Our consistency stress test (fsstress + fio + atomic write workers +
"f2fs_io shutdown 1") triggers below kernel BUG:

 F2FS-fs (vdd): Stopped filesystem due to reason: 0
 ------------[ cut here ]------------
 kernel BUG at fs/f2fs/segment.c:3989!
 Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
 Workqueue: writeback wb_workfn (flush-253:48)
 RIP: 0010:f2fs_allocate_data_block+0x257a/0x38e0
 Call Trace:
  <TASK>
  do_write_block+0x155/0xc10
  f2fs_outplace_write_data+0x192/0x340
  f2fs_do_write_data_page+0xc57/0x1880
  f2fs_write_single_data_page+0xda9/0x15a0
  f2fs_write_cache_pages+0x973/0x1f20
  __f2fs_write_data_pages+0x6c4/0x1890
  do_writepages+0x21e/0x560
  __writeback_single_inode+0x119/0x11b0
  writeback_sb_inodes+0x67d/0x17a0
  wb_writeback+0x207/0x820
  wb_workfn+0x128/0xc30
  process_one_work+0x925/0x1600
  worker_thread+0x60a/0xff0
  kthread+0x35f/0x460
  ret_from_fork+0x474/0x7e0
  ret_from_fork_asm+0x1a/0x30
  </TASK>

The BUG is f2fs_bug_on(sbi, curseg->next_blkoff >= BLKS_PER_SEG(sbi))
in f2fs_allocate_data_block(), next_blkoff was 512.

The root cause is a race in between atomic write commit and shutdown
as below:

Thread A (commit atomic write)  Thread B (shutdown)        Thread C (writeback)
- f2fs_ioc_commit_atomic_write
 - f2fs_commit_atomic_write
  - __f2fs_commit_atomic_write
   - __replace_atomic_write_block
    - f2fs_replace_block
     - __f2fs_replace_block
                                - f2fs_ioc_shutdown
                                 - f2fs_do_shutdown
                                 : F2FS_GOING_DOWN_METASYNC
                                  - f2fs_sync_fs
                                                           - f2fs_write_single_data_page
                                                           : pass f2fs_cp_error() check
                                  - f2fs_stop_checkpoint
                                  : set CP_ERROR_FLAG
      - change_curseg
       - reset_curseg
       : curseg->segno = new_segno
       : curseg->alloc_type = SSR
       : curseg->next_blkoff = __next_free_blkoff()
         which is BLKS_PER_SEG if there is no free
         slot in new_segno
       - f2fs_get_sum_cache
       : return -EIO due to f2fs_cp_error()
      : return error w/o restoring curseg
     : goto out_unlock, skip restoring
       old segno, blkoff and alloc_type
                                                            - f2fs_do_write_data_page
                                                             - f2fs_outplace_write_data
                                                              - do_write_block
                                                               - f2fs_allocate_data_block
                                                               : curseg->segno is valid
                                                               : f2fs_bug_on(next_blkoff >=
                                                                 BLKS_PER_SEG)

Since commit 86f33603f8c5 ("f2fs: handle errors of
f2fs_get_meta_page_nofail"), change_curseg() can fail after the curseg
has already been switched to the new segment, then the curseg is left
in an inconsistent state: it points to a segment which may have no
free slot, its summary block is zeroed, and the caller can not restore
it. Subsequent block allocation on the curseg will trigger the BUG.
Moreover, the writeback thread dies with curseg_lock, curseg_mutex and
sentry_lock held, so the commit, shutdown and other I/O threads hang
in D state.

Since change_curseg() only fails once CP_ERROR_FLAG is set, no
checkpoint will be committed afterward, let's invalidate the curseg via
reset_curseg_fields() on failure, as new_curseg() does for -ENOSPC,
then f2fs_allocate_data_block() will fail with -ENOSPC on the curseg
instead of triggering BUG, and do_write_block() can handle the error
since CP_ERROR_FLAG has been set.

Cc: stable@kernel.org
Fixes: 86f33603f8c5 ("f2fs: handle errors of f2fs_get_meta_page_nofail")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Adjusted context to retain the existing folio summary API instead of the upstream cached-block API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 09d044c6a166d..75f78ed7eb909 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3234,6 +3234,7 @@ static int change_curseg(struct f2fs_sb_info *sbi, int type)
 	if (IS_ERR(sum_folio)) {
 		/* GC won't be able to use stale summary pages by cp_error */
 		memset(curseg->sum_blk, 0, sbi->sum_entry_size);
+		reset_curseg_fields(curseg);
 		return PTR_ERR(sum_folio);
 	}
 	sum_node = SUM_BLK_PAGE_ADDR(sbi, sum_folio, new_segno);
-- 
2.53.0



