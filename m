Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CE4FD78D;
	Tue, 13 Oct 2026 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894563; cv=none; b=AoTfXTUP9HhneUfa9mYA77NMynl74PRs6bt9PnQk0ozwGWzIjkLFwjvTiyDMYH30a3FkYfy4fCnOcvR3FsGAb5IquxyJsImKhW36OcQBkB53BkGpYMOYQJ054uC9xyhw6qzvEIyzjR6wbzXil+/n/BIIc7pbce22qcAJaRJKI60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894563; c=relaxed/simple;
	bh=z4GylVignGhzYrZD03omw+iY+Up8C8NV/lO1upIhBkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHKeuk7PWVh6jIZlCQ5V7zdHnxp/DtuzbzhWD6A5LAJ3wfW2TRM/gE6WwcchWMbFB/7tJdR9g751LFPTOKdBMWCETc4ehvfPisNm4LF5qdvqew+OuUiPFZfGBO2sf59R1vAF0d1L8K9vlZOv/qxk2sbI4cfmXA3xnqoyqIZMCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKZtGzMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKZtGzMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F41F000FF;
	Tue, 13 Oct 2026 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894561;
	bh=ncVV8dCPoKGVz4BHHBLmeJg6U8N+Cm54Dek2vPgyDuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKZtGzMqOo43w4uu468NVqwEnkNFakbXe7HCDlLWIZ41/h+9cziCDDugbboUrS5eL
	 7+IOtCSNmE95dElHsqkR9mlDCrazHMqyQUNcHinl+UsCIei06JX/BtIcXA8jT7Yxl/
	 UNsOKnH7SkM3uRaWA+N6Ouhdu0rzdSXCdxng6jeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 602/621] x86/CPU/AMD: Fix AMD TLBI Erratum #1718
Date: Tue, 13 Oct 2026 13:39:57 +0200
Message-ID: <20261013112935.085075153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 87db7795cbaaf636ae22ae031f4906db7bb77803 upstream.

The processor may fail to invalidate a TLB entry while executing an
INVLPGB/TLBSYNC instruction pair.

Detect the erratum and apply a software workaround when a microcode fix
is not present.

Fixes: 82378c6c2f43 ("x86/mm: Use INVLPGB for kernel TLB flushes")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Rik van Riel <riel@surriel.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20261002211617.1001617-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    4 ++++
 arch/x86/include/asm/tlb.h         |    6 ++++++
 arch/x86/kernel/cpu/amd.c          |    4 ++++
 3 files changed, 14 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -458,6 +458,8 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
 #define X86_FEATURE_WRMSR_XX_BASE_NS	(20*32+ 1) /* WRMSR to {FS,GS,KERNEL_GS}_BASE is non-serializing */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* LFENCE always serializing / synchronizes RDTSC */
+
+#define X86_FEATURE_TLBSYNC_SFW_NO	(20*32+ 4) /* TLBI Erratum #1718 fixed in microcode */
 #define X86_FEATURE_VERW_CLEAR		(20*32+ 5) /* The memory form of VERW mitigates TSA */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
 
@@ -556,4 +558,6 @@
 #define X86_BUG_ITS_NATIVE_ONLY		X86_BUG( 1*32+ 8) /* "its_native_only" CPU is affected by ITS, VMX is not affected */
 #define X86_BUG_TSA			X86_BUG( 1*32+ 9) /* "tsa" CPU is affected by Transient Scheduler Attacks */
 #define X86_BUG_VMSCAPE			X86_BUG( 1*32+10) /* "vmscape" CPU is affected by VMSCAPE attacks from guests */
+
+#define X86_BUG_TLBI			X86_BUG( 1*32+12) /* "tlbi" AMD TLBI Erratum #1718 */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -110,6 +110,12 @@ static inline void __tlbsync(void)
 
 	/* TLBSYNC: supported in binutils >= 0.36. */
 	asm volatile(".byte 0x0f, 0x01, 0xff" ::: "memory");
+
+	if (!static_cpu_has_bug(X86_BUG_TLBI))
+		return;
+
+	/* TLBSYNC: supported in binutils >= 0.36. */
+	asm volatile(".byte 0x0f, 0x01, 0xff" ::: "memory");
 }
 #else
 /* Some compilers (I'm looking at you clang!) simply can't do DCE */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1050,6 +1050,10 @@ static void init_amd_zen5(struct cpuinfo
 		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
 		pr_emerg_once("RDSEED32 is broken. Disabling the corresponding CPUID bit.\n");
 	}
+
+	if (cpu_has(c, X86_FEATURE_INVLPGB) &&
+	    !cpu_has(c, X86_FEATURE_TLBSYNC_SFW_NO))
+		set_cpu_bug(c, X86_BUG_TLBI);
 }
 
 static void init_amd(struct cpuinfo_x86 *c)


