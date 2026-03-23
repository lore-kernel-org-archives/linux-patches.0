Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E63AEF21;
	Mon, 23 Mar 2026 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275225; cv=none; b=Q4kvoqXEcmGXpra66/9OlHg07K2iNwSuXHpRB5Cn/ZbUt+ToiqLUZSP8xiSlvtQjpt5i0RjX2Jk0Zcs8uJX0ZrfZcWxLRuVnt6hVhvSKPZqbCsBVPN/WF1J0gJzGqSDT5Q98RaJB5poyeKKium6qkJToE44uNn+dknRURzaxGWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275225; c=relaxed/simple;
	bh=QovV3sWXQhny0zHgBvZYK2OuVNlHXPr71BmdeWG+ubE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxN+Y65TjqF8kMHTza7pX1rHtlf5YAv29GRI4mT2U2pAxmbpREzU+lOrbS1nSzqlKOum4Lod+S2V16rNDIkIiljDjC5E9DptETDOst6jpoxFKMZmsa/HrXCQetqHuxgCG2YXAciwttHDD2shIcnACURzIqSDOGLVGJQnzll88gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNs4+MWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNs4+MWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD74C4CEF7;
	Mon, 23 Mar 2026 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275225;
	bh=QovV3sWXQhny0zHgBvZYK2OuVNlHXPr71BmdeWG+ubE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNs4+MWyHQ6Y70CxDlH89V8av8YKfNRus/uaF55jQKE8V7R8k36uw9U6KBpVo48pY
	 1WOFFt4QY/YZZzpeuxt66bn/bWA3N8uB2LhoXSJKTPDRmgPjTmvfVlWmrIc+Zmp+ge
	 bAU/Ei0IDe21mutUycuYfuHvavRFHe7vXjCu1fv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/460] powerpc/kexec/core: use big-endian types for crash variables
Date: Mon, 23 Mar 2026 14:40:15 +0100
Message-ID: <20260323134527.132119736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 20197b967a6a29dab81495f25a988515bda84cfe ]

Use explicit word-sized big-endian types for kexec and crash related
variables. This makes the endianness unambiguous and avoids type
mismatches that trigger sparse warnings.

The change addresses sparse warnings like below (seen on both 32-bit
and 64-bit builds):

CHECK   ../arch/powerpc/kexec/core.c
sparse:    expected unsigned int static [addressable] [toplevel] [usertype] crashk_base
sparse:    got restricted __be32 [usertype]
sparse: warning: incorrect type in assignment (different base types)
sparse:    expected unsigned int static [addressable] [toplevel] [usertype] crashk_size
sparse:    got restricted __be32 [usertype]
sparse: warning: incorrect type in assignment (different base types)
sparse:    expected unsigned long long static [addressable] [toplevel] mem_limit
sparse:    got restricted __be32 [usertype]
sparse: warning: incorrect type in assignment (different base types)
sparse:    expected unsigned int static [addressable] [toplevel] [usertype] kernel_end
sparse:    got restricted __be32 [usertype]

No functional change intended.

Fixes: ea961a828fe7 ("powerpc: Fix endian issues in kexec and crash dump code")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512221405.VHPKPjnp-lkp@intel.com/
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251224151257.28672-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index 50e7cf4b992b1..31797f2145ec5 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -23,6 +23,7 @@
 #include <asm/firmware.h>
 
 #define cpu_to_be_ulong __PASTE(cpu_to_be, BITS_PER_LONG)
+#define __be_word __PASTE(__be, BITS_PER_LONG)
 
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
@@ -158,25 +159,25 @@ int __init overlaps_crashkernel(unsigned long start, unsigned long size)
 }
 
 /* Values we need to export to the second kernel via the device tree. */
-static phys_addr_t crashk_base;
-static phys_addr_t crashk_size;
-static unsigned long long mem_limit;
+static __be_word crashk_base;
+static __be_word crashk_size;
+static __be_word mem_limit;
 
 static struct property crashk_base_prop = {
 	.name = "linux,crashkernel-base",
-	.length = sizeof(phys_addr_t),
+	.length = sizeof(__be_word),
 	.value = &crashk_base
 };
 
 static struct property crashk_size_prop = {
 	.name = "linux,crashkernel-size",
-	.length = sizeof(phys_addr_t),
+	.length = sizeof(__be_word),
 	.value = &crashk_size,
 };
 
 static struct property memory_limit_prop = {
 	.name = "linux,memory-limit",
-	.length = sizeof(unsigned long long),
+	.length = sizeof(__be_word),
 	.value = &mem_limit,
 };
 
@@ -205,11 +206,11 @@ static void __init export_crashk_values(struct device_node *node)
 }
 #endif /* CONFIG_CRASH_RESERVE */
 
-static phys_addr_t kernel_end;
+static __be_word kernel_end;
 
 static struct property kernel_end_prop = {
 	.name = "linux,kernel-end",
-	.length = sizeof(phys_addr_t),
+	.length = sizeof(__be_word),
 	.value = &kernel_end,
 };
 
-- 
2.51.0



