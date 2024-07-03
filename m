Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F011741DD;
	Wed,  3 Jul 2024 11:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006191; cv=none; b=DfU5gepjMabf82h6QWx2ldIUif4LA9PNYX/4OfrETbZfAfEcGlem3/NB0BTeA++bO3BWWHIfYLWT3b308EKDo0K2QvjR59nN4JMkB44rGBmqCnGdcVZC6wZRv8Qr7di+QsbPhykfKyoFEYJNlx5j9NXAYdNzjreWDlowP9sZMrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006191; c=relaxed/simple;
	bh=JZ0pJFFifHaPMvZ00qw7qHRXe5uwWnmGLafLrKqURko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpU3IE/vTm92lquiAznzBcEBw4s+UB8O0pHbBkxpNMsF33LiOubeeGF10+XFWt9f9Bs+YJWHwfqDWRcj+/Vu28pw8c0aYMD7xtKSr84ENwrR3EBx+uMDGxuQSJRRydlfnS16GpNupjLzttbEunLCU/HynVl7sw0M/NqzDIQYssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8tXJ7hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8tXJ7hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2E1C2BD10;
	Wed,  3 Jul 2024 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006190;
	bh=JZ0pJFFifHaPMvZ00qw7qHRXe5uwWnmGLafLrKqURko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8tXJ7hyjC+dr2zXUQxmdwOaJcIvfHxKKTWJmWGMB2YF1cPp06rrEJ4YlL4VViZ6Y
	 Ya35B3KBPgpe0vulELdltYZrv/I0VEliS5vDdvcEYleiYU05JZcPRgZwZ5My9h8RKu
	 y8LMhHKfKYucepYKTk1arCfROPGoELMhQckCvWj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 331/356] csky, hexagon: fix broken sys_sync_file_range
Date: Wed,  3 Jul 2024 12:41:07 +0200
Message-ID: <20240703102925.634037574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


