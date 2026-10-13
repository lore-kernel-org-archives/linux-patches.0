Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75A13E1203;
	Tue, 13 Oct 2026 11:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892029; cv=none; b=sdiKT33t18BSghPstDB3sxFo4VSRgu5w46oJsD8kQgpVxtGm5Rd3yMleGEBx03i7RB2+WxrHDsT/DMEaV52l3O56KkteLKIVqn5uUb4FJ1N8BjIZ+Flos2qMTGBCIOQTEsH4JsEOFdJpTkObym4z4rbU+H9q5Kto3GmYzWiBD58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892029; c=relaxed/simple;
	bh=d23D3aoo43Qm6Z3WB6BFBMMKUFRv0LQynOqhvy4K/aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKpbf4VS2IbeFg38Uc24adD/cjtgeD0BSoNERmOF7vZ2AMb08Ax6DSoeF6tmln/OVB4i3m3bZFA4pA7o9zrfLJhA0kFGUfyQEyYwki6mJJBxpTpicVwJBoQG/b5gYtqvcfFfKUpN1P2sUB79zM+NLMTYEpDKBHAtb5XLxiD+urI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETd3JwMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETd3JwMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8D71F000FF;
	Tue, 13 Oct 2026 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892027;
	bh=hJ/Snt8Rhl80/tvgszQWjAg4XIBon0L/uAlJeOvYnvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETd3JwMDbCO8BDGUWm7fvfYDZv7DjLDYc0/kt5ltov6jloYenBbmTb3jUwjSwmWVx
	 ai8S68b5L9lrYhCh2w3eItnGGLcthwRmvl+R33mM/g9mE8R0EEE0pZ9ozg3DjIOX6p
	 PHMWPh/ky26hlvV6IlM5sQVEHzY2ertncW4aRVrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 037/281] x86/CPU/AMD: Fix AMD TLBI Erratum #1718
Date: Tue, 13 Oct 2026 13:35:53 +0200
Message-ID: <20261013112855.953112200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/include/asm/cpufeatures.h |    3 +++
 arch/x86/include/asm/tlb.h         |    6 ++++++
 arch/x86/kernel/cpu/amd.c          |    4 ++++
 3 files changed, 13 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -465,6 +465,8 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
 #define X86_FEATURE_WRMSR_XX_BASE_NS	(20*32+ 1) /* WRMSR to {FS,GS,KERNEL_GS}_BASE is non-serializing */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* LFENCE always serializing / synchronizes RDTSC */
+
+#define X86_FEATURE_TLBSYNC_SFW_NO	(20*32+ 4) /* TLBI Erratum #1718 fixed in microcode */
 #define X86_FEATURE_VERW_CLEAR		(20*32+ 5) /* The memory form of VERW mitigates TSA */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
 
@@ -575,4 +577,5 @@
 #define X86_BUG_TSA			X86_BUG( 1*32+ 9) /* "tsa" CPU is affected by Transient Scheduler Attacks */
 #define X86_BUG_VMSCAPE			X86_BUG( 1*32+10) /* "vmscape" CPU is affected by VMSCAPE attacks from guests */
 #define X86_BUG_SEAMRET_INVD_VMCS	X86_BUG( 1*32+11) /* "seamret_invd_vmcs" SEAMRET from P-SEAMLDR clears the current VMCS */
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
@@ -1047,6 +1047,10 @@ static void init_amd_zen5(struct cpuinfo
 		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
 		pr_emerg_once("RDSEED32 is broken. Disabling the corresponding CPUID bit.\n");
 	}
+
+	if (cpu_has(c, X86_FEATURE_INVLPGB) &&
+	    !cpu_has(c, X86_FEATURE_TLBSYNC_SFW_NO))
+		set_cpu_bug(c, X86_BUG_TLBI);
 }
 
 static void init_amd(struct cpuinfo_x86 *c)


