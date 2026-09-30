Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949CB4E73B2;
	Wed, 30 Sep 2026 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789001; cv=none; b=BoAmgE7pazYngwMpOvTnLbZ3jWb5R3TcV8oocOO6xOdZmyLeK5vpjPtAOE8i35ObqrT2RKaXHVbhdlV+mWK7/F20XFkQnEUMOT3P60asD2X8x7jl+Nyx+BlnC0/dttH2ZcZvdHOCiioQIy2RS81RB1llJRGCAHv5ExeK0sTLWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789001; c=relaxed/simple;
	bh=9IsXayu4Ql1Fhw2A50fUF5Pi28OIL5eMMLUm6Vfnod4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/lu6IfRnE2VjFshjy5DO7SyZwPoOfT1In+uFMehXpFw+N0s1wcHy+qzZ+AYCln2Lzw54AgZWWH4UKRAJTl4FDYagSDLd1nHdKI/+pqoeeZt1BuQZ70CXk21bW0nlw2d3S3+JCouAU2lD+FcBvNN04zVPVMFNYJcPdEAhZH5et8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTNxoJwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTNxoJwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520A1F000FF;
	Wed, 30 Sep 2026 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788999;
	bh=4z5Bcj1zUdkNG9KVyvWUVu/DEnFbksHcV/H1ldmCSko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTNxoJwVwJri6NPjUDWuAnv/qlVjGzdBQNNEM0O+c5Gn/EMRf+xW77FGlgLwespoF
	 7MB2SycguhsQRJAVKBZnlrRQqRzL+EkELj4WFleQFUwrZeXol+yhplK6y/5RheWGVS
	 CbvTpFZQu9DAZQ3of0TcUFUjx0Cyp2B1YqsQc4C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/877] RISC-V: KVM: Fix perf-backed counter accounting across stop and read
Date: Wed, 30 Sep 2026 17:20:34 +0200
Message-ID: <20260930152421.655665400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

[ Upstream commit c7e2cc38c56142cdab25e6f73602a8222bf9479b ]

pmu_ctr_read() adds the event count returned by perf_event_read_value()
to counter_val, which can accumulate the same count repeatedly across
reads. kvm_riscv_vcpu_pmu_ctr_stop() also leaves counter_val stale by
not folding the current event count into it.

Make reads of perf-backed counters side-effect free, and use
perf_event_pause() when stopping a counter to fold the current event
count into counter_val while resetting it. This preserves the counter
value across stop/start and lets the snapshot path use counter_val
directly.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260825083719.643970-4-suunj1331@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 468e58f152153..147fc0d107ca9 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -245,12 +245,13 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
 		fevent_code = get_event_code(pmc->event_idx);
 		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+		*out_val = pmc->counter_val;
 	} else if (pmc->perf_event) {
-		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
+		*out_val = pmc->counter_val +
+			   perf_event_read_value(pmc->perf_event, &enabled, &running);
 	} else {
 		return -EINVAL;
 	}
-	*out_val = pmc->counter_val;
 
 	return 0;
 }
@@ -561,7 +562,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 	bool snap_flag_set = flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
@@ -598,8 +598,11 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 			}
 		} else if (pmc->perf_event) {
 			if (pmc->started) {
-				/* Stop counting the counter */
-				perf_event_disable(pmc->perf_event);
+				/*
+				 * Stop the counter and fold the live count into counter_val.
+				 * Reset the event value to avoid redundant accumulation.
+				 */
+				pmc->counter_val += perf_event_pause(pmc->perf_event, true);
 				pmc->started = false;
 			} else {
 				sbiret = SBI_ERR_ALREADY_STOPPED;
@@ -613,9 +616,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		}
 
 		if (snap_flag_set && !sbiret) {
-			if (pmc->perf_event)
-				pmc->counter_val += perf_event_read_value(pmc->perf_event,
-									  &enabled, &running);
 			/*
 			 * The counter and overflow indicies in the snapshot region are w.r.to
 			 * cbase. Modify the set bit in the counter mask instead of the pmc_index
-- 
2.53.0



