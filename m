Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278CC3E3DAB;
	Tue, 17 Mar 2026 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765494; cv=none; b=qx9uxM+M/xeYlHJ09EFL8rLnxNXAsx3A/XE0nori7wIabGhicmRAkcKy5X6o0/y3hnh1iTRXu6DRTV16Fm1I/jrsECA6T9Z/y6SvbNKqIGV8BKAY1/omm0els9CIyti5q5Pan5ElDLpq1NOkEHdRW9C7HTxfWF2xreAxNLqqnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765494; c=relaxed/simple;
	bh=7fu7hBT/mdncdmpY22SjA4q2Jp1i7NTJAwg6X4hv9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMkizWrQI54vgesUAPVVUWXf0a1eFGVKRzHGLzNQu/WoNeNG9FGVIvqI2czNxj8sAY6Awee6mD1YJZjIHWrhGojxqTeUS2X9LllLsp6Jvxo1/PqTu+q5I80BHEPdx9rWg4LGzPefyMPpSiIs6RGS9XMUvotw+3t7nsaXsC00+K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/BAaXX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/BAaXX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B266C4CEF7;
	Tue, 17 Mar 2026 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765493;
	bh=7fu7hBT/mdncdmpY22SjA4q2Jp1i7NTJAwg6X4hv9sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/BAaXX11u3OGlAbwrMTAYNm7VmhA8b0AwCLXhh3iWikPZzrpkDqdGUvw/zzOnTFG
	 ee1a9tqhFKNmJupryOHWZZh9/7VT2LMTPSLManrCLeC90Yzb3wslCfSYH2LLIjYfjU
	 Gbh3xZ//Ck94Rt0Fq1CDZNzEYgXn+yVYYRbOb0sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 003/378] powerpc/kexec/core: use big-endian types for crash variables
Date: Tue, 17 Mar 2026 17:29:20 +0100
Message-ID: <20260317163007.093416258@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 104c05520bf05..dc44f11be353e 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -23,6 +23,7 @@
 #include <asm/firmware.h>
 
 #define cpu_to_be_ulong __PASTE(cpu_to_be, BITS_PER_LONG)
+#define __be_word __PASTE(__be, BITS_PER_LONG)
 
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
@@ -146,25 +147,25 @@ int __init overlaps_crashkernel(unsigned long start, unsigned long size)
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
 
@@ -193,11 +194,11 @@ static void __init export_crashk_values(struct device_node *node)
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



