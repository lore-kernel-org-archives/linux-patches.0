Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F164CF2;
	Mon,  8 Apr 2024 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581440; cv=none; b=WCYpqN2QAWLAUl4A7L8VXGQZeKvbFF+qNNj4Rt9JeB7+bFXd2EL0ew3RB62HW1/aa2MwbTa0HIYryqT4B1v8UVJQJtVg/4yzr6zIEVAvptdgiNc65jqF+a+qC7IRJzw7i75v9UftyqcCTq78t5+3CZzhHWP2XUKlDnZT6s3+qVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581440; c=relaxed/simple;
	bh=pECaPdJjQ7oDyMY/EtBVSjQ+7quhH+7goZH7FA0wujU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbwAkfoOs5hB9z94B6PeSYe2kJ0GyVdnvvxTz3xK1vj2zNHQAdggerRk1BAzVTmOYpg+cxwbj2/s68qCWPSxtLMqrPr2Cqf4XvVtdyUj9MBAm5Yt8HI+RmgscLv9hGAfel5yzvVeJDFrCnAwsbbOAX1HFjqCtmq6v4B4m2hi/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdehnbXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdehnbXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80779C433F1;
	Mon,  8 Apr 2024 13:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581439;
	bh=pECaPdJjQ7oDyMY/EtBVSjQ+7quhH+7goZH7FA0wujU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdehnbXK674T7Hf2N9Pm4EZ8J2rsR4ebn+NHHE6JeBZAAFam4F8gadOMrw4q78Zpj
	 V43no3H8v04VoU1mU1ny969BEU3P1nCtWW/54rOaxMq004WxnNbo83GrM3hbtUvqzV
	 j8AhOIpIZt12Pq0CY+3CYuj8y0p9GQd1A7GKrKBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/252] s390/bpf: Fix bpf_plt pointer arithmetic
Date: Mon,  8 Apr 2024 14:55:03 +0200
Message-ID: <20240408125306.784533401@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 7ded842b356d151ece8ac4985940438e6d3998bb ]

Kui-Feng Lee reported a crash on s390x triggered by the
dummy_st_ops/dummy_init_ptr_arg test [1]:

  [<0000000000000002>] 0x2
  [<00000000009d5cde>] bpf_struct_ops_test_run+0x156/0x250
  [<000000000033145a>] __sys_bpf+0xa1a/0xd00
  [<00000000003319dc>] __s390x_sys_bpf+0x44/0x50
  [<0000000000c4382c>] __do_syscall+0x244/0x300
  [<0000000000c59a40>] system_call+0x70/0x98

This is caused by GCC moving memcpy() after assignments in
bpf_jit_plt(), resulting in NULL pointers being written instead of
the return and the target addresses.

Looking at the GCC internals, the reordering is allowed because the
alias analysis thinks that the memcpy() destination and the assignments'
left-hand-sides are based on different objects: new_plt and
bpf_plt_ret/bpf_plt_target respectively, and therefore they cannot
alias.

This is in turn due to a violation of the C standard:

  When two pointers are subtracted, both shall point to elements of the
  same array object, or one past the last element of the array object
  ...

>From the C's perspective, bpf_plt_ret and bpf_plt are distinct objects
and cannot be subtracted. In the practical terms, doing so confuses the
GCC's alias analysis.

The code was written this way in order to let the C side know a few
offsets defined in the assembly. While nice, this is by no means
necessary. Fix the noncompliance by hardcoding these offsets.

[1] https://lore.kernel.org/bpf/c9923c1d-971d-4022-8dc8-1364e929d34c@gmail.com/

