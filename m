Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14C72F32
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 01:32:13 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-2d07ae11467so30165677b3.12
        for <patches@lists.linux.dev>; Thu, 17 Feb 2022 17:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dTNKukE2OugMPlgBk0kjAWyCH6abjxYQr54aQU93Dsw=;
        b=ABklzAtjJO6j7LDPYqAAa8FMBHRCVRGQF9PPgv1Ft7BksPe+v0U4UtLqnJsC19Zl+L
         OiKRmyuEcoTRRKFBp3BTGS3uZg88aOaB1lT9kR2IiFowkyJOhVXcf7+CcmC7GCPrzTCD
         BITgWHEz7HCVI7Af9B/6LjbgwjLOZjcprbzUH9rdJ9qBQZSTGDRBivNHqM+goHwAdAni
         X3MZQeaRwo/+/z4gUJPbEHgTpyN0LcZEMshl3fQ1X85XdmQJTmmg0Mz/88iJDSBoE/ga
         njGfNFJR68AFMP5mfkafiqlun4vwVLWrNo6ZCUKZ7+8pNObKd0TpR4bIPsQZXA4RSrdN
         kOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dTNKukE2OugMPlgBk0kjAWyCH6abjxYQr54aQU93Dsw=;
        b=2Xq0Jww3vd1MyOm+5mcAXBr0tFBypeXQqGwzORfeYv3EeNLpLPrNR6Rrf4qq0jqUVf
         EkWwcOYRI46pBFIoqpEcMzEcxLS2yjnvWt+5v8wGLY6Ru6GDxpBOedP+XB/qlFX9Fvlk
         8YFDUlCzsvOsZ8hoygeYAid1I7TYd+wXCmVdF/0tSQi126WqTkkiAh8Lnm++3HcxoxoX
         vF+uXlPwQ3inCXrxncvICQtDJRfderkqMVuUuXfcECJuwIuIa/JY1s6E+7Pc3OOaYJkR
         /U/7nEcPhr0qeS8Gq9MVxw3toPmmrUltxSChbwuQIfPX24rLCvKka9VY9RZtje8woIa7
         TtrQ==
X-Gm-Message-State: AOAM530JbJmw653LA16PIiY9IlajJ3Z09QtcHAVLC21ESiy+69YEC+Qp
	y3h8LR3nUr24RaIVEQMNFHFMUrrV
X-Google-Smtp-Source: ABdhPJwsJO2Rxv67e92BrTyGx5Y4hnYBxxLRQBfIXOhGoUuxgk+IA4yKbq8A7sv6et2/hsO5I289kysI
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:3126:6c42:fb6:7d09])
 (user=juew job=sendgmr) by 2002:a0d:eb09:0:b0:2d1:e0df:5104 with SMTP id
 u9-20020a0deb09000000b002d1e0df5104mr5703478ywe.250.1645147932575; Thu, 17
 Feb 2022 17:32:12 -0800 (PST)
Date: Thu, 17 Feb 2022 17:32:09 -0800
In-Reply-To: <Yg54nse5qNQO3sbW@zn.tnic>
Message-Id: <20220218013209.2436006-1-juew@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Yg54nse5qNQO3sbW@zn.tnic>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v2] x86/mce: work around an erratum on fast string copy instructions.
From: Jue Wang <juew@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jue Wang <juew@google.com>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"

A rare kernel panic scenario can happen when the following conditions
are met due to an erratum on fast string copy instructions:

1) An uncorrected error.
2) That error must be in first cache line of a page.
3) Kernel must execute page_copy from the page immediately before that
page.

The fast string copy instructions ("REP; MOVS*") could consume an
uncorrectable memory error in the cache line _right after_ the desired
region to copy and raise an MCE.

Bit 0 of MSR_IA32_MISC_ENABLE can be cleared to disable fast string
copy and will avoid such spurious machine checks. However, that is less
preferable due to the permanent performance impact. Considering memory
poison is rare, it's desirable to keep fast string copy enabled until an
MCE is seen.

Intel has confirmed the following:
1. The CPU erratum of fast string copy only applies to Skylake,
Cascade Lake and Cooper Lake generations.

