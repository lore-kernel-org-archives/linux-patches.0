Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6757333DEF9;
	Wed, 30 Sep 2026 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792932; cv=none; b=HK/Gy/3tONafwQ+J/kNCJS5Zx8YtTt7hEYnxUGb1bEqqgc6kfjzRQYYChatM8puKNuZP7k5Ee2b1jdm7JFqd0KQXDVoUYQwOC2q4TSobeRDWVGADSajgelYIJ4VCo64nEoo1AkLz5n4FwV8GA/KbP2zH8JgPpGYk8gqHgI54Tz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792932; c=relaxed/simple;
	bh=nyvD57GpaUpRduA6B1GH9nlPr/WLFm0rbSXYcpmZhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBto2N1B9eMLHsJyLbZWhS+Ifz3UshasSw/xyOQUdBIQgE45TQwKqC0suV1r6sgPOpq3I7LS4JmnvBiAUwzMASuik+hH2/0pGPP0j/WsTT9pPnW+8k4+/mqSWNZKdBapV62RD7pbH+L9MLZ031O+AJ+0eLH1RQSjmkQm5JqUWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN2uub37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN2uub37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0821F00899;
	Wed, 30 Sep 2026 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792931;
	bh=4AAPyrYSauQPA376qVQNHSCaT5X7wwrJHz8eHxWfuCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN2uub37UsiAK71/rCMZO/R5wfBIjmMGAg/ZQ0pFniW+a9b/jiI/Wbdr3Dx+0GKo/
	 3JYMWUmc1qLTSaX49l8lzbcs4tu44uZcx7z78F0zzOWNJNsWAic14HeM8h2UHlU7y9
	 59MABS/685ai5iONCsuRoeBinXKwgtJGY4FXm+Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/395] RISC-V: KVM: Fix perf-backed counter accounting across stop and read
Date: Wed, 30 Sep 2026 17:24:53 +0200
Message-ID: <20260930152341.296091744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index a32a12df726da..b374d92c9aa63 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -249,12 +249,13 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
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
@@ -619,7 +620,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 	bool snap_flag_set = flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
@@ -656,8 +656,11 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
@@ -671,9 +674,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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



