Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359D12F26
	for <patches@lists.linux.dev>; Mon,  7 Feb 2022 04:36:44 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id q12-20020a17090a2e0c00b001b874772fecso4938602pjd.2
        for <patches@lists.linux.dev>; Sun, 06 Feb 2022 20:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RpgZKv2pVrDwgi45sVAGsLhZHRNIToNQoQwH+0Lvsto=;
        b=XQU5iYcr6a16R873ijABcrJIJQvoY6+ZidyrmpaLJI8ap0nOPS0uAadVqL44nJqbLC
         jVKw3xgZFolPPieidVjP9oGlEZvjKCkEy0OdknkbZXXDEAuhnovmBOT9eV1IGehPbjhr
         Zm0tFnedLEsJWGDqUAk1ejxoUfWkJXD/Y5824olCFtCi53Uo3hmyoMCgTIE5jAq+B1Mr
         k/12Lp8/ihI9TPTsjb+pekgA2S212xjuZQg3g4Fee3RiUi0lhw692l8ikgzMFUI52KU4
         jZC3oIulGrPtlhPzBO8p68/6r1VH9FG4YY/pZJdX1rQRlYLl1AVA//AB/DzD2QZ/LgY2
         EZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RpgZKv2pVrDwgi45sVAGsLhZHRNIToNQoQwH+0Lvsto=;
        b=g1pMGuOif1n/sPHi32scU/XIulSpoKRyItxMG84wEpkJKW+SXvSN0iRy2Gp9+CQktr
         gp/p1xLmHejNBodJZAovfFWJi1hmre2IHg9KNUPRgBYVbyHT8QO2ZWFtLwUT/EYuadja
         ZmM04alXEZvtkDALvpaJsp2/QdNkBvfr3Zn0riXnUDDNP8c4QWtr9r4HPfVgx+l/WMQT
         w8ger9m0xIzc36kf39tC0T0ec43gyEmkpgOjI11XGc1FjpDULUnweAwjILjwCEMDmKu1
         UhJXRgwfbmPS+pLXiPqjOZfShKc3IqQHHyloFpVudv3rwCnRXc61HHnNpgGgUhmCQyNs
         4X8g==
X-Gm-Message-State: AOAM532LZWQjaZo4KERtZBQqSosrjMPmsRKl5epp2GfO6qv0qIFMCZ7C
	V/4M45eoiQHVoSDmBuaykl28nwCS
X-Google-Smtp-Source: ABdhPJw7haqNCja730dbklrD2inGu4ZzhrXi20XTGrD1LNTCyQm4RisEuw91mmTo3UC8p/QzN9zJOSgw
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:786b:6fb0:c021:39be])
 (user=juew job=sendgmr) by 2002:a17:90a:5503:: with SMTP id
 b3mr16550573pji.187.1644208603586; Sun, 06 Feb 2022 20:36:43 -0800 (PST)
Date: Sun,  6 Feb 2022 20:36:40 -0800
Message-Id: <20220207043640.2829295-1-juew@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [RFC] x86/mce: Add workaround for SKX/CLX/CPX spurious machine checks
From: Jue Wang <juew@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"

The fast string copy instructions ("rep movs*") could consume an
uncorrectable memory error in the cache line _right after_ the
desired region to copy and raise an MCE.

Bit 0 of MSR_IA32_MISC_ENABLE can be cleared to disable fast string copy
and will avoid such spurious machine checks. However, that is less
preferable due to the permanent performance impact. Considering memory
poison is rare, it's desirable to keep fast string enabled until an MCE
is seen.

Intel has confirmed the following:
1. The CPU erratum of fast string copy only applies to
SKX/CLX/CPL generations.
2. Directly return from MCE handler will result in complete execution
of the fast string copy (rep movs*) with no data loss or corruption.
3. Directly return from MCE handler will not result in another MCE
firing on the next poisoned cache line due to rep movs*.
4. Directly return from MCE handler will resume execution from a
correct point in code.
5. Directly return from MCE handler due to any other SRAR MCEs will
result in the same instruction that triggered the MCE firing a second
MCE immediately.
6. It's not safe to directly return without disabling the fast string
copy, as the next fast string copy of the same buffer on the same CPU
would result in a PANIC MCE.

