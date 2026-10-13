Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBBB4E9C3D;
	Tue, 13 Oct 2026 12:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894048; cv=none; b=XtLZ+dwBg7M9MtYbDpwV66R1SojNRVNfjMKsXml02vCBT0aYsmPKPb0m3d5UfGZyZP1LlftIlXyjr01CyiOwTiJLl6nK8tld6tVj2ZANAtDC+srMSCSaXlI7tkUSHgqG6SZm1sjeQncCqafHNsSBVvE5nRlm23DfnZ8ugOjgFuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894048; c=relaxed/simple;
	bh=4qJmLJAgIEJoB5R1ER9Ylw8hSbk7yCrjJEE4+rlPGkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHxsu8AD50PgmIyGjbhRFd8v4f+5Y9quFsqq5i3GELZIOvsXKaCIyyH6JnRDZTk156vkBcq88O7qTyJxYWzCm9UlUs3l/+KdciUfREI7/2FLJshazXS6wBDz70wiRtH5evQWEc4nohn/0J0Y4MdVKzrbtsXjHkSlEir/IGITfj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUPYE9UC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUPYE9UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAC91F00893;
	Tue, 13 Oct 2026 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894047;
	bh=d6G2T5UWIpZlSPkk5qLzhCJC9lv8odzY2FQm/euQivc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUPYE9UCTLEXqwNmYOpZnml2on6kTfRyYKDD23ZKEmqsrEqxJqMXiYMTVXgvT2Hqe
	 pAHd+bouKqGjuGNLxjLvPrzSXRZtDe41gzvfgTvDnOU6BKnGyrY+BOyXuKqk7MuAMf
	 MS4+X6hRx5mf8RayzRopHBCT9hW8fEu1eqnv7OiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/621] LoongArch: KVM: Get VM PMU capability from HW GCFG register
Date: Tue, 13 Oct 2026 13:36:27 +0200
Message-ID: <20261013112930.145639995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 74087611f0ba7b336dcdde855ffca7d15b2ebe0f ]

Now VM PMU capability comes from host PMU capability directly, instead
bit 23 of HW GCFG CSR register also show PMU capability for VM. It will
be better if it comes from HW GCFG CSR register rather than just host
PMU capability, especially when LVZ feature is emulated in TCG mode, in
which case without PMU capability.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 501514d6ebd2 ("LoongArch: KVM: Validate MSI data before routing it to EIOINTC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/kvm_host.h  |  8 ++++++
 arch/loongarch/include/asm/loongarch.h |  2 ++
 arch/loongarch/kvm/vm.c                | 36 ++++++++++++++++----------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 735396787b147..72ee4cdf5acc6 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -126,6 +126,8 @@ struct kvm_arch {
 	struct kvm_phyid_map  *phyid_map;
 	/* Enabled PV features */
 	unsigned long pv_features;
+	/* Supported KVM features */
+	unsigned long kvm_features;
 
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
@@ -293,6 +295,12 @@ static inline int kvm_get_pmu_num(struct kvm_vcpu_arch *arch)
 	return (arch->cpucfg[6] & CPUCFG6_PMNUM) >> CPUCFG6_PMNUM_SHIFT;
 }
 
+/* Check whether KVM support this feature (VMM may disable it) */
+static inline bool kvm_vm_support(struct kvm_arch *arch, int feature)
+{
+	return !!(arch->kvm_features & BIT_ULL(feature));
+}
+
 bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu);
 
 /* Debug: dump vcpu state */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 3de03cb864b24..58a4a3b6b035d 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -511,6 +511,8 @@
 #define  CSR_GCFG_GPERF_SHIFT		24
 #define  CSR_GCFG_GPERF_WIDTH		3
 #define  CSR_GCFG_GPERF			(_ULCAST_(0x7) << CSR_GCFG_GPERF_SHIFT)
+#define  CSR_GCFG_GPMP_SHIFT		23
+#define  CSR_GCFG_GPMP			(_ULCAST_(0x1) << CSR_GCFG_GPMP_SHIFT)
 #define  CSR_GCFG_GCI_SHIFT		20
 #define  CSR_GCFG_GCI_WIDTH		2
 #define  CSR_GCFG_GCI			(_ULCAST_(0x3) << CSR_GCFG_GCI_SHIFT)
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 890d27e37dde4..99f5d4b7c930e 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_vcpu.h>
+#include <asm/kvm_csr.h>
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
 
@@ -24,6 +25,23 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 					sizeof(kvm_vm_stats_desc),
 };
 
+static void kvm_vm_init_features(struct kvm *kvm)
+{
+	unsigned long val;
+
+	val = read_csr_gcfg();
+	if (val & CSR_GCFG_GPMP)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PMU);
+
+	/* Enable all PV features by default */
+	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
+	kvm->arch.kvm_features = BIT(KVM_LOONGARCH_VM_FEAT_PV_IPI);
+	if (kvm_pvtime_supported()) {
+		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PV_STEALTIME);
+	}
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int i;
@@ -43,11 +61,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.pv_setting_lock);
 
 	kvm_init_vmcs(kvm);
-
-	/* Enable all PV features by default */
-	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
-	if (kvm_pvtime_supported())
-		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+	kvm_vm_init_features(kvm);
 
 	/*
 	 * cpu_vabits means user address space only (a half of total).
@@ -137,18 +151,14 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 		if (cpu_has_lbt_mips)
 			return 0;
 		return -ENXIO;
-	case KVM_LOONGARCH_VM_FEAT_PMU:
-		if (cpu_has_pmp)
+	case KVM_LOONGARCH_VM_FEAT_PTW:
+		if (cpu_has_ptw)
 			return 0;
 		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_PMU:
 	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
-		return 0;
 	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
-		if (kvm_pvtime_supported())
-			return 0;
-		return -ENXIO;
-	case KVM_LOONGARCH_VM_FEAT_PTW:
-		if (cpu_has_ptw)
+		if (kvm_vm_support(&kvm->arch, attr->attr))
 			return 0;
 		return -ENXIO;
 	default:
-- 
2.53.0



