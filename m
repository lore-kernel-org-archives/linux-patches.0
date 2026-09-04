Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88FF405C3F;
	Fri,  4 Sep 2026 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501932; cv=none; b=ZSO2zWxrUigwAF38gHSamEglSCMGyWmBbstwfeaX2cqgPFPV8RY+uIfm/IPmp7DxLjt7vjPnwaUAFlSpPpzoiuBfdlMOB6Ul6kQm5DWjmCSKHGfaUdHC4ZM8IUApF1Cn4ebhNJnAvjYi+VJucgxnVdgGIC7lxiE+OOuqRIOarMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501932; c=relaxed/simple;
	bh=LJY1/2ozq4uMSv6Bn9mtYaq6y1mSa5nQSWDfaoKGSLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=En2qOBefTo7KCsPOxRH5u5glqwYroN1cukWjHN+OnN2vDyDGxVqLBFLOEdDl9peRLTItn+P/CcOscwwLdDdgn+QsGfhaxXvlGwgsLX49BRKY+2I8SGDvdIkwcQME3A/GKGexW6kpomTCpM6BckBR8J3jS3XLXzVBlixoBTNMv78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q95FxseX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q95FxseX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB631F00A3D;
	Fri,  4 Sep 2026 06:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501930;
	bh=K/ZrbUxRS6/FQWQo8LyOHi+6UxpWQU3UYWzyN5uBiY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q95FxseXq7c/El3/3raGTnHC/Izr/q3ab6bCY43+nR11fD+Us+k09bgYbdbPXrPWh
	 bHTvg9qbeTkNVeJuvBLJTsvdfNTcqimd0ZjEW5ov/+qkvo96SZasmaME+YaC0AgVsI
	 2I9jxss4acqh4Y5AXE1u3VY4zJjq3th+wSzy1xe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/403] f2fs: fix potential deadloop in prepare_compress_overwrite()
Date: Fri,  4 Sep 2026 06:56:46 +0200
Message-ID: <20260904045734.887531784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 3147ee567dd9004a49826ddeaf0a4b12865d4409 ]

Jan Prusakowski reported a kernel hang issue as below:

When running xfstests on linux-next kernel (6.14.0-rc3, 6.12) I
encountered a problem in generic/475 test where fsstress process
gets blocked in __f2fs_write_data_pages() and the test hangs.
The options I used are:

MKFS_OPTIONS  -- -O compression -O extra_attr -O project_quota -O quota /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o discard,compress_extension=* /dev/vdc /vdc

INFO: task kworker/u8:0:11 blocked for more than 122 seconds.
      Not tainted 6.14.0-rc3-xfstests-lockdep #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:0    state:D stack:0     pid:11    tgid:11    ppid:2      task_flags:0x4208160 flags:0x00004000
Workqueue: writeback wb_workfn (flush-253:0)
Call Trace:
 <TASK>
 __schedule+0x309/0x8e0
 schedule+0x3a/0x100
 schedule_preempt_disabled+0x15/0x30
 __mutex_lock+0x59a/0xdb0
 __f2fs_write_data_pages+0x3ac/0x400
 do_writepages+0xe8/0x290
 __writeback_single_inode+0x5c/0x360
 writeback_sb_inodes+0x22f/0x570
 wb_writeback+0xb0/0x410
 wb_do_writeback+0x47/0x2f0
 wb_workfn+0x5a/0x1c0
 process_one_work+0x223/0x5b0
 worker_thread+0x1d5/0x3c0
 kthread+0xfd/0x230
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30
 </TASK>

The root cause is: once generic/475 starts toload error table to dm
device, f2fs_prepare_compress_overwrite() will loop reading compressed
cluster pages due to IO error, meanwhile it has held .writepages lock,
it can block all other writeback tasks.

Let's fix this issue w/ below changes:
- add f2fs_handle_page_eio() in prepare_compress_overwrite() to
detect IO error.
- detect cp_error earler in f2fs_read_multi_pages().

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reported-by: Jan Prusakowski <jprusakowski@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c |  1 +
 fs/f2fs/data.c     | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c2ec80c82b6de..9e7fb8d883099 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1141,6 +1141,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		f2fs_compress_ctx_add_page(cc, page_folio(page));
 
 		if (!PageUptodate(page)) {
+			f2fs_handle_page_eio(sbi, page_folio(page), DATA);
 release_and_retry:
 			f2fs_put_rpages(cc);
 			f2fs_unlock_rpages(cc, i + 1);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 16c15360605b0..ec816df4887cc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2250,6 +2250,12 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 	int i;
 	int ret = 0;
 
+	if (unlikely(f2fs_cp_error(sbi))) {
+		ret = -EIO;
+		from_dnode = false;
+		goto out_put_dnode;
+	}
+
 	f2fs_bug_on(sbi, f2fs_cluster_is_empty(cc));
 
 	last_block_in_file = F2FS_BYTES_TO_BLK(f2fs_readpage_limit(inode) +
@@ -2293,10 +2299,6 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 	if (ret)
 		goto out;
 
-	if (unlikely(f2fs_cp_error(sbi))) {
-		ret = -EIO;
-		goto out_put_dnode;
-	}
 	f2fs_bug_on(sbi, dn.data_blkaddr != COMPRESS_ADDR);
 
 skip_reading_dnode:
-- 
2.53.0



