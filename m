Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2545221F10;
	Mon,  2 Jun 2025 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877383; cv=none; b=r0HC02z0rq90sN4IGmJvO8DJsXztiPET3rMblg/SfajKNYm+GixDaOdspmMVcbBzcZ2QkATtvUrO3P+TJzpngrlrXDraNP3kme/yP0+Y9CxhmTuHeU6xXz0msCOhbvRaPpXeoNu3QlDp0d15wvcpCuaOTW3+XGyPphDYwaXiFAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877383; c=relaxed/simple;
	bh=PmM690IWJNcOwMtN5ZNdami2z0fMDaz+6phHWjiYVec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwIiQKiLa6NhCTGaMwwbs28XFyHwExuMsr9L7K86TZklUeH3zYAG0CzQsaCYrs12Dmlnos+am+8slrnfeIj6h6pRGV9c77f5faGv/irUx6q/O8sHAce6tA6RCbQYIMtIVEKlfUa/3RRgAOtJpEWD4KjdXgPZOktuyKX5eelVOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x4Dv7L6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x4Dv7L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F747C4CEEE;
	Mon,  2 Jun 2025 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877382;
	bh=PmM690IWJNcOwMtN5ZNdami2z0fMDaz+6phHWjiYVec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0x4Dv7L6f+0iF0yoLt2YUp+g3L+OIKUVxn3KzU6V1jFkqz105o0z1vL5mtr5I6BRR
	 FZCEPAi/kn+eE9RB5XItdTmBLhysVGWnVaGbQZy5QqFcpts5Jv4BkykxmLFSf0H4S0
	 Q1KJ+TsKCsYMWRQMt492RG1rJ3yOKR8M+hIa1bhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 260/325] smb: client: Fix use-after-free in cifs_fill_dirent
Date: Mon,  2 Jun 2025 15:48:56 +0200
Message-ID: <20250602134330.340149528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong1@huawei.com>

commit a7a8fe56e932a36f43e031b398aef92341bf5ea0 upstream.

There is a race condition in the readdir concurrency process, which may
access the rsp buffer after it has been released, triggering the
following KASAN warning.

 ==================================================================
 BUG: KASAN: slab-use-after-free in cifs_fill_dirent+0xb03/0xb60 [cifs]
 Read of size 4 at addr ffff8880099b819c by task a.out/342975

 CPU: 2 UID: 0 PID: 342975 Comm: a.out Not tainted 6.15.0-rc6+ #240 PREEMPT(full)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x53/0x70
  print_report+0xce/0x640
  kasan_report+0xb8/0xf0
  cifs_fill_dirent+0xb03/0xb60 [cifs]
  cifs_readdir+0x12cb/0x3190 [cifs]
  iterate_dir+0x1a1/0x520
  __x64_sys_getdents+0x134/0x220
  do_syscall_64+0x4b/0x110
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7f996f64b9f9
 Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
 f0 ff ff  0d f7 c3 0c 00 f7 d8 64 89 8
 RSP: 002b:00007f996f53de78 EFLAGS: 00000207 ORIG_RAX: 000000000000004e
 RAX: ffffffffffffffda RBX: 00007f996f53ecdc RCX: 00007f996f64b9f9
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
 RBP: 00007f996f53dea0 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000207 R12: ffffffffffffff88
 R13: 0000000000000000 R14: 00007ffc8cd9a500 R15: 00007f996f51e000
  </TASK>

 Allocated by task 408:
  kasan_save_stack+0x20/0x40
  kasan_save_track+0x14/0x30
  __kasan_slab_alloc+0x6e/0x70
  kmem_cache_alloc_noprof+0x117/0x3d0
  mempool_alloc_noprof+0xf2/0x2c0
  cifs_buf_get+0x36/0x80 [cifs]
  allocate_buffers+0x1d2/0x330 [cifs]
  cifs_demultiplex_thread+0x22b/0x2690 [cifs]
  kthread+0x394/0x720
  ret_from_fork+0x34/0x70
  ret_from_fork_asm+0x1a/0x30

 Freed by task 342979:
  kasan_save_stack+0x20/0x40
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x37/0x50
  kmem_cache_free+0x2b8/0x500
  cifs_buf_release+0x3c/0x70 [cifs]
  cifs_readdir+0x1c97/0x3190 [cifs]
  iterate_dir+0x1a1/0x520
  __x64_sys_getdents64+0x134/0x220
  do_syscall_64+0x4b/0x110
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 The buggy address belongs to the object at ffff8880099b8000
  which belongs to the cache cifs_request of size 16588
 The buggy address is located 412 bytes inside of
  freed 16588-byte region [ffff8880099b8000, ffff8880099bc0cc)

 The buggy address belongs to the physical page:
 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x99b8
 head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 anon flags: 0x80000000000040(head|node=0|zone=1)
 page_type: f5(slab)
 raw: 0080000000000040 ffff888001e03400 0000000000000000 dead000000000001
 raw: 0000000000000000 0000000000010001 00000000f5000000 0000000000000000
 head: 0080000000000040 ffff888001e03400 0000000000000000 dead000000000001
 head: 0000000000000000 0000000000010001 00000000f5000000 0000000000000000
 head: 0080000000000003 ffffea0000266e01 00000000ffffffff 00000000ffffffff
 head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8880099b8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880099b8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff8880099b8180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff8880099b8200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880099b8280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

POC is available in the link [1].

The problem triggering process is as follows:

Process 1                       Process 2
-----------------------------------------------------------------
cifs_readdir
  /* file->private_data == NULL */
  initiate_cifs_search
    cifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
    smb2_query_dir_first ->query_dir_first()
      SMB2_query_directory
        SMB2_query_directory_init
        cifs_send_recv
        smb2_parse_query_directory
          srch_inf->ntwrk_buf_start = (char *)rsp;
          srch_inf->srch_entries_start = (char *)rsp + ...
          srch_inf->last_entry = (char *)rsp + ...
          srch_inf->smallBuf = true;
  find_cifs_entry
    /* if (cfile->srch_inf.ntwrk_buf_start) */
    cifs_small_buf_release(cfile->srch_inf // free

                        cifs_readdir  ->iterate_shared()
                          /* file->private_data != NULL */
                          find_cifs_entry
                            /* in while (...) loop */
                            smb2_query_dir_next  ->query_dir_next()
                              SMB2_query_directory
                                SMB2_query_directory_init
                                cifs_send_recv
                                  compound_send_recv
                                    smb_send_rqst
                                    __smb_send_rqst
                                      rc = -ERESTARTSYS;
                                      /* if (fatal_signal_pending()) */
                                      goto out;
                                      return rc
                            /* if (cfile->srch_inf.last_entry) */
                            cifs_save_resume_key()
                              cifs_fill_dirent // UAF
                            /* if (rc) */
                            return -ENOENT;

Fix this by ensuring the return code is checked before using pointers
from the srch_inf.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220131 [1]
Fixes: a364bc0b37f1 ("[CIFS] fix saving of resume key before CIFSFindNext")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/readdir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -788,11 +788,11 @@ find_cifs_entry(const unsigned int xid,
 		rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
 						 search_flags,
 						 &cfile->srch_inf);
+		if (rc)
+			return -ENOENT;
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
 		if (cfile->srch_inf.last_entry)
 			cifs_save_resume_key(cfile->srch_inf.last_entry, cfile);
-		if (rc)
-			return -ENOENT;
 	}
 	if (index_to_find < cfile->srch_inf.index_of_last_entry) {
 		/* we found the buffer that contains the entry */


