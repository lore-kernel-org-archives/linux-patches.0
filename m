Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B805B51C056;
	Wed, 30 Sep 2026 18:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792875; cv=none; b=HV+0OsQHToH2jmXEe4pGzvVX/MjrKWrowDkdpOasaD11KNS90skryQFF7AWAPa4i4fmi1RSOPkQXJokZ0anNh0IBA3XR5U5foyY1rdFVdwBxXF6hx2yTmI8jG+r27guEDjMwPKUB59rDrEpgrcs2aolvEOSCtxKthTRs3iMFBVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792875; c=relaxed/simple;
	bh=khaO9ifMdEq17+l7wnIlFzioe5/qN/gjmRpZMewph54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4tCA8h0Asq7uR2f22TKz7++PeZLb5zbIaKaEt9D5ZT8K4pBUPccBuXoqS/8vrIm20AvLNMXblXa8QIfSp13vUsrM4CcNhIuTGuOb48/qx4df8y9EoIpepFqoWw/KDsUmom9g5RZefv5vEhLe/vVwxACIBiChmvyNFt5CaEVW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mb9egTiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mb9egTiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBDB1F000FF;
	Wed, 30 Sep 2026 18:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792874;
	bh=jXJGFlZgVHN73cdt00z+lV1W1F/z/0MIls+WImP4+qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb9egTiDPMt+F4a22D8wXmYvW/C/D7TCSKd/VYeqDRhKX6K/FUbezRvmOXg/a5znR
	 fB7de+DBIQMXTMnRsrghm+CZl/lWAf6WM8gAOsM/CCDjOA3vrGfYkAAhFc39rbMYyA
	 Y/kf9Iow0lcD51doHv+GlvfgsBAfXWBmUL/zM4AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/395] RISC-V: KVM: Preserve firmware counter value across stop/start
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152341.251058640@linuxfoundation.org>
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
index ef55089c0c1a6..f3a8fd52d13a5 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -648,10 +648,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
@@ -669,9 +671,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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



