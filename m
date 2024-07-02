Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387911BE227;
	Tue,  2 Jul 2024 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941123; cv=none; b=o2u0cjMKf4vd7qT0ToQ9U/v3MHOUNfWMOR0dYflWjdHtucwpPiT2cmixf6h9u8SiP/D2g0Jo/Uk4cNohK7QFdFoAeC0HE+OyDhwiTZIbhJeyoipioiZIpKBDHDftLuUF/m+ZP6xGjOlCrXYtxmtt/eBofxs/LrufA+FPRO+jWCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941123; c=relaxed/simple;
	bh=1AeR2rBsINyXDmAWwDLbAG9zhLNa33nJ0Vbut49i6U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNbEhuLGdFgtsKZGeYY8jIIWT7SWbD+/NlLWLaypLEJ+Ex68YMVYKtoAcgem5FscHbT639Rcx4PesxbFFLgbeuU+NEYHzlp45gDJ6U2nBdiOGkJt/VMDOScz/YyaSOI5iHvl0cZBfo0xtEvGJIWgPJa6I/j00Xqs7LoODqD2sf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3x3B8LT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3x3B8LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE2FC116B1;
	Tue,  2 Jul 2024 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941123;
	bh=1AeR2rBsINyXDmAWwDLbAG9zhLNa33nJ0Vbut49i6U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3x3B8LTk4Q06ijjbSLIDCI+6iwmfdPaT6oXON4FtQfeOxmXMk1HkFQzIweSxwWID
	 t5msG0PHwIub4XJrkBRYqO1QWCFT8doyIerD8tXKytbeVW18+XVi+saUhiiDOnDueE
	 Y2B92aCQ5m+0U7JZ0swhJAu20dX0RPxO3OnnI3Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 133/163] csky, hexagon: fix broken sys_sync_file_range
Date: Tue,  2 Jul 2024 19:04:07 +0200
Message-ID: <20240702170238.088202286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 3339b99ef6fe38dac43b534cba3a8a0e29fb2eff upstream.

Both of these architectures require u64 function arguments to be
passed in even/odd pairs of registers or stack slots, which in case of
sync_file_range would result in a seven-argument system call that is
not currently possible. The system call is therefore incompatible with
all existing binaries.

While it would be possible to implement support for seven arguments
like on mips, it seems better to use a six-argument version, either
with the normal argument order but misaligned as on most architectures
or with the reordered sync_file_range2() calling conventions as on
arm and powerpc.

Cc: stable@vger.kernel.org
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/include/uapi/asm/unistd.h    |    1 +
 arch/hexagon/include/uapi/asm/unistd.h |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/csky/include/uapi/asm/unistd.h
+++ b/arch/csky/include/uapi/asm/unistd.h
@@ -6,6 +6,7 @@
 #define __ARCH_WANT_SYS_CLONE3
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYNC_FILE_RANGE2
 #include <asm-generic/unistd.h>
 
 #define __NR_set_thread_area	(__NR_arch_specific_syscall + 0)
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -36,5 +36,6 @@
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYNC_FILE_RANGE2
 
 #include <asm-generic/unistd.h>