Fixes: f1d5df84cd8c ("s390/bpf: Implement bpf_arch_text_poke()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20240320015515.11883-1-iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 46 ++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index e507692e51e71..8af02176f68bf 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -516,11 +516,12 @@ static void bpf_skip(struct bpf_jit *jit, int size)
  * PLT for hotpatchable calls. The calling convention is the same as for the
  * ftrace hotpatch trampolines: %r0 is return address, %r1 is clobbered.
  */
-extern const char bpf_plt[];
-extern const char bpf_plt_ret[];
-extern const char bpf_plt_target[];
-extern const char bpf_plt_end[];
-#define BPF_PLT_SIZE 32
+struct bpf_plt {
+	char code[16];
+	void *ret;
+	void *target;
+} __packed;
+extern const struct bpf_plt bpf_plt;
 asm(
 	".pushsection .rodata\n"
 	"	.balign 8\n"
@@ -531,15 +532,14 @@ asm(
 	"	.balign 8\n"
 	"bpf_plt_ret: .quad 0\n"
 	"bpf_plt_target: .quad 0\n"
-	"bpf_plt_end:\n"
 	"	.popsection\n"
 );
 
-static void bpf_jit_plt(void *plt, void *ret, void *target)
+static void bpf_jit_plt(struct bpf_plt *plt, void *ret, void *target)
 {
-	memcpy(plt, bpf_plt, BPF_PLT_SIZE);
-	*(void **)((char *)plt + (bpf_plt_ret - bpf_plt)) = ret;
-	*(void **)((char *)plt + (bpf_plt_target - bpf_plt)) = target ?: ret;
+	memcpy(plt, &bpf_plt, sizeof(*plt));
+	plt->ret = ret;
+	plt->target = target;
 }
 
 /*
@@ -662,9 +662,9 @@ static void bpf_jit_epilogue(struct bpf_jit *jit, u32 stack_depth)
 	jit->prg = ALIGN(jit->prg, 8);
 	jit->prologue_plt = jit->prg;
 	if (jit->prg_buf)
-		bpf_jit_plt(jit->prg_buf + jit->prg,
+		bpf_jit_plt((struct bpf_plt *)(jit->prg_buf + jit->prg),
 			    jit->prg_buf + jit->prologue_plt_ret, NULL);
-	jit->prg += BPF_PLT_SIZE;
+	jit->prg += sizeof(struct bpf_plt);
 }
 
 static int get_probe_mem_regno(const u8 *insn)
@@ -1901,9 +1901,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	struct bpf_jit jit;
 	int pass;
 
-	if (WARN_ON_ONCE(bpf_plt_end - bpf_plt != BPF_PLT_SIZE))
-		return orig_fp;
-
 	if (!fp->jit_requested)
 		return orig_fp;
 
@@ -2009,14 +2006,11 @@ bool bpf_jit_supports_far_kfunc_call(void)
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *old_addr, void *new_addr)
 {
+	struct bpf_plt expected_plt, current_plt, new_plt, *plt;
 	struct {
 		u16 opc;
 		s32 disp;
 	} __packed insn;
-	char expected_plt[BPF_PLT_SIZE];
-	char current_plt[BPF_PLT_SIZE];
-	char new_plt[BPF_PLT_SIZE];
-	char *plt;
 	char *ret;
 	int err;
 
@@ -2035,18 +2029,18 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		 */
 	} else {
 		/* Verify the PLT. */
-		plt = (char *)ip + (insn.disp << 1);
-		err = copy_from_kernel_nofault(current_plt, plt, BPF_PLT_SIZE);
+		plt = ip + (insn.disp << 1);
+		err = copy_from_kernel_nofault(&current_plt, plt,
+					       sizeof(current_plt));
 		if (err < 0)
 			return err;
 		ret = (char *)ip + 6;
-		bpf_jit_plt(expected_plt, ret, old_addr);
-		if (memcmp(current_plt, expected_plt, BPF_PLT_SIZE))
+		bpf_jit_plt(&expected_plt, ret, old_addr);
+		if (memcmp(&current_plt, &expected_plt, sizeof(current_plt)))
 			return -EINVAL;
 		/* Adjust the call address. */
-		bpf_jit_plt(new_plt, ret, new_addr);
-		s390_kernel_write(plt + (bpf_plt_target - bpf_plt),
-				  new_plt + (bpf_plt_target - bpf_plt),
+		bpf_jit_plt(&new_plt, ret, new_addr);
+		s390_kernel_write(&plt->target, &new_plt.target,
 				  sizeof(void *));
 	}
 
-- 
2.43.0



