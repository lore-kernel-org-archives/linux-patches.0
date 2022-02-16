Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA80369D
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 21:53:17 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d16-20020a056a0010d000b004e0204c9753so2077999pfu.7
        for <patches@lists.linux.dev>; Wed, 16 Feb 2022 13:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tKxMnnjXgKWYzOMe8JPy0W04lQPVzibEjMdAZvml6iQ=;
        b=iL/vwgn2Mgc+bA0KeYitrCvpSfslRQT9OJpyeDmnokroQnet684RHgN81jVcyYK5t4
         +LSdjRqbyeeB+QtuOF2KjG5iB9hjG7hlayemXSaptOxuri2t/7R4bur+FdYR++F33+kI
         El6qoy7wh/WaCLl2RQ8evqDI+PA2DDC4bzSG1/lGk4oJvDo8dIlH9wn+6gfWkAk+DdZm
         5mU+Kg04JbSqgvcdaMZFOLBZhip1r0dk+rPWo5WwhlH/1+TnJ0ZD6ouKXrnw6WRh7PYV
         2fvXCMFMAvF8o2CYy/nIZ5jTJICtnr6uV1gZmQOaxnj85beJgXmzpJlJrVEMmThLAIAh
         3/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tKxMnnjXgKWYzOMe8JPy0W04lQPVzibEjMdAZvml6iQ=;
        b=AFqZEu7AKEcbNqtWV8UoJIF+56r2rrzwRZBCncU67tpZJncLPuVssWtQ+hgTKyHx8J
         1/oRpVeBJDfE0/xwt3FMiWpeno61its7EWzF7O7Hx5Xy62/UdW8GclBO9xtzsW7jP+aw
         zmifeinwVZsdpZ3zEhRI/blFol7/BrJiRdqUin8Ljfbg6LMdZcX88tdfaM81K35RxAkc
         EXRF0jhKUb2ZXUBSSumMLYgLIBWI1fH2S9fcujtn/+ZwsB6L9bjzmVaXSafeqs/cdHI3
         P4S+hxzvrwGu4xzmE1oGrHyFU8VdABXkVFkSUW1/2guiHYXmMIJfiQdt6q0DMdMLeC2n
         TzTg==
X-Gm-Message-State: AOAM5322HCMbelylxdPUniAFsl9RlfmwgfYDIQCO4JyrwUljAJvs8vTc
	09cNxDM3MnM13B2ndV8Awp4KaCYj
X-Google-Smtp-Source: ABdhPJycvUPdTzZFPzztRoaTFdPMhpEeiTf9MaUSQSNkLE+F4jWrTgDfoSJ86WePlyCs5dve1mHEFSFP
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:aa7e:772c:ae40:cf58])
 (user=juew job=sendgmr) by 2002:a17:903:204a:b0:14e:b8d9:b13a with SMTP id
 q10-20020a170903204a00b0014eb8d9b13amr4565898pla.10.1645048396587; Wed, 16
 Feb 2022 13:53:16 -0800 (PST)
Date: Wed, 16 Feb 2022 13:53:13 -0800
In-Reply-To: <CAPcxDJ5t47M-+Bn_D+Vj7zbJTxhjrx=HsLX=iQj-EF_h2oVTsg@mail.gmail.com>
Message-Id: <20220216215313.1707663-1-juew@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CAPcxDJ5t47M-+Bn_D+Vj7zbJTxhjrx=HsLX=iQj-EF_h2oVTsg@mail.gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] x86/mce: work around an erratum on fast string copy instructions.
From: Jue Wang <juew@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"

A rare kernel panic scenario can happen when the following conditions
are met due to an erratum on fast string copy instructions.
1) An uncorrected error.
2) That error must be in first cache line of a page.
3) Kernel must execute page_copy from the page immediately before that
page.

The fast string copy instructions ("REP; MOVS*") could consume an
uncorrectable memory error in the cache line _right after_ the
desired region to copy and raise an MCE.

Bit 0 of MSR_IA32_MISC_ENABLE can be cleared to disable fast string copy
and will avoid such spurious machine checks. However, that is less
preferable due to the permanent performance impact. Considering memory
poison is rare, it's desirable to keep fast string copy enabled until
an MCE is seen.

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

This is still better than the OS crashes on MCEs raised on an
irrelevant process due to "REP; MOVS*' accesses in a kernel context,
e.g., copy_page.

Tested:

Injected errors on 1st cache line of 8 anonymous pages of process
'proc1' and observed MCE consumption from 'proc2' with no panic
(directly returned).

Without the fix, the host panicked within a few minutes on a
random 'proc2' process due to kernel access from copy_page.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kernel/cpu/mce/core.c     | 56 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/internal.h |  5 ++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5818b837fd4d..5c9d200ec4cd 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -834,6 +834,52 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
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
+ * degradation on the CPU affected. This is still better than the OS crashes on
+ * MCEs raised on an irrelevant process due to "REP; MOVS*" accesses from a
+ * kernel context (e.g., copy_page).
+ *
+ * Returns true when fast string copy on CPU should be disabled.
+ */
+static noinstr bool quirk_skylake_repmov(void)
+{
+	u64 mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
+	u64 misc_enable = __rdmsr(MSR_IA32_MISC_ENABLE);
+
+	// Only applies the quirk to local machine checks, i.e., no broadcast
+	// sync is needed.
+	if ((mcgstatus & MCG_STATUS_LMCES) &&
+	    unlikely(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
+
+		// The blob of logic below is checking for a software
+		// recoverable data fetch error.
+		if ((mc1_status &
+		     (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
+		      MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
+		      MCI_STATUS_AR | MCI_STATUS_S)) ==
+		     (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
+		      MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
+		      MCI_STATUS_AR | MCI_STATUS_S)) {
+			msr_clear_bit(MSR_IA32_MISC_ENABLE,
+				      MSR_IA32_MISC_ENABLE_FAST_STRING_BIT);
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
@@ -1403,6 +1449,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	else if (unlikely(!mca_cfg.initialized))
 		return unexpected_machine_check(regs);
 
+	if (mce_flags.skx_repmov_quirk && quirk_skylake_repmov())
+		return;
+
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1858,6 +1907,13 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
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
index 52c633950b38..cec227c25138 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -170,7 +170,10 @@ struct mce_vendor_flags {
 	/* SandyBridge IFU quirk */
 	snb_ifu_quirk		: 1,
 
-	__reserved_0		: 57;
+	/* Skylake, Cascade Lake, Cooper Lake rep movs quirk */
+	skx_repmov_quirk		: 1,
+
+	__reserved_0		: 56;
 };
 
 extern struct mce_vendor_flags mce_flags;
-- 
2.35.1.265.g69c8d7142f-goog

