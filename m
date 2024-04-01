Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5451CA8F;
	Mon,  1 Apr 2024 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987512; cv=none; b=kFJKXRaV4Op4GJ1nAIiZRohQ9xBUyYi8yBvNcz/9M/IL1EY/niIHM0O/VE+bEysDHgpeZaUCFNVry93x6jCU0GA/jmyL0+KM8FfjvPNGS4AMqtnylxansuAWY1v6g/PzLt3ZuxE4dh2ayHoarNCuIQzmOZsLVlwi6Rvt/TZLR5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987512; c=relaxed/simple;
	bh=ZK4ATIthivDUUeJM+j6m4LZmFrnnR7Ki52u3oIe3/2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAleCs6TwwOJYS5IRYm/7PpDxT3/bq43VadHxqMVSs7u3TTEUndn5VqWkRG/X3aG33VQRNHgr0xMIyU+YhpMQ0c83Aq4UXZ1mEfrdovSfqjbnAtc79asmvTuuImM/EFzFyyVAJpAs4KEUiuo3QAvKIbl2h17CmzuZZ4BiRy2SWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0WFmbjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0WFmbjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9517C433F1;
	Mon,  1 Apr 2024 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987512;
	bh=ZK4ATIthivDUUeJM+j6m4LZmFrnnR7Ki52u3oIe3/2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0WFmbjHIAiKgB8Joj/zRBQLklRHhGRNVmR28975zp3IzDHdKCKDstQLvMbqGkv1d
	 Wi6+DzmBU/b+rm5UYnCB6X+usmadofST2xRfMYrMpYYXpeeoPrSmS6dNN4NUeh/xIM
	 dEUzOAk552MSOU/7uLMuyuSWz9nduauXrAYkvMBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Florent Revest <revest@chromium.org>,
	Helge Deller <deller@gmx.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Kees Cook <keescook@chromium.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Sam James <sam@gentoo.org>,
	Stefan Roesch <shr@devkernel.io>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 292/399] ARM: prctl: reject PR_SET_MDWE on pre-ARMv6
Date: Mon,  1 Apr 2024 17:44:18 +0200
Message-ID: <20240401152557.902261301@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zev Weiss <zev@bewilderbeest.net>

commit 166ce846dc5974a266f6c2a2896dbef5425a6f21 upstream.

On v5 and lower CPUs we can't provide MDWE protection, so ensure we fail
any attempt to enable it via prctl(PR_SET_MDWE).

Previously such an attempt would misleadingly succeed, leading to any
subsequent mmap(PROT_READ|PROT_WRITE) or execve() failing unconditionally
(the latter somewhat violently via force_fatal_sig(SIGSEGV) due to
READ_IMPLIES_EXEC).

Link: https://lkml.kernel.org/r/20240227013546.15769-6-zev@bewilderbeest.net
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: <stable@vger.kernel.org>	[6.3+]
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sam James <sam@gentoo.org>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/mman.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 arch/arm/include/asm/mman.h

--- /dev/null
+++ b/arch/arm/include/asm/mman.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <asm/system_info.h>
+#include <uapi/asm/mman.h>
+
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return cpu_architecture() >= CPU_ARCH_ARMv6;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+
+#endif /* __ASM_MMAN_H__ */


