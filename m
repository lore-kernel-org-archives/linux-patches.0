Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDC53D74
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 12:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB8C433D6;
	Mon, 21 Nov 2022 12:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669034698;
	bh=Dz58t9g+8f6ve7iRQR+QJr9INc/CbGm6k7ibtIAQZtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqjHJVmOtO1gCa9UsiVPFDMdyf61+P6oWgSMVvvXEcyQbmiTd/7MWwCq8Xq0dqZsK
	 rLDUNd0b4KQzLPv71gcnziDrRkV6urfehb1C5ByI6d52MtSoLZI2lyFkLzU63mhMox
	 yD4ppFSHrqDZzWsVDA0cdoWPczAbjW+Ae3lAXecc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	eranian@google.com,
	Ingo Molnar <mingo@kernel.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4.19 03/34] x86/cpufeature: Add facility to check for min microcode revisions
Date: Mon, 21 Nov 2022 13:43:25 +0100
Message-Id: <20221121124151.000522553@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

For bug workarounds or checks, it is useful to check for specific
microcode revisions.

Add a new generic function to match the CPU with stepping.
Add the other function to check the min microcode revisions for
the matched CPU.

A new table format is introduced to facilitate the quirk to
fill the related information.

This does not change the existing x86_cpu_id because it's an ABI
shared with modules, and also has quite different requirements,
as in no wildcards, but everything has to be matched exactly.

Originally-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com
Link: https://lkml.kernel.org/r/1549319013-4522-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c          |   31 +++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -11,4 +11,32 @@
 
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 
+/*
+ * Match specific microcode revisions.
+ *
+ * vendor/family/model/stepping must be all set.
+ *
+ * Only checks against the boot CPU.  When mixed-stepping configs are
+ * valid for a CPU model, add a quirk for every valid stepping and
+ * do the fine-tuning in the quirk handler.
+ */
+
+struct x86_cpu_desc {
+	__u8	x86_family;
+	__u8	x86_vendor;
+	__u8	x86_model;
+	__u8	x86_stepping;
+	__u32	x86_microcode_rev;
+};
+
+#define INTEL_CPU_DESC(mod, step, rev) {			\
+	.x86_family = 6,					\
+	.x86_vendor = X86_VENDOR_INTEL,				\
+	.x86_model = mod,					\
+	.x86_stepping = step,					\
+	.x86_microcode_rev = rev,				\
+}
+
+extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
+
 #endif
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -48,3 +48,34 @@ const struct x86_cpu_id *x86_match_cpu(c
 	return NULL;
 }
 EXPORT_SYMBOL(x86_match_cpu);
+
+static const struct x86_cpu_desc *
+x86_match_cpu_with_stepping(const struct x86_cpu_desc *match)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	const struct x86_cpu_desc *m;
+
+	for (m = match; m->x86_family | m->x86_model; m++) {
+		if (c->x86_vendor != m->x86_vendor)
+			continue;
+		if (c->x86 != m->x86_family)
+			continue;
+		if (c->x86_model != m->x86_model)
+			continue;
+		if (c->x86_stepping != m->x86_stepping)
+			continue;
+		return m;
+	}
+	return NULL;
+}
+
+bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table)
+{
+	const struct x86_cpu_desc *res = x86_match_cpu_with_stepping(table);
+
+	if (!res || res->x86_microcode_rev > boot_cpu_data.microcode)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(x86_cpu_has_min_microcode_rev);


