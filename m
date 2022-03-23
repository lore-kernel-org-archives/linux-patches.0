Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD9C6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFB6C36AE3;
	Wed, 23 Mar 2022 23:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076803;
	bh=5pDjDD9vDm00RpUlnqSUOvgAc1aYQgnjnm6iV+Jxb1Y=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=1dLKZ/Oj++UR9t9ZsofShYc7uaZtN7ZkysLjnhIEQlvBw1C6sRIXMvD0e2NWX2pYl
	 KEwVaUHVzDwGDrNFsdOjF+qmUuqLljmJs+QVL5AD3s9oAagx1IRrkxxv6IPc49JfS+
	 AUNAhq7cArHsnb/rbF2lfULWw0tKyswx6s28+BTk=
Date: Wed, 23 Mar 2022 16:06:42 -0700
To: will@kernel.org,tglx@linutronix.de,rmk+kernel@armlinux.org.uk,paul.walmsley@sifive.com,palmer@rivosinc.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,jszhang@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 28/41] arm64: mm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
Message-Id: <20220323230643.2EFB6C36AE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Jisheng Zhang <jszhang@kernel.org>
Subject: arm64: mm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

Link: https://lkml.kernel.org/r/20211206160514.2000-5-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/arm64/mm/init.c~arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef
+++ a/arch/arm64/mm/init.c
@@ -64,7 +64,6 @@ EXPORT_SYMBOL(memstart_addr);
  */
 phys_addr_t arm64_dma_phys_limit __ro_after_init;
 
-#ifdef CONFIG_KEXEC_CORE
 /*
  * reserve_crashkernel() - reserves memory for crash kernel
  *
@@ -78,6 +77,9 @@ static void __init reserve_crashkernel(v
 	unsigned long long crash_max = arm64_dma_phys_limit;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
+
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base);
 	/* no crashkernel= or invalid value specified */
@@ -110,11 +112,6 @@ static void __init reserve_crashkernel(v
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 }
-#else
-static void __init reserve_crashkernel(void)
-{
-}
-#endif /* CONFIG_KEXEC_CORE */
 
 /*
  * Return the maximum physical address for a zone accessible by the given bits
_
