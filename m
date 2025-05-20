Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCAD24503E;
	Tue, 20 May 2025 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750074; cv=none; b=qIyeyaX83K05QVQK2VoR+vim+pUf3/Bw6+eGRMmB2VS19jsXD9K/K5nQ6iqwgmdsTiFQRMbC2geJ+EYMI9hdKZI81vH8qkX5Qs3dOPz8btuuepw+ulv0O/2nhC0grsMqj/zPuijKeqTOCekRh7K0fGxHAWKzC4V7p5Hz/6r8eQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750074; c=relaxed/simple;
	bh=cRnht0v8UTDk+t28Ja3OAySVCSmMMOE7m1hW2FmFLzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ7yWv5GpUzN/a++DVg1qumzDolE83rvCd5LXFA4a6Fcbb0+7B4t464DIe0wQ9grw4Fw36EtRqn/62lO/4rvKsLj+WJqUrEhPgJWPI0rAoEUNjB5r9GR8AoM+cAhQ5MRIhe20fDlvOtUqnow9fW0DSIU+lY7NNbQmXLrubt1FDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBRGFPhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBRGFPhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494C4C4CEE9;
	Tue, 20 May 2025 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750073;
	bh=cRnht0v8UTDk+t28Ja3OAySVCSmMMOE7m1hW2FmFLzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBRGFPhFs1e9sRb0tCs1D5FSHB1PQMorG0FFYKMCDuWp2R5cd8zv1fo8Aot81++bz
	 ATWYwyGg7o3P35pNu19CyGkeihj6U7+ivIo17Y2bPevMCWfT6ad2AIYYJoZUE93Ghi
	 WG92omnwiXe5VxLrHNV14LZgBvSHHrc8b2vLJKzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/143] binfmt_elf: Move brk for static PIE even if ASLR disabled
Date: Tue, 20 May 2025 15:49:21 +0200
Message-ID: <20250520125810.295222635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 11854fe263eb1b9a8efa33b0c087add7719ea9b4 ]

In commit bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing
direct loader exec"), the brk was moved out of the mmap region when
loading static PIE binaries (ET_DYN without INTERP). The common case
for these binaries was testing new ELF loaders, so the brk needed to
be away from mmap to avoid colliding with stack, future mmaps (of the
loader-loaded binary), etc. But this was only done when ASLR was enabled,
in an attempt to minimize changes to memory layouts.

