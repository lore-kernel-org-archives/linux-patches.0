Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B0F1F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE758C433C7;
	Fri, 21 Jul 2023 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956652;
	bh=Lsppj9B7rRi8RcMYxdEZAkVs7hoaObgXzOSktSXciLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOI33lmUF/nBjEgf+oFNDXDbBz0VcE1x190nCAVNpKZrbwiKGNAZiqQG0ICFXTesc
	 V5Ks+agTEKbtGtbpk7M17d5pwCn+r+ey7ONm95TbSPnddRnkscVLD+wsKmEllogjnK
	 3P1Gor06sfRRxbSlYMlmNzrRu7FtoyJPo9aZsrtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.4 225/292] arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2
Date: Fri, 21 Jul 2023 18:05:34 +0200
Message-ID: <20230721160538.533809070@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

commit 6df696cd9bc1ceed0e92e36908f88bbd16d18255 upstream.

AmpereOne has an erratum in its implementation of FEAT_HAFDBS that
required disabling the feature on the design. This was done by reporting
the feature as not implemented in the ID register, although the
corresponding control bits were not actually RES0. This does not align
well with the requirements of the architecture, which mandates these
bits be RES0 if HAFDBS isn't implemented.

The kernel's use of stage-1 is unaffected, as the HA and HD bits are
only set if HAFDBS is detected in the ID register. KVM, on the other
hand, relies on the RES0 behavior at stage-2 to use the same value for
VTCR_EL2 on any cpu in the system. Mitigate the non-RES0 behavior by
leaving VTCR_EL2.HA clear on affected systems.

Cc: stable@vger.kernel.org
Cc: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Darren Hart <darren@os.amperecomputing.com>
Acked-by: D Scott Phillips <scott@os.amperecomputing.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20230609220104.1836988-2-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    3 +++
 arch/arm64/Kconfig                     |   19 +++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |    7 +++++++
 arch/arm64/kvm/hyp/pgtable.c           |   14 +++++++++++---
 arch/arm64/tools/cpucaps               |    1 +
 5 files changed, 41 insertions(+), 3 deletions(-)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -52,6 +52,9 @@ stable kernels.
 | Allwinner      | A64/R18         | UNKNOWN1        | SUN50I_ERRATUM_UNKNOWN1     |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2064142        | ARM64_ERRATUM_2064142       |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -407,6 +407,25 @@ menu "Kernel Features"
 
 menu "ARM errata workarounds via the alternatives framework"
 
+config AMPERE_ERRATUM_AC03_CPU_38
+        bool "AmpereOne: AC03_CPU_38: Certain bits in the Virtualization Translation Control Register and Translation Control Registers do not follow RES0 semantics"
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  erratum AC03_CPU_38 on AmpereOne.
+
+	  The affected design reports FEAT_HAFDBS as not implemented in
+	  ID_AA64MMFR1_EL1.HAFDBS, but (V)TCR_ELx.{HA,HD} are not RES0
+	  as required by the architecture. The unadvertised HAFDBS
+	  implementation suffers from an additional erratum where hardware
+	  A/D updates can occur after a PTE has been marked invalid.
+
+	  The workaround forces KVM to explicitly set VTCR_EL2.HA to 0,
+	  which avoids enabling unadvertised hardware Access Flag management
+	  at stage-2.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -730,6 +730,13 @@ const struct arm64_cpu_capabilities arm6
 		.cpu_enable = cpu_clear_bf16_from_user_emulation,
 	},
 #endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
+	{
+		.desc = "AmpereOne erratum AC03_CPU_38",
+		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	},
+#endif
 	{
 	}
 };
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -623,10 +623,18 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u
 #ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
-	 * on all CPUs. The features is RES0 on CPUs without the support
-	 * and must be ignored by the CPUs.
+	 * on all CPUs. In systems that have asymmetric support for the feature
+	 * this allows KVM to leverage hardware support on the subset of cores
+	 * that implement the feature.
+	 *
+	 * The architecture requires VTCR_EL2.HA to be RES0 (thus ignored by
+	 * hardware) on implementations that do not advertise support for the
+	 * feature. As such, setting HA unconditionally is safe, unless you
+	 * happen to be running on a design that has unadvertised support for
+	 * HAFDBS. Here be dragons.
 	 */
-	vtcr |= VTCR_EL2_HA;
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		vtcr |= VTCR_EL2_HA;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -77,6 +77,7 @@ WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
+WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE


