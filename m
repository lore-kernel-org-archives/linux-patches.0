Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62C32E285C;
	Mon, 22 Sep 2025 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569962; cv=none; b=b0j+7E0tSaZ4E6nJMG7J7QxkvmRGzSlbCrdE3V/ivlsq6AYvMF/1Z8X8CyDU7JR73ywgsLKFRDeGsAs8tXzfpz3MzBUzZoHTsBNaftODyT8D19iqfyviqLTskasN/JkPFRzoerCf0gpxN3zn1MDBLq+PBLbXDqTgURSjjDg1a0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569962; c=relaxed/simple;
	bh=L9cpiQ1Y2KJ9DJBtA/XidW1hhlFUCoWmwgoxQFegMtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcrRgRZWkTLucFeoeCZRZHDaQ8tqYYzZdJTxsQeHkQRs/bCe/ezEculECSEOBBNTUhcNvvJNuaB2dceho+o/uLC5SOzy7kMpAj/cgjV/9PgEEmqpaqZBVy60y3JiCuWuCEALJ2k1UCP+FXXD07+fB0Rhp39P2w5xYT1rPNU5X6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dDVaH9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dDVaH9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46F4C4CEF0;
	Mon, 22 Sep 2025 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569961;
	bh=L9cpiQ1Y2KJ9DJBtA/XidW1hhlFUCoWmwgoxQFegMtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dDVaH9jLwxxkkmyYHbXASeeMgCVzW/vuQUn95lvYA3JQvTvTXO2jj67HeUo72NRN
	 CoK4ISe6TS3/qATZTgwc1yH/E+UB/LJJPPvhMjs7GMl9kY++09EVADZu9PnhgxH0pX
	 2BFh4UgDzQLkG5FS47YHP1h3zq4riibh5ARLQ87w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Zhang <zhangxi@kylinos.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 047/105] LoongArch: Fix unreliable stack for live patching
Date: Mon, 22 Sep 2025 21:29:30 +0200
Message-ID: <20250922192410.151234043@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 677d4a52d4dc4a147d5e84af9ff207832578be70 upstream.

When testing the kernel live patching with "modprobe livepatch-sample",
there is a timeout over 15 seconds from "starting patching transition"
to "patching complete". The dmesg command shows "unreliable stack" for
user tasks in debug mode, here is one of the messages:

  livepatch: klp_try_switch_task: bash:1193 has an unreliable stack

The "unreliable stack" is because it can not unwind from do_syscall()
to its previous frame handle_syscall(). It should use fp to find the
original stack top due to secondary stack in do_syscall(), but fp is
not used for some other functions, then fp can not be restored by the
next frame of do_syscall(), so it is necessary to save fp if task is
not current, in order to get the stack top of do_syscall().

Here are the call chains:

  klp_enable_patch()
    klp_try_complete_transition()
      klp_try_switch_task()
        klp_check_and_switch_task()
          klp_check_stack()
            stack_trace_save_tsk_reliable()
              arch_stack_walk_reliable()

When executing "rmmod livepatch-sample", there exists a similar issue.
With this patch, it takes a short time for patching and unpatching.

Before:

  # modprobe livepatch-sample
  # dmesg -T | tail -3
  [Sat Sep  6 11:00:20 2025] livepatch: 'livepatch_sample': starting patching transition
  [Sat Sep  6 11:00:35 2025] livepatch: signaling remaining tasks
  [Sat Sep  6 11:00:36 2025] livepatch: 'livepatch_sample': patching complete

  # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
  # rmmod livepatch_sample
  rmmod: ERROR: Module livepatch_sample is in use
  # rmmod livepatch_sample
  # dmesg -T | tail -3
  [Sat Sep  6 11:06:05 2025] livepatch: 'livepatch_sample': starting unpatching transition
  [Sat Sep  6 11:06:20 2025] livepatch: signaling remaining tasks
  [Sat Sep  6 11:06:21 2025] livepatch: 'livepatch_sample': unpatching complete

After:

  # modprobe livepatch-sample
  # dmesg -T | tail -2
  [Tue Sep 16 16:19:30 2025] livepatch: 'livepatch_sample': starting patching transition
  [Tue Sep 16 16:19:31 2025] livepatch: 'livepatch_sample': patching complete

  # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
  # rmmod livepatch_sample
  # dmesg -T | tail -2
  [Tue Sep 16 16:19:36 2025] livepatch: 'livepatch_sample': starting unpatching transition
  [Tue Sep 16 16:19:37 2025] livepatch: 'livepatch_sample': unpatching complete

Cc: stable@vger.kernel.org # v6.9+
Fixes: 199cc14cb4f1 ("LoongArch: Add kernel livepatching support")
Reported-by: Xi Zhang <zhangxi@kylinos.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/stacktrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -51,12 +51,13 @@ int arch_stack_walk_reliable(stack_trace
 	if (task == current) {
 		regs->regs[3] = (unsigned long)__builtin_frame_address(0);
 		regs->csr_era = (unsigned long)__builtin_return_address(0);
+		regs->regs[22] = 0;
 	} else {
 		regs->regs[3] = thread_saved_fp(task);
 		regs->csr_era = thread_saved_ra(task);
+		regs->regs[22] = task->thread.reg22;
 	}
 	regs->regs[1] = 0;
-	regs->regs[22] = 0;
 
 	for (unwind_start(&state, task, regs);
 	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {


