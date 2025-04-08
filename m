Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2F2063FD;
	Tue,  8 Apr 2025 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115354; cv=none; b=QukQ0lmcRz3dc8xSsnqTWjq92V2VhkRAGVS6A1e2xJfg7uHJZOUyZT5nCIHcUNgMptmnomh8+uld+oQi3EA3W03Id6IXQK0VfmhGIct13IO3MM4tNanMkp4hKwp5gTOd9jmI8Ekkc4jX+M0Bh6iBKFM4rQ/ywFw97jK35b56EeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115354; c=relaxed/simple;
	bh=UOqq2kBLVS2TUFlLPSMvWIku0qIFKzoN3LSPX5JJ/KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIZqCQ7oaum2QRS4mD910caApq8LGDzXkDIu8P2dSMxXKQfzBTd5eT4/59t60ilYFPP8OFeYbVy9gyZaJt2U91jKOKoGG5WJNNkpbm+YAgEk/ZI0Qv3Xk0B/HSPwKF4LTIaQ+IfxYdr5/AtLCIKvcDCXUUd7CW9z1LlH3ME+KoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EctfjP1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EctfjP1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B47C4CEE5;
	Tue,  8 Apr 2025 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115354;
	bh=UOqq2kBLVS2TUFlLPSMvWIku0qIFKzoN3LSPX5JJ/KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EctfjP1htwpODlsiZ8GCKzNAQppNTk/hO2Usgt70tZoi2H1Z9FLNAlEsOSrk3ZQbn
	 4qc/MOr3BJc6X1/Q4J61sJE80JvEl3xXVRsR0U2fbd9bavs+/ncFyONOyyaeGP6CTY
	 CsGUKN93AchAqF1AHqmG15obScK6BABNzbleBDbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Jane Chu <jane.chu@oracle.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 443/499] x86/mce: use is_copy_from_user() to determine copy-from-user context
Date: Tue,  8 Apr 2025 12:50:55 +0200
Message-ID: <20250408104902.276084741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 1a15bb8303b6b104e78028b6c68f76a0d4562134 upstream.

Patch series "mm/hwpoison: Fix regressions in memory failure handling",
v4.

## 1. What am I trying to do:

This patchset resolves two critical regressions related to memory failure
handling that have appeared in the upstream kernel since version 5.17, as
compared to 5.10 LTS.

    - copyin case: poison found in user page while kernel copying from user space
    - instr case: poison found while instruction fetching in user space

## 2. What is the expected outcome and why

- For copyin case:

Kernel can recover from poison found where kernel is doing get_user() or
copy_from_user() if those places get an error return and the kernel return
-EFAULT to the process instead of crashing.  More specifily, MCE handler
checks the fixup handler type to decide whether an in kernel #MC can be
recovered.  When EX_TYPE_UACCESS is found, the PC jumps to recovery code
specified in _ASM_EXTABLE_FAULT() and return a -EFAULT to user space.

- For instr case:

If a poison found while instruction fetching in user space, full recovery
is possible.  User process takes #PF, Linux allocates a new page and fills
by reading from storage.


## 3. What actually happens and why

- For copyin case: kernel panic since v5.17

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and later patches updated the
extable fixup type for copy-from-user operations, changing it from
EX_TYPE_UACCESS to EX_TYPE_EFAULT_REG.  It breaks previous EX_TYPE_UACCESS
handling when posion found in get_user() or copy_from_user().

- For instr case: user process is killed by a SIGBUS signal due to #CMCI
  and #MCE race

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

### Background: why *UN*corrected errors tied to *C*MCI in Intel platform [1]

Prior to Icelake memory controllers reported patrol scrub events that
detected a previously unseen uncorrected error in memory by signaling a
broadcast machine check with an SRAO (Software Recoverable Action
Optional) signature in the machine check bank.  This was overkill because
it's not an urgent problem that no core is on the verge of consuming that
bad data.  It's also found that multi SRAO UCE may cause nested MCE
interrupts and finally become an IERR.

