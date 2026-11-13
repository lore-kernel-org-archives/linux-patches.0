Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590766;
	b=vf9RLeDRY8bMSYIFms9dzuKGLx2k6wu5lt12SSXX5wOqvM4eN9w0WsCHNlQjGpXzAZDM
	 OQ26yvmGkW8gpYeVSvTGCfvRr8XULYFbo6AWbZJWIzVWgyhS+gM8Gq2YiB9KkYDWZ3sAu
	 qMFYAcOwiODcdUV8jjHhyHksHn9l8eu+ve/V3OPk50jKInrDmjfpjJ/0D1ZUEueftIZkW
	 SSKGBJATKvb6YuMUQGZ4lmshIJErXMrVbiGl2CyO8dXXTZo0eBI0VGo/1xCgDOxKvEsgT
	 ojCzSwX+vC9vfzueiEt6Zz24EGXzcuh/L5yuwnHF/fMQA90DjCELfoGMbxjkjprtGBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGBLpcSl67VbhHN4EgGsf7VuOCdFrwB3yBOioutFjp8=;
	b=pTT+WTtSMyty1+VC5LWcICtRWqTvtOEyKIH637XTcg+bZboIQfT/1y84hBJBAKMZ2dFN
	 ooZ4dKy58pxw7d2DPGbWVhFmfolSelHyx+U2qrCURJI6MhtTGqvsQgIW29gMb0la8egvZ
	 iXG2Aj734vc1YNMKznJqPWtctCGWogK6g+BMzjVNR6ix6GZKPC4HwGnLi5lwaaW4+a+5b
	 +wAwMdTNVwvZV4ydk6o3JFT4CPOJdFMQWDgjsBxM1mrjYXPlPQ+KebuRgaLuyJsaf0a94
	 jrZnlxeAyqsnjBaTP+vCUc8j6jtKoRTXqOaNJ4yc5FG4zt+oahcl/i/LXLlv2idpJDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5mzsPs4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F411607C343;
	Fri, 13 Nov 2026 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5mzsPs4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDF41F000C4;
	Fri, 13 Nov 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590766;
	bh=KGBLpcSl67VbhHN4EgGsf7VuOCdFrwB3yBOioutFjp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5mzsPs4qj4qWh5LE3TEyDHODxAGTBdwCQc+8N7TW/f9Qc+oJfat2kpbgzFXUYUdV
	 XjUjePlnSj/EHUe9VztPpc+6KsU+zIO6ofsCW8XLKeFZ/lpSZd9OySWc4ktO4WZUuh
	 RKFtsJdqgmfL2kev8O8Pn10EJq1zdEjIQYqR8p7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 647/686] f2fs: fix to invalidate curseg if change_curseg() fails
Date: Fri, 13 Nov 2026 10:53:00 -0500
Message-ID: <20261113153843.702187702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted error-path context to use PTR_ERR(sum_folio) instead of PTR_ERR(entry) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c0ec2715408e8..1097e688d165f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3067,6 +3067,7 @@ static int change_curseg(struct f2fs_sb_info *sbi, int type)
 	if (IS_ERR(sum_folio)) {
 		/* GC won't be able to use stale summary pages by cp_error */
 		memset(curseg->sum_blk, 0, sbi->sum_entry_size);
+		reset_curseg_fields(curseg);
 		return PTR_ERR(sum_folio);
 	}
 	sum_node = SUM_BLK_PAGE_ADDR(sbi, sum_folio, new_segno);
-- 
2.53.0



