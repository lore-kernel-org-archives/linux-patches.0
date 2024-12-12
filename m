Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C132213E97;
	Thu, 12 Dec 2024 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016323; cv=none; b=lxwlJIOkRAYZrUmo8R6uvdSmdIVUwaurTFAPcFor5AHY27+lgCJxLz7tYoY5Gc8SD+2rzl3Idd6OL4boB6/uvSkpCeIRaR7EvkU3l2BsJvIDXZeUQSOcTSZUzYrzWYJBwMK62tObLYjQ8KE9mEuacqQV+c2texhwHvgzkDTOgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016323; c=relaxed/simple;
	bh=itIfiC5wfXNHZ5TiX2+s2dI6VnA8UZ8Km7ZuxJj8iZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTxeyGR8QyZ6ofA9F9sxGtD3AnluQHHj/6rXObgsGs3APQ39Zr1F3QI9tWA/Ore78wf4hvBoO7QTskmIeEaI7uq4v5qbQk4cw8xi7mC1PKxUvDITVLI3jXPnFIt0tSn2cmq00nstvHHtQmKMILYoIzXSf53m+1xlm8XPZtw4ArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPLZ1BdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPLZ1BdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7344C4CED0;
	Thu, 12 Dec 2024 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016323;
	bh=itIfiC5wfXNHZ5TiX2+s2dI6VnA8UZ8Km7ZuxJj8iZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPLZ1BdPmD4KZJrSprt7tJvBjAN4mSv68PpMVVG4n2wxAvus25fkoLfyaVB8HZKrP
	 F38u/1+KHRogZjfoPzW6vXHUbYxSllhjWmRvR5MmItPoyKraZPTQpATRNiSUis8O1S
	 HiewQBmMn41sI7gqJtp1muy3cJl3+q8qVADvJIHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 167/466] x86/cacheinfo: Delete global num_cache_leaves
Date: Thu, 12 Dec 2024 15:55:36 +0100
Message-ID: <20241212144313.400721548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

commit 9677be09e5e4fbe48aeccb06ae3063c5eba331c3 upstream.

Linux remembers cpu_cachinfo::num_leaves per CPU, but x86 initializes all
CPUs from the same global "num_cache_leaves".

This is erroneous on systems such as Meteor Lake, where each CPU has a
distinct num_leaves value. Delete the global "num_cache_leaves" and
initialize num_leaves on each CPU.

init_cache_level() no longer needs to set num_leaves. Also, it never had to
set num_levels as it is unnecessary in x86. Keep checking for zero cache
leaves. Such condition indicates a bug.

  [ bp: Cleanup. ]

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.3+
Link: https://lore.kernel.org/r/20241128002247.26726-3-ricardo.neri-calderon@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/cacheinfo.c |   43 +++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -178,8 +178,6 @@ struct _cpuid4_info_regs {
 	struct amd_northbridge *nb;
 };
 
-static unsigned short num_cache_leaves;
-
 /* AMD doesn't have CPUID4. Emulate it here to report the same
    information to the user.  This makes some assumptions about the machine:
    L2 not shared, no SMT etc. that is currently true on AMD CPUs.
@@ -717,20 +715,23 @@ void cacheinfo_hygon_init_llc_id(struct
 
 void init_amd_cacheinfo(struct cpuinfo_x86 *c)
 {
+	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(c->cpu_index);
 
 	if (boot_cpu_has(X86_FEATURE_TOPOEXT)) {
-		num_cache_leaves = find_num_cache_leaves(c);
+		ci->num_leaves = find_num_cache_leaves(c);
 	} else if (c->extended_cpuid_level >= 0x80000006) {
 		if (cpuid_edx(0x80000006) & 0xf000)
-			num_cache_leaves = 4;
+			ci->num_leaves = 4;
 		else
-			num_cache_leaves = 3;
+			ci->num_leaves = 3;
 	}
 }
 
 void init_hygon_cacheinfo(struct cpuinfo_x86 *c)
 {
-	num_cache_leaves = find_num_cache_leaves(c);
+	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(c->cpu_index);
+
+	ci->num_leaves = find_num_cache_leaves(c);
 }
 
 void init_intel_cacheinfo(struct cpuinfo_x86 *c)
@@ -740,21 +741,21 @@ void init_intel_cacheinfo(struct cpuinfo
 	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
 	unsigned int new_l2 = 0, new_l3 = 0, i; /* Cache sizes from cpuid(4) */
 	unsigned int l2_id = 0, l3_id = 0, num_threads_sharing, index_msb;
+	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(c->cpu_index);
 
 	if (c->cpuid_level > 3) {
-		static int is_initialized;
-
-		if (is_initialized == 0) {
-			/* Init num_cache_leaves from boot CPU */
-			num_cache_leaves = find_num_cache_leaves(c);
-			is_initialized++;
-		}
+		/*
+		 * There should be at least one leaf. A non-zero value means
+		 * that the number of leaves has been initialized.
+		 */
+		if (!ci->num_leaves)
+			ci->num_leaves = find_num_cache_leaves(c);
 
 		/*
 		 * Whenever possible use cpuid(4), deterministic cache
 		 * parameters cpuid leaf to find the cache details
 		 */
-		for (i = 0; i < num_cache_leaves; i++) {
+		for (i = 0; i < ci->num_leaves; i++) {
 			struct _cpuid4_info_regs this_leaf = {};
 			int retval;
 
@@ -790,14 +791,14 @@ void init_intel_cacheinfo(struct cpuinfo
 	 * Don't use cpuid2 if cpuid4 is supported. For P4, we use cpuid2 for
 	 * trace cache
 	 */
-	if ((num_cache_leaves == 0 || c->x86 == 15) && c->cpuid_level > 1) {
+	if ((!ci->num_leaves || c->x86 == 15) && c->cpuid_level > 1) {
 		/* supports eax=2  call */
 		int j, n;
 		unsigned int regs[4];
 		unsigned char *dp = (unsigned char *)regs;
 		int only_trace = 0;
 
-		if (num_cache_leaves != 0 && c->x86 == 15)
+		if (ci->num_leaves && c->x86 == 15)
 			only_trace = 1;
 
 		/* Number of times to iterate */
@@ -991,14 +992,12 @@ static void ci_leaf_init(struct cacheinf
 
 int init_cache_level(unsigned int cpu)
 {
-	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
 
-	if (!num_cache_leaves)
+	/* There should be at least one leaf. */
+	if (!ci->num_leaves)
 		return -ENOENT;
-	if (!this_cpu_ci)
-		return -EINVAL;
-	this_cpu_ci->num_levels = 3;
-	this_cpu_ci->num_leaves = num_cache_leaves;
+
 	return 0;
 }
 


