Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC491BE849;
	Tue,  2 Jul 2024 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941126; cv=none; b=hXftEgrzKnZQESNRmwuqp2XirG6XepCZQHZxI/Dy2BdsgYfm+bQ8jXor+yQrX1LY4OD8l96Nscg81R9gtJrR4MSxDRsTj75Lx7j2Hods9k2TC7qf5CUb+z+GeQqw2EAFgg/cDodSW0u0RQs3dx93BOO8J0I8C+cxYV6ZZ8zYg8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941126; c=relaxed/simple;
	bh=ExNQWRmanlbj5E0NE7p8uQCKjpWVa4qMqgIcsMJZyHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOIYc6T7zyBRcTHzjE1srWahJvd5cerLml2+4nK15JXiNDeiWHz+H+F2G/z9c31o/Of/FqdYJkYruY3L192tHCha5n7MG/dOX/FKWJ1rSzcov841Gm/9mC5m8zE0NJxHTA/V5lqoKO3UIbzKOnEbxlwR9hrYyjQWdjRwoz8ICXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bvye00L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bvye00L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD4C4AF0D;
	Tue,  2 Jul 2024 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941126;
	bh=ExNQWRmanlbj5E0NE7p8uQCKjpWVa4qMqgIcsMJZyHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bvye00L1thstWp85p58lnTmSF0P/YQVDyFvGSpTqixHh4Y5oaRqCo+QaYmb3UOyTW
	 alN1d5ACCxoUlRoUBCsFcAcNzrGppMcmMuHoF9ppn1Sb6mVY8sQbM+xx4jKYNaitao
	 dYYZXthdNs8qyS4fRXY1KVLjzM6+nQd9dashXDqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 134/163] hexagon: fix fadvise64_64 calling conventions
Date: Tue,  2 Jul 2024 19:04:08 +0200
Message-ID: <20240702170238.125752421@linuxfoundation.org>
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


