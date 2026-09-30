Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE47C50E5BC;
	Wed, 30 Sep 2026 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786900; cv=none; b=GIyXUeO6Lceb3cYgFGPkIRTrHA5byJVaALrECG9ZXOtLojB5973/4ASPm9YJEv8VOZnLmi0AxeEYskfbjn+m9onARskh1moS2FtYguXNppstoJSOJuOsO1SMfOd5qVqvK8SrqjJ8UmP53S5OMXDfKnU4khCeLndNKtp6zUfN0+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786900; c=relaxed/simple;
	bh=jgnXfxBkeCbiO2PgiLRIwaTMWGFt1UHACH6mUCLeKCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHRWhwuCywk0azvdxgq+pazreiJwetwk0E0jmFxPrPqaFnwKyxceWfxP/0gJ1UBzo9pjhTHlZcVAGNI0+BR0G5fW1ma3CZVNZ7+P3BBaaqHLUNJE6Zj5eoRoY1WsZnSCMdZWWaDTemp47o9p7uyvc5rL8jEIPcBzG4CTxFoJ/YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TSoD2Jw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TSoD2Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0DE1F000FF;
	Wed, 30 Sep 2026 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786898;
	bh=nCvm2/u48IjgccvRmODR1oI3AZRQSVDJ7pNTzOKbkyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TSoD2JwLGjYjxlhjmbjW/p0Dp+0HHSsnlpss1CJs6Axs4vGfuoKd3avbB6RjT8RQ
	 20yfqq6yI1c3EGiUWaZmZI+e9FQeClW62X/VOSJSUj3/WQ0ymrrCamLlu+CQUPiD0T
	 W8LAj+6BFgUBxBvtE+ADt6T/5QcF0HVNkvUmd+K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 040/457] RISC-V: KVM: Fix perf-backed counter accounting across stop and read
Date: Wed, 30 Sep 2026 17:22:25 +0200
Message-ID: <20260930152346.900297237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index a749591a675de..73d76fd19896b 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -270,12 +270,13 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 			return -EINVAL;
 
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
@@ -645,7 +646,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 	bool snap_flag_set = flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
@@ -683,8 +683,11 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
@@ -698,9 +701,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		}
 
 		if (snap_flag_set && !sbiret) {
-			if (pmc->perf_event)
-				pmc->counter_val += perf_event_read_value(pmc->perf_event,
-									  &enabled, &running);
 			/*
 			 * The counter and overflow indices in the snapshot region are w.r.to
 			 * cbase. Modify the set bit in the counter mask instead of the pmc_index
-- 
2.53.0



