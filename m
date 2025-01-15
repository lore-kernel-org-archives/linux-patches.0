Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083EB1DB15D;
	Wed, 15 Jan 2025 11:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938895; cv=none; b=sX6DDTlvVbKGnbBXJJX5zf2I1Qw6js0Km/5/OjnjUZCeQJU3I59eqTz/fGtttMDI8QjjK/XFINNxdjWOoJbCVHs0z4OlVhpVWtHKyYGoQpwBaPmb269ffVw5fLEOMq7F32D+lTDk/BVxV0XN2fB81Rw+5hZGnrzJk/gMN+ZVYNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938895; c=relaxed/simple;
	bh=c9X0NIWDNI+k1MMq9AG7A/YUGZIM2iNKo0Grdb7Tcfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5lUeCn/YhftmZ5E50bOxHwlxmTTnFrvqiO77H3FgEIw3MrbfhNFJ+2E9+0YfuED1ZCTwtZvNgEO2WifdoW7pmfEMRtUq8V40F4NAxuvOsGzg+/YuiNUONfaDvw8FaoUckzxZPyNi6NRXPLD8qYWzvf7hyT93E6ktyMSamAp72E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGHd7rBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGHd7rBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BA4C4CEE4;
	Wed, 15 Jan 2025 11:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938893;
	bh=c9X0NIWDNI+k1MMq9AG7A/YUGZIM2iNKo0Grdb7Tcfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGHd7rBTOszS+R8E5VDP/j8B3GMUGxLE5h3aGJhEGW8rV7xpotnkCv4GIisW1FbwE
	 isgibqrN1/8g3nHc+Z93CIEuIda7lRpeeq/1OcSrRYg7ZDg4w1iUotqZv5JGv3OSuo
	 S781wqpkXUZeNYL5nzCDnzdc6Vli0VQmJdTtgD5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrea Parri <parri.andrea@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/129] riscv: Fix text patching when IPI are used
Date: Wed, 15 Jan 2025 11:38:23 +0100
Message-ID: <20250115103559.456512572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit c97bf629963e52b205ed5fbaf151e5bd342f9c63 ]

For now, we use stop_machine() to patch the text and when we use IPIs for
remote icache flushes (which is emitted in patch_text_nosync()), the system
hangs.

So instead, make sure every CPU executes the stop_machine() patching
function and emit a local icache flush there.

Co-developed-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/20240229121056.203419-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 13134cc94914 ("riscv: kprobes: Fix incorrect address calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/patch.h |  1 +
 arch/riscv/kernel/ftrace.c     | 44 ++++++++++++++++++++++++++++++----
 arch/riscv/kernel/patch.c      | 16 +++++++++----
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/patch.h b/arch/riscv/include/asm/patch.h
index e88b52d39eac..9f5d6e14c405 100644
--- a/arch/riscv/include/asm/patch.h
+++ b/arch/riscv/include/asm/patch.h
@@ -6,6 +6,7 @@
 #ifndef _ASM_RISCV_PATCH_H
 #define _ASM_RISCV_PATCH_H
 
+int patch_insn_write(void *addr, const void *insn, size_t len);
 int patch_text_nosync(void *addr, const void *insns, size_t len);
 int patch_text_set_nosync(void *addr, u8 c, size_t len);
 int patch_text(void *addr, u32 *insns, int ninsns);
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 03a6434a8cdd..6ede2bcce238 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -8,6 +8,7 @@
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/memory.h>
+#include <linux/stop_machine.h>
 #include <asm/cacheflush.h>
 #include <asm/patch.h>
 
@@ -75,8 +76,7 @@ static int __ftrace_modify_call(unsigned long hook_pos, unsigned long target,
 		make_call_t0(hook_pos, target, call);
 
 	/* Replace the auipc-jalr pair at once. Return -EPERM on write error. */
-	if (patch_text_nosync
-	    ((void *)hook_pos, enable ? call : nops, MCOUNT_INSN_SIZE))
+	if (patch_insn_write((void *)hook_pos, enable ? call : nops, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
@@ -88,7 +88,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	make_call_t0(rec->ip, addr, call);
 
-	if (patch_text_nosync((void *)rec->ip, call, MCOUNT_INSN_SIZE))
+	if (patch_insn_write((void *)rec->ip, call, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
@@ -99,7 +99,7 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 {
 	unsigned int nops[2] = {NOP4, NOP4};
 
-	if (patch_text_nosync((void *)rec->ip, nops, MCOUNT_INSN_SIZE))
+	if (patch_insn_write((void *)rec->ip, nops, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
@@ -134,6 +134,42 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 	return ret;
 }
+
+struct ftrace_modify_param {
+	int command;
+	atomic_t cpu_count;
+};
+
+static int __ftrace_modify_code(void *data)
+{
+	struct ftrace_modify_param *param = data;
+
+	if (atomic_inc_return(&param->cpu_count) == num_online_cpus()) {
+		ftrace_modify_all_code(param->command);
+		/*
+		 * Make sure the patching store is effective *before* we
+		 * increment the counter which releases all waiting CPUs
+		 * by using the release variant of atomic increment. The
+		 * release pairs with the call to local_flush_icache_all()
+		 * on the waiting CPU.
+		 */
+		atomic_inc_return_release(&param->cpu_count);
+	} else {
+		while (atomic_read(&param->cpu_count) <= num_online_cpus())
+			cpu_relax();
+	}
+
+	local_flush_icache_all();
+
+	return 0;
+}
+
+void arch_ftrace_update_code(int command)
+{
+	struct ftrace_modify_param param = { command, ATOMIC_INIT(0) };
+
+	stop_machine(__ftrace_modify_code, &param, cpu_online_mask);
+}
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 30e12b310cab..78387d843aa5 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -196,7 +196,7 @@ int patch_text_set_nosync(void *addr, u8 c, size_t len)
 }
 NOKPROBE_SYMBOL(patch_text_set_nosync);
 
-static int patch_insn_write(void *addr, const void *insn, size_t len)
+int patch_insn_write(void *addr, const void *insn, size_t len)
 {
 	size_t patched = 0;
 	size_t size;
@@ -240,16 +240,24 @@ static int patch_text_cb(void *data)
 	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < patch->ninsns; i++) {
 			len = GET_INSN_LENGTH(patch->insns[i]);
-			ret = patch_text_nosync(patch->addr + i * len,
-						&patch->insns[i], len);
+			ret = patch_insn_write(patch->addr + i * len, &patch->insns[i], len);
 		}
-		atomic_inc(&patch->cpu_count);
+		/*
+		 * Make sure the patching store is effective *before* we
+		 * increment the counter which releases all waiting CPUs
+		 * by using the release variant of atomic increment. The
+		 * release pairs with the call to local_flush_icache_all()
+		 * on the waiting CPU.
+		 */
+		atomic_inc_return_release(&patch->cpu_count);
 	} else {
 		while (atomic_read(&patch->cpu_count) <= num_online_cpus())
 			cpu_relax();
 		smp_mb();
 	}
 
+	local_flush_icache_all();
+
 	return ret;
 }
 NOKPROBE_SYMBOL(patch_text_cb);
-- 
2.39.5



