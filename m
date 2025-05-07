Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE7D214813;
	Wed,  7 May 2025 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645113; cv=none; b=O+P5rYq5Nh0ZXVDQlhO7penLGQ0HDIsBx3ZwEO3I2Dd8XxWO7vXBP2OlavYrbjVNuZnkEAlwDkJPaMsbMGCVfEhPj2VhU5pQn7mMyeDYNCx1aY9GRh1Hr4So2SOQFLbrhsq7pK8TR+rUyIXCSya2AklY1/j0GrTLOf+R1ilZwGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645113; c=relaxed/simple;
	bh=iv2obqMYoysDSWb3X+wGoYy1edbYHcUnKdI+icdNb4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahkGzmtLohr6wJo7jbfiJJN6Ef4KtiPBfBy/u+LZ6xl3w0B30Am3eWLo3earmoA1y/aARIopTldW8tYffWrdocnxm0EsYmCEn5060zDZnCVrQseZMqGNx6+KZMuh1w3X/QM10Vd4a4ed6+HgBn7Z7HjcWfA/ifuNLpyKTXlFxoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zn8SG2lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn8SG2lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7275BC4CEE2;
	Wed,  7 May 2025 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645112;
	bh=iv2obqMYoysDSWb3X+wGoYy1edbYHcUnKdI+icdNb4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zn8SG2lqpmt6f9p8zgC9sUaH1EK6fp/TJvusNOBxzsGZRMlv+ZpKtrAkPHndeSuBg
	 wyxS8fg965pFxLs22bLt9YCMGyMgA/sXIoBX2SMlAOGdCy5ZXdMFo02CqNWllvMkh9
	 DgoDc7gW8ObUTqKxGg7WIV9ecQVV+McW4rESB1BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Nam Cao <namcao@linutronix.de>
Subject: [PATCH 6.6 098/129] riscv: Pass patch_text() the length in bytes
Date: Wed,  7 May 2025 20:40:34 +0200
Message-ID: <20250507183817.472661426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit 51781ce8f4486c3738a6c85175b599ad1be71f89 upstream.

patch_text_nosync() already handles an arbitrary length of code, so this
removes a superfluous loop and reduces the number of icache flushes.

Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240327160520.791322-6-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[apply to v6.6]
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/patch.h     |    2 +-
 arch/riscv/kernel/patch.c          |   14 +++++---------
 arch/riscv/kernel/probes/kprobes.c |   18 ++++++++++--------
 arch/riscv/net/bpf_jit_comp64.c    |    7 ++++---
 4 files changed, 20 insertions(+), 21 deletions(-)

--- a/arch/riscv/include/asm/patch.h
+++ b/arch/riscv/include/asm/patch.h
@@ -9,7 +9,7 @@
 int patch_insn_write(void *addr, const void *insn, size_t len);
 int patch_text_nosync(void *addr, const void *insns, size_t len);
 int patch_text_set_nosync(void *addr, u8 c, size_t len);
-int patch_text(void *addr, u32 *insns, int ninsns);
+int patch_text(void *addr, u32 *insns, size_t len);
 
 extern int riscv_patch_in_stop_machine;
 
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -19,7 +19,7 @@
 struct patch_insn {
 	void *addr;
 	u32 *insns;
-	int ninsns;
+	size_t len;
 	atomic_t cpu_count;
 };
 
@@ -234,14 +234,10 @@ NOKPROBE_SYMBOL(patch_text_nosync);
 static int patch_text_cb(void *data)
 {
 	struct patch_insn *patch = data;
-	unsigned long len;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
-		for (i = 0; ret == 0 && i < patch->ninsns; i++) {
-			len = GET_INSN_LENGTH(patch->insns[i]);
-			ret = patch_insn_write(patch->addr + i * len, &patch->insns[i], len);
-		}
+		ret = patch_insn_write(patch->addr, patch->insns, patch->len);
 		/*
 		 * Make sure the patching store is effective *before* we
 		 * increment the counter which releases all waiting CPUs
@@ -262,13 +258,13 @@ static int patch_text_cb(void *data)
 }
 NOKPROBE_SYMBOL(patch_text_cb);
 
-int patch_text(void *addr, u32 *insns, int ninsns)
+int patch_text(void *addr, u32 *insns, size_t len)
 {
 	int ret;
 	struct patch_insn patch = {
 		.addr = addr,
 		.insns = insns,
-		.ninsns = ninsns,
+		.len = len,
 		.cpu_count = ATOMIC_INIT(0),
 	};
 
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -23,13 +23,13 @@ post_kprobe_handler(struct kprobe *, str
 
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
+	size_t len = GET_INSN_LENGTH(p->opcode);
 	u32 insn = __BUG_INSN_32;
-	unsigned long offset = GET_INSN_LENGTH(p->opcode);
 
-	p->ainsn.api.restore = (unsigned long)p->addr + offset;
+	p->ainsn.api.restore = (unsigned long)p->addr + len;
 
-	patch_text_nosync(p->ainsn.api.insn, &p->opcode, 1);
-	patch_text_nosync((void *)p->ainsn.api.insn + offset, &insn, 1);
+	patch_text_nosync(p->ainsn.api.insn, &p->opcode, len);
+	patch_text_nosync((void *)p->ainsn.api.insn + len, &insn, GET_INSN_LENGTH(insn));
 }
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)
@@ -116,16 +116,18 @@ void *alloc_insn_page(void)
 /* install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	u32 insn = (p->opcode & __INSN_LENGTH_MASK) == __INSN_LENGTH_32 ?
-		   __BUG_INSN_32 : __BUG_INSN_16;
+	size_t len = GET_INSN_LENGTH(p->opcode);
+	u32 insn = len == 4 ? __BUG_INSN_32 : __BUG_INSN_16;
 
-	patch_text(p->addr, &insn, 1);
+	patch_text(p->addr, &insn, len);
 }
 
 /* remove breakpoint from text */
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	patch_text(p->addr, &p->opcode, 1);
+	size_t len = GET_INSN_LENGTH(p->opcode);
+
+	patch_text(p->addr, &p->opcode, len);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -14,6 +14,7 @@
 #include "bpf_jit.h"
 
 #define RV_FENTRY_NINSNS 2
+#define RV_FENTRY_NBYTES (RV_FENTRY_NINSNS * 4)
 
 #define RV_REG_TCC RV_REG_A6
 #define RV_REG_TCC_SAVED RV_REG_S6 /* Store A6 in S6 if program do calls */
@@ -681,7 +682,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	if (ret)
 		return ret;
 
-	if (memcmp(ip, old_insns, RV_FENTRY_NINSNS * 4))
+	if (memcmp(ip, old_insns, RV_FENTRY_NBYTES))
 		return -EFAULT;
 
 	ret = gen_jump_or_nops(new_addr, ip, new_insns, is_call);
@@ -690,8 +691,8 @@ int bpf_arch_text_poke(void *ip, enum bp
 
 	cpus_read_lock();
 	mutex_lock(&text_mutex);
-	if (memcmp(ip, new_insns, RV_FENTRY_NINSNS * 4))
-		ret = patch_text(ip, new_insns, RV_FENTRY_NINSNS);
+	if (memcmp(ip, new_insns, RV_FENTRY_NBYTES))
+		ret = patch_text(ip, new_insns, RV_FENTRY_NBYTES);
 	mutex_unlock(&text_mutex);
 	cpus_read_unlock();
 


