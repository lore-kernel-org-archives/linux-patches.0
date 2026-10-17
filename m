Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8547224D6;
	Sat, 17 Oct 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253180; cv=none; b=ZMVt3tu4DwTakhxfrXoIZAs6NH5mCrSfmHn+cWqiJwazmCEoDHB6+gygQGyt9FAefECiTkWwhvgJY6gIMxO81HSyrOrM/bW57lBHCCeqqQ1YSnFgOEcT0L/c7l0erq/URI5bAWLk3nz9DYY/9Q7f7Na4AFQ8FoywhaR4FWdGUPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253180; c=relaxed/simple;
	bh=W3yPTDPQQe0Of5hK6yGzUWeGNMRRt72Y0JVgKsGMHD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXSyZ9s/sgTj/zbP+qhteTLMKoTHGYGJz5upS80N09CAmtXRFglx1mxj1XoungqzhypYAWx7/GILY/ayjaPdFbf8jVW7og0fBnXsfrRt4u+LxYgJ4BTMgNMHbpwvUeorwW49fVIU1PduWM4Gxlmsf9qjCZVnNVXHnWTamGS8Nig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGGxcCn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGGxcCn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064591F000C4;
	Sat, 17 Oct 2026 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253179;
	bh=a4DDRKcw5vx2VBfQ3ZEEtT/pmUjqCiOjGrBedwnat3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGGxcCn93s6IdoRoU0wUGlKsbSQNk3ZV5lEgloUNe98CCwIgeb8O2yaZYAAFDQt4e
	 GA6tHneqa0bV/54AnlhcYnHjjA8uB8wSGRkWMNMEVV3VpjoUi4FEQrd1bCE982gnI3
	 VAxGpPk4L1mVZVhD+Y2O8cTTKSx7VBD1F4/6Nz0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei-Jie Hung <imbigking12@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/869] riscv: patch: fix handling of bpf-jit execmem addresses
Date: Sat, 17 Oct 2026 17:47:57 +0200
Message-ID: <20261017160037.940910466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei-Jie Hung <imbigking12@gmail.com>

[ Upstream commit a510e1ae8c9030750c2edf7b0bc9b186cd8c7a06 ]

Commit 8718e5a3090b ("riscv: patch: skip fixmap mapping when kernel text
is already writable") gated the core_kernel_text() branch of patch_map()
on CONFIG_STRICT_KERNEL_RWX, and explicitly left the vmalloc branch
unchanged. That branch has a separate problem.

That branch only creates a temporary writable fixmap alias when
CONFIG_STRICT_MODULE_RWX is enabled, and otherwise assumes the target is
directly writable and returns the address unchanged. That assumption no
longer holds: bpf_prog_pack_alloc calls set_memory_rox() on every pack
unconditionally in alloc_new_pack(), independently of any
CONFIG_STRICT_*_RWX option, so BPF text in the vmalloc area is read-only
regardless of what CONFIG_STRICT_MODULE_RWX says.

With CONFIG_STRICT_MODULE_RWX=n, patch_map() returns the read-only
address directly, the subsequent copy_to_kernel_nofault() takes a
page fault and returns -EFAULT. bpf_arch_text_copy() turns that into
-EINVAL, which propagates through bpf_jit_binary_pack_finalize() to the
WARN_ON() in bpf_int_jit_compile() and leaves the program un-JITed.

Note that BPF cannot be fixed the way kprobes was in
commit bdc46e507b59 ("riscv: mm: make EXECMEM_KPROBES writable without
CONFIG_STRICT_MODULE_RWX"). EXECMEM_BPF is already PAGE_KERNEL, i.e.
writable at allocation time; the read-only mapping is established
afterwards by generic code in alloc_new_pack(), which arch code cannot
influence. The only place this can be handled is patch_map().

This is the same problem that was fixed on arm64 by commit b1480ed230ac
("arm64: patching: fix handling of execmem addresses"), and the fix is
the same: CONFIG_EXECMEM is what actually tracks whether the vmalloc
area can hold executable memory that needs a temporary alias to be
written. CONFIG_BPF_JIT, CONFIG_KPROBES and CONFIG_MODULES all select
it.

Note that this is not limited to CONFIG_MODULES=n. Unlike arm64, riscv
selects CONFIG_ARCH_OPTIONAL_KERNEL_RWX, so CONFIG_STRICT_MODULE_RWX can
be disabled with CONFIG_MODULES=y as well, and the bug is reachable in
that configuration too.

The !CONFIG_MMU build is unaffected: it has its own __patch_insn_set()
and __patch_insn_write() implementations and never calls patch_map().

Fixes: 2c9e5d4a0082 ("bpf: remove CONFIG_BPF_JIT dependency on CONFIG_MODULES of")
Signed-off-by: Wei-Jie Hung <imbigking12@gmail.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Tested-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260914115607.350097-1-imbigking12@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/patch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index f8826f1595e16..9c9282f8a3a50 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -46,7 +46,7 @@ static __always_inline void *patch_map(void *addr, const unsigned int fixmap)
 
 	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
 		phys = __pa_symbol(addr);
-	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
+	} else if (IS_ENABLED(CONFIG_EXECMEM)) {
 		struct page *page = vmalloc_to_page(addr);
 
 		BUG_ON(!page);
-- 
2.53.0



