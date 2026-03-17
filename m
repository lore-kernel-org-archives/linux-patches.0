Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DDA332604;
	Tue, 17 Mar 2026 17:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767120; cv=none; b=PzOvMasbo5o0zl0HMolJtJ/jMptraUids4s7VuX8HFfWrL6mKBGzQvnslC6jZ8Y5jzK6g9dJvMH+ciP/bgQs7E9aCPxcD6O0U4ZFC2A1qkWJfaD0ef+sEgecjXZITkr0pdiJ8B77se4KEnxHW/bPgdKk/Yu8lfQtrK0isgQK9o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767120; c=relaxed/simple;
	bh=WAD3Deg8IhtmTPQSTLkZJVsEOYWzgHHO6FzfL5Qf4dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAVGHDSGZWRj5c9ntEyeJ9IO6cMFIbhTRajcsMmB6swvZhoTVdHROJR/S4rJGOc06iXZRIsUJ9dvrxEzvegzxhL3fGedGJozRENKp74giHdoHKjWjEnuJ3cTYQkF67I83YxLkVy31++vDVDItEi0ROrne87GkJvl6G69jy3M2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1ynVmSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1ynVmSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C9FC4CEF7;
	Tue, 17 Mar 2026 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767120;
	bh=WAD3Deg8IhtmTPQSTLkZJVsEOYWzgHHO6FzfL5Qf4dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1ynVmSbbOlLQkWiIPgqUG6tp+zRHlfg7eU+9opV999Kccun+VjIJtkn/zBBZr8+B
	 M6lOcOCHMhP7xX3PR+Bl63uy+FlWWkmilEYLvH0EytiJVLhFmJfchuiVHjPskjoNRh
	 X+/IDmMe+xo5RakX70e+xvW5iCgv19wTA+qfs3bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Collins <bcollins@kernel.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/333] kexec: Include kernel-end even without crashkernel
Date: Tue, 17 Mar 2026 17:30:48 +0100
Message-ID: <20260317163000.072748031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Collins <bcollins@kernel.org>

[ Upstream commit 38c64dfe0af12778953846df5f259e913275cfe5 ]

Certain versions of kexec don't even work without kernel-end being
added to the device-tree. Add it even if crash-kernel is disabled.

Signed-off-by: Ben Collins <bcollins@kernel.org>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/2025042122-inescapable-mandrill-8a5ff2@boujee-and-buff
Stable-dep-of: 20197b967a6a ("powerpc/kexec/core: use big-endian types for crash variables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index d1a2d755381ca..cf803d09c8e51 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -22,6 +22,8 @@
 #include <asm/setup.h>
 #include <asm/firmware.h>
 
+#define cpu_to_be_ulong __PASTE(cpu_to_be, BITS_PER_LONG)
+
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
@@ -136,17 +138,10 @@ int __init overlaps_crashkernel(unsigned long start, unsigned long size)
 }
 
 /* Values we need to export to the second kernel via the device tree. */
-static phys_addr_t kernel_end;
 static phys_addr_t crashk_base;
 static phys_addr_t crashk_size;
 static unsigned long long mem_limit;
 
-static struct property kernel_end_prop = {
-	.name = "linux,kernel-end",
-	.length = sizeof(phys_addr_t),
-	.value = &kernel_end,
-};
-
 static struct property crashk_base_prop = {
 	.name = "linux,crashkernel-base",
 	.length = sizeof(phys_addr_t),
@@ -165,8 +160,6 @@ static struct property memory_limit_prop = {
 	.value = &mem_limit,
 };
 
-#define cpu_to_be_ulong	__PASTE(cpu_to_be, BITS_PER_LONG)
-
 static void __init export_crashk_values(struct device_node *node)
 {
 	/* There might be existing crash kernel properties, but we can't
@@ -190,6 +183,15 @@ static void __init export_crashk_values(struct device_node *node)
 	mem_limit = cpu_to_be_ulong(memory_limit);
 	of_update_property(node, &memory_limit_prop);
 }
+#endif /* CONFIG_CRASH_RESERVE */
+
+static phys_addr_t kernel_end;
+
+static struct property kernel_end_prop = {
+	.name = "linux,kernel-end",
+	.length = sizeof(phys_addr_t),
+	.value = &kernel_end,
+};
 
 static int __init kexec_setup(void)
 {
@@ -200,16 +202,17 @@ static int __init kexec_setup(void)
 		return -ENOENT;
 
 	/* remove any stale properties so ours can be found */
-	of_remove_property(node, of_find_property(node, kernel_end_prop.name, NULL));
+	of_remove_property(node, of_find_property(node, kernel_end_prop.name,
+						  NULL));
 
 	/* information needed by userspace when using default_machine_kexec */
 	kernel_end = cpu_to_be_ulong(__pa(_end));
 	of_add_property(node, &kernel_end_prop);
 
+#ifdef CONFIG_CRASH_RESERVE
 	export_crashk_values(node);
-
+#endif
 	of_node_put(node);
 	return 0;
 }
 late_initcall(kexec_setup);
-#endif /* CONFIG_CRASH_RESERVE */
-- 
2.51.0



