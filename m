Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A71194123;
	Wed,  3 Jul 2024 10:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004267; cv=none; b=DITp/x7Dm5mlEJEJ//+EerQgaVFjPhevNjEvyzYEW2nc9jn0HY5KpTUH4RQ9r/WSg64jYFiyD/su62+E1FlLe6ejcPq5rCA1MjCVKK6/tdt0NreLItJDrYCWWCN/6QZ3fh/EB48x+YEHNd/6ig9XrUNT13+a7kuRRX59ivYIzlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004267; c=relaxed/simple;
	bh=P5bOG7NvJwiwbrYWgkBx++g16JyqRQNxcB+DuPrFgUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPgUXRiW27STIioMVX/JnsG3N37h32UDVVHBUpBXYyn1lvd6Rqp5QCuV7XbxDc1LSdlktXPtxtirT3v85oAAg8BS3bNKsSMDfJKc0Xk76q0uLve9+pmbmOIXwNm3BcTpFK/oo8DZ1/zUviFqZVKDzlLSbK/dF/udWqJFT6ffJBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLffMWVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLffMWVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7332C2BD10;
	Wed,  3 Jul 2024 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004267;
	bh=P5bOG7NvJwiwbrYWgkBx++g16JyqRQNxcB+DuPrFgUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLffMWVfeMo+Yf4ZoNuOak1j0pFK4VNpmmP+yQVLD3z9/CY3qc+UyJQcLvxWPUPcS
	 E3f9+pO0QRH+PrWjokW2LHZ1PNbcKcfTfCOkIb9bGwUYb0uzbIk9ct5rjkVOnpOPXn
	 Arxrn68go+A297ijNUmg1YCcT0xSVldYgEVDUo1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 176/189] hexagon: fix fadvise64_64 calling conventions
Date: Wed,  3 Jul 2024 12:40:37 +0200
Message-ID: <20240703102848.114648007@linuxfoundation.org>
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
@@ -14,6 +14,13 @@
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


