Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442A1C2A8
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkvUcwdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4997C433C8;
	Wed,  4 Oct 2023 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444602;
	bh=17yKl22E0CiXI4CvvIDsD4Dary9ixQbykQSqHiN54KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkvUcwdDXt2BlWTyEfb1V1zT6kCX0lv6aLJKyY5TwvhgYiGCp99dXyM9z08tiRusM
	 w2f1+tgFC/DayiPDavQr3zav5iGhu+ucBxGNuEyzwWZd6/wcad3fkF2Ei8iB3nBaaY
	 KdDvRaN69TWQNYPEo9Lp5leCLVR1+jaJOomJLC7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 280/321] mm/damon/vaddr-test: fix memory leak in damon_do_test_apply_three_regions()
Date: Wed,  4 Oct 2023 19:57:05 +0200
Message-ID: <20231004175242.258420846@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 45120b15743fa7c0aa53d5db6dfb4c8f87be4abd upstream.

When CONFIG_DAMON_VADDR_KUNIT_TEST=y and making CONFIG_DEBUG_KMEMLEAK=y
and CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y, the below memory leak is detected.

Since commit 9f86d624292c ("mm/damon/vaddr-test: remove unnecessary
variables"), the damon_destroy_ctx() is removed, but still call
damon_new_target() and damon_new_region(), the damon_region which is
allocated by kmem_cache_alloc() in damon_new_region() and the damon_target
which is allocated by kmalloc in damon_new_target() are not freed.  And
the damon_region which is allocated in damon_new_region() in
damon_set_regions() is also not freed.

So use damon_destroy_target to free all the damon_regions and damon_target.

    unreferenced object 0xffff888107c9a940 (size 64):
      comm "kunit_try_catch", pid 1069, jiffies 4294670592 (age 732.761s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        60 c7 9c 07 81 88 ff ff f8 cb 9c 07 81 88 ff ff  `...............
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c82be>] damon_test_apply_three_regions1+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff8881079cc740 (size 56):
      comm "kunit_try_catch", pid 1069, jiffies 4294670592 (age 732.761s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c82be>] damon_test_apply_three_regions1+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888107c9ac40 (size 64):
      comm "kunit_try_catch", pid 1071, jiffies 4294670595 (age 732.843s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        a0 cc 9c 07 81 88 ff ff 78 a1 76 07 81 88 ff ff  ........x.v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c851e>] damon_test_apply_three_regions2+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff8881079ccc80 (size 56):
      comm "kunit_try_catch", pid 1071, jiffies 4294670595 (age 732.843s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c851e>] damon_test_apply_three_regions2+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888107c9af40 (size 64):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.011s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        20 a2 76 07 81 88 ff ff b8 a6 76 07 81 88 ff ff   .v.......v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776a200 (size 56):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.011s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776a740 (size 56):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.025s)
      hex dump (first 32 bytes):
        3d 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00  =.......?.......
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819bfcc2>] damon_set_regions+0x4c2/0x8e0
        [<ffffffff819c7dbb>] damon_do_test_apply_three_regions.constprop.0+0xfb/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888108038240 (size 64):
      comm "kunit_try_catch", pid 1075, jiffies 4294670600 (age 733.022s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 03 00 00 00 6b 6b 6b 6b  ............kkkk
        48 ad 76 07 81 88 ff ff 98 ae 76 07 81 88 ff ff  H.v.......v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c898d>] damon_test_apply_three_regions4+0x1cd/0x210
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776ad28 (size 56):
      comm "kunit_try_catch", pid 1075, jiffies 4294670600 (age 733.022s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819bfcc2>] damon_set_regions+0x4c2/0x8e0
        [<ffffffff819c7dbb>] damon_do_test_apply_three_regions.constprop.0+0xfb/0x3e0
        [<ffffffff819c898d>] damon_test_apply_three_regions4+0x1cd/0x210
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20

Link: https://lkml.kernel.org/r/20230925072100.3725620-1-ruanjinjie@huawei.com
Fixes: 9f86d624292c ("mm/damon/vaddr-test: remove unnecessary variables")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -148,6 +148,8 @@ static void damon_do_test_apply_three_re
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
+
+	damon_destroy_target(t);
 }
 
 /*


