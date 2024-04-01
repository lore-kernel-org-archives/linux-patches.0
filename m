Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBD91C0DE7;
	Mon,  1 Apr 2024 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990319; cv=none; b=RjoETCntzsJuXVApYJ6TjPoq6gP/l9pt7jqIG4bWSU3tIfB8+UCZZKgMywVdeYMElwVPu0dNTq9BFibpPic37M0/31FM0Gs0cg4YFcyDej3psMDOoWjNe/32V8vSAw1R3qbpMY7QvxdZql6OAFPw8dChiTO+eO/6EESIipVmAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990319; c=relaxed/simple;
	bh=PttL485j/B/nbzLrJb+9GfAk8ivWFN0m9yyEIaxlXVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRJdg5heBQx8CuNlEjgkylo1FiL+74GYQK1zMdTPZk3xNuUyb5fgW25j0AVuvUZUVUnUbglrBQs4YM/nXm4RgiYkGPRYFR8l850YwcNlbmB+mHDkodUwPgjA4CI93UM6t9DGKvyucO6CQvu6yHqc/VjX2pd2Ni31z/d7EV5sWiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghhhWXla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghhhWXla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2723BC433F1;
	Mon,  1 Apr 2024 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990318;
	bh=PttL485j/B/nbzLrJb+9GfAk8ivWFN0m9yyEIaxlXVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghhhWXlaMHhgE1pDcM1EZJbEJAu+oFxlnAdBYEibk8dREmM+oL28FbsWuwjFP9oPZ
	 gfVQYkq7WsfbUzQSlv/LS98C0EUkk7rSA/Gy4k93kOmuiEQ7/MndaQXonpLIAaVeB2
	 FzB49XGUP+1MdBJSawfuF38IXDqrOp4Kl8EvzGCg=
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
Subject: [PATCH 6.6 315/396] ARM: prctl: reject PR_SET_MDWE on pre-ARMv6
Date: Mon,  1 Apr 2024 17:46:04 +0200
Message-ID: <20240401152557.304292646@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


