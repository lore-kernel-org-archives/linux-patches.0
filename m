Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922D36A37E;
	Wed, 30 Sep 2026 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788992; cv=none; b=cQI7UgQN5JX28/sskkZrYpS0i9jkQwINuzURu8hB6svh6dw7xueg8Nz0/1zsKOgwkamtFvqe6gQnRLal+LjOyRF+9YFaJY0XGk90sysSMr4IariBC7Vf3ctTw0rNFnnXpIIBBfSl+WluqV3LKT8x1SRW7ET0HJIy0VxEx3ArjWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788992; c=relaxed/simple;
	bh=yGZLvg9f14NWhQE7pF0YUxKMyE6DKBMfxlAAJw737E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3ssG1Nn8Kt9dCkBsN/v52qeep6F2pTBAL9UiZBia9krmDSdAInAXfIbS03EjzCy7d5GK71620ZRzsFp8GWiRFwk3B1iwCUw0ViQ76Vgxm1v51LZ03iwGATBH0Ezrz5SfjdtTSgoYsvOQ5g40EgnhqT0l3Y2SuM98hJqp1MTfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHiScyfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHiScyfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13071F000FF;
	Wed, 30 Sep 2026 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788991;
	bh=zWPdlvld5jzrczJRBI1FByvJPnvG9QRq5tX10rnRRUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHiScyfFe80hHNIoBKDM9l52qWdndkoQfkneri6rqeLvOi9Lhpv6iOu9xfKPe41+v
	 xQaCtVDs8zhCR0i8VhtmEOfYL0K8bwuva1Vs9wien9On7PQFp5RKT3yNPdUI/fSPQN
	 ZwsV8ExmKV8DBTPjS0Q+ufc5wYI6q5Ux9Z38CRCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/877] RISC-V: KVM: Preserve firmware counter value across stop/start
Date: Wed, 30 Sep 2026 17:20:32 +0200
Message-ID: <20260930152421.612684064@linuxfoundation.org>
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
index 9ec3280db91d9..4073adf4f91a3 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -590,10 +590,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
@@ -611,9 +613,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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



