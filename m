Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A48E357D11;
	Wed, 30 Sep 2026 16:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786891; cv=none; b=lHlV13NOUw4eZPTx/w1E77+nYAneks6AKOqxNQa5M8kH0/1XOF9Et82UkXH86yaarwnlEjil+1exlj4nFLcFGZh/7bjuUf5sLMKLC8QCxbEnlKubruixj4gRFXyyvsOdo13RaYXYUPATyWrKdBAy2NisnC3rwrMo2oqLboFLkg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786891; c=relaxed/simple;
	bh=jr+O6yZJIxKiY4IGai8bFlhX+RxiQWR+O2xRZZpzx7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4+2+wWOigqG9YMBF5Ob9FLksDca8kZkkxX+9ImpIQQ2tfxUeAv5Ajqb6m59uEEKaXxH+43TMgZCsZYRdAO5U1C6MPQVun6IIFb5Nc6BuJ3YlWEwFAS7GoF0GDJygIboW8lKdu0cXqZegGOpbF/WkzdGBU07MaL3vimg5SZQoT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzjkWZ/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzjkWZ/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53621F000FF;
	Wed, 30 Sep 2026 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786890;
	bh=iJtzya2QNTmASZgFOrUdM7BcG2AL6UrF9k3vMTXQcWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzjkWZ/1JOg+Y3mcB1Bk2XlqPxySaeff49QeLP0hj96rM0j4uBVCAqMCwhSc3sxs2
	 wa/OwaGpvvnoQZ98QhjOxLKsu7tgNRaZCJvV/cppgfb1VI17mQFVjkpEybHR+AyKRi
	 n/YU+4+NxArW86QKzaw6AaEMYW2sRbGrUReiXeJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 038/457] RISC-V: KVM: Preserve firmware counter value across stop/start
Date: Wed, 30 Sep 2026 17:22:23 +0200
Message-ID: <20260930152346.857637574@linuxfoundation.org>
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

[ Upstream commit 8b3fd1a8b305321171602bfa7c41212441cf69e4 ]

Firmware events accumulate in kvpmu->fw_event[].value while running,
but counter stop only clears fw_event[].started without saving the
value back to pmc->counter_val. A subsequent counter start without
SBI_PMU_START_FLAG_SET_INIT_VALUE reloads the stale counter_val into
fw_event[].value, losing all events counted so far.

Save fw_event[].value into counter_val when actually stopping a
running counter, and remove the now redundant synchronization from
the snapshot path.

Fixes: badc386869e2c ("RISC-V: KVM: Support firmware events")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260825083719.643970-2-suunj1331@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index a7f948410d531..904d266a66c44 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -675,10 +675,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				goto out;
 			}
 
-			if (!kvpmu->fw_event[fevent_code].started)
+			if (!kvpmu->fw_event[fevent_code].started) {
 				sbiret = SBI_ERR_ALREADY_STOPPED;
-
-			kvpmu->fw_event[fevent_code].started = false;
+			} else {
+				kvpmu->fw_event[fevent_code].started = false;
+				pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+			}
 		} else if (pmc->perf_event) {
 			if (pmc->started) {
 				/* Stop counting the counter */
@@ -696,9 +698,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		}
 
 		if (snap_flag_set && !sbiret) {
-			if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW)
-				pmc->counter_val = kvpmu->fw_event[fevent_code].value;
-			else if (pmc->perf_event)
+			if (pmc->perf_event)
 				pmc->counter_val += perf_event_read_value(pmc->perf_event,
 									  &enabled, &running);
 			/*
-- 
2.53.0