After adding support to respect alignment requirements for static PIE
binaries in commit 3545deff0ec7 ("binfmt_elf: Honor PT_LOAD alignment
for static PIE"), it became possible to have a large gap after the
final PT_LOAD segment and the top of the mmap region. This means that
future mmap allocations might go after the last PT_LOAD segment (where
brk might be if ASLR was disabled) instead of before them (where they
traditionally ended up).

On arm64, running with ASLR disabled, Ubuntu 22.04's "ldconfig" binary,
a static PIE, has alignment requirements that leaves a gap large enough
after the last PT_LOAD segment to fit the vdso and vvar, but still leave
enough space for the brk (which immediately follows the last PT_LOAD
segment) to be allocated by the binary.

fffff7f20000-fffff7fde000 r-xp 00000000 fe:02 8110426 /sbin/ldconfig.real
fffff7fee000-fffff7ff5000 rw-p 000be000 fe:02 8110426 /sbin/ldconfig.real
fffff7ff5000-fffff7ffa000 rw-p 00000000 00:00 0
***[brk will go here at fffff7ffa000]***
fffff7ffc000-fffff7ffe000 r--p 00000000 00:00 0       [vvar]
fffff7ffe000-fffff8000000 r-xp 00000000 00:00 0       [vdso]
fffffffdf000-1000000000000 rw-p 00000000 00:00 0      [stack]

After commit 0b3bc3354eb9 ("arm64: vdso: Switch to generic storage
implementation"), the arm64 vvar grew slightly, and suddenly the brk
collided with the allocation.

fffff7f20000-fffff7fde000 r-xp 00000000 fe:02 8110426 /sbin/ldconfig.real
fffff7fee000-fffff7ff5000 rw-p 000be000 fe:02 8110426 /sbin/ldconfig.real
fffff7ff5000-fffff7ffa000 rw-p 00000000 00:00 0
***[oops, no room any more, vvar is at fffff7ffa000!]***
fffff7ffa000-fffff7ffe000 r--p 00000000 00:00 0       [vvar]
fffff7ffe000-fffff8000000 r-xp 00000000 00:00 0       [vdso]
fffffffdf000-1000000000000 rw-p 00000000 00:00 0      [stack]

The solution is to unconditionally move the brk out of the mmap region
for static PIE binaries. Whether ASLR is enabled or not does not change if
there may be future mmap allocation collisions with a growing brk region.

Update memory layout comments (with kernel-doc headings), consolidate
the setting of mm->brk to later (it isn't needed early), move static PIE
brk out of mmap unconditionally, and make sure brk(2) knows to base brk
position off of mm->start_brk not mm->end_data no matter what the cause of
moving it is (via current->brk_randomized).

For the CONFIG_COMPAT_BRK case, though, leave the logic unchanged, as we
can never safely move the brk. These systems, however, are not using
specially aligned static PIE binaries.

Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/lkml/f93db308-4a0e-4806-9faf-98f890f5a5e6@arm.com/
Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
Link: https://lore.kernel.org/r/20250425224502.work.520-kees@kernel.org
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 71 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0a216a078c315..47335a0f4a618 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -825,6 +825,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
 	struct elf_phdr *elf_property_phdata = NULL;
 	unsigned long elf_brk;
+	bool brk_moved = false;
 	int retval, i;
 	unsigned long elf_entry;
 	unsigned long e_entry;
@@ -1092,15 +1093,19 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			/* Calculate any requested alignment. */
 			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
 
-			/*
-			 * There are effectively two types of ET_DYN
-			 * binaries: programs (i.e. PIE: ET_DYN with PT_INTERP)
-			 * and loaders (ET_DYN without PT_INTERP, since they
-			 * _are_ the ELF interpreter). The loaders must
-			 * be loaded away from programs since the program
-			 * may otherwise collide with the loader (especially
-			 * for ET_EXEC which does not have a randomized
-			 * position). For example to handle invocations of
+			/**
+			 * DOC: PIE handling
+			 *
+			 * There are effectively two types of ET_DYN ELF
+			 * binaries: programs (i.e. PIE: ET_DYN with
+			 * PT_INTERP) and loaders (i.e. static PIE: ET_DYN
+			 * without PT_INTERP, usually the ELF interpreter
+			 * itself). Loaders must be loaded away from programs
+			 * since the program may otherwise collide with the
+			 * loader (especially for ET_EXEC which does not have
+			 * a randomized position).
+			 *
+			 * For example, to handle invocations of
 			 * "./ld.so someprog" to test out a new version of
 			 * the loader, the subsequent program that the
 			 * loader loads must avoid the loader itself, so
@@ -1113,6 +1118,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * ELF_ET_DYN_BASE and loaders are loaded into the
 			 * independently randomized mmap region (0 load_bias
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
+			 *
+			 * See below for "brk" handling details, which is
+			 * also affected by program vs loader and ASLR.
 			 */
 			if (interpreter) {
 				/* On ET_DYN with PT_INTERP, we do the ASLR. */
@@ -1229,8 +1237,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	start_data += load_bias;
 	end_data += load_bias;
 
-	current->mm->start_brk = current->mm->brk = ELF_PAGEALIGN(elf_brk);
-
 	if (interpreter) {
 		elf_entry = load_elf_interp(interp_elf_ex,
 					    interpreter,
@@ -1286,27 +1292,44 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	mm->end_data = end_data;
 	mm->start_stack = bprm->p;
 
-	if ((current->flags & PF_RANDOMIZE) && (snapshot_randomize_va_space > 1)) {
+	/**
+	 * DOC: "brk" handling
+	 *
+	 * For architectures with ELF randomization, when executing a
+	 * loader directly (i.e. static PIE: ET_DYN without PT_INTERP),
+	 * move the brk area out of the mmap region and into the unused
+	 * ELF_ET_DYN_BASE region. Since "brk" grows up it may collide
+	 * early with the stack growing down or other regions being put
+	 * into the mmap region by the kernel (e.g. vdso).
+	 *
+	 * In the CONFIG_COMPAT_BRK case, though, everything is turned
+	 * off because we're not allowed to move the brk at all.
+	 */
+	if (!IS_ENABLED(CONFIG_COMPAT_BRK) &&
+	    IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
+	    elf_ex->e_type == ET_DYN && !interpreter) {
+		elf_brk = ELF_ET_DYN_BASE;
+		/* This counts as moving the brk, so let brk(2) know. */
+		brk_moved = true;
+	}
+	mm->start_brk = mm->brk = ELF_PAGEALIGN(elf_brk);
+
+	if ((current->flags & PF_RANDOMIZE) && snapshot_randomize_va_space > 1) {
 		/*
-		 * For architectures with ELF randomization, when executing
-		 * a loader directly (i.e. no interpreter listed in ELF
-		 * headers), move the brk area out of the mmap region
-		 * (since it grows up, and may collide early with the stack
-		 * growing down), and into the unused ELF_ET_DYN_BASE region.
+		 * If we didn't move the brk to ELF_ET_DYN_BASE (above),
+		 * leave a gap between .bss and brk.
 		 */
-		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
-		    elf_ex->e_type == ET_DYN && !interpreter) {
-			mm->brk = mm->start_brk = ELF_ET_DYN_BASE;
-		} else {
-			/* Otherwise leave a gap between .bss and brk. */
+		if (!brk_moved)
 			mm->brk = mm->start_brk = mm->brk + PAGE_SIZE;
-		}
 
 		mm->brk = mm->start_brk = arch_randomize_brk(mm);
+		brk_moved = true;
+	}
+
 #ifdef compat_brk_randomized
+	if (brk_moved)
 		current->brk_randomized = 1;
 #endif
-	}
 
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
-- 
2.39.5



