Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D565194083;
	Wed,  3 Jul 2024 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004261; cv=none; b=GJnCv84onHGoDfxRrP4oIAoSTSXwEzdiwTWitALyEiNwKj8esi9pexxDE+19VWXUDt1MKvQ8AE9x4SngQLJN3oTPm3bgtwICY/QHaxgpAtntxjzRQTcqZrJtqRqRZ2sgHzerAyvl/SaH+eToc1PICneO9aBFhV5h12tlk3EsuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004261; c=relaxed/simple;
	bh=IjeboZQ76DSQ9bkmgy9TCteHDfjS5347spTZBDcm2bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM3TM4lT04Xc1JKwMMFu919UD6VzMCinKjW80Cd8M7Yw6NDNVw+Hhf7MWjOCwNJNapJxDFnhKn03yS1+GobzHboCmBrElRVjz7IHhEzLapI+WqFV0GQve2A98lLKbG1rBYbWAbzI+oLhvExZTx/33ewt9QbCpC/BIhtb+Gw0Llw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la6phVFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la6phVFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA37AC4AF0D;
	Wed,  3 Jul 2024 10:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004261;
	bh=IjeboZQ76DSQ9bkmgy9TCteHDfjS5347spTZBDcm2bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la6phVFYiWE7FWpsYcmBIiFSCQtM1vDKBOimZ/kfcYP7ZNHOvKhNR3sC5XRPvJz2E
	 w5Ab7wsoxgjWFrzQ7tmfToHTesEUs5OB5fA4v7/kLbR5mbEnU7x9GQx+Y15r12V5sh
	 YeqXEGpsJxNsTlQ+Bn0V6uaE4luiPZoxMZ//47Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 174/189] sh: rework sync_file_range ABI
Date: Wed,  3 Jul 2024 12:40:35 +0200
Message-ID: <20240703102848.039433861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 30766f1105d6d2459c3b9fe34a3e52b637a72950 upstream.

The unusual function calling conventions on SuperH ended up causing
sync_file_range to have the wrong argument order, with the 'flags'
argument getting sorted before 'nbytes' by the compiler.

In userspace, I found that musl, glibc, uclibc and strace all expect the
normal calling conventions with 'nbytes' last, so changing the kernel
to match them should make all of those work.

In order to be able to also fix libc implementations to work with existing
kernels, they need to be able to tell which ABI is used. An easy way
to do this is to add yet another system call using the sync_file_range2
ABI that works the same on all architectures.

Old user binaries can now work on new kernels, and new binaries can
try the new sync_file_range2() to work with new kernels or fall back
to the old sync_file_range() version if that doesn't exist.

Cc: stable@vger.kernel.org
Fixes: 75c92acdd5b1 ("sh: Wire up new syscalls.")
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/kernel/sys_sh32.c           |   11 +++++++++++
 arch/sh/kernel/syscalls/syscall.tbl |    3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -59,3 +59,14 @@ asmlinkage int sys_fadvise64_64_wrapper(
 				 (u64)len0 << 32 | len1, advice);
 #endif
 }
+
+/*
+ * swap the arguments the way that libc wants them instead of
+ * moving flags ahead of the 64-bit nbytes argument
+ */
+SYSCALL_DEFINE6(sh_sync_file_range6, int, fd, SC_ARG64(offset),
+                SC_ARG64(nbytes), unsigned int, flags)
+{
+        return ksys_sync_file_range(fd, SC_VAL64(loff_t, offset),
+                                    SC_VAL64(loff_t, nbytes), flags);
+}
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -321,7 +321,7 @@
 311	common	set_robust_list			sys_set_robust_list
 312	common	get_robust_list			sys_get_robust_list
 313	common	splice				sys_splice
-314	common	sync_file_range			sys_sync_file_range
+314	common	sync_file_range			sys_sh_sync_file_range6
 315	common	tee				sys_tee
 316	common	vmsplice			sys_vmsplice
 317	common	move_pages			sys_move_pages
@@ -395,6 +395,7 @@
 385	common	pkey_alloc			sys_pkey_alloc
 386	common	pkey_free			sys_pkey_free
 387	common	rseq				sys_rseq
+388	common	sync_file_range2		sys_sync_file_range2
 # room for arch specific syscalls
 393	common	semget				sys_semget
 394	common	semctl				sys_semctl


