Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971223DAAC9;
	Thu, 17 Sep 2026 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671100; cv=none; b=gNIqchKuVhQgnNkrQkBkddwR6R5q0cZEpvX2Oi9KcWh+UvIHnbL7EzVCWhwGgSAZtdGoeN8L7Lo3dpMJodDE9EyHSOLUbNb/QZtqGAsVh6TXl6PULsGqw0B+7qSQnAzi22TUNPeWlzxTLUgY7x/MHf2gNBOvrHZbyd0IhoUGHkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671100; c=relaxed/simple;
	bh=XgYDP5PcFDRDis9asmwz1x+uUzL++GPgjSeaZuEfKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeYSvnb5+MjIDPMy4GlzFsPCOVR5rGQUM8M615r5aseCFXqkWaoYoW+lKQ9dzGqD2r311gBIEdVo7ry1QM1BrqvK315zwbtuDnN153/2DBYJ7OtJ2PHALRBs3FF7lAh8q6GNk3pT9KqjIYVUeKYPwd1HuSzeAq2GBuYzUJbRqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayHH5NJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayHH5NJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07A81F000FF;
	Thu, 17 Sep 2026 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671099;
	bh=hgPZcpMtCwu4kmdlXz4Um2yvJNYArMeChbimj6cTKpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayHH5NJ55LxvYaskT+gOKZcNuwnvkKvrwQKoZQkF9Q8gGJdlz1RhBsVqGSJqbsRmJ
	 WUnswLmMLQRmlBi/NVX3x9qUcBPdHqZXSfMVPBPvVn5Q0aH81Ug+a34kuAkH8XT9+8
	 zG0/y2rESAvSfiRUgWU4Z0nxoJTW9GeLRF6VXJPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 0867/1102] perf: RISC-V: use BIT_ULL for u64 overflow masks
Date: Thu, 17 Sep 2026 16:13:30 +0100
Message-ID: <20260917151602.322329597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

commit 6693171c8c540b3a54e671992f0561613076fc3b upstream.

Overflow status and restart masks are u64, but bits were built with
BIT(). On RV32 that is an unsigned long shift, so indices >= 32 truncate
or wrap and corrupt the mask.

Use BIT_ULL() for those u64 bitops.

Fixes: a8625217a054 ("drivers/perf: riscv: Implement SBI PMU snapshot function")
Assisted-by: DeepSeek:deepseek-v3
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/prpmask01bitul.v2.1786434000.git.liuxixin@kylinos.cn
Cc: stable@vger.kernel.org
[pjw@kernel.org: updated to apply]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -946,7 +946,7 @@ static inline void pmu_sbi_start_ovf_ctr
 	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
 
 	for_each_set_bit(idx, cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS) {
-		if (ctr_ovf_mask & BIT(idx)) {
+		if (ctr_ovf_mask & BIT_ULL(idx)) {
 			event = cpu_hw_evt->events[idx];
 			hwc = &event->hw;
 			max_period = riscv_pmu_ctr_get_width_mask(event);
@@ -1055,14 +1055,14 @@ static irqreturn_t pmu_sbi_ovf_handler(i
 			hidx = info->csr - CSR_CYCLE;
 
 		/* check if the corresponding bit is set in scountovf or overflow mask in shmem */
-		if (!(overflow & BIT(hidx)))
+		if (!(overflow & BIT_ULL(hidx)))
 			continue;
 
 		/*
 		 * Keep a track of overflowed counters so that they can be started
 		 * with updated initial value.
 		 */
-		overflowed_ctrs |= BIT(lidx);
+		overflowed_ctrs |= BIT_ULL(lidx);
 		hw_evt = &event->hw;
 		/* Update the event states here so that we know the state while reading */
 		hw_evt->state |= PERF_HES_STOPPED;


