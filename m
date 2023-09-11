Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3797EC433C7;
	Mon, 11 Sep 2023 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446069;
	bh=qkVDtVl449FAfVDiF7Smp49HHCbYihgdU9DIFGaVUiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3wQhp7VJPll4I/l8RU9R0+/EE+0GVucK0wauOAPrtRbdDT4JIo1iOp59QbsBP10n
	 wj5eB76CF6ivPDqLRlkhH1yGachyfyCr9vD0JeHdVQ3kFlTY3OVCvDnQtEXC3A6yu0
	 oWz13td7VKKIGhz8MoyUru8gTHCrtMO0divZ/E0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 570/600] x86/MCE: Always save CS register on AMD Zen IF Poison errors
Date: Mon, 11 Sep 2023 15:50:03 +0200
Message-ID: <20230911134650.435453928@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 4240e2ebe67941ce2c4f5c866c3af4b5ac7a0c67 upstream.

The Instruction Fetch (IF) units on current AMD Zen-based systems do not
guarantee a synchronous #MC is delivered for poison consumption errors.
Therefore, MCG_STATUS[EIPV|RIPV] will not be set. However, the
microarchitecture does guarantee that the exception is delivered within
the same context. In other words, the exact rIP is not known, but the
context is known to not have changed.

There is no architecturally-defined method to determine this behavior.

The Code Segment (CS) register is always valid on such IF unit poison
errors regardless of the value of MCG_STATUS[EIPV|RIPV].

Add a quirk to save the CS register for poison consumption from the IF
unit banks.

This is needed to properly determine the context of the error.
Otherwise, the severity grading function will assume the context is
IN_KERNEL due to the m->cs value being 0 (the initialized value). This
leads to unnecessary kernel panics on data poison errors due to the
kernel believing the poison consumption occurred in kernel context.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230814200853.29258-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c     |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/internal.h |    5 ++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -857,6 +857,26 @@ static noinstr bool quirk_skylake_repmov
 }
 
 /*
+ * Some Zen-based Instruction Fetch Units set EIPV=RIPV=0 on poison consumption
+ * errors. This means mce_gather_info() will not save the "ip" and "cs" registers.
+ *
+ * However, the context is still valid, so save the "cs" register for later use.
+ *
+ * The "ip" register is truly unknown, so don't save it or fixup EIPV/RIPV.
+ *
+ * The Instruction Fetch Unit is at MCA bank 1 for all affected systems.
+ */
+static __always_inline void quirk_zen_ifu(int bank, struct mce *m, struct pt_regs *regs)
+{
+	if (bank != 1)
+		return;
+	if (!(m->status & MCI_STATUS_POISON))
+		return;
+
+	m->cs = regs->cs;
+}
+
+/*
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
  */
@@ -875,6 +895,9 @@ static __always_inline int mce_no_way_ou
 		if (mce_flags.snb_ifu_quirk)
 			quirk_sandybridge_ifu(i, m, regs);
 
+		if (mce_flags.zen_ifu_quirk)
+			quirk_zen_ifu(i, m, regs);
+
 		m->bank = i;
 		if (mce_severity(m, regs, &tmp, true) >= MCE_PANIC_SEVERITY) {
 			mce_read_aux(m, i);
@@ -1852,6 +1875,9 @@ static int __mcheck_cpu_apply_quirks(str
 		if (c->x86 == 0x15 && c->x86_model <= 0xf)
 			mce_flags.overflow_recov = 1;
 
+		if (c->x86 >= 0x17 && c->x86 <= 0x1A)
+			mce_flags.zen_ifu_quirk = 1;
+
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -157,6 +157,9 @@ struct mce_vendor_flags {
 	 */
 	smca			: 1,
 
+	/* Zen IFU quirk */
+	zen_ifu_quirk		: 1,
+
 	/* AMD-style error thresholding banks present. */
 	amd_threshold		: 1,
 
@@ -172,7 +175,7 @@ struct mce_vendor_flags {
 	/* Skylake, Cascade Lake, Cooper Lake REP;MOVS* quirk */
 	skx_repmov_quirk	: 1,
 
-	__reserved_0		: 56;
+	__reserved_0		: 55;
 };
 
 extern struct mce_vendor_flags mce_flags;


