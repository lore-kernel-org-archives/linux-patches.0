Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F97461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BB1C433C7;
	Sun, 17 Sep 2023 20:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981178;
	bh=cZS+qh46bIqR0WX02KtlA5HfUGYii7eFdviKLg5sEOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMQqP0X5oAzC04CysKJN9xHGlHRzxvMs5hVLWYnpFdvBE9cx0qxr6+vuElPVrircA
	 S5ELAuK910qFF5BhDZbT7iA/PgPojUmLjw5a8JCo3Wu9UTTgdnKfnt8MzIxlqUfo/r
	 //XhJrwd3walA+73mqgWYjsMABVaB8TaMtZSDfQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David S. Miller" <davem@davemloft.net>,
	Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 6.1 055/219] net: deal with integer overflows in kmalloc_reserve()
Date: Sun, 17 Sep 2023 21:13:02 +0200
Message-ID: <20230917191043.002216435@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 915d975b2ffa58a14bfcf16fafe00c41315949ff upstream.

Blamed commit changed:
    ptr = kmalloc(size);
    if (ptr)
      size = ksize(ptr);

to:
    size = kmalloc_size_roundup(size);
    ptr = kmalloc(size);

This allowed various crash as reported by syzbot [1]
and Kyle Zeng.

Problem is that if @size is bigger than 0x80000001,
kmalloc_size_roundup(size) returns 2^32.

kmalloc_reserve() uses a 32bit variable (obj_size),
so 2^32 is truncated to 0.

kmalloc(0) returns ZERO_SIZE_PTR which is not handled by
skb allocations.

Following trace can be triggered if a netdev->mtu is set
close to 0x7fffffff

We might in the future limit netdev->mtu to more sensible
limit (like KMALLOC_MAX_SIZE).

This patch is based on a syzbot report, and also a report
and tentative fix from Kyle Zeng.

[1]
BUG: KASAN: user-memory-access in __build_skb_around net/core/skbuff.c:294 [inline]
BUG: KASAN: user-memory-access in __alloc_skb+0x3c4/0x6e8 net/core/skbuff.c:527
Write of size 32 at addr 00000000fffffd10 by task syz-executor.4/22554

CPU: 1 PID: 22554 Comm: syz-executor.4 Not tainted 6.1.39-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/03/2023
Call trace:
dump_backtrace+0x1c8/0x1f4 arch/arm64/kernel/stacktrace.c:279
show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:286
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x120/0x1a0 lib/dump_stack.c:106
print_report+0xe4/0x4b4 mm/kasan/report.c:398
kasan_report+0x150/0x1ac mm/kasan/report.c:495
kasan_check_range+0x264/0x2a4 mm/kasan/generic.c:189
memset+0x40/0x70 mm/kasan/shadow.c:44
__build_skb_around net/core/skbuff.c:294 [inline]
__alloc_skb+0x3c4/0x6e8 net/core/skbuff.c:527
alloc_skb include/linux/skbuff.h:1316 [inline]
igmpv3_newpack+0x104/0x1088 net/ipv4/igmp.c:359
add_grec+0x81c/0x1124 net/ipv4/igmp.c:534
igmpv3_send_cr net/ipv4/igmp.c:667 [inline]
igmp_ifc_timer_expire+0x1b0/0x1008 net/ipv4/igmp.c:810
call_timer_fn+0x1c0/0x9f0 kernel/time/timer.c:1474
expire_timers kernel/time/timer.c:1519 [inline]
__run_timers+0x54c/0x710 kernel/time/timer.c:1790
run_timer_softirq+0x28/0x4c kernel/time/timer.c:1803
_stext+0x380/0xfbc
____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
call_on_irq_stack+0x24/0x4c arch/arm64/kernel/entry.S:891
do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:84
invoke_softirq kernel/softirq.c:437 [inline]
__irq_exit_rcu+0x1c0/0x4cc kernel/softirq.c:683
irq_exit_rcu+0x14/0x78 kernel/softirq.c:695
el0_interrupt+0x7c/0x2e0 arch/arm64/kernel/entry-common.c:717
__el0_irq_handler_common+0x18/0x24 arch/arm64/kernel/entry-common.c:724
el0t_64_irq_handler+0x10/0x1c arch/arm64/kernel/entry-common.c:729
el0t_64_irq+0x1a0/0x1a4 arch/arm64/kernel/entry.S:584

Fixes: 12d6c1d3a2ad ("skbuff: Proactively round up to kmalloc bucket size")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Ajay: Regenerated the patch for v6.1.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -428,11 +428,17 @@ static void *kmalloc_reserve(unsigned in
 			     bool *pfmemalloc)
 {
 	bool ret_pfmemalloc = false;
-	unsigned int obj_size;
+	size_t obj_size;
 	void *obj;
 
 	obj_size = SKB_HEAD_ALIGN(*size);
-	*size = obj_size = kmalloc_size_roundup(obj_size);
+
+	obj_size = kmalloc_size_roundup(obj_size);
+	/* The following cast might truncate high-order bits of obj_size, this
+	 * is harmless because kmalloc(obj_size >= 2^32) will fail anyway.
+	 */
+	*size = (unsigned int)obj_size;
+
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.


