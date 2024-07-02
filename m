Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2A1BF301;
	Tue,  2 Jul 2024 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940508; cv=none; b=cfD8XAStwfo1anT4B/EJS4LkdpGoGeQ955C/Z8GTF8vQOSLuF7a7gG+08UIbtAV0vJnufjOq8ng5bAGq0LJ9wq4aX3nPEJglNV+91Cov1cuQNpQw+y/MpON/k4PyKTNS1eF0OeuYsSpmfJnxmOTzfC5/HPk4ZXGR5wCl9gPBiJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940508; c=relaxed/simple;
	bh=rw5Gi67vN7T6vY+rX23B8sxgXhX4QLvYGoGxazAj0vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duowCYyrebEniAGAV8m468Zjd1kdtb/CYjLBz9iRMkmQWlz+M42uTengM7iuOEFY47kZ1PBdPpiGmSgr7uyqrDa2FELSTK3qisNJIO/1TG4ea3L0gJuDFocuw6Mk5vp5OosKxrgKQYJukrO6bpgquz7QElfq5dn1HlChP144cRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxVEh8xI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxVEh8xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E5C4AF0A;
	Tue,  2 Jul 2024 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940507;
	bh=rw5Gi67vN7T6vY+rX23B8sxgXhX4QLvYGoGxazAj0vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxVEh8xIhHTzoRZb7Mep+iX6iiDM5dHH40F6ccOtzHsr+39rSDGoDiLuKqHglJdlP
	 H6SDLfyhBgXakGdoCy9mDHjEgMSyBCJI3VtE0VEPjXcD1aHAgRpizJRzND3tPM4ow8
	 6jErF/5zwSZeqIw34E2BOCRZnUYKwjtz10OpQAD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.9 175/222] sh: rework sync_file_range ABI
Date: Tue,  2 Jul 2024 19:03:33 +0200
Message-ID: <20240702170250.666142023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


