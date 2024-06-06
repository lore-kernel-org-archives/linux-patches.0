Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C575197A8F;
	Thu,  6 Jun 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683283; cv=none; b=HJWWlQF5po+fl3Aesg/9WSM8kI9RTvCYUp0sSpprrpQkh7GQ04ZAsQMmDvWMNR3ycLC0rjD6Z8hmIpUs1BCnjG04eTe6yIRgzeY6UCE9DvgryfIFjNVibFdne6xmtiC/7dwVHs+GqiQ7ssNv3cXZ+i+XGBMXdEZZDLmqLjxdDKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683283; c=relaxed/simple;
	bh=aLHlcXT1K6KMsiQJA1+7P400xZkXn9uBzP2zTq3M9Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1JL9k5Z8p0eT4GueFeCQ5MWFPb463hMGywGvRnVQlp1oYKd5GOc3nQWAANliEkanBaTBSrd6yp2s9KXW85uI5opyWdDVc7uPK2D1kNSSLcnFhp+ojCNwNcGrIZ4FuJjp1OnrIPvOtSF4cW1qhyibLrcYaY3qVMMXjNbW0QN2Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkERkC7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkERkC7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429BEC32781;
	Thu,  6 Jun 2024 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683283;
	bh=aLHlcXT1K6KMsiQJA1+7P400xZkXn9uBzP2zTq3M9Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkERkC7OoYwfm7piH1WMKDLMsi7lSv52TiUTDRmney1q8ygRB5hdV0KqAF4ZOPm+4
	 7f8nF3HxeqS8dVVN3W9BsVB9fsUpX0x/ApIt4d7qfu/cQRc3+61aO0ET87BoPcT8LZ
	 KYXkN+2tnDhbfGTeBjrDDoQ/KzVFdZZmfsel+UUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/473] kernel/numa.c: Move logging out of numa.h
Date: Thu,  6 Jun 2024 16:01:29 +0200
Message-ID: <20240606131705.245824038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f512c0aba54b..8fc218a55be4e 100644
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
 int numa_map_to_online_node(int node);
 
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
 static inline int numa_map_to_online_node(int node)
 {
diff --git a/kernel/Makefile b/kernel/Makefile
index ebc692242b68b..c90ee75eb8043 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
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



