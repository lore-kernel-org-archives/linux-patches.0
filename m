Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D75A94D
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC39C433C7;
	Mon, 28 Aug 2023 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218013;
	bh=dGE/1pNTSjdA7j0z9Om04BXIz863Pk1bqJn8Z7YIECI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrKmonk9aPAWLZvYuHRDrqFCDbAwAgA+guwmP11PmvbGgzunJEgrKJcqNOhCZIuRc
	 XQLK0VjxZLpZtfC5QHFDt+wC+AtLIov67bUHdVPcQsmVc8zVFEW4xdz+dF9avihtKL
	 klzEXhboUrqMEZZ/h313myX85fY2t0V/sbmU0IkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayush Jain <ayush.jain3@amd.com>,
	Raghavendra K T <raghavendra.kt@amd.com>,
	John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 063/129] selftests/mm: FOLL_LONGTERM need to be updated to 0x100
Date: Mon, 28 Aug 2023 12:12:22 +0200
Message-ID: <20230828101159.454479442@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Jain <ayush.jain3@amd.com>

commit 1738b949625c7e17a454b25de33f1f415da3db69 upstream.

After commit 2c2241081f7d ("mm/gup: move private gup FOLL_ flags to
internal.h") FOLL_LONGTERM flag value got updated from 0x10000 to 0x100 at
include/linux/mm_types.h.

As hmm.hmm_device_private.hmm_gup_test uses FOLL_LONGTERM Updating same
here as well.

Before this change test goes in an infinite assert loop in
hmm.hmm_device_private.hmm_gup_test
==========================================================
 RUN           hmm.hmm_device_private.hmm_gup_test ...
hmm-tests.c:1962:hmm_gup_test:Expected HMM_DMIRROR_PROT_WRITE..
..(2) == m[2] (34)
hmm-tests.c:157:hmm_gup_test:Expected ret (-1) == 0 (0)
hmm-tests.c:157:hmm_gup_test:Expected ret (-1) == 0 (0)
...
==========================================================

 Call Trace:
 <TASK>
 ? sched_clock+0xd/0x20
 ? __lock_acquire.constprop.0+0x120/0x6c0
 ? ktime_get+0x2c/0xd0
 ? sched_clock+0xd/0x20
 ? local_clock+0x12/0xd0
 ? lock_release+0x26e/0x3b0
 pin_user_pages_fast+0x4c/0x70
 gup_test_ioctl+0x4ff/0xbb0
 ? gup_test_ioctl+0x68c/0xbb0
 __x64_sys_ioctl+0x99/0xd0
 do_syscall_64+0x60/0x90
 ? syscall_exit_to_user_mode+0x2a/0x50
 ? do_syscall_64+0x6d/0x90
 ? syscall_exit_to_user_mode+0x2a/0x50
 ? do_syscall_64+0x6d/0x90
 ? irqentry_exit_to_user_mode+0xd/0x20
 ? irqentry_exit+0x3f/0x50
 ? exc_page_fault+0x96/0x200
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f6aaa31aaff

After this change test is able to pass successfully.

Link: https://lkml.kernel.org/r/20230808124347.79163-1-ayush.jain3@amd.com
Fixes: 2c2241081f7d ("mm/gup: move private gup FOLL_ flags to internal.h")
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 4adaad1b822f..20294553a5dd 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -57,9 +57,14 @@ enum {
 
 #define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 /* Just the flags we need, copied from mm.h: */
-#define FOLL_WRITE	0x01	/* check pte is writable */
-#define FOLL_LONGTERM   0x10000 /* mapping lifetime is indefinite */
 
+#ifndef FOLL_WRITE
+#define FOLL_WRITE	0x01	/* check pte is writable */
+#endif
+
+#ifndef FOLL_LONGTERM
+#define FOLL_LONGTERM   0x100 /* mapping lifetime is indefinite */
+#endif
 FIXTURE(hmm)
 {
 	int		fd;
-- 
2.42.0