Hence, Intel downgrades the machine check bank signature of patrol scrub
from SRAO to UCNA (Uncorrected, No Action required), and signal changed to
#CMCI.  Just to add to the confusion, Linux does take an action (in
uc_decode_notifier()) to try to offline the page despite the UC*NA*
signature name.

### Background: why #CMCI and #MCE race when poison is consuming in
    Intel platform [1]

Having decided that CMCI/UCNA is the best action for patrol scrub errors,
the memory controller uses it for reads too.  But the memory controller is
executing asynchronously from the core, and can't tell the difference
between a "real" read and a speculative read.  So it will do CMCI/UCNA if
an error is found in any read.

Thus:

1) Core is clever and thinks address A is needed soon, issues a
   speculative read.

2) Core finds it is going to use address A soon after sending the read
   request

3) The CMCI from the memory controller is in a race with MCE from the
   core that will soon try to retire the load from address A.

Quite often (because speculation has got better) the CMCI from the memory
controller is delivered before the core is committed to the instruction
reading address A, so the interrupt is taken, and Linux offlines the page
(marking it as poison).


## Why user process is killed for instr case

Commit 046545a661af ("mm/hwpoison: fix error page recovered but reported
"not recovered"") tries to fix noise message "Memory error not recovered"
and skips duplicate SIGBUSs due to the race.  But it also introduced a bug
that kill_accessing_process() return -EHWPOISON for instr case, as result,
kill_me_maybe() send a SIGBUS to user process.

# 4. The fix, in my opinion, should be:

- For copyin case:

The key point is whether the error context is in a read from user memory.
We do not care about the ex-type if we know its a MOV reading from
userspace.

is_copy_from_user() return true when both of the following two checks are
true:

    - the current instruction is copy
    - source address is user memory

If copy_user is true, we set

m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;

Then do_machine_check() will try fixup_exception() first.

- For instr case: let kill_accessing_process() return 0 to prevent a SIGBUS.

- For patch 3:

The return value of memory_failure() is quite important while discussed
instr case regression with Tony and Miaohe for patch 2, so add comment
about the return value.


This patch (of 3):

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and commit 4c132d1d844a
("x86/futex: Remove .fixup usage") updated the extable fixup type for
copy-from-user operations, changing it from EX_TYPE_UACCESS to
EX_TYPE_EFAULT_REG.  The error context for copy-from-user operations no
longer functions as an in-kernel recovery context.  Consequently, the
error context for copy-from-user operations no longer functions as an
in-kernel recovery context, resulting in kernel panics with the message:
"Machine check: Data load in unrecoverable area of kernel."

To address this, it is crucial to identify if an error context involves a
read operation from user memory.  The function is_copy_from_user() can be
utilized to determine:

    - the current operation is copy
    - when reading user memory

When these conditions are met, is_copy_from_user() will return true,
confirming that it is indeed a direct copy from user memory.  This check
is essential for correctly handling the context of errors in these
operations without relying on the extable fixup types that previously
allowed for in-kernel recovery.

So, use is_copy_from_user() to determine if a context is copy user directly.

Link: https://lkml.kernel.org/r/20250312112852.82415-1-xueshuai@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250312112852.82415-2-xueshuai@linux.alibaba.com
Fixes: 4c132d1d844a ("x86/futex: Remove .fixup usage")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/severity.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -300,13 +300,12 @@ static noinstr int error_context(struct
 	copy_user  = is_copy_from_user(regs);
 	instrumentation_end();
 
-	switch (fixup_type) {
-	case EX_TYPE_UACCESS:
-		if (!copy_user)
-			return IN_KERNEL;
-		m->kflags |= MCE_IN_KERNEL_COPYIN;
-		fallthrough;
+	if (copy_user) {
+		m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;
+		return IN_KERNEL_RECOV;
+	}
 
+	switch (fixup_type) {
 	case EX_TYPE_FAULT_MCE_SAFE:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;


