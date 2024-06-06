Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B90F1ABCC4;
	Thu,  6 Jun 2024 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683288; cv=none; b=qcweRgbtK0F2IFV0JGlChEww+c0b0EgJ3XHv3lq8IxJjbIKcHEWqt0C2dvEd7lTr8gkoD2WCFdcBd4MhB3xDD6Gw+pQPhaSO6uGRxtDImrOKJ3kTp7Phey0T1p6QvIxjnJXaQ4Ho6b0Lqxw8vNMZ6dCL7k3xfKuyS+Ljh/klFdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683288; c=relaxed/simple;
	bh=jnnu74GelYzaIq7e5PynIy3Nl0MWJ4B914AG+JE6fJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG1oTlCcCIYOxNWvzpiODUCv5kvJrA7PFZJpkunqDrxlGpXKd+YZAV6WQDnvmNEgp8l30Ympuk+dQzszyttquu0jMqW8qYGeCBFnid+V2glaBWR0wWdRAyKQ2uaSSyEzOnaKRZJkHJ7grosb0LElzbRNwg1NjV4zQTA/Vj9yZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npy/e6y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npy/e6y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A45BC2BD10;
	Thu,  6 Jun 2024 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683288;
	bh=jnnu74GelYzaIq7e5PynIy3Nl0MWJ4B914AG+JE6fJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npy/e6y8XKEVlmDDh3DSNrnvUWUZNbvU8YPfUEy9pBrwvzX7J5eJgVbNK1rf12P/w
	 spDe00NKwS5sPt1rBTAWV2P3esVtVyaAjIs9kJC37yCdGbFyS2zY4UPevo09flCtGc
	 7skXe70MozDMCZYhhZfbSua5UY5m3n3pzs3dAOhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/744] kernel/numa.c: Move logging out of numa.h
Date: Thu,  6 Jun 2024 15:58:21 +0200
Message-ID: <20240606131739.737314826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit d7a73e3f089204aee3393687e23fd45a22657b08 ]

Moving these stub functions to a .c file means we can kill a sched.h
dependency on printk.h.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Stable-dep-of: f9f67e5adc8d ("x86/numa: Fix SRAT lookup of CFMWS ranges with numa_fill_memblks()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/numa.h | 19 ++++++-------------
 kernel/Makefile      |  1 +
 kernel/numa.c        | 26 ++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 13 deletions(-)
 create mode 100644 kernel/numa.c

diff --git a/include/linux/numa.h b/include/linux/numa.h
index a904861de8000..915033a757315 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_NUMA_H
 #define _LINUX_NUMA_H
+#include <linux/init.h>
 #include <linux/types.h>
 
 #ifdef CONFIG_NODES_SHIFT
@@ -22,34 +23,26 @@
 #endif
 
 #ifdef CONFIG_NUMA
-#include <linux/printk.h>
 #include <asm/sparsemem.h>
 
 /* Generic implementation available */
 int numa_nearest_node(int node, unsigned int state);
 
 #ifndef memory_add_physaddr_to_nid
-static inline int memory_add_physaddr_to_nid(u64 start)
-{
-	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
+int memory_add_physaddr_to_nid(u64 start);
 #endif
+
 #ifndef phys_to_target_node
-static inline int phys_to_target_node(u64 start)
-{
-	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
-			start);
-	return 0;
-}
+int phys_to_target_node(u64 start);
 #endif
+
 #ifndef numa_fill_memblks
 static inline int __init numa_fill_memblks(u64 start, u64 end)
 {
 	return NUMA_NO_MEMBLK;
 }
 #endif
+
 #else /* !CONFIG_NUMA */
 static inline int numa_nearest_node(int node, unsigned int state)
 {
diff --git a/kernel/Makefile b/kernel/Makefile
index 3947122d618bf..ce105a5558fcf 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
 obj-$(CONFIG_HAVE_STATIC_CALL) += static_call.o
 obj-$(CONFIG_HAVE_STATIC_CALL_INLINE) += static_call_inline.o
 obj-$(CONFIG_CFI_CLANG) += cfi.o
+obj-$(CONFIG_NUMA) += numa.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/numa.c b/kernel/numa.c
new file mode 100644
index 0000000000000..67ca6b8585c06
--- /dev/null
+++ b/kernel/numa.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/printk.h>
+#include <linux/numa.h>
+
+/* Stub functions: */
+
+#ifndef memory_add_physaddr_to_nid
+int memory_add_physaddr_to_nid(u64 start)
+{
+	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
+
+#ifndef phys_to_target_node
+int phys_to_target_node(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phys_to_target_node);
+#endif
-- 
2.43.0



