Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726514B075;
	Wed,  5 Mar 2025 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197864; cv=none; b=J7Mvg84IjQm0QpDQo7cKKMYIWwEYkAzYcRfhzR5TPZeqvD4kHjgg/BFLP1XTOQokox+JFnbfhXLnGRqnFslFIpirPkdUcgdaFNOLGrG+A+mW5E/R4bm/jhD3ajqO94Myd3jxYF/8+yA8WIhG7ZbSzG1dSGd5nAmG5GlnQ8tAUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197864; c=relaxed/simple;
	bh=zNf69GeX7A7mFS0BU3jb/Ssxhd/cr18gKMA5nkdpmMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGNemnFQvDiL0W2X34H4OQqGDS/aakY9P11ftoj3/oN8YKv3Cn0BHezZ98oEH/nz3lA+Ghiz4uTWeutd7w5VNgkVwfg5Cy+B0RbxaJ9PVail4xm2rcuLs6pVLn26yrpt369YXaOmtkO87csoDisQSqG0LSiiZyqt6GhqjlcDQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIiJ5eKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIiJ5eKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEC3C4CED1;
	Wed,  5 Mar 2025 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197864;
	bh=zNf69GeX7A7mFS0BU3jb/Ssxhd/cr18gKMA5nkdpmMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIiJ5eKm4jaYd2Upf6BhmfaIWchSntzLqEHuctgrF/rub4mPtDSVk8E1OzGwvbs/t
	 x3J27VIzYoJCSlbOE++TqwSh1n1421G46A8ASAGIrQ1065vfrfC/bUzfINobFww12Z
	 wcj76LEVCzpR8ddnHwXu99dq1yAvof+GoEgu8hIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 126/142] x86/apic: Provide apic_force_nmi_on_cpu()
Date: Wed,  5 Mar 2025 18:49:05 +0100
Message-ID: <20250305174505.392576515@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9cab5fb776d4367e26950cf759211e948335288e upstream

When SMT siblings are soft-offlined and parked in one of the play_dead()
variants they still react on NMI, which is problematic on affected Intel
CPUs. The default play_dead() variant uses MWAIT on modern CPUs, which is
not guaranteed to be safe when updated concurrently.

Right now late loading is prevented when not all SMT siblings are online,
but as they still react on NMI, it is possible to bring them out of their
park position into a trivial rendezvous handler.

Provide a function which allows to do that. I does sanity checks whether
the target is in the cpus_booted_once_mask and whether the APIC driver
supports it.

Mark X2APIC and XAPIC as capable, but exclude 32bit and the UV and NUMACHIP
variants as that needs feedback from the relevant experts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115903.603100036@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/apic.h           |    5 ++++-
 arch/x86/kernel/apic/apic_flat_64.c   |    2 ++
 arch/x86/kernel/apic/ipi.c            |    8 ++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |    1 +
 arch/x86/kernel/apic/x2apic_phys.c    |    1 +
 5 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -277,7 +277,8 @@ struct apic {
 
 	u32	disable_esr		: 1,
 		dest_mode_logical	: 1,
-		x2apic_set_max_apicid	: 1;
+		x2apic_set_max_apicid	: 1,
+		nmi_to_offline_cpu	: 1;
 
 	u32	(*calc_dest_apicid)(unsigned int cpu);
 
@@ -543,6 +544,8 @@ extern bool default_check_apicid_used(ph
 extern void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap);
 extern int default_cpu_present_to_apicid(int mps_cpu);
 
+void apic_send_nmi_to_offline_cpu(unsigned int cpu);
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline unsigned int read_apic_id(void) { return 0; }
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -103,6 +103,7 @@ static struct apic apic_flat __ro_after_
 	.send_IPI_allbutself		= default_send_IPI_allbutself,
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
+	.nmi_to_offline_cpu		= true,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
@@ -175,6 +176,7 @@ static struct apic apic_physflat __ro_af
 	.send_IPI_allbutself		= default_send_IPI_allbutself,
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
+	.nmi_to_offline_cpu		= true,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -97,6 +97,14 @@ sendmask:
 	__apic_send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 }
 
+void apic_send_nmi_to_offline_cpu(unsigned int cpu)
+{
+	if (WARN_ON_ONCE(!apic->nmi_to_offline_cpu))
+		return;
+	if (WARN_ON_ONCE(!cpumask_test_cpu(cpu, &cpus_booted_once_mask)))
+		return;
+	apic->send_IPI(cpu, NMI_VECTOR);
+}
 #endif /* CONFIG_SMP */
 
 static inline int __prepare_ICR2(unsigned int mask)
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -251,6 +251,7 @@ static struct apic apic_x2apic_cluster _
 	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
+	.nmi_to_offline_cpu		= true,
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -166,6 +166,7 @@ static struct apic apic_x2apic_phys __ro
 	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
+	.nmi_to_offline_cpu		= true,
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,


