Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EC86FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9DCC433CA;
	Sun, 17 Sep 2023 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980327;
	bh=kMdnKKDQXJ7aurRM+b2SZzRwItfKGRxWM676bBBn6CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRz8Ia984mV15ic3bLlXLOXZrAVbG1IAZzdEViWizz8tx35OkV7Gr5lzRMDux3Grs
	 iRE45rPAbpsED3bWExuruYEPCRDQqE9lKNcCFD/myVyM4gMyNLjfC/08Adf2evyyXy
	 hPhyKBkSipRBYJAMT+omHPPd8gnYgyZehP+rz8Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <hffilwlqm@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 159/285] s390/bpf: Pass through tail call counter in trampolines
Date: Sun, 17 Sep 2023 21:12:39 +0200
Message-ID: <20230917191057.178544391@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit a192103a11465e9d517975c50f9944dc80e44d61 ]

s390x eBPF programs use the following extension to the s390x calling
convention: tail call counter is passed on stack at offset
STK_OFF_TCCNT, which callees otherwise use as scratch space.

Currently trampoline does not respect this and clobbers tail call
counter. This breaks enforcing tail call limits in eBPF programs, which
have trampolines attached to them.

Fix by forwarding a copy of the tail call counter to the original eBPF
program in the trampoline (for fexit), and by restoring it at the end
of the trampoline (for fentry).

Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Reported-by: Leon Hwang <hffilwlqm@gmail.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230906004448.111674-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 5e9371fbf3d5f..de2fb12120d2e 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2088,6 +2088,7 @@ struct bpf_tramp_jit {
 				 */
 	int r14_off;		/* Offset of saved %r14 */
 	int run_ctx_off;	/* Offset of struct bpf_tramp_run_ctx */
+	int tccnt_off;		/* Offset of saved tailcall counter */
 	int do_fexit;		/* do_fexit: label */
 };
 
@@ -2258,12 +2259,16 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	tjit->r14_off = alloc_stack(tjit, sizeof(u64));
 	tjit->run_ctx_off = alloc_stack(tjit,
 					sizeof(struct bpf_tramp_run_ctx));
+	tjit->tccnt_off = alloc_stack(tjit, sizeof(u64));
 	/* The caller has already reserved STACK_FRAME_OVERHEAD bytes. */
 	tjit->stack_size -= STACK_FRAME_OVERHEAD;
 	tjit->orig_stack_args_off = tjit->stack_size + STACK_FRAME_OVERHEAD;
 
 	/* aghi %r15,-stack_size */
 	EMIT4_IMM(0xa70b0000, REG_15, -tjit->stack_size);
+	/* mvc tccnt_off(4,%r15),stack_size+STK_OFF_TCCNT(%r15) */
+	_EMIT6(0xd203f000 | tjit->tccnt_off,
+	       0xf000 | (tjit->stack_size + STK_OFF_TCCNT));
 	/* stmg %r2,%rN,fwd_reg_args_off(%r15) */
 	if (nr_reg_args)
 		EMIT6_DISP_LH(0xeb000000, 0x0024, REG_2,
@@ -2400,6 +2405,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 				       (nr_stack_args * sizeof(u64) - 1) << 16 |
 				       tjit->stack_args_off,
 			       0xf000 | tjit->orig_stack_args_off);
+		/* mvc STK_OFF_TCCNT(4,%r15),tccnt_off(%r15) */
+		_EMIT6(0xd203f000 | STK_OFF_TCCNT, 0xf000 | tjit->tccnt_off);
 		/* lgr %r1,%r8 */
 		EMIT4(0xb9040000, REG_1, REG_8);
 		/* %r1() */
@@ -2456,6 +2463,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	if (flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET))
 		EMIT6_DISP_LH(0xe3000000, 0x0004, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
+	/* mvc stack_size+STK_OFF_TCCNT(4,%r15),tccnt_off(%r15) */
+	_EMIT6(0xd203f000 | (tjit->stack_size + STK_OFF_TCCNT),
+	       0xf000 | tjit->tccnt_off);
 	/* aghi %r15,stack_size */
 	EMIT4_IMM(0xa70b0000, REG_15, tjit->stack_size);
 	/* Emit an expoline for the following indirect jump. */
-- 
2.40.1



