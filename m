Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C411CAD
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wooAowZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66104C433C8;
	Mon,  9 Oct 2023 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857518;
	bh=sdSw9Cl2tEce3cntvCtRAoH76cX4DV1REmKRucgzlOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wooAowZ8fhk4SkU1LNxZBcu/i6SHqRu5TTbWcd2aIMPLgZGW7Pi76LlZR5SWIDmMU
	 jXYo2j9C00i+hWgFrnC7MaEYMjyjCvgfZO5Ih7pt5QbVm2SFvhuYST5dKJ9oBLuIkx
	 WdbP+EHnBKRnTW/nZIt4rc3ZVa+A5uWb4FYsBMrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 071/162] arm64: errata: Add Cortex-A520 speculative unprivileged load workaround
Date: Mon,  9 Oct 2023 15:00:52 +0200
Message-ID: <20231009130124.883125091@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |   13 +++++++++++++
 arch/arm64/kernel/cpu_errata.c         |    8 ++++++++
 arch/arm64/kernel/entry.S              |    4 ++++
 arch/arm64/tools/cpucaps               |    1 +
 5 files changed, 28 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
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
@@ -983,6 +983,19 @@ config ARM64_ERRATUM_2457168
 
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
@@ -723,6 +723,14 @@ const struct arm64_cpu_capabilities arm6
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
@@ -419,6 +419,10 @@ alternative_else_nop_endif
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
@@ -71,6 +71,7 @@ WORKAROUND_2064142
 WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2658417
+WORKAROUND_2966298
 WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE


