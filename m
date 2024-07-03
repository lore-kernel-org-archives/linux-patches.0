Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6DE176242;
	Wed,  3 Jul 2024 10:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003732; cv=none; b=Igc+mWkA9/f/XT7jt2bbARjDvKHcV6uMnuFIY+tKTeWsmDJY2YBq8ZIwJB9SARAv/w1B+3ngl/y0aMzeN6UZlum4mqBF0d3p1Eu62wH02FE9vmOI31lAI78upJSaadYzsUJ43ztZMFkgmVVHpQ0DwEVQwG+7FVHEANMP5arDFu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003732; c=relaxed/simple;
	bh=/9TOwmFv931ym6RR3oVRGjpZM7IM9HckbgozZlYrGSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWiVh6J6W+Dqb948XwP1f5jiZPyUS34VUeJESZm73iKljqENJol3h64N+JQ//6VZsr+yL5XvYhcMXgdYe58JwTyxxygCdIoBZEI238oA7af+ux42OKFy06B/SuwE+Cod2wRfVJZMURKE1qSXfMxQ5DLmfn+VSAj8xANHNzpAxqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEJ6acgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEJ6acgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323CCC2BD10;
	Wed,  3 Jul 2024 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003731;
	bh=/9TOwmFv931ym6RR3oVRGjpZM7IM9HckbgozZlYrGSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEJ6acgzVP4rU/ev09bsTqGZFJC3VeU3qDhpcmGzoeXGBVIC5oy2cCbpaCbh4mpQ3
	 fo2sRckq2TTGLf0Y1SssesXTnI+JaIWsrCNaU7IR6oiV5Moyx4ZpI7+shQgRtr3/JO
	 tk47RxKWvZHsRne93ijxgUzNt+Ewy60UfTPkHNXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 129/139] hexagon: fix fadvise64_64 calling conventions
Date: Wed,  3 Jul 2024 12:40:26 +0200
Message-ID: <20240703102835.307134046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 896842284c6ccba25ec9d78b7b6e62cdd507c083 upstream.

fadvise64_64() has two 64-bit arguments at the wrong alignment
for hexagon, which turns them into a 7-argument syscall that is
not supported by Linux.

The downstream musl port for hexagon actually asks for a 6-argument
version the same way we do it on arm, csky, powerpc, so make the
kernel do it the same way to avoid having to change both.

Link: https://github.com/quic/musl/blob/hexagon/arch/hexagon/syscall_arch.h#L78
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/include/asm/syscalls.h |    6 ++++++
 arch/hexagon/kernel/syscalltab.c    |    7 +++++++
 2 files changed, 13 insertions(+)
 create mode 100644 arch/hexagon/include/asm/syscalls.h

--- /dev/null
+++ b/arch/hexagon/include/asm/syscalls.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm-generic/syscalls.h>
+
+asmlinkage long sys_hexagon_fadvise64_64(int fd, int advice,
+	                                  u32 a2, u32 a3, u32 a4, u32 a5);
--- a/arch/hexagon/kernel/syscalltab.c
+++ b/arch/hexagon/kernel/syscalltab.c
@@ -27,6 +27,13 @@
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
 
+SYSCALL_DEFINE6(hexagon_fadvise64_64, int, fd, int, advice,
+		SC_ARG64(offset), SC_ARG64(len))
+{
+	return ksys_fadvise64_64(fd, SC_VAL64(loff_t, offset), SC_VAL64(loff_t, len), advice);
+}
+#define sys_fadvise64_64 sys_hexagon_fadvise64_64
+
 void *sys_call_table[__NR_syscalls] = {
 #include <asm/unistd.h>
 };


