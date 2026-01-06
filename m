Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA47365A13;
	Tue,  6 Jan 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722452; cv=none; b=mpk7OToFICpayJBnfOjiJIcd3hANdRMRz2vBBm61PTpmqRLlPZTy04RsclvVbHHHsXDRMeXntaWYBvbMsTX8Qu64cq7rZRv/kghaWFpYEbl9GYeeMRSMFj/jR965FnyuH4nybwKvkJoBYv5Sq4DL1Jrsc5adqyCpAk4VQtaII5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722452; c=relaxed/simple;
	bh=M0RIIYhJdHrRbn3iDp443SBow7UdBtVIKXn0nEuMMVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZVDMEf6HLe22HLizic/ZEPZHfp6yMjaiMb+6N0yShHxkZsCwv0gx9xyYHEIUFnN1FlgcZJJ7++HD7bi8jrUPF1utET27sSMALBk4q4Ch5nnP5eSAa2bSw4L9Z2UfaL/WIQdXBiph/IY7A2U4Vhe+c6Tp8l/FKbzQMnK8GJty1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrEC5bBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrEC5bBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA24C116C6;
	Tue,  6 Jan 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722451;
	bh=M0RIIYhJdHrRbn3iDp443SBow7UdBtVIKXn0nEuMMVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrEC5bBJ3TLx0vLq1uq48E0kfZqtVG8j/Qlpfu3+KMjBrZyCAorDSbNzP/Eg/EhCK
	 gvNozP5FG9tissWSUgh+HYGFjx2pqZrEi1Ipta6QZgeAkcAfVhwDnHXViBFxPH/Aiy
	 2AdCmjyHPmrAZ2FFNv5RjMKqSdhEy65pK/WgZii8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 236/312] rust: maple_tree: rcu_read_lock() in destructor to silence lockdep
Date: Tue,  6 Jan 2026 18:05:10 +0100
Message-ID: <20260106170556.389683809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 6558749ef3405c143711cbdc67ec88cbc1582d91 upstream.

When running the Rust maple tree kunit tests with lockdep, you may trigger
a warning that looks like this:

	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!

	other info that might help us debug this:

	rcu_scheduler_active = 2, debug_locks = 1
	no locks held by kunit_try_catch/344.

	stack backtrace:
	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
	Tainted: [N]=TEST
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
	Call Trace:
	 <TASK>
	 dump_stack_lvl+0x71/0x90
	 lockdep_rcu_suspicious+0x150/0x190
	 mas_start+0x104/0x150
	 mas_find+0x179/0x240
	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
	 ? lock_release+0xeb/0x2a0
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_try_run_case+0x74/0x160
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_generic_run_threadfn_adapter+0x12/0x30
	 kthread+0x21c/0x230
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork+0x16c/0x270
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork_asm+0x11/0x20
	 </TASK>

This is because the destructor of maple tree calls mas_find() without
taking rcu_read_lock() or the spinlock.  Doing that is actually ok in this
case since the destructor has exclusive access to the entire maple tree,
but it triggers a lockdep warning.  To fix that, take the rcu read lock.

In the future, it's possible that memory reclaim could gain a feature
where it reallocates entries in maple trees even if no user-code is
touching it.  If that feature is added, then this use of rcu read lock
would become load-bearing, so I did not make it conditional on lockdep.

We have to repeatedly take and release rcu because the destructor of T
might perform operations that sleep.

Link: https://lkml.kernel.org/r/20251217-maple-drop-rcu-v1-1-702af063573f@google.com
Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215108
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/maple_tree.rs | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index e72eec56bf57..265d6396a78a 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -265,7 +265,16 @@ impl<T: ForeignOwnable> MapleTree<T> {
         loop {
             // This uses the raw accessor because we're destroying pointers without removing them
             // from the maple tree, which is only valid because this is the destructor.
-            let ptr = ma_state.mas_find_raw(usize::MAX);
+            //
+            // Take the rcu lock because mas_find_raw() requires that you hold either the spinlock
+            // or the rcu read lock. This is only really required if memory reclaim might
+            // reallocate entries in the tree, as we otherwise have exclusive access. That feature
+            // doesn't exist yet, so for now, taking the rcu lock only serves the purpose of
+            // silencing lockdep.
+            let ptr = {
+                let _rcu = kernel::sync::rcu::Guard::new();
+                ma_state.mas_find_raw(usize::MAX)
+            };
             if ptr.is_null() {
                 break;
             }
-- 
2.52.0



