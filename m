Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4143A35C1A8;
	Wed,  3 Dec 2025 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780129; cv=none; b=ESTFCNo49Gp+AI+Mb5iBNywP6vtvIS9l/VNpfOB9/a1Bpw2/yjQpU2+1nCcdlDxNHh2lXUUuoXxD0ACprVH0+3B5LmcgsejW2UHL0ifgvfLMuwPBNB7FxtxjRnnnAcsfRZ12FlxEcG6Tw6OyPto9q3SJzK0fGaZikAzQdg1xk0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780129; c=relaxed/simple;
	bh=wuEHeqN6YBPgWq+w8Vwp6RCLytazVKzVf9rjlOFFLBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2Vt+pRib+iaz0/Gqahpe+HDxzvfylGnfeOFYMWRaUZrpvuGSo6WjT5V+k0Gpn9OWhlhtyAe3OKaxnfLUNMJbP1rPiZtePB8t7sV+bGpeg1VB9ooL6N2Vv32D7DXVSfd+c62DfRZhKJ5uIrHscOXzyUowA6nRB6xB8v3stzZp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TymZcSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TymZcSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA118C4CEF5;
	Wed,  3 Dec 2025 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780129;
	bh=wuEHeqN6YBPgWq+w8Vwp6RCLytazVKzVf9rjlOFFLBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TymZcSEEG6rOIgHrBJteMggnhDtOBL/GMq5NU69MPoFd3nHs/YbSJc6zUsj6pHF/
	 98YFRwBRTrpTL0w0OkouC4BJpDNeFFp+iP5R9wrI1EZ23n4EwvZSRwo1e9I9JEaaHN
	 q2YyXk0tcmB+iapUuZJR3/L+i5CKBWXsHvhZdYpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 422/568] asm-generic: partially revert "Unify uapi bitsperlong.h for arm64, riscv and loongarch"
Date: Wed,  3 Dec 2025 16:27:04 +0100
Message-ID: <20251203152456.153913409@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 6e8d96909a23c8078ee965bd48bb31cbef2de943 upstream.

Unifying the asm-generic headers across 32-bit and 64-bit architectures
based on the compiler provided macros was a good idea and appears to work
with all user space, but it caused a regression when building old kernels
on systems that have the new headers installed in /usr/include, as this
combination trips an inconsistency in the kernel's own tools/include
headers that are a mix of userspace and kernel-internal headers.

This affects kernel builds on arm64, riscv64 and loongarch64 systems that
might end up using the "#define __BITS_PER_LONG 32" default from the old
tools headers. Backporting the commit into stable kernels would address
this, but it would still break building kernels without that backport,
and waste time for developers trying to understand the problem.

arm64 build machines are rather common, and on riscv64 this can also
happen in practice, but loongarch64 is probably new enough to not
be used much for building old kernels, so only revert the bits
for arm64 and riscv.

Link: https://lore.kernel.org/all/20230731160402.GB1823389@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 8386f58f8deda ("asm-generic: Unify uapi bitsperlong.h for arm64, riscv and loongarch")
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/uapi/asm/bitsperlong.h       |   24 ++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/bitsperlong.h       |   14 ++++++++++++++
 tools/arch/arm64/include/uapi/asm/bitsperlong.h |   24 ++++++++++++++++++++++++
 tools/arch/riscv/include/uapi/asm/bitsperlong.h |   14 ++++++++++++++
 4 files changed, 76 insertions(+)
 create mode 100644 arch/arm64/include/uapi/asm/bitsperlong.h
 create mode 100644 arch/riscv/include/uapi/asm/bitsperlong.h
 create mode 100644 tools/arch/arm64/include/uapi/asm/bitsperlong.h
 create mode 100644 tools/arch/riscv/include/uapi/asm/bitsperlong.h

--- /dev/null
+++ b/arch/arm64/include/uapi/asm/bitsperlong.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_BITSPERLONG_H
+#define __ASM_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif	/* __ASM_BITSPERLONG_H */
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/bitsperlong.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2015 Regents of the University of California
+ */
+
+#ifndef _UAPI_ASM_RISCV_BITSPERLONG_H
+#define _UAPI_ASM_RISCV_BITSPERLONG_H
+
+#define __BITS_PER_LONG (__SIZEOF_POINTER__ * 8)
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _UAPI_ASM_RISCV_BITSPERLONG_H */
--- /dev/null
+++ b/tools/arch/arm64/include/uapi/asm/bitsperlong.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_BITSPERLONG_H
+#define __ASM_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif	/* __ASM_BITSPERLONG_H */
--- /dev/null
+++ b/tools/arch/riscv/include/uapi/asm/bitsperlong.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2015 Regents of the University of California
+ */
+
+#ifndef _UAPI_ASM_RISCV_BITSPERLONG_H
+#define _UAPI_ASM_RISCV_BITSPERLONG_H
+
+#define __BITS_PER_LONG (__SIZEOF_POINTER__ * 8)
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _UAPI_ASM_RISCV_BITSPERLONG_H */


