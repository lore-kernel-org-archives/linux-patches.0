Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F4F4CDDFF;
	Thu, 17 Sep 2026 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659319; cv=none; b=P/ky9fb82d1OuiZdbEG6VqzI4zSjOSMGyt6AJ+zaMVMplqqnhPMtpD4x4U40tylMiOHA1lHYQukt3AAkK0hd0lhwHIO5RgyjSTSVjPQsd3XWFtZ3la2P8As8fK90sthgA0r/tHHgyjVnWoLZhDLgPgqZCny7oG1x9sqn89TWkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659319; c=relaxed/simple;
	bh=dxJUvVDPQh7U4ZtxhxKVBuDxeGA407G6P/jlu9PC9pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYjHSzLyqsRij55WFkWvuOx47+KdPVBpBiE4nTMAdQgDJpaV8dmgSspkmCspv+fQRC5pwCBGog6AxDEnNDBA/fSqDh9rwLiDLje4eofqUergLAGbLRY3oqAltrydaSPHpkKqHjDYHhK7VCUYLPjlBnsoE+8Q1cwjCh1ZoGtE3Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll+VuT7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll+VuT7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952861F0089A;
	Thu, 17 Sep 2026 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659312;
	bh=y72zT/eL0J+DjrxEL852ti1IEfmEo0X/827QePar1xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll+VuT7zrwV6Y4yaUh0U7ylPrq9AIikqLoKJlnmv5Qk1EIi3LxMULamhGGhsRNACq
	 Of/vgYM5y2/cYm0oO82kv/MAk9OlOaCTPUBEVjSv6mCbiob69QRVFDpkA8zMBoOQEV
	 vY7iDuQKJRNmiB1fx06hI8GQZCav6YUqrrt4MUG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 215/733] powerpc: Dont drop _TIF_RESTOREALL on syscall restart
Date: Thu, 17 Sep 2026 16:08:43 +0100
Message-ID: <20260917151356.555010575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit c7585b8e99ad97a0f5dd21e45c90a33aeab0d92b ]

So the syscall return sequence is as follows:
A syscall return to userspace is prepared and then a short asm sequence
that actually does the RFI. Note that this asm range is restartable i.e.
EE is still on, so an interrupt (e.g. decrementer or external interrupt)
can hit while SRR/GPRs are being loaded. This is defined via:

RESTART_TABLE(.Lsyscall_rst_start, .Lsyscall_rst_end, syscall_restart)

This restart table then sends us to syscall_restart rather than resuming
in the middle of the RFI. The same stub is also used if irq_happened
already has a pending bit (soft-masked irq that has not been replayed
yet (PowerPC special case of local_irq_disable())).

Here is a bit of a flow of sequence of code to visualize:
  syscall_exit_prepare
      decide full-GPR restore (_TIF_RESTOREALL) for signal,
      rt_sigreturn or syscall trace
      save that in regs->exit_result and return it in r3
           |
           v
  .Lsyscall_rst_start .. _end     EE still on
      irq_happened set or interrupt in this range?
           | no                         | yes
           v                            v
      cmpdi r3,0                  syscall_exit_restart
      restore all / zero            replay irq, try exit again
      volatiles; RFI                must return flags in r3
                                    again for the same cmpdi

Now r3 after prepare is the flags word, not the actual syscall return. A nested
interrupt clobbers it, so the restart stub reloads RESULT into r3 and the
C handler (syscall_exit_restart()) should put the flags back (because later asm
checks whether r3 returned from C has _TIF_RESTOREALL set or not):
	cmpdi r3, 0
	bne	.Lsyscall_restore_regs

Note that syscall_exit_restart() already ORs any new _TIF_RESTOREALL into
exit_result, but then it only returns the new sample and not the full
regs->exit_result.

That sample could be often 0 even when restore-all is still required:

  - rt_sigreturn / syscall trace set the bit in prepare's local
    ret and in exit_result. They never set exit_flags, which is
    what restart samples.

  - a signal does set exit_flags but restart clears it. A
    second pass through the stub then returns 0 while
    exit_result still has the bit.

The asm as mentioned earlier then treats r3==0 as the fast path and
zeros r0/r4-r12. That means the userspace that needed the full register
set could SIGSEGVs, (which could happen often in ld64.so.2 like while
doing a parallel kernel build as reported by Venkat).

So we should instead return the accumulated exit_result, like how we do
in interrupt_exit_user_restart(). Note that prior to this commit
263e5159e00a ("powerpc: Fix exit_flags field placement in pt_regs for ptrace")
we were returning regs->exit_result from syscall_exit_restart(), but
this commit changed that behaviour.

Fixes: 263e5159e00a ("powerpc: Fix exit_flags field placement in pt_regs for ptrace")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/75419f88-eab9-444b-bf97-28a9765819ad@linux.ibm.com/
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/10c86c909f870d90b3094f76b692b44ebe9caeac.1787976185.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 5b88bf72786c7..55f9c0c9922ac 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -175,7 +175,7 @@ notrace unsigned long syscall_exit_restart(unsigned long r3, struct pt_regs *reg
 	current_thread_info()->exit_flags &= ~_TIF_RESTOREALL;
 	regs->exit_result |= ret;
 
-	return ret;
+	return regs->exit_result;
 }
 #endif
 
-- 
2.53.0



