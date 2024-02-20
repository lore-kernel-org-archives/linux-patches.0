Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3B3151CD2;
	Tue, 20 Feb 2024 20:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462716; cv=none; b=hw2PzrPm6ZPRUrvCO0vB0HElnth26IpUkasksR2KXWY+Lr6jdnZuSdygsbLkZc04PQBjH8VNrCxkpDm5UP5na+y31EVTEHs4rllImDcTs77mab/nvgYPnO73FqcxdnV8AFv/jULrfdxpx8k4RnbBb7qa4Ok2tDV4Buqx4T/nyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462716; c=relaxed/simple;
	bh=FZLV0axGTja0a6c6JeRzsRlD+e2EfqMD5rdrVvaPk0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O038LKQYJ+uoaxhp4jFyz6ZqWc6Y6IEL13CI+1y64QXra/rYvTF+UC2fGgzj199maKv6APtEQtCmEX4PTAI+1/w76BQMtRWPlHeBfH1aoEfYOMnTRHlLxGUm8jSblg0EVYggdqMJQA0Gfvk9aOJjuFYbGHIaEF+nUCWCUWKZT8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGLSUekn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGLSUekn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92221C433C7;
	Tue, 20 Feb 2024 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462716;
	bh=FZLV0axGTja0a6c6JeRzsRlD+e2EfqMD5rdrVvaPk0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGLSUeknAsMSMkpeQFjv1yJ0i58kvt0MVgj94Pe60Sw6h8C64CrY91A89tl17k4Ml
	 XN01XmS75dNA7u71OsLZx2/LWb9MLU0MxJ5zAv/ScgS79su5gWpUsdeecFaAzRwXS+
	 A0k+qFZE9d8oZ79X1TZLK2saWyUz1AZo8t4w81xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaoqin Huang <shahuang@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/197] KVM: selftests: Fix a semaphore imbalance in the dirty ring logging test
Date: Tue, 20 Feb 2024 21:49:34 +0100
Message-ID: <20240220204841.539330841@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ba58f873cdeec30b6da48e28dd5782c5a3e1371b ]

When finishing the final iteration of dirty_log_test testcase, set
host_quit _before_ the final "continue" so that the vCPU worker doesn't
run an extra iteration, and delete the hack-a-fix of an extra "continue"
from the dirty ring testcase.  This fixes a bug where the extra post to
sem_vcpu_cont may not be consumed, which results in failures in subsequent
runs of the testcases.  The bug likely was missed during development as
x86 supports only a single "guest mode", i.e. there aren't any subsequent
testcases after the dirty ring test, because for_each_guest_mode() only
runs a single iteration.

For the regular dirty log testcases, letting the vCPU run one extra
iteration is a non-issue as the vCPU worker waits on sem_vcpu_cont if and
only if the worker is explicitly told to stop (vcpu_sync_stop_requested).
But for the dirty ring test, which needs to periodically stop the vCPU to
reap the dirty ring, letting the vCPU resume the guest _after_ the last
iteration means the vCPU will get stuck without an extra "continue".

However, blindly firing off an post to sem_vcpu_cont isn't guaranteed to
be consumed, e.g. if the vCPU worker sees host_quit==true before resuming
the guest.  This results in a dangling sem_vcpu_cont, which leads to
subsequent iterations getting out of sync, as the vCPU worker will
continue on before the main task is ready for it to resume the guest,
leading to a variety of asserts, e.g.

  ==== Test Assertion Failure ====
  dirty_log_test.c:384: dirty_ring_vcpu_ring_full
  pid=14854 tid=14854 errno=22 - Invalid argument
     1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
     2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
     3   (inlined by) run_test at dirty_log_test.c:802
     4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
     5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
     6  0x0000ffff9be173c7: ?? ??:0
     7  0x0000ffff9be1749f: ?? ??:0
     8  0x000000000040206f: _start at ??:?
  Didn't continue vcpu even without ring full

Alternatively, the test could simply reset the semaphores before each
testcase, but papering over hacks with more hacks usually ends in tears.

Reported-by: Shaoqin Huang <shahuang@redhat.com>
Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Link: https://lore.kernel.org/r/20240202231831.354848-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 50 +++++++++++---------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8758c10ec850..ec40a33c29fd 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -355,7 +355,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
-	/* Cleared pages should be the same as collected */
+	/*
+	 * Cleared pages should be the same as collected, as KVM is supposed to
+	 * clear only the entries that have been harvested.
+	 */
 	TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
 		    "with collected (%u)", cleared, count);
 
@@ -394,12 +397,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	}
 }
 
-static void dirty_ring_before_vcpu_join(void)
-{
-	/* Kick another round of vcpu just to make sure it will quit */
-	sem_post(&sem_vcpu_cont);
-}
-
 struct log_mode {
 	const char *name;
 	/* Return true if this mode is supported, otherwise false */
@@ -412,7 +409,6 @@ struct log_mode {
 				     uint32_t *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
-	void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
@@ -431,7 +427,6 @@ struct log_mode {
 		.supported = dirty_ring_supported,
 		.create_vm_done = dirty_ring_create_vm_done,
 		.collect_dirty_pages = dirty_ring_collect_dirty_pages,
-		.before_vcpu_join = dirty_ring_before_vcpu_join,
 		.after_vcpu_run = dirty_ring_after_vcpu_run,
 	},
 };
@@ -492,14 +487,6 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 		mode->after_vcpu_run(vcpu, ret, err);
 }
 
-static void log_mode_before_vcpu_join(void)
-{
-	struct log_mode *mode = &log_modes[host_log_mode];
-
-	if (mode->before_vcpu_join)
-		mode->before_vcpu_join();
-}
-
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -701,6 +688,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	unsigned long *bmap;
 	uint32_t ring_buf_idx = 0;
+	int sem_val;
 
 	if (!log_mode_supported()) {
 		print_skip("Log mode '%s' not supported",
@@ -772,12 +760,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
-	host_quit = false;
+	WRITE_ONCE(host_quit, false);
 	host_dirty_count = 0;
 	host_clear_count = 0;
 	host_track_next_count = 0;
 	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
+	/*
+	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
+	 * that the main task and vCPU worker were synchronized and completed
+	 * verification of all iterations.
+	 */
+	sem_getvalue(&sem_vcpu_stop, &sem_val);
+	TEST_ASSERT_EQ(sem_val, 0);
+	sem_getvalue(&sem_vcpu_cont, &sem_val);
+	TEST_ASSERT_EQ(sem_val, 0);
+
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	while (iteration < p->iterations) {
@@ -803,15 +801,21 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
 		       atomic_read(&vcpu_sync_stop_requested) == false);
 		vm_dirty_log_verify(mode, bmap);
-		sem_post(&sem_vcpu_cont);
 
-		iteration++;
+		/*
+		 * Set host_quit before sem_vcpu_cont in the final iteration to
+		 * ensure that the vCPU worker doesn't resume the guest.  As
+		 * above, the dirty ring test may stop and wait even when not
+		 * explicitly request to do so, i.e. would hang waiting for a
+		 * "continue" if it's allowed to resume the guest.
+		 */
+		if (++iteration == p->iterations)
+			WRITE_ONCE(host_quit, true);
+
+		sem_post(&sem_vcpu_cont);
 		sync_global_to_guest(vm, iteration);
 	}
 
-	/* Tell the vcpu thread to quit */
-	host_quit = true;
-	log_mode_before_vcpu_join();
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
-- 
2.43.0



