Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3283F23DB;
	Fri,  4 Sep 2026 05:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499496; cv=none; b=GJDgaA56BMfGMWFuC2RGLmXsmwl5SmLTrYQkTOnOVVxodP3CRX/qelfQ+3wxclOb67c4ekhgBfwlVZoZH0ys1ZWg/qSYRIteNYJ9rw7lK+c2hG9FG8davEhmdcnLkhj2GRHXb5Q0Djm2V6SGDoFa6yb86OdY4X+sDOaiSCc44B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499496; c=relaxed/simple;
	bh=nl8ZwAfvBgjmes+GtFAHbJjWIrW1rE7GlD4NpwRK3XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgLT6iiiN3EVaOTrvMlLW4CKx3qCyGaIRknA7cSHM1WlcjvAYLNmUctHUkTE8CIk8R1wI/uMHoia35s8dfahBQmz72InxmK14vIJEYcFHQd+GhWHeeEnkaHGMaT9BgyLxGWq+YUokc5x4gPr7pi7blGozJz6E4Wwq3DlA2JxyxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhuF/5E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhuF/5E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE201F00A3D;
	Fri,  4 Sep 2026 05:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499493;
	bh=hN9X1SQM8cWKSYyDKqjS60zjj/CRPaHhLpobX2bsPrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhuF/5E4QI7Rv+uBEc/jW6egsETVZ5u+epVuRQhbf+QFWn4MCrR5dEUBC7iAxMvel
	 XU597lqOHnri399kqbg3j1tvGMzue8yhMnIqm4Dm88NsHhbC2f0cUqJqS0X5RkjA6Y
	 ObZQ10Nzlf298AZpo/DWx04JE/WYdUWxGcjRFoLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveed Khan <naveed@digiscrypt.com>,
	Guidong Han <2045gemini@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.2 436/713] RISC-V: KVM: Fix PMU event info array size overflow
Date: Fri,  4 Sep 2026 06:56:44 +0200
Message-ID: <20260904045813.604524272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guidong Han <2045gemini@gmail.com>

commit 735bc20c24187ca419c9d5e63860a54b91be34bd upstream.

SBI PMU EVENT_GET_INFO stores guest-controlled num_events * sizeof(*einfo)
in a 32-bit integer. On RV64, num_events = 0x10000001 makes 0x100000010
truncate to 16. KVM then allocates one entry but loops over the original
num_events, causing out-of-bounds reads and writes. A nested guest
triggered:

BUG: KASAN: slab-out-of-bounds in kvm_riscv_vcpu_pmu_event_info+0xa4/0x142
Read of size 4 at addr ff600000074d46b0 by task init/1
Call Trace:
[<ffffffff8006471c>] kvm_riscv_vcpu_pmu_event_info+0xa4/0x142
[<ffffffff800690c0>] kvm_sbi_ext_pmu_handler+0xca/0x268
[<ffffffff8006779e>] kvm_riscv_vcpu_sbi_ecall+0xec/0x1e6
[<ffffffff8006008c>] kvm_riscv_vcpu_exit+0x48c/0x540
[<ffffffff8005ea0a>] kvm_arch_vcpu_ioctl_run+0x37e/0xc80
Allocated by task 1:
 __kmalloc_noprof+0x19e/0x4b0
 kvm_riscv_vcpu_pmu_event_info+0x72/0x142
 kvm_sbi_ext_pmu_handler+0xca/0x268
 kvm_riscv_vcpu_sbi_ecall+0xec/0x1e6
 kvm_riscv_vcpu_exit+0x48c/0x540
 kvm_arch_vcpu_ioctl_run+0x37e/0xc80
The buggy address is located 0 bytes to the right of
 allocated 16-byte region [ff600000074d46a0, ff600000074d46b0)

Store the shared-memory size in size_t and reject multiplication overflow.
Allocate the guest-driven array with GFP_KERNEL_ACCOUNT so it is charged
to kmemcg, and use __GFP_NOWARN to suppress allocation failure warnings.
Use kvcalloc() to allow vmalloc fallback and an unsigned long loop index
to match num_events.

Reported-by: Naveed Khan <naveed@digiscrypt.com>
Closes: https://lore.kernel.org/kvm/178345245327.72065.13249716450708539854@digiscrypt.com/
Fixes: e309fd113b9f ("RISC-V: KVM: Implement get event info function")
Cc: stable@vger.kernel.org
Signed-off-by: Guidong Han <2045gemini@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260730092533.1369531-1-2045gemini@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_pmu.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -12,7 +12,9 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/nospec.h>
+#include <linux/overflow.h>
 #include <linux/perf/riscv_pmu.h>
+#include <linux/slab.h>
 #include <asm/csr.h>
 #include <asm/kvm_isa.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -479,13 +481,14 @@ int kvm_riscv_vcpu_pmu_event_info(struct
 				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata)
 {
 	struct riscv_pmu_event_info *einfo = NULL;
-	int shmem_size = num_events * sizeof(*einfo);
+	size_t shmem_size;
 	gpa_t shmem;
 	u32 eidx, etype;
 	u64 econfig;
 	int ret;
 
-	if (flags != 0 || (saddr_low & (SZ_16 - 1) || num_events == 0)) {
+	if (flags != 0 || (saddr_low & (SZ_16 - 1)) || num_events == 0 ||
+	    check_mul_overflow(num_events, sizeof(*einfo), &shmem_size)) {
 		ret = SBI_ERR_INVALID_PARAM;
 		goto out;
 	}
@@ -500,7 +503,8 @@ int kvm_riscv_vcpu_pmu_event_info(struct
 		}
 	}
 
-	einfo = kzalloc(shmem_size, GFP_KERNEL);
+	einfo = kvcalloc(num_events, sizeof(*einfo),
+			 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!einfo) {
 		ret = SBI_ERR_FAILURE;
 		goto out;
@@ -512,7 +516,7 @@ int kvm_riscv_vcpu_pmu_event_info(struct
 		goto free_mem;
 	}
 
-	for (int i = 0; i < num_events; i++) {
+	for (unsigned long i = 0; i < num_events; i++) {
 		eidx = einfo[i].event_idx;
 		etype = kvm_pmu_get_perf_event_type(eidx);
 		econfig = kvm_pmu_get_perf_event_config(eidx, einfo[i].event_data);
@@ -525,7 +529,7 @@ int kvm_riscv_vcpu_pmu_event_info(struct
 		ret = SBI_ERR_INVALID_ADDRESS;
 
 free_mem:
-	kfree(einfo);
+	kvfree(einfo);
 out:
 	retdata->err_val = ret;
 


