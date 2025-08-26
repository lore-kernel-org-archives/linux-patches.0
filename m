Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C6D20C001;
	Tue, 26 Aug 2025 11:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208379; cv=none; b=qhxlUkoV3CN27+05iXZlw6LlSRMsoAPAY3EEsjamAdRlPIT8xjy82xhxdnzsCVKKe/DmYKeiEaO0LsOzY8DwolCPxoJ+0HlFVVEQX2MN/MGTtyfrm4ZW2jPS3sqWeOCBj3PEPThhqjGRY9QzPoIpTtPLGQ0f2rDdK2fbPqBmr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208379; c=relaxed/simple;
	bh=hXmK7BjMEGkdV5WjEA8QsyVT4LcgFz6clwBS6S3GYqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOvgafWHHwTxs8/PdpKXrVNX7nuyMGr7XymEAWtEXd0tT+aH1W0gWpKcj+XLHXT/KQ1vK43AG393/0JA5kwuUbAqSroJOd9v9axoQa7bTgOAQni0OspSvdhknTweX/xpKFsSUHfsI5JXWcFqAAqQk97gWO9Y0XIEz4bR/GsEjuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJcxN12I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJcxN12I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0D8C4CEF1;
	Tue, 26 Aug 2025 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208379;
	bh=hXmK7BjMEGkdV5WjEA8QsyVT4LcgFz6clwBS6S3GYqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJcxN12IOvn72sr4j7ttjsiJQHprHoaspdGL7HxS0pO+fwSRkaTNTYpcC99QykcIS
	 6FQrhH9udbHmHuPQeqrE04jHo9fKjVze1xFCmYYTRiypFCxSbxdQVXtpKG3iIX4GiT
	 6kykgYhePE6r77boSpcl0YXKpfVxP7GE6SozmCQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 089/322] parisc: Check region is readable by user in raw_copy_from_user()
Date: Tue, 26 Aug 2025 13:08:24 +0200
Message-ID: <20250826110917.858670201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 91428ca9320edbab1211851d82429d33b9cd73ef upstream.

Because of the way the _PAGE_READ is handled in the parisc PTE, an
access interruption is not generated when the kernel reads from a
region where the _PAGE_READ is zero. The current code was written
assuming read access faults would also occur in the kernel.

This change adds user access checks to raw_copy_from_user().  The
prober_user() define checks whether user code has read access to
a virtual address. Note that page faults are not handled in the
exception support for the probe instruction. For this reason, we
precede the probe by a ldb access check.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/special_insns.h |   28 ++++++++++++++++++++++++++++
 arch/parisc/lib/memcpy.c                |   19 ++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/special_insns.h
+++ b/arch/parisc/include/asm/special_insns.h
@@ -32,6 +32,34 @@
 	pa;						\
 })
 
+/**
+ * prober_user() - Probe user read access
+ * @sr:		Space regster.
+ * @va:		Virtual address.
+ *
+ * Return: Non-zero if address is accessible.
+ *
+ * Due to the way _PAGE_READ is handled in TLB entries, we need
+ * a special check to determine whether a user address is accessible.
+ * The ldb instruction does the initial access check. If it is
+ * successful, the probe instruction checks user access rights.
+ */
+#define prober_user(sr, va)	({			\
+	unsigned long read_allowed;			\
+	__asm__ __volatile__(				\
+		"copy %%r0,%0\n"			\
+		"8:\tldb 0(%%sr%1,%2),%%r0\n"		\
+		"\tproberi (%%sr%1,%2),%3,%0\n"		\
+		"9:\n"					\
+		ASM_EXCEPTIONTABLE_ENTRY(8b, 9b,	\
+				"or %%r0,%%r0,%%r0")	\
+		: "=&r" (read_allowed)			\
+		: "i" (sr), "r" (va), "i" (PRIV_USER)	\
+		: "memory"				\
+	);						\
+	read_allowed;					\
+})
+
 #define CR_EIEM 15	/* External Interrupt Enable Mask */
 #define CR_CR16 16	/* CR16 Interval Timer */
 #define CR_EIRR 23	/* External Interrupt Request Register */
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 #define get_user_space()	mfsp(SR_USER)
 #define get_kernel_space()	SR_KERNEL
@@ -32,9 +33,25 @@ EXPORT_SYMBOL(raw_copy_to_user);
 unsigned long raw_copy_from_user(void *dst, const void __user *src,
 			       unsigned long len)
 {
+	unsigned long start = (unsigned long) src;
+	unsigned long end = start + len;
+	unsigned long newlen = len;
+
 	mtsp(get_user_space(), SR_TEMP1);
 	mtsp(get_kernel_space(), SR_TEMP2);
-	return pa_memcpy(dst, (void __force *)src, len);
+
+	/* Check region is user accessible */
+	if (start)
+	while (start < end) {
+		if (!prober_user(SR_TEMP1, start)) {
+			newlen = (start - (unsigned long) src);
+			break;
+		}
+		start += PAGE_SIZE;
+		/* align to page boundry which may have different permission */
+		start = PAGE_ALIGN_DOWN(start);
+	}
+	return len - newlen + pa_memcpy(dst, (void __force *)src, newlen);
 }
 EXPORT_SYMBOL(raw_copy_from_user);
 


