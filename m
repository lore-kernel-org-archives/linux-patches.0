Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F417990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1jxdkiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DCBC433C8;
	Mon,  9 Oct 2023 13:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856981;
	bh=BiRexuPBJw/dTkF7wf34NxVxQ4X3pLUus7mNtc7zD/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1jxdkiP9idq/TzEuODFJB38RwaXpsdbw6l65rOC7VycDTYqXhEeSkHoy/1ZO/5zi
	 RxYW02aQ0eUvE9+4LluTtAT393Dip06yY+TZXWzoDUZbrNibqxTaVqiqlxuonVHch4
	 fBjPn8Qh1sNvn7mnsdMtJm2iqobKfdVHQMEzVUO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.5 055/163] arm64: errata: Add Cortex-A520 speculative unprivileged load workaround
Date: Mon,  9 Oct 2023 15:00:19 +0200
Message-ID: <20231009130125.554921054@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

commit 471470bc7052d28ce125901877dd10e4c048e513 upstream.

Implement the workaround for ARM Cortex-A520 erratum 2966298. On an
affected Cortex-A520 core, a speculatively executed unprivileged load
might leak data from a privileged load via a cache side channel. The
issue only exists for loads within a translation regime with the same
translation (e.g. same ASID and VMID). Therefore, the issue only affects
the return to EL0.

The workaround is to execute a TLBI before returning to EL0 after all
loads of privileged data. A non-shareable TLBI to any address is
sufficient.

The workaround isn't necessary if page table isolation (KPTI) is
enabled, but for simplicity it will be. Page table isolation should
normally be disabled for Cortex-A520 as it supports the CSV3 feature
and the E0PD feature (used when KASLR is enabled).

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230921194156.1050055-2-robh@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                          |   13 +++++++++++++
 arch/arm64/kernel/cpu_errata.c              |    8 ++++++++
 arch/arm64/kernel/entry.S                   |    4 ++++
 arch/arm64/tools/cpucaps                    |    1 +
 5 files changed, 28 insertions(+)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -63,6 +63,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #1902691        | ARM64_ERRATUM_1902691       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A520     | #2966298        | ARM64_ERRATUM_2966298       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319        |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1038,6 +1038,19 @@ config ARM64_ERRATUM_2645198
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2966298
+	bool "Cortex-A520: 2966298: workaround for speculatively executed unprivileged load"
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A520 erratum 2966298.
+
+	  On an affected Cortex-A520 core, a speculatively executed unprivileged
+	  load might leak data from a privileged level via a cache side channel.
+
+	  Work around this problem by executing a TLBI before returning to EL0.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -730,6 +730,14 @@ const struct arm64_cpu_capabilities arm6
 		.cpu_enable = cpu_clear_bf16_from_user_emulation,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2966298
+	{
+		.desc = "ARM erratum 2966298",
+		.capability = ARM64_WORKAROUND_2966298,
+		/* Cortex-A520 r0p0 - r0p1 */
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A520, 0, 0, 1),
+	},
+#endif
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 	{
 		.desc = "AmpereOne erratum AC03_CPU_38",
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -428,6 +428,10 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
+alternative_if ARM64_WORKAROUND_2966298
+	tlbi	vale1, xzr
+	dsb	nsh
+alternative_else_nop_endif
 alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
 	ldr	lr, [sp, #S_LR]
 	add	sp, sp, #PT_REGS_SIZE		// restore sp
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -83,6 +83,7 @@ WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
+WORKAROUND_2966298
 WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE


