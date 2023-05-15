Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D2BFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C14C433EF;
	Mon, 15 May 2023 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170049;
	bh=CxbJiUdoOwWCub5oUT4dciourSL24OIe77Bt3433Y8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEV2fdxTvxaRZL2UgClFvwNHIGpRKv3QA3yHqbMOU0rIU++hc2vXjVn9Hq01UDv0s
	 Yrv6YEBWjgKdFRR25/pwzOhPFEtLfmWFzHEtjtNTrn4k2BYei0defKsSxLx3PEIyv8
	 MfCPpfr6GL5xSwgg1R54x7f9yEMOx9RWL+fcGK60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+401145a9a237779feb26@syzkaller.appspotmail.com>,
	Borislav Petkov <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.3 241/246] x86: fix clear_user_rep_good() exception handling annotation
Date: Mon, 15 May 2023 18:27:33 +0200
Message-Id: <20230515161729.882088074@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

This code no longer exists in mainline, because it was removed in
commit d2c95f9d6802 ("x86: don't use REP_GOOD or ERMS for user memory
clearing") upstream.

However, rather than backport the full range of x86 memory clearing and
copying cleanups, fix the exception table annotation placement for the
final 'rep movsb' in clear_user_rep_good(): rather than pointing at the
actual instruction that did the user space access, it pointed to the
register move just before it.

That made sense from a code flow standpoint, but not from an actual
usage standpoint: it means that if user access takes an exception, the
exception handler won't actually find the instruction in the exception
tables.

As a result, rather than fixing it up and returning -EFAULT, it would
then turn it into a kernel oops report instead, something like:

    BUG: unable to handle page fault for address: 0000000020081000
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    ...
    RIP: 0010:clear_user_rep_good+0x1c/0x30 arch/x86/lib/clear_page_64.S:147
    ...
    Call Trace:
      __clear_user arch/x86/include/asm/uaccess_64.h:103 [inline]
      clear_user arch/x86/include/asm/uaccess_64.h:124 [inline]
      iov_iter_zero+0x709/0x1290 lib/iov_iter.c:800
      iomap_dio_hole_iter fs/iomap/direct-io.c:389 [inline]
      iomap_dio_iter fs/iomap/direct-io.c:440 [inline]
      __iomap_dio_rw+0xe3d/0x1cd0 fs/iomap/direct-io.c:601
      iomap_dio_rw+0x40/0xa0 fs/iomap/direct-io.c:689
      ext4_dio_read_iter fs/ext4/file.c:94 [inline]
      ext4_file_read_iter+0x4be/0x690 fs/ext4/file.c:145
      call_read_iter include/linux/fs.h:2183 [inline]
      do_iter_readv_writev+0x2e0/0x3b0 fs/read_write.c:733
      do_iter_read+0x2f2/0x750 fs/read_write.c:796
      vfs_readv+0xe5/0x150 fs/read_write.c:916
      do_preadv+0x1b6/0x270 fs/read_write.c:1008
      __do_sys_preadv2 fs/read_write.c:1070 [inline]
      __se_sys_preadv2 fs/read_write.c:1061 [inline]
      __x64_sys_preadv2+0xef/0x150 fs/read_write.c:1061
      do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
      entry_SYSCALL_64_after_hwframe+0x63/0xcd

which then looks like a filesystem bug rather than the incorrect
exception annotation that it is.

[ The alternative to this one-liner fix is to take the upstream series
  that cleans this all up:

    68674f94ffc9 ("x86: don't use REP_GOOD or ERMS for small memory copies")
    20f3337d350c ("x86: don't use REP_GOOD or ERMS for small memory clearing")
    adfcf4231b8c ("x86: don't use REP_GOOD or ERMS for user memory copies")
  * d2c95f9d6802 ("x86: don't use REP_GOOD or ERMS for user memory clearing")
    3639a535587d ("x86: move stac/clac from user copy routines into callers")
    577e6a7fd50d ("x86: inline the 'rep movs' in user copies for the FSRM case")
    8c9b6a88b7e2 ("x86: improve on the non-rep 'clear_user' function")
    427fda2c8a49 ("x86: improve on the non-rep 'copy_user' function")
  * e046fe5a36a9 ("x86: set FSRS automatically on AMD CPUs that have FSRM")
    e1f2750edc4a ("x86: remove 'zerorest' argument from __copy_user_nocache()")
    034ff37d3407 ("x86: rewrite '__copy_user_nocache' function")

  with either the whole series or at a minimum the two marked commits
  being needed to fix this issue ]

Reported-by: syzbot <syzbot+401145a9a237779feb26@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=401145a9a237779feb26
Fixes: 0db7058e8e23 ("x86/clear_user: Make it faster")
Cc: Borislav Petkov <bp@alien8.de>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/clear_page_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -142,8 +142,8 @@ SYM_FUNC_START(clear_user_rep_good)
 	and $7, %edx
 	jz .Lrep_good_exit
 
-.Lrep_good_bytes:
 	mov %edx, %ecx
+.Lrep_good_bytes:
 	rep stosb
 
 .Lrep_good_exit:


