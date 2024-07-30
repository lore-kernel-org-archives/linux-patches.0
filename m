Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C01A76A7;
	Tue, 30 Jul 2024 17:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359859; cv=none; b=hM1rs0Ogg4JrzYsFwj16HYvWaXD+Yx2sToTon6SyI0PrZevbte64QVRIiTXaP6BQXfq5uVRxgFoNI2/clbK6vlcLiZPxluQUPHJHuuaXpVV9Z1XMGawO/x/c98kkJSW3RMEjVeLLbYAztZU6F/tstt6cNqy4/AlnxpoRnDfQhb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359859; c=relaxed/simple;
	bh=JOjFEmw679C50v8ILDMoypGBeetsDOmpJmIJnzOpd/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sR6mL3O9rBsKzr4KlspIyThaDYP4UcCJXZurWZ1jVm86aAF69AVVfEL+3aHdc64nw0tc9UVB7gP+FtxBBw7SLGPYbrEYzuLch6l0xgGQCPwzMutK+eicm0WbR1yAt5OEt2CTX7/5dRDsU26aanzY+m2QJ4ZtpHWo6T07QyDZFdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZY2CQee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZY2CQee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D85AC4AF0E;
	Tue, 30 Jul 2024 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359859;
	bh=JOjFEmw679C50v8ILDMoypGBeetsDOmpJmIJnzOpd/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZY2CQeeYYtBkYw5wW0CYODZXKjidfAod7QmH+rmIgY47i8A5lnQi7+bVp6fOFmdP
	 VSif9Vsu608pF7lG01+U57hWco/oeZYCmlN5110OawvWbG9sju/aTXOlj9GjlvodQZ
	 1VEKrcfk+9hOJdS4R9qgybj+mUXwjdzbhlu0ROcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 537/809] mm/hugetlb: fix possible recursive locking detected warning
Date: Tue, 30 Jul 2024 17:46:53 +0200
Message-ID: <20240730151745.951612596@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

commit 667574e873b5f77a220b2a93329689f36fb56d5d upstream.

When tries to demote 1G hugetlb folios, a lockdep warning is observed:

============================================
WARNING: possible recursive locking detected
6.10.0-rc6-00452-ga4d0275fa660-dirty #79 Not tainted
--------------------------------------------
bash/710 is trying to acquire lock:
ffffffff8f0a7850 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0x244/0x460

but task is already holding lock:
ffffffff8f0a6f48 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0xae/0x460

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&h->resize_lock);
  lock(&h->resize_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by bash/710:
 #0: ffff8f118439c3f0 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x64/0xe0
 #1: ffff8f11893b9e88 (&of->mutex#2){+.+.}-{3:3}, at: kernfs_fop_write_iter+0xf8/0x1d0
 #2: ffff8f1183dc4428 (kn->active#98){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x100/0x1d0
 #3: ffffffff8f0a6f48 (&h->resize_lock){+.+.}-{3:3}, at: demote_store+0xae/0x460

stack backtrace:
CPU: 3 PID: 710 Comm: bash Not tainted 6.10.0-rc6-00452-ga4d0275fa660-dirty #79
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0xa0
 __lock_acquire+0x10f2/0x1ca0
 lock_acquire+0xbe/0x2d0
 __mutex_lock+0x6d/0x400
 demote_store+0x244/0x460
 kernfs_fop_write_iter+0x12c/0x1d0
 vfs_write+0x380/0x540
 ksys_write+0x64/0xe0
 do_syscall_64+0xb9/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa61db14887
RSP: 002b:00007ffc56c48358 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa61db14887
RDX: 0000000000000002 RSI: 000055a030050220 RDI: 0000000000000001
RBP: 000055a030050220 R08: 00007fa61dbd1460 R09: 000000007fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fa61dc1b780 R14: 00007fa61dc17600 R15: 00007fa61dc16a00
 </TASK>

Lockdep considers this an AA deadlock because the different resize_lock
mutexes reside in the same lockdep class, but this is a false positive.
Place them in distinct classes to avoid these warnings.

Link: https://lkml.kernel.org/r/20240712031314.2570452-1-linmiaohe@huawei.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -681,6 +681,7 @@ HPAGEFLAG(RawHwpUnreliable, raw_hwp_unre
 /* Defines one hugetlb page size */
 struct hstate {
 	struct mutex resize_lock;
+	struct lock_class_key resize_key;
 	int next_nid_to_alloc;
 	int next_nid_to_free;
 	unsigned int order;
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4643,7 +4643,7 @@ void __init hugetlb_add_hstate(unsigned
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
 	h = &hstates[hugetlb_max_hstate++];
-	mutex_init(&h->resize_lock);
+	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
 	h->mask = ~(huge_page_size(h) - 1);
 	for (i = 0; i < MAX_NUMNODES; ++i)


