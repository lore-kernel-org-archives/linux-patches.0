Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578502459E3;
	Tue, 20 May 2025 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749397; cv=none; b=A1DQ3jqBJDK3BadwmnN2UzZAoVxEW6JbTjPpXvmON6d8SF8OTIouPj1TwWMWxdaXcepvyVe+4JWgbwqGrh/3ZwyryOWEBShfvkYh5+JpMv27EAK2WQxd00u0DO6GKZuxhpbL7jxMmhjhNiVE0Z3GQJXqqGX6BF1TENLiBScsaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749397; c=relaxed/simple;
	bh=R5+Fpv74hDRbcyJ8ZNr9fyj6ot5rQt99nXZ1RFUxEOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGgEbTwCLHhO6FGnpm4OJuXr2EBTuup8O8pqKodEXwqMKz94rkxezfHijJXC8r3PGLaU+eAG+7KJxfZJWlRxIuMN2UyCYhH+Y1YJfe/gr1BE39liWgBLUlzREKo1W9tEbRDHgHWEZJJ4cplOmYY/+MfzDh+lcWKbnCSch/J5Kws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwF/Rtfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwF/Rtfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B43C4CEE9;
	Tue, 20 May 2025 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749396;
	bh=R5+Fpv74hDRbcyJ8ZNr9fyj6ot5rQt99nXZ1RFUxEOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwF/Rtfufhs2i2He0oXVKO7pD4+LOS7oCUAnLjtcH0XfbU1wet5eGNIahiqrM5/cg
	 Xwu9bS+qIpLvaPQ8JC/QCGS+dUu3tF7soEntp+7LYdTn3EZWjSqpJmXYTN1qWwduMl
	 ZrSSiQlVqV2JhIDIeecnORCnmb0q5ZRdWV1T1MKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/97] binfmt_elf: Honor PT_LOAD alignment for static PIE
Date: Tue, 20 May 2025 15:49:33 +0200
Message-ID: <20250520125800.996332646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 3545deff0ec7a37de7ed9632e262598582b140e9 ]

The p_align values in PT_LOAD were ignored for static PIE executables
(i.e. ET_DYN without PT_INTERP). This is because there is no way to
request a non-fixed mmap region with a specific alignment. ET_DYN with
PT_INTERP uses a separate base address (ELF_ET_DYN_BASE) and binfmt_elf
performs the ASLR itself, which means it can also apply alignment. For
the mmap region, the address selection happens deep within the vm_mmap()
implementation (when the requested address is 0).

The earlier attempt to implement this:

  commit 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD p_align values for static PIE")
  commit 925346c129da ("fs/binfmt_elf: fix PT_LOAD p_align values for loaders")

did not take into account the different base address origins, and were
eventually reverted:

  aeb7923733d1 ("revert "fs/binfmt_elf: use PT_LOAD p_align values for static PIE"")

In order to get the correct alignment from an mmap base, binfmt_elf must
perform a 0-address load first, then tear down the mapping and perform
alignment on the resulting address. Since this is slightly more overhead,
only do this when it is needed (i.e. the alignment is not the default
ELF alignment). This does, however, have the benefit of being able to
use MAP_FIXED_NOREPLACE, to avoid potential collisions.

With this fixed, enable the static PIE self tests again.

Reported-by: H.J. Lu <hjl.tools@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=215275
Link: https://lore.kernel.org/r/20240508173149.677910-3-keescook@chromium.org
Signed-off-by: Kees Cook <kees@kernel.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c                       | 42 +++++++++++++++++++++++----
 tools/testing/selftests/exec/Makefile |  2 +-
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 26abe256e91fb..fd3d800f69c1c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1120,10 +1120,13 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				goto out_free_dentry;
 			}
 
+			/* Calculate any requested alignment. */
+			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
+
 			/*
 			 * There are effectively two types of ET_DYN
-			 * binaries: programs (i.e. PIE: ET_DYN with INTERP)
-			 * and loaders (ET_DYN without INTERP, since they
+			 * binaries: programs (i.e. PIE: ET_DYN with PT_INTERP)
+			 * and loaders (ET_DYN without PT_INTERP, since they
 			 * _are_ the ELF interpreter). The loaders must
 			 * be loaded away from programs since the program
 			 * may otherwise collide with the loader (especially
@@ -1143,15 +1146,44 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
 			if (interpreter) {
+				/* On ET_DYN with PT_INTERP, we do the ASLR. */
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
-				alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
+				/* Adjust alignment as requested. */
 				if (alignment)
 					load_bias &= ~(alignment - 1);
 				elf_flags |= MAP_FIXED_NOREPLACE;
-			} else
-				load_bias = 0;
+			} else {
+				/*
+				 * For ET_DYN without PT_INTERP, we rely on
+				 * the architectures's (potentially ASLR) mmap
+				 * base address (via a load_bias of 0).
+				 *
+				 * When a large alignment is requested, we
+				 * must do the allocation at address "0" right
+				 * now to discover where things will load so
+				 * that we can adjust the resulting alignment.
+				 * In this case (load_bias != 0), we can use
+				 * MAP_FIXED_NOREPLACE to make sure the mapping
+				 * doesn't collide with anything.
+				 */
+				if (alignment > ELF_MIN_ALIGN) {
+					load_bias = elf_load(bprm->file, 0, elf_ppnt,
+							     elf_prot, elf_flags, total_size);
+					if (BAD_ADDR(load_bias)) {
+						retval = IS_ERR_VALUE(load_bias) ?
+							 PTR_ERR((void*)load_bias) : -EINVAL;
+						goto out_free_dentry;
+					}
+					vm_munmap(load_bias, total_size);
+					/* Adjust alignment as requested. */
+					if (alignment)
+						load_bias &= ~(alignment - 1);
+					elf_flags |= MAP_FIXED_NOREPLACE;
+				} else
+					load_bias = 0;
+			}
 
 			/*
 			 * Since load_bias is used for all subsequent loading
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b54986078d7ea..a705493c04bb7 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -6,7 +6,7 @@ CFLAGS += -D_GNU_SOURCE
 ALIGNS := 0x1000 0x200000 0x1000000
 ALIGN_PIES        := $(patsubst %,load_address.%,$(ALIGNS))
 ALIGN_STATIC_PIES := $(patsubst %,load_address.static.%,$(ALIGNS))
-ALIGNMENT_TESTS   := $(ALIGN_PIES)
+ALIGNMENT_TESTS   := $(ALIGN_PIES) $(ALIGN_STATIC_PIES)
 
 TEST_PROGS := binfmt_script.py
 TEST_GEN_PROGS := execveat non-regular $(ALIGNMENT_TESTS)
-- 
2.39.5



