Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA14F5E04;
	Tue, 13 Oct 2026 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893867; cv=none; b=Pf4Z54MRtLEV+5k6CvJRdtlwBC9etqRkOgILrFZxfQf7i4FG2YTq17WOCYkf4E+WS/cfMtRsjSEzmLtuhcD3QugktcWrsQQcWFtqzAqUdICDLlOMHuHAZBpCc9oe0BILWiR7gAQD6qcGVIk2CNmik9H/DC0+/7fd0sgte/2pzcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893867; c=relaxed/simple;
	bh=6VIAFMoXPlx8u6HlX2Hiuz9JXkUCCQEVyutgoSgRM28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXnrVm5+augdH5vNwdjsGo6PgiLwIQjod0EkTbHLddFFoN07a2MCNCc2Qz500CJeCdLR70enDwOE9rX8/d44dCCX6dMTn4rPga9d6db9JGhoaqAdHDU2FLXY8ZXvtInZYqzTWbCdrK3LAHydAMvhb05WEKR46Puk/I1xJ9YzsY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evxc688W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evxc688W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161D61F000FF;
	Tue, 13 Oct 2026 12:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893866;
	bh=E7zl0a/6YboH0XgDGgPEg8tGZ7TNN8f7H95dPt1i6A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evxc688W9n4eQks7I+sQ32fUzGWo66672F0UxZ2NPOOtjzqU78atxA6DkBossuFvs
	 QGW8AaGBGBih6xQHIItfAyXGeVqLh4ddX7LEfBnDpUAw7ZWjE42jhCVQ/7/Q9Rsez4
	 BycUpgT/2dDa9bibxN7zszmEgqJLa9PXAbTj/Kgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	Lukas Gerlach <lukas.gerlach@cispa.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/621] KVM: riscv: Fix Spectre-v1 in PMU counter access
Date: Tue, 13 Oct 2026 13:36:04 +0200
Message-ID: <20261013112929.606714055@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Gerlach <lukas.gerlach@cispa.de>

[ Upstream commit 2dda6a9e09ee4f3c30ea72ba949a6ea781205e3a ]

Guest-controlled counter indices received via SBI ecalls are used to
index into the PMC array. Sanitize them with array_index_nospec()
to prevent speculative out-of-bounds access.

Similar to x86 commit 13c5183a4e64 ("KVM: x86: Protect MSR-based
index computations in pmu.h from Spectre-v1/L1TF attacks").

Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
Reviewed-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
Link: https://lore.kernel.org/r/20260303-kvm-riscv-spectre-v1-v2-4-192caab8e0dc@cispa.de
Signed-off-by: Anup Patel <anup@brainfault.org>
Stable-dep-of: 735bc20c2418 ("RISC-V: KVM: Fix PMU event info array size overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index b374d92c9aa63..b0e585a60e0ea 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
 #include <linux/perf/riscv_pmu.h>
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -87,7 +88,8 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 
 static u64 kvm_pmu_get_perf_event_hw_config(u32 sbi_event_code)
 {
-	return hw_event_perf_map[sbi_event_code];
+	return hw_event_perf_map[array_index_nospec(sbi_event_code,
+						    SBI_PMU_HW_GENERAL_MAX)];
 }
 
 static u64 kvm_pmu_get_perf_event_cache_config(u32 sbi_event_code)
@@ -218,6 +220,7 @@ static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type != SBI_PMU_CTR_TYPE_FW)
@@ -244,6 +247,7 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return -EINVAL;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
@@ -533,6 +537,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 		return 0;
 	}
 
+	cidx = array_index_nospec(cidx, RISCV_KVM_MAX_COUNTERS);
 	retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
 
 	return 0;
@@ -567,7 +572,8 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	}
 	/* Start the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index = i + ctr_base;
+		pmc_index = array_index_nospec(i + ctr_base,
+					       RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		/* The guest started the counter again. Reset the overflow status */
@@ -637,7 +643,8 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 
 	/* Stop the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
-		pmc_index = i + ctr_base;
+		pmc_index = array_index_nospec(i + ctr_base,
+					       RISCV_KVM_MAX_COUNTERS);
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		pmc = &kvpmu->pmc[pmc_index];
@@ -769,6 +776,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		}
 	}
 
+	ctr_idx = array_index_nospec(ctr_idx, RISCV_KVM_MAX_COUNTERS);
 	pmc = &kvpmu->pmc[ctr_idx];
 	pmc->idx = ctr_idx;
 
-- 
2.53.0



