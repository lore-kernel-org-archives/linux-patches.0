Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728971C0DD9;
	Tue,  2 Jul 2024 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941669; cv=none; b=DwMNvg5tl8eD68x8LxR5aKuBhRRQ6iOu9LIk6gqKqo3n8qLsTdjmQ5m3IFG7A4klh8z4W1iWATcLU50MMRstxYtvgy6gUfEZ2SRs1+P3W6vZByG1TZjT09HQf2chVyl/5a6IVQ6a6+bCSx6qMuvUHJEDmCTK+QBM9NE8+prLFBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941669; c=relaxed/simple;
	bh=Konm8y5XKnFzxLtgXerqkYejvq0yvMcrzAiSltu3acA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZpegR8U4WdVJmHJxI5Ni19wn8GJ1YDyA8z04XG5EI4SBMXVTpRyUChB5kl835drp0nS+CyBwYlmcaFNG+SJUDZwTxd1xV15r4ln03FCYBPxN7KdVv8sdJEoH86kDHZQgDM4lEygjTT1HX7ixAzqZAr3J0b9w125sPI/iG5WRDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u019th0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u019th0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC28C116B1;
	Tue,  2 Jul 2024 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941669;
	bh=Konm8y5XKnFzxLtgXerqkYejvq0yvMcrzAiSltu3acA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u019th0BH2ViBww07pSq3GnTmvgJ7Iu8noTq8uy2M8osH3iRUGys8z5jJ88JAbNe1
	 nw3C0iOD2fJgAoS0xvluSypRO6AsJeXa8Z8tDCyDzVKCIydovigFM9P/HSV+6/2kbo
	 DDZ2x015Ou5SteEJoh6MRpBKfMb5TpPaBAdp+PUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 101/128] sh: rework sync_file_range ABI
Date: Tue,  2 Jul 2024 19:05:02 +0200
Message-ID: <20240702170230.042268221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


