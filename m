Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA01D5CE0;
	Fri, 17 Oct 2025 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714045; cv=none; b=EDuM0jCqVkvOoxAbv5rF5uyHcvzxLdSx4jmUSJLHDrqskeeXRF9cp6qA3wBpPilgQNh7fgph3MYQUGD/y8sZU9llPbstKYX9DKUEhDnYOIDO8SSEEVDYpcfSLNkziJTG3MubLWlU6szDU8t+/QCv8dy3V031dT94Gl9xdyjrd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714045; c=relaxed/simple;
	bh=/PnmzpY02QJavIIz1eY1cBbKGIXnyc41endqCBVTPPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHjc5FNqqtRYTJi8/GXiqL2DFEZOfSLR+VoSJQsS/A8LmBa4bV1Ea4FLVnbzb0/iiJcZYwmbKvxr4zOlfl7CCT8H/VNJm+kdF7FFdZUYBqd+uD5V4rWdFDrNXKI4/0JYGUuLN/cqzi+obspA2UVybkQb6ODj/bQI4I3R4+BtDrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eE2pF+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eE2pF+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5666DC4CEE7;
	Fri, 17 Oct 2025 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714045;
	bh=/PnmzpY02QJavIIz1eY1cBbKGIXnyc41endqCBVTPPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eE2pF+aPT0MsjR+pFIgwJ2C8jrNF5754UHdm9AGUG0Jlwe19tg4tUkShqNwGmvTk
	 y+TbEVWBTbGWWwrWHx3TrDFFhtNS26a0Z+V1LPQZwuVls8LwE/UseuOKcrftw7hC+i
	 u7FmKA651FvtCCa2P1QnvdYEimWbhfaxzCau+xMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.6 185/201] s390/bpf: Change seen_reg to a mask
Date: Fri, 17 Oct 2025 16:54:06 +0200
Message-ID: <20251017145141.554488973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit 7ba4f43e16de351fe9821de80e15d88c884b2967 upstream.

Using a mask instead of an array saves a small amount of memory and
allows marking multiple registers as seen with a simple "or". Another
positive side-effect is that it speeds up verification with jitterbug.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240703005047.40915-2-iii@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -35,7 +35,7 @@
 
 struct bpf_jit {
 	u32 seen;		/* Flags to remember seen eBPF instructions */
-	u32 seen_reg[16];	/* Array to remember which registers are used */
+	u16 seen_regs;		/* Mask to remember which registers are used */
 	u32 *addrs;		/* Array with relative instruction addresses */
 	u8 *prg_buf;		/* Start of program */
 	int size;		/* Size of program and literal pool */
@@ -118,8 +118,8 @@ static inline void reg_set_seen(struct b
 {
 	u32 r1 = reg2hex[b1];
 
-	if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
-		jit->seen_reg[r1] = 1;
+	if (r1 >= 6 && r1 <= 15)
+		jit->seen_regs |= (1 << r1);
 }
 
 #define REG_SET_SEEN(b1)					\
@@ -127,8 +127,6 @@ static inline void reg_set_seen(struct b
 	reg_set_seen(jit, b1);					\
 })
 
-#define REG_SEEN(b1) jit->seen_reg[reg2hex[(b1)]]
-
 /*
  * EMIT macros for code generation
  */
@@ -436,12 +434,12 @@ static void restore_regs(struct bpf_jit
 /*
  * Return first seen register (from start)
  */
-static int get_start(struct bpf_jit *jit, int start)
+static int get_start(u16 seen_regs, int start)
 {
 	int i;
 
 	for (i = start; i <= 15; i++) {
-		if (jit->seen_reg[i])
+		if (seen_regs & (1 << i))
 			return i;
 	}
 	return 0;
@@ -450,15 +448,15 @@ static int get_start(struct bpf_jit *jit
 /*
  * Return last seen register (from start) (gap >= 2)
  */
-static int get_end(struct bpf_jit *jit, int start)
+static int get_end(u16 seen_regs, int start)
 {
 	int i;
 
 	for (i = start; i < 15; i++) {
-		if (!jit->seen_reg[i] && !jit->seen_reg[i + 1])
+		if (!(seen_regs & (3 << i)))
 			return i - 1;
 	}
-	return jit->seen_reg[15] ? 15 : 14;
+	return (seen_regs & (1 << 15)) ? 15 : 14;
 }
 
 #define REGS_SAVE	1
@@ -467,8 +465,10 @@ static int get_end(struct bpf_jit *jit,
  * Save and restore clobbered registers (6-15) on stack.
  * We save/restore registers in chunks with gap >= 2 registers.
  */
-static void save_restore_regs(struct bpf_jit *jit, int op, u32 stack_depth)
+static void save_restore_regs(struct bpf_jit *jit, int op, u32 stack_depth,
+			      u16 extra_regs)
 {
+	u16 seen_regs = jit->seen_regs | extra_regs;
 	const int last = 15, save_restore_size = 6;
 	int re = 6, rs;
 
@@ -482,10 +482,10 @@ static void save_restore_regs(struct bpf
 	}
 
 	do {
-		rs = get_start(jit, re);
+		rs = get_start(seen_regs, re);
 		if (!rs)
 			break;
-		re = get_end(jit, rs + 1);
+		re = get_end(seen_regs, rs + 1);
 		if (op == REGS_SAVE)
 			save_regs(jit, rs, re);
 		else
@@ -579,7 +579,7 @@ static void bpf_jit_prologue(struct bpf_
 	/* Tail calls have to skip above initialization */
 	jit->tail_call_start = jit->prg;
 	/* Save registers */
-	save_restore_regs(jit, REGS_SAVE, stack_depth);
+	save_restore_regs(jit, REGS_SAVE, stack_depth, 0);
 	/* Setup literal pool */
 	if (is_first_pass(jit) || (jit->seen & SEEN_LITERAL)) {
 		if (!is_first_pass(jit) &&
@@ -653,7 +653,7 @@ static void bpf_jit_epilogue(struct bpf_
 	/* Load exit code: lgr %r2,%b0 */
 	EMIT4(0xb9040000, REG_2, BPF_REG_0);
 	/* Restore registers */
-	save_restore_regs(jit, REGS_RESTORE, stack_depth);
+	save_restore_regs(jit, REGS_RESTORE, stack_depth, 0);
 	if (nospec_uses_trampoline()) {
 		jit->r14_thunk_ip = jit->prg;
 		/* Generate __s390_indirect_jump_r14 thunk */
@@ -1519,7 +1519,7 @@ static noinline int bpf_jit_insn(struct
 		/*
 		 * Restore registers before calling function
 		 */
-		save_restore_regs(jit, REGS_RESTORE, stack_depth);
+		save_restore_regs(jit, REGS_RESTORE, stack_depth, 0);
 
 		/*
 		 * goto *(prog->bpf_func + tail_call_start);


