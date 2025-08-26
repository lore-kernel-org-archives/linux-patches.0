Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCE11E480;
	Tue, 26 Aug 2025 13:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213554; cv=none; b=UIeMCfxgDZd0ZWeTqaQadLhht3F71Mz2gAMAL8kNV9gLwST2YwoI6yk1X/j+AFddt78WKgnmxGv6Dw41mrvtO8b5SFNcgNVyQDVWlpGFStPiekxsTp2dB/D6fLwDg7okbIMJDYGuo8Y7sme19oJ0MD2lnDzWI/FeDjDsLVrl73A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213554; c=relaxed/simple;
	bh=rJtpfX9wHAguCNY9doxt6TqVOpdKJV6ESK+Vd1xuR5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeI4vz5lgxHVc42law01xSL9yaJpgt3Vhm9Xn2sUjZe4+PxgTUQSlWcUQXtspgAma0HTulI8EUqBdqwxq9yxKIgR+o6YU5CNp/r0pc5dbkzsZrSjz4v6V8U24SoDmy23CAPaHuInZ3iEcTtKfX/7qz6m/7a8K+e2IJHjzMhT5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3c+5nVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3c+5nVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38767C4CEF1;
	Tue, 26 Aug 2025 13:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213554;
	bh=rJtpfX9wHAguCNY9doxt6TqVOpdKJV6ESK+Vd1xuR5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3c+5nVcLxPS02mwKXPSldaxlt6/eUUILxgUkBApdIWp2NGJuh9vfZXpzPIsI7hw7
	 /8/sQOrVlD4a9cxkphxCPKm0DxjkOPBUbd9e2U72F5jSclgbZA+UDfxvRrGimodpAI
	 q/KWp0vOPZzAwEogvu/BuDwLbloHtsrzfg7nDnZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 392/587] parisc: Check region is readable by user in raw_copy_from_user()
Date: Tue, 26 Aug 2025 13:09:01 +0200
Message-ID: <20250826111002.888469562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