The mitigation in this patch should mitigate the erratum completely with
the only caveat that the fast string copy is disabled on the affected
hyper thread thus performance degradation.

This is still better than the OS crashes on MCEs raised on an
irrelevant process due to 'rep movs*' accesses in a kernel context,
e.g., copy_page.

Since a host drain / fail-over usually starts right after the first
MCE is signaled, which results in VM migration or termination, the
performance degradation is a transient effect.

Tested:

Injected errors on 1st cache line of 8 anonymous pages of process
'proc1' and observed MCE consumption from 'proc2' with no panic
(directly returned).

Without the fix, the host panicked within a few minutes on a
random 'proc2' process due to kernel access from copy_page.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kernel/cpu/mce/core.c     | 61 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/internal.h |  5 ++-
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5818b837fd4d..06001e3b2ff2 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -834,6 +834,57 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 	m->cs = regs->cs;
 }
 
+static bool is_intel_srar(u64 mci_status)
+{
+	return (mci_status &
+		(MCI_STATUS_VAL|MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN|
+		 MCI_STATUS_ADDRV|MCI_STATUS_MISCV|MCI_STATUS_PCC|
+		 MCI_STATUS_AR|MCI_STATUS_S)) ==
+		(MCI_STATUS_VAL|MCI_STATUS_UC|MCI_STATUS_EN|MCI_STATUS_ADDRV|
+		 MCI_STATUS_MISCV|MCI_STATUS_AR|MCI_STATUS_S);
+}
+
+/*
+ * Disable fast string copy and return from the MCE handler upon the first SRAR
+ * MCE on bank 1 due to a CPU erratum on Intel SKX/CLX/CPL CPUs.
+ * The fast string copy instructions ("rep movs*") could consume an
+ * uncorrectable memory error in the cache line _right after_ the
+ * desired region to copy and raise an MCE with RIP pointing to the
+ * instruction _after_ the "rep movs*".
+ * This mitigation addresses the issue completely with the caveat of
+ * performance degradation on the CPU affected. This is still better
+ * than the OS crashes on MCEs raised on an irrelevant process due to
+ * 'rep movs*' accesses in a kernel context (e.g., copy_page).
+ * Since a host drain / fail-over usually starts right after the first
+ * MCE is signaled, which results in VM migration or termination, the
+ * performance degradation is a transient effect.
+ *
+ * Returns true when fast string copy on cpu should be disabled.
+ */
+static bool quirk_skylake_repmov(void)
+{
+	/*
+	 * State that represents if an SRAR MCE has already signaled on the DCU bank.
+	 */
+	static DEFINE_PER_CPU(bool, srar_dcu_signaled);
+
+	if (unlikely(!__this_cpu_read(srar_dcu_signaled))) {
+		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
+
+		if (is_intel_srar(mc1_status)) {
+			__this_cpu_write(srar_dcu_signaled, true);
+			msr_clear_bit(MSR_IA32_MISC_ENABLE,
+				      MSR_IA32_MISC_ENABLE_FAST_STRING_BIT);
+			mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
+			mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
+			pr_err("First SRAR MCE on DCU, CPU: %d, disable fast string copy.\n",
+			       smp_processor_id());
+			return true;
+		}
+	}
+	return false;
+}
+
 /*
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
@@ -1403,6 +1454,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	else if (unlikely(!mca_cfg.initialized))
 		return unexpected_machine_check(regs);
 
+	if (mce_flags.skx_repmov_quirk && quirk_skylake_repmov())
+		return;
+
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1858,6 +1912,13 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
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
2.35.0.263.gb82422642f-goog

