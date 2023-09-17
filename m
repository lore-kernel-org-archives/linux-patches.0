Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4176FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBA0C433CD;
	Sun, 17 Sep 2023 20:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982687;
	bh=KAVKGJixNp6XijGaHTH4LjTLJ3gVVcNBShOGcYAVGuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrxhWPJN5UbbM6YwiC6qlZ905oBtSUGonOtV9L+3iUWoPVPGuckgBc8BRuPboe2tm
	 onDndTIVy8utwRHThfBLeR+TcGEYOPiVR0pJgD7nVClM9YOrlrGFWAyhtR2ROyfjSn
	 RM8xJj13eA+tdU65CcK4+yj9Oj1mkxmkxl2cBdmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Zhen Lei <thunder.leizhen@huaweicloud.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 324/511] rcu: dump vmalloc memory info safely
Date: Sun, 17 Sep 2023 21:12:31 +0200
Message-ID: <20230917191121.641499605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

commit c83ad36a18c02c0f51280b50272327807916987f upstream.

Currently, for double invoke call_rcu(), will dump rcu_head objects memory
info, if the objects is not allocated from the slab allocator, the
vmalloc_dump_obj() will be invoke and the vmap_area_lock spinlock need to
be held, since the call_rcu() can be invoked in interrupt context,
therefore, there is a possibility of spinlock deadlock scenarios.

And in Preempt-RT kernel, the rcutorture test also trigger the following
lockdep warning:

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 1
3 locks held by swapper/0/1:
 #0: ffffffffb534ee80 (fullstop_mutex){+.+.}-{4:4}, at: torture_init_begin+0x24/0xa0
 #1: ffffffffb5307940 (rcu_read_lock){....}-{1:3}, at: rcu_torture_init+0x1ec7/0x2370
 #2: ffffffffb536af40 (vmap_area_lock){+.+.}-{3:3}, at: find_vmap_area+0x1f/0x70
irq event stamp: 565512
hardirqs last  enabled at (565511): [<ffffffffb379b138>] __call_rcu_common+0x218/0x940
hardirqs last disabled at (565512): [<ffffffffb5804262>] rcu_torture_init+0x20b2/0x2370
softirqs last  enabled at (399112): [<ffffffffb36b2586>] __local_bh_enable_ip+0x126/0x170
softirqs last disabled at (399106): [<ffffffffb43fef59>] inet_register_protosw+0x9/0x1d0
Preemption disabled at:
[<ffffffffb58040c3>] rcu_torture_init+0x1f13/0x2370
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.5.0-rc4-rt2-yocto-preempt-rt+ #15
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0xb0
 dump_stack+0x14/0x20
 __might_resched+0x1aa/0x280
 ? __pfx_rcu_torture_err_cb+0x10/0x10
 rt_spin_lock+0x53/0x130
 ? find_vmap_area+0x1f/0x70
 find_vmap_area+0x1f/0x70
 vmalloc_dump_obj+0x20/0x60
 mem_dump_obj+0x22/0x90
 __call_rcu_common+0x5bf/0x940
 ? debug_smp_processor_id+0x1b/0x30
 call_rcu_hurry+0x14/0x20
 rcu_torture_init+0x1f82/0x2370
 ? __pfx_rcu_torture_leak_cb+0x10/0x10
 ? __pfx_rcu_torture_leak_cb+0x10/0x10
 ? __pfx_rcu_torture_init+0x10/0x10
 do_one_initcall+0x6c/0x300
 ? debug_smp_processor_id+0x1b/0x30
 kernel_init_freeable+0x2b9/0x540
 ? __pfx_kernel_init+0x10/0x10
 kernel_init+0x1f/0x150
 ret_from_fork+0x40/0x50
 ? __pfx_kernel_init+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

The previous patch fixes this by using the deadlock-safe best-effort
version of find_vm_area.  However, in case of failure print the fact that
the pointer was a vmalloc pointer so that we print at least something.

Link: https://lkml.kernel.org/r/20230904180806.1002832-2-joel@joelfernandes.org
Fixes: 98f180837a89 ("mm: Make mem_dump_obj() handle vmalloc() memory")
Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reported-by: Zhen Lei <thunder.leizhen@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -1110,7 +1110,9 @@ void mem_dump_obj(void *object)
 	if (vmalloc_dump_obj(object))
 		return;
 
-	if (virt_addr_valid(object))
+	if (is_vmalloc_addr(object))
+		type = "vmalloc memory";
+	else if (virt_addr_valid(object))
 		type = "non-slab/vmalloc memory";
 	else if (object == NULL)
 		type = "NULL pointer";


