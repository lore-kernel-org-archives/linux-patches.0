Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB01E98E3;
	Sun,  7 Jun 2026 11:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830186; cv=none; b=WybDSJ9EDZ7B+ctScLj6p9izrAeFxed3jU8T2vAr7idCBLsMgT82FLHHWYE28WtWPSDEPEKT8WK6sK8bY87Ir6KuWcOm0ancoV2Jet289OMy7LbrDPuypuHFO9Pr+gJ6Aal5VXPAK89rf+TmVzHIz1VuwiYpsjWJxkP6J7pNrjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830186; c=relaxed/simple;
	bh=fXO5wCTBmz6MY8qh9hKFR5gXuqW+IHyaildeEi30z9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRl6qtV911VDg3WY9u0BxBFHOyl1C2ChVKvbWN1kALqzN3uMj1QnuKA9H2eI9yr1j9sS4mQ5XHL/iSfuewgH/q5hpPA6gcTtNST0HRXQXpgePB7kGBp9D0Qm9esxsbJ3UZqO4bEEReUcWyqHw2PeM48VMKlrtg4oEXvP1KbK0cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di7aaC2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di7aaC2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CB61F00893;
	Sun,  7 Jun 2026 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830185;
	bh=GKjaC6oe34q2dmdFJuWDnpsmezkeg/BNrgJL9YTuwtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Di7aaC2/eLZuNgE39709XQOeYntMXHOnEg5TNft9p3QdPVYIPoOaVbYcul1Nt7tdk
	 7HdfPHC5wemwOOz8z3fXpQJgvCHKH7HRVhLmSXpksfN9Y1Yn4P/DZTC9k4E6VGIGsQ
	 6H1l/a4ter74JYLn3n61aKQzU+sppNaRxIqHw2lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/307] x86/ftrace: Relocate %rip-relative percpu refs in dynamic trampolines
Date: Sun,  7 Jun 2026 12:01:38 +0200
Message-ID: <20260607095738.807754934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

[ Upstream commit a17dc12bfed8868e6a86f3b45c16065a70641acb ]

With CONFIG_CALL_DEPTH_TRACKING enabled on an x86 retbleed-affected platform
(eg: Skylake), with retbleed=stuff, registering a dynamic ftrace trampoline
crashes on the first call into the traced function:

  BUG: unable to handle page fault for address: ffff88817ae18880
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 4b53067 P4D 4b53067 PUD 0
  Oops: Oops: 0002 [#1] SMP PTI
  CPU: 3 UID: 0 PID: 187 Comm: usleep Not tainted 7.0.10 #243 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
  Code: 24 78 00 00 00 00 48 89 ea 48 89 54 24 20 48 8b b4 24 b8 00 00 00 48 8b bc 24 b0 00 00 00 48 89 bc 24 80 00 00 00 48 83 ef 05 <65> 48 c1 3d 1f a8 b6 02 05 48 8b 15 f6 00 00 00 4c 89 3c 24 4c 89
  Call Trace:
   <TASK>
   ? find_held_lock
   ? exc_page_fault
   ? lock_release
   ? __x64_sys_clock_nanosleep
   ? lockdep_hardirqs_on_prepare
   ? trace_hardirqs_on
   __x64_sys_clock_nanosleep
   do_syscall_64
   ? exc_page_fault
   ? call_depth_return_thunk
   entry_SYSCALL_64_after_hwframe
  ...
  Kernel panic - not syncing: Fatal exception

This small reproducer allows to easily trigger the crash:

  # echo 'p __x64_sys_clock_nanosleep' > /sys/kernel/tracing/kprobe_events
  # echo 1 > /sys/kernel/tracing/events/kprobes/p___x64_sys_clock_nanosleep_0/enable
  # usleep 1

Monitoring the crash under GDB points to the exact instruction in charge of
incrementing the call depth:

  sarq $5, %gs:__x86_call_depth(%rip)

This instruction matches the one inserted by the ftrace_regs_caller from
ftrace_64.S. This emitted code was likely working fine until the introduction
of

  59bec00ace28 ("x86/percpu: Introduce %rip-relative addressing to PER_CPU_VAR()"):

it has made the call depth accounting addressing relative to $rip, instead of
being based on an absolute address.

As this code exact location depends on where the trampoline lives in memory,
the corresponding displacement needs to be adjusted at runtime to actually
correctly find the per-cpu __x86_call_depth value, otherwise the targeted
address is wrong, leading to the page fault seen above.

Fix the %rip-relative displacement of the copied CALL_DEPTH_ACCOUNT
instruction (from ftrace_regs_caller) by calling text_poke_apply_relocation(),
as it is done for example by the x86 BPF JIT compiler through
x86_call_depth_emit_accounting(). This corrects both CALL_DEPTH_ACCOUNT slots,
in ftrace_caller and ftrace_regs_caller.

  [ bp: Massage. ]

Fixes: 59bec00ace28 ("x86/percpu: Introduce %rip-relative addressing to PER_CPU_VAR()")
Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260527-fix_call_depth_in_trampoline-v1-1-1c1abc8ae310@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -371,6 +371,13 @@ create_trampoline(struct ftrace_ops *ops
 	}
 
 	/*
+	 * Generated trampoline may contain rIP-relative addressing which
+	 * displacement needs to be fixed.
+	 */
+	text_poke_apply_relocation(trampoline, trampoline, size,
+				   (void *)start_offset, size);
+
+	/*
 	 * The address of the ftrace_ops that is used for this trampoline
 	 * is stored at the end of the trampoline. This will be used to
 	 * load the third parameter for the callback. Basically, that