Directly return from the MCE handler:
2. Will result in complete execution of the "REP; MOVS*" with no data
loss or corruption.
3. Will not result in another MCE firing on the next poisoned cache line
due to "REP; MOVS*".
4. Will resume execution from a correct point in code.
5. Will result in the same instruction that triggered the MCE firing a
second MCE immediately for any other software recoverable data fetch
errors.
6. Is not safe without disabling the fast string copy, as the next fast
string copy of the same buffer on the same CPU would result in a PANIC
MCE.

This should mitigate the erratum completely with the only caveat that
the fast string copy is disabled on the affected hyper thread thus
performance degradation.

This is still better than the OS crashing on MCEs raised on an
irrelevant process due to "REP; MOVS*' accesses in a kernel context,
e.g., copy_page.

Tested:

Injected errors on 1st cache line of 8 anonymous pages of process
'proc1' and observed MCE consumption from 'proc2' with no panic
(directly returned).

Without the fix, the host panicked within a few minutes on a
random 'proc2' process due to kernel access from copy_page.

  [ bp: Fix comment style + touch ups. ]

Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mce/core.c     | 58 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/internal.h |  5 ++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5818b837fd4d..d2502a6c3516 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -834,6 +834,54 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 	m->cs = regs->cs;
 }
 
+/*
+ * Disable fast string copy and return from the MCE handler upon the first SRAR
+ * MCE on bank 1 due to a CPU erratum on Intel Skylake/Cascade Lake/Cooper Lake
+ * CPUs.
+ * The fast string copy instructions ("REP; MOVS*") could consume an
+ * uncorrectable memory error in the cache line _right after_ the desired region
+ * to copy and raise an MCE with RIP pointing to the instruction _after_ the
+ * "REP; MOVS*".
+ * This mitigation addresses the issue completely with the caveat of performance
+ * degradation on the CPU affected. This is still better than the OS crashing on
+ * MCEs raised on an irrelevant process due to "REP; MOVS*" accesses from a
+ * kernel context (e.g., copy_page).
+ *
+ * Returns true when fast string copy on CPU has been disabled.
+ */
+static noinstr bool quirk_skylake_repmov(void)
+{
+	u64 mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
+	u64 misc_enable = __rdmsr(MSR_IA32_MISC_ENABLE);
+
+	/*
+	 * Apply the quirk only to local machine checks, i.e., no broadcast
+	 * sync is needed.
+	 */
+	if ((mcgstatus & MCG_STATUS_LMCES) &&
+	    unlikely(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
+
+		/* Check for a software-recoverable data fetch error. */
+		if ((mc1_status &
+		     (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
+		      MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
+		      MCI_STATUS_AR | MCI_STATUS_S)) ==
+		     (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
+		      MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
+		      MCI_STATUS_AR | MCI_STATUS_S)) {
+			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
+			__wrmsr(MSR_IA32_MISC_ENABLE,
+				(u32)misc_enable, (u32)(misc_enable >> 32));
+			mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
+			mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
+			pr_err_once("Errata detected, disable fast string copy instructions.\n");
+			return true;
+		}
+	}
+	return false;
+}
+
 /*
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
@@ -1403,6 +1451,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	else if (unlikely(!mca_cfg.initialized))
 		return unexpected_machine_check(regs);
 
+	if (mce_flags.skx_repmov_quirk && quirk_skylake_repmov())
+		return;
+
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1858,6 +1909,13 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
 		if (c->x86 == 6 && c->x86_model == 45)
 			mce_flags.snb_ifu_quirk = 1;
+
+		/*
+		 * Skylake, Cascacde Lake and Cooper Lake require a quirk on
+		 * rep movs.
+		 */
+		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_SKYLAKE_X)
+			mce_flags.skx_repmov_quirk = 1;
 	}
 
 	if (c->x86_vendor == X86_VENDOR_ZHAOXIN) {
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 52c633950b38..24d099e2d2a2 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -170,7 +170,10 @@ struct mce_vendor_flags {
 	/* SandyBridge IFU quirk */
 	snb_ifu_quirk		: 1,
 
-	__reserved_0		: 57;
+	/* Skylake, Cascade Lake, Cooper Lake REP;MOVS* quirk */
+	skx_repmov_quirk	: 1,
+
+	__reserved_0		: 56;
 };
 
 extern struct mce_vendor_flags mce_flags;
-- 
2.35.1.265.g69c8d7142f-goog

