Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AA82690F9;
	Tue,  8 Apr 2025 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113359; cv=none; b=Po136T6emhrh16Q9jVezdEn4b06/EyZmb2B3ywM+ITEJXsPcPqEW4OjLs1xgH7P55B+uqnmGcPHuB9KIvexY/B5eViR5KSwlALEYWfDhuVIzbz50vKaRN/Ai4iW1ex627hWEI/smtzwqFaJbWMI3utJrQ/g75erVKnIoNN4Sa8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113359; c=relaxed/simple;
	bh=26BzGNn6h8j8A3f9r2eOBD4lZsYXSk2JkJrFfuJ8Pr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzu7H2q4nt5DWJ+iORjGktEWxQx3tnpu5bmjZGsoeQ6hmysjXa2Q1RhsSBFkrZus4UWGy4P8T1RgS7YbbN0MdYqWAZB1AZ5HOkMFOAhiA4Ml2RJ5WGKS5Dl8aRh7E1BL+ssJ596H88PSRY1hRGzbTpRq/fXfBZy66yR7dwnTtvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLGbdnCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLGbdnCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FF3C4CEE5;
	Tue,  8 Apr 2025 11:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113359;
	bh=26BzGNn6h8j8A3f9r2eOBD4lZsYXSk2JkJrFfuJ8Pr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLGbdnClN5WTdJq0zLbq7n1EWEZXhWTTWeXWHSUYZbmrsxcQngnLiAqKFAt3vIs7I
	 MMm1hmsSWyg19jkJiySaUhy+nGTEBlzgQgqCQHPcsoFg8oVqs+gBswSGPGhvsLQRbR
	 +w35ZrWslaq6saCOc96pr3Lf9lvpEvGwQhTABuK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/268] um: remove copy_from_kernel_nofault_allowed
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104832.014001219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 84a6fc378471fbeaf48f8604566a5a33a3d63c18 ]

There is no need to override the default version of this function
anymore as UML now has proper _nofault memory access functions.

Doing this also fixes the fact that the implementation was incorrect as
using mincore() will incorrectly flag pages as inaccessible if they were
swapped out by the host.

Fixes: f75b1b1bedfb ("um: Implement probe_kernel_read()")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250210160926.420133-3-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/shared/os.h |  1 -
 arch/um/kernel/Makefile     |  2 +-
 arch/um/kernel/maccess.c    | 19 --------------
 arch/um/os-Linux/process.c  | 51 -------------------------------------
 4 files changed, 1 insertion(+), 72 deletions(-)
 delete mode 100644 arch/um/kernel/maccess.c

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 0df646c6651ea..3b382da2996f0 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -211,7 +211,6 @@ extern int os_protect_memory(void *addr, unsigned long len,
 extern int os_unmap_memory(void *addr, int len);
 extern int os_drop_memory(void *addr, int length);
 extern int can_drop_memory(void);
-extern int os_mincore(void *addr, unsigned long len);
 
 /* execvp.c */
 extern int execvp_noalloc(char *buf, const char *file, char *const argv[]);
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 811188be954ca..321250f3f5703 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -17,7 +17,7 @@ extra-y := vmlinux.lds
 obj-y = config.o exec.o exitcode.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o sysrq.o time.o tlb.o trap.o \
-	um_arch.o umid.o maccess.o kmsg_dump.o capflags.o skas/
+	um_arch.o umid.o kmsg_dump.o capflags.o skas/
 obj-y += load_file.o
 
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
deleted file mode 100644
index 8ccd56813f684..0000000000000
--- a/arch/um/kernel/maccess.c
+++ /dev/null
@@ -1,19 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2013 Richard Weinberger <richrd@nod.at>
- */
-
-#include <linux/uaccess.h>
-#include <linux/kernel.h>
-#include <os.h>
-
-bool copy_from_kernel_nofault_allowed(const void *src, size_t size)
-{
-	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
-
-	if ((unsigned long)src < PAGE_SIZE || size <= 0)
-		return false;
-	if (os_mincore(psrc, size + src - psrc) <= 0)
-		return false;
-	return true;
-}
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index e52dd37ddadcc..2686120ab2325 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -223,57 +223,6 @@ int __init can_drop_memory(void)
 	return ok;
 }
 
-static int os_page_mincore(void *addr)
-{
-	char vec[2];
-	int ret;
-
-	ret = mincore(addr, UM_KERN_PAGE_SIZE, vec);
-	if (ret < 0) {
-		if (errno == ENOMEM || errno == EINVAL)
-			return 0;
-		else
-			return -errno;
-	}
-
-	return vec[0] & 1;
-}
-
-int os_mincore(void *addr, unsigned long len)
-{
-	char *vec;
-	int ret, i;
-
-	if (len <= UM_KERN_PAGE_SIZE)
-		return os_page_mincore(addr);
-
-	vec = calloc(1, (len + UM_KERN_PAGE_SIZE - 1) / UM_KERN_PAGE_SIZE);
-	if (!vec)
-		return -ENOMEM;
-
-	ret = mincore(addr, UM_KERN_PAGE_SIZE, vec);
-	if (ret < 0) {
-		if (errno == ENOMEM || errno == EINVAL)
-			ret = 0;
-		else
-			ret = -errno;
-
-		goto out;
-	}
-
-	for (i = 0; i < ((len + UM_KERN_PAGE_SIZE - 1) / UM_KERN_PAGE_SIZE); i++) {
-		if (!(vec[i] & 1)) {
-			ret = 0;
-			goto out;
-		}
-	}
-
-	ret = 1;
-out:
-	free(vec);
-	return ret;
-}
-
 void init_new_thread_signals(void)
 {
 	set_handler(SIGSEGV);
-- 
2.39.5



