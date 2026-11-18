Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020845;
	b=J47qWSxgouV+rQsZ0XTmoaXNVMq0TZxaWJ9uWsek+FGUvgYgNkGRWtP89dnAKZWCskIN
	 e0PYOvlN8hQFcJ4w29qAHx2MN4Pbytyvx/UMnjB9/FLG4FG1kguY/AAv3LhKG5eL6jQmU
	 /Dbvash0hHVpsF36Pvx3Th+3wG5kQZF2D3oWr24sRezcxaJYvevTgPoKnjEqNPsJQwTgP
	 CQeTsa+BNnVdliSPt1MrmHzYe0wV0HTwUuNg0tzNHOE037mngevKCTkojIP2VX6gNG6zQ
	 jQgPMo0a11kXn7iQs7hksW7S0J0E3NtDYAqKW8IKRN4GXiw0mpDQEMsQ0m7Z0R8zLvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JavGiplzlYbuyqYVJAVgbJlwQmrSBqpDhO8R2Wj3xTE=;
	b=WnxjDg+uf/qLzygF33EIsjMVYTwxBS5mKGN2WtJD9Re1zk+rbW57zHxsTG3FrxnV2+hR
	 2HiUNp44htyvFP4dnJ8+g/5laLGa4bhFJbg16TXISRDHa2HLNsoJeHvmVv/CiFKxH2TAq
	 X0vNOTxl+9wqHe73sV8UcBS5I9qphS1okMTvBT6/WA2/+5uHpOctHEeYtkDYH023TKDnN
	 C19PejvO6hLgwfUxibyc01OIGKObxLSe6C1IwK+RFPCGptFNepWBRbYerPcu24ytIkcsa
	 O1QWR8zEYc9ShuzAoQph5DDVSjksU2J3sBTJD4vGPUrgTACZipLBle3DQfSdoElQzvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0VHyCkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5416A606A335;
	Wed, 18 Nov 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0VHyCkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADA91F000C4;
	Wed, 18 Nov 2026 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020844;
	bh=JavGiplzlYbuyqYVJAVgbJlwQmrSBqpDhO8R2Wj3xTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0VHyCkpYZfGROrP2JVQFW8i6gfpP7TgEo/HJvbae9a8umpjLph8uAJ4Z3QbQUMIj
	 rzylhjSg/a16PnRh1uFAOMP2FBBIPsOxnyVF+3Y2ewpJUyuyKJpwsAOaQayNffrroa
	 WRm4R0m2qQRMkRmM+7GTRCa8LEchz7XSHeSDStwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2094/2651] bpf: Forbid sleeping in bpf_find_vma() callbacks
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150401.398028339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit c6dc0a288d4e787c578d7ab0464b9c943ad88ecc ]

A sleepable program can call bpf_find_vma() and use a sleepable helper
such as bpf_copy_from_user() or bpf_copy_from_user_task() in the
callback. The verifier accepts this, but bpf_find_vma() runs the callback
with the mmap_lock of the mm held for read. If the user copy faults on
that mm, the fault handler has to take mmap_lock again. Lockdep reports
recursive locking, and if a writer queued up in between, the fault blocks
behind the writer, which waits for the read lock the helper already
holds:

    sleepable prog                  other thread of the same mm
    bpf_find_vma(current, ...)
      mmap_read_trylock(mm)
                                    mmap_write_lock(mm)  <- waits
      callback: copy_from_user()
        page fault
          mmap_read_lock(mm)        <- queued behind the writer

This is the same problem as with sleepable task_vma iterator programs.
The verifier checks synchronous callbacks in the caller's context, so
in_sleepable_context() is true in the callback of a sleepable program.

Verify the callback like a hash map for_each callback, as running in an
RCU read-side critical section where sleeping is not allowed, and actually
hold rcu_read_lock() around it, so that global functions the callback
calls, which are then verified for a non-sleepable context, see the RCU
protection they are verified with.

Non-sleepable programs already run the callback under RCU, nothing changes
for them. A sleepable program whose bpf_find_vma() callback calls any
helper, kfunc or global function that may sleep is now rejected by the
verifier, including ones that would be harmless under mmap_lock as they
don't touch user memory.

Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 6 ++++++
 kernel/bpf/verifier.c  | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index cf2bf388e1817..2fa6b8dae8c4f 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -810,8 +810,14 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 	vma = find_vma(mm, start);
 
 	if (vma && vma->vm_start <= start && vma->vm_end > start) {
+		/*
+		 * The callback must not sleep while mmap_lock is held, and the
+		 * verifier checks it as an RCU read-side critical section.
+		 */
+		rcu_read_lock();
 		callback_fn((u64)(long)task, (u64)(long)vma,
 			    (u64)(long)callback_ctx, 0, 0);
+		rcu_read_unlock();
 		ret = 0;
 	}
 	bpf_mmap_unlock_mm(work, mm);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2cb34276313cf..1dea0faaffcc3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10271,6 +10271,8 @@ static int set_find_vma_callback_state(struct bpf_verifier_env *env,
 	bpf_mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
 	bpf_mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
 	callee->in_callback_fn = true;
+	/* bpf_find_vma() runs the callback under mmap_lock and RCU. */
+	callee->in_rcu_callback_fn = true;
 	callee->callback_ret_range = retval_range(0, 1);
 	return 0;
 }
-- 
2.53.0



