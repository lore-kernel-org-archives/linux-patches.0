Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E47487BC;
	Mon,  1 Apr 2024 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990315; cv=none; b=OHXKco5Hfc7i0KCU6K6+AG3d+9TlZqIClp9R2mI/3RD9YX9ZDmEDKrff3xl/yusFOXK2ksZW8frdYWYjyqSPEE/+rnZ5ynnV+M8eY8K9CrLgXurC5jI9m3Qv/NfLrUWuWcf4KAbb3AChqI4rrRkywq5dapuWH2gyuYUnVI8/53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990315; c=relaxed/simple;
	bh=6Z5pSzI1leVm7kPoWvhMMlvSKoKMU4JK96ZPrNks8G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqenu3puNV7WsrWzTGgO7PSHg6pvpCPCzMXTg/33JCoUeu1aCFF3H0rW+1RBTSopBzyMUYB8kzw7KlVJhBDvz2bX7BJVb0nAox/EQ8W4vlOTFLmOepU75RVlrTpSzOFJGL6HqSSGVHZ02p+1J6GBWAqrjuXfYmkH+FJF34RZZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17kFA3IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17kFA3IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E570C433F1;
	Mon,  1 Apr 2024 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990315;
	bh=6Z5pSzI1leVm7kPoWvhMMlvSKoKMU4JK96ZPrNks8G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17kFA3IQj/Fz5qcpr9bavmq9S6AQm9upWVM0A7RixUohmiZFKLwheTwkgVeuD1sQD
	 v9c2LzPiCEJwD5+NMCiMmOmoUUQl0UNviwvJoKyiCLDu3+34GkP9/9WcMFF78u+o7+
	 iKqoJWERmm9LJ4EqbvOOdpkTTf9TIPUs0i7c/PaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Florent Revest <revest@chromium.org>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 314/396] prctl: generalize PR_SET_MDWE support check to be per-arch
Date: Mon,  1 Apr 2024 17:46:03 +0200
Message-ID: <20240401152557.273858649@linuxfoundation.org>
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

commit d5aad4c2ca057e760a92a9a7d65bd38d72963f27 upstream.

Patch series "ARM: prctl: Reject PR_SET_MDWE where not supported".

I noticed after a recent kernel update that my ARM926 system started
segfaulting on any execve() after calling prctl(PR_SET_MDWE).  After some
investigation it appears that ARMv5 is incapable of providing the
appropriate protections for MDWE, since any readable memory is also
implicitly executable.

The prctl_set_mdwe() function already had some special-case logic added
disabling it on PARISC (commit 793838138c15, "prctl: Disable
prctl(PR_SET_MDWE) on parisc"); this patch series (1) generalizes that
check to use an arch_*() function, and (2) adds a corresponding override
for ARM to disable MDWE on pre-ARMv6 CPUs.

With the series applied, prctl(PR_SET_MDWE) is rejected on ARMv5 and
subsequent execve() calls (as well as mmap(PROT_READ|PROT_WRITE)) can
succeed instead of unconditionally failing; on ARMv6 the prctl works as it
did previously.

[0] https://lore.kernel.org/all/2023112456-linked-nape-bf19@gregkh/


This patch (of 2):

There exist systems other than PARISC where MDWE may not be feasible to
support; rather than cluttering up the generic code with additional
arch-specific logic let's add a generic function for checking MDWE support
and allow each arch to override it as needed.

Link: https://lkml.kernel.org/r/20240227013546.15769-4-zev@bewilderbeest.net
Link: https://lkml.kernel.org/r/20240227013546.15769-5-zev@bewilderbeest.net
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Acked-by: Helge Deller <deller@gmx.de>	[parisc]
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
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
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/mman.h |   14 ++++++++++++++
 include/linux/mman.h           |    8 ++++++++
 kernel/sys.c                   |    7 +++++--
 3 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 arch/parisc/include/asm/mman.h

--- /dev/null
+++ b/arch/parisc/include/asm/mman.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <uapi/asm/mman.h>
+
+/* PARISC cannot allow mdwe as it needs writable stacks */
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return false;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+
+#endif /* __ASM_MMAN_H__ */
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -161,6 +161,14 @@ calc_vm_flag_bits(unsigned long flags)
 
 unsigned long vm_commit_limit(void);
 
+#ifndef arch_memory_deny_write_exec_supported
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return true;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+#endif
+
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2395,8 +2395,11 @@ static inline int prctl_set_mdwe(unsigne
 	if (bits & PR_MDWE_NO_INHERIT && !(bits & PR_MDWE_REFUSE_EXEC_GAIN))
 		return -EINVAL;
 
-	/* PARISC cannot allow mdwe as it needs writable stacks */
-	if (IS_ENABLED(CONFIG_PARISC))
+	/*
+	 * EOPNOTSUPP might be more appropriate here in principle, but
+	 * existing userspace depends on EINVAL specifically.
+	 */
+	if (!arch_memory_deny_write_exec_supported())
 		return -EINVAL;
 
 	current_bits = get_current_mdwe();


