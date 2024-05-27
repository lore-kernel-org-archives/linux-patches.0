Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902F3262BE;
	Mon, 27 May 2024 19:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838162; cv=none; b=YsnOZmfzEmAz0XwEBuCUxgOiW+24XzkiSrBAXtUbt0oEf0s+2mDKQZIHcPLVobAmjugpduGacKX1Rap1RszsdoW5Z7F0z/g/vuZT8l640Pw821ZzVjtti+QVqRK1NAW4rOolrUGN9enO8uhRvyFgSZ9/v/+bLNsC6WVJ8LmWwYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838162; c=relaxed/simple;
	bh=sD4xzaOBQbpzgI0F79hoYDzQv9JXO4lvC8ogVXcbzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vk9fSOc3ZOPZDmMpj/Tm6rPAEJCCy6LbxVGwa32sYWF42BqyeaGpAcNhHLoFvphl2AuI0LPdj1YTNyaVbkUOzo1702bZutk+3methNYQP4nDN/7sz4n2sxG/3biZCZvCK5UpU5mAlixH3dIQB8MYGUr0449+fYl66F3q3ZPnjCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvN0Ob8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvN0Ob8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269BBC2BBFC;
	Mon, 27 May 2024 19:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838162;
	bh=sD4xzaOBQbpzgI0F79hoYDzQv9JXO4lvC8ogVXcbzoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvN0Ob8/PKqz/XeSmClKTmfmclpiOD9jMUvd98r0CnXKO0lfyC9ejWQjejB3WaCoM
	 d/ZeuTu8ZQQELYYvdPfK9TM6YG6nbeZ56eRH3zlYfUYdlpkt54F203Hzc9XjQ6nXmm
	 I0RwYs2pMAy5kb/Gp5crN8PQpFGwHlThhM8LMNqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Robert Richter <rrichter@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 290/493] x86/numa: Fix SRAT lookup of CFMWS ranges with numa_fill_memblks()
Date: Mon, 27 May 2024 20:54:52 +0200
Message-ID: <20240527185639.795449395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Robert Richter <rrichter@amd.com>

[ Upstream commit f9f67e5adc8dc2e1cc51ab2d3d6382fa97f074d4 ]

For configurations that have the kconfig option NUMA_KEEP_MEMINFO
disabled, numa_fill_memblks() only returns with NUMA_NO_MEMBLK (-1).
SRAT lookup fails then because an existing SRAT memory range cannot be
found for a CFMWS address range. This causes the addition of a
duplicate numa_memblk with a different node id and a subsequent page
fault and kernel crash during boot.

Fix this by making numa_fill_memblks() always available regardless of
NUMA_KEEP_MEMINFO.

As Dan suggested, the fix is implemented to remove numa_fill_memblks()
from sparsemem.h and alos using __weak for the function.

Note that the issue was initially introduced with [1]. But since
phys_to_target_node() was originally used that returned the valid node
0, an additional numa_memblk was not added. Though, the node id was
wrong too, a message is seen then in the logs:

 kernel/numa.c:  pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",

[1] commit fd49f99c1809 ("ACPI: NUMA: Add a node and memblk for each
    CFMWS not in SRAT")

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/all/66271b0072317_69102944c@dwillia2-xfh.jf.intel.com.notmuch/
Fixes: 8f1004679987 ("ACPI/NUMA: Apply SRAT proximity domain to entire CFMWS window")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/sparsemem.h | 2 --
 arch/x86/mm/numa.c               | 4 ++--
 drivers/acpi/numa/srat.c         | 5 +++++
 include/linux/numa.h             | 7 +------
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index 1be13b2dfe8bf..64df897c0ee30 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -37,8 +37,6 @@ extern int phys_to_target_node(phys_addr_t start);
 #define phys_to_target_node phys_to_target_node
 extern int memory_add_physaddr_to_nid(u64 start);
 #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
-extern int numa_fill_memblks(u64 start, u64 end);
-#define numa_fill_memblks numa_fill_memblks
 #endif
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 65e9a6e391c04..ce84ba86e69e9 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -929,6 +929,8 @@ int memory_add_physaddr_to_nid(u64 start)
 }
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
+#endif
+
 static int __init cmp_memblk(const void *a, const void *b)
 {
 	const struct numa_memblk *ma = *(const struct numa_memblk **)a;
@@ -1001,5 +1003,3 @@ int __init numa_fill_memblks(u64 start, u64 end)
 	}
 	return 0;
 }
-
-#endif
diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 0214518fc582f..3ca22db3ed5db 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -206,6 +206,11 @@ int __init srat_disabled(void)
 	return acpi_numa < 0;
 }
 
+__weak int __init numa_fill_memblks(u64 start, u64 end)
+{
+	return NUMA_NO_MEMBLK;
+}
+
 #if defined(CONFIG_X86) || defined(CONFIG_ARM64) || defined(CONFIG_LOONGARCH)
 /*
  * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
diff --git a/include/linux/numa.h b/include/linux/numa.h
index 915033a757315..1d43371fafd2f 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -36,12 +36,7 @@ int memory_add_physaddr_to_nid(u64 start);
 int phys_to_target_node(u64 start);
 #endif
 
-#ifndef numa_fill_memblks
-static inline int __init numa_fill_memblks(u64 start, u64 end)
-{
-	return NUMA_NO_MEMBLK;
-}
-#endif
+int numa_fill_memblks(u64 start, u64 end);
 
 #else /* !CONFIG_NUMA */
 static inline int numa_nearest_node(int node, unsigned int state)
-- 
2.43.0



