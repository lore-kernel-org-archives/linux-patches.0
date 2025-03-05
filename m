Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC150178CC8;
	Wed,  5 Mar 2025 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198544; cv=none; b=q5HFtrmR0eMslhMWaD1aGvtUOvehCdlJcFikMTh0UJ7adqpusbakw/T4mBxlzDKd5TkWArWZvIZ9muLVu0ZLBvMaBLAAPW8oggT/tQQl7VAMIx2GgwnsSX9YTuJRriLO6P+8YMKblyUivzT6gzgGJEOG1aYcm0XQ8/n8K0IUqnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198544; c=relaxed/simple;
	bh=Aku5J7KM7sYTbhxKjbwK8Y/d5VfJVGCyU+WIOq9916I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oG8NvNhO/ztg7o5x7r5CdYkvwA1hfiZmuLCHRd1ECUp9lUyiM2XVpBoPo2G7sb9nIZ6D+jNkuH7pzpQ2ditEIRaiMzYvGQhy/OTXxrzB44he0IX0hOPB3CkM9drh4fD4NdC1LZ9wH0qH8Uv3bOdrCaxO+T3ufPU9afQl91BXs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZvGRDSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZvGRDSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A30AC4CED1;
	Wed,  5 Mar 2025 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198544;
	bh=Aku5J7KM7sYTbhxKjbwK8Y/d5VfJVGCyU+WIOq9916I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZvGRDSqXjNEWGKtksBzf5jrWpMqb+bpQeEvR7y6ThKc0J5vdLaW0PiYVO2Cxhhee
	 KQoDPEd/NeA5rxmMIYFzpYSGRn2DMii474kqzvvpgSbgYDgyW3v8IVol1oapVcAK2a
	 +gHEnb2wq/OTbwM+uGwZwVYUqodBSxDNGTWKsUTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/157] uprobes: Reject the shared zeropage in uprobe_write_opcode()
Date: Wed,  5 Mar 2025 18:48:21 +0100
Message-ID: <20250305174507.916832058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit bddf10d26e6e5114e7415a0e442ec6f51a559468 ]

We triggered the following crash in syzkaller tests:

  BUG: Bad page state in process syz.7.38  pfn:1eff3
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1eff3
  flags: 0x3fffff00004004(referenced|reserved|node=0|zone=1|lastcpupid=0x1fffff)
  raw: 003fffff00004004 ffffe6c6c07bfcc8 ffffe6c6c07bfcc8 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000fffffffe 0000000000000000
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x32/0x50
   bad_page+0x69/0xf0
   free_unref_page_prepare+0x401/0x500
   free_unref_page+0x6d/0x1b0
   uprobe_write_opcode+0x460/0x8e0
   install_breakpoint.part.0+0x51/0x80
   register_for_each_vma+0x1d9/0x2b0
   __uprobe_register+0x245/0x300
   bpf_uprobe_multi_link_attach+0x29b/0x4f0
   link_create+0x1e2/0x280
   __sys_bpf+0x75f/0xac0
   __x64_sys_bpf+0x1a/0x30
   do_syscall_64+0x56/0x100
   entry_SYSCALL_64_after_hwframe+0x78/0xe2

   BUG: Bad rss-counter state mm:00000000452453e0 type:MM_FILEPAGES val:-1

The following syzkaller test case can be used to reproduce:

  r2 = creat(&(0x7f0000000000)='./file0\x00', 0x8)
  write$nbd(r2, &(0x7f0000000580)=ANY=[], 0x10)
  r4 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x42, 0x0)
  mmap$IORING_OFF_SQ_RING(&(0x7f0000ffd000/0x3000)=nil, 0x3000, 0x0, 0x12, r4, 0x0)
  r5 = userfaultfd(0x80801)
  ioctl$UFFDIO_API(r5, 0xc018aa3f, &(0x7f0000000040)={0xaa, 0x20})
  r6 = userfaultfd(0x80801)
  ioctl$UFFDIO_API(r6, 0xc018aa3f, &(0x7f0000000140))
  ioctl$UFFDIO_REGISTER(r6, 0xc020aa00, &(0x7f0000000100)={{&(0x7f0000ffc000/0x4000)=nil, 0x4000}, 0x2})
  ioctl$UFFDIO_ZEROPAGE(r5, 0xc020aa04, &(0x7f0000000000)={{&(0x7f0000ffd000/0x1000)=nil, 0x1000}})
  r7 = bpf$PROG_LOAD(0x5, &(0x7f0000000140)={0x2, 0x3, &(0x7f0000000200)=ANY=[@ANYBLOB="1800000000120000000000000000000095"], &(0x7f0000000000)='GPL\x00', 0x7, 0x0, 0x0, 0x0, 0x0, '\x00', 0x0, @fallback=0x30, 0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x0, @void, @value}, 0x94)
  bpf$BPF_LINK_CREATE_XDP(0x1c, &(0x7f0000000040)={r7, 0x0, 0x30, 0x1e, @val=@uprobe_multi={&(0x7f0000000080)='./file0\x00', &(0x7f0000000100)=[0x2], 0x0, 0x0, 0x1}}, 0x40)

The cause is that zero pfn is set to the PTE without increasing the RSS
count in mfill_atomic_pte_zeropage() and the refcount of zero folio does
not increase accordingly. Then, the operation on the same pfn is performed
in uprobe_write_opcode()->__replace_page() to unconditional decrease the
RSS count and old_folio's refcount.

Therefore, two bugs are introduced:

 1. The RSS count is incorrect, when process exit, the check_mm() report
    error "Bad rss-count".

 2. The reserved folio (zero folio) is freed when folio->refcount is zero,
    then free_pages_prepare->free_page_is_bad() report error
    "Bad page state".

There is more, the following warning could also theoretically be triggered:

  __replace_page()
    -> ...
      -> folio_remove_rmap_pte()
        -> VM_WARN_ON_FOLIO(is_zero_folio(folio), folio)

Considering that uprobe hit on the zero folio is a very rare case, just
reject zero old folio immediately after get_user_page_vma_remote().

[ mingo: Cleaned up the changelog ]

Fixes: 7396fa818d62 ("uprobes/core: Make background page replacement logic account for rss_stat counters")
Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20250224031149.1598949-1-tongtiangen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7f1a95b4f14de..e11e2df50a3ee 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -495,6 +495,11 @@ int uprobe_write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	if (ret <= 0)
 		goto put_old;
 
+	if (is_zero_page(old_page)) {
+		ret = -EINVAL;
+		goto put_old;
+	}
+
 	if (WARN(!is_register && PageCompound(old_page),
 		 "uprobe unregister should never work on compound page\n")) {
 		ret = -EINVAL;
-- 
2.39.5



