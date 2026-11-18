Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018479;
	b=4/+nFl5ItDZfxt7865haOp28VcTBRwgUdQsjbb07EyscUl6/jzJGWgBGBqnEwYnoiNqS
	 oSbt9PDzSJ/mDoms6g38UTvQQQzyzaK1bUe+evuknPQMEoEY/Eota9aU3E9PKN3UH2pk9
	 urLs////dAYfmn5CquIdV0aE7YZjC/tII3l9ktK+dsbMpG4jJ0EDf22hTR9P8LzJ7MS01
	 gw2DpP4dwzjv/u01bNmuurFJRZsQOftNI+q15WIexethuXylLknvV32WFTQiCMk62OrJd
	 PNJKxz+Dpc24H5XVx6NdCwjcXW3EJasOCausqJHkF/bvV7MXEPx/07Ls5sScuunA54Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIPxBi1fYMWQ9o8Ds+YOiq/oPHLDsN+Dzi0EizLNTgQ=;
	b=zF393pb0vlXo4U1BQSiGUuHBh77rqo+wDrB08okh7kjSd/aBOGjws5cpoEwbEAA8A0UL
	 Az1BlKQr5Xsrz+lYulTt2txFcELVx74rpf3o3cJ0GSudw1y05X4rwhgAYfraQKEC5GkVr
	 Z43g3vrXFeIR1k0oMQdyOmk+60fC5nJxnvtlR6Gy/f67+uHMMYMDex41DN4jm0LMbGd0+
	 tIU2y7l/DEllW93mFBTK2PhzmrtDzA8LXh27rNez26TQ93KufJQUeCT13J8VDMmCOHVsU
	 3eD3uzIkthPyxXDRzs7qQKmABFgopFR3QWdIPLsKNStnO7OFMxWuCiniYgrbxMLe4TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaUuRmUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2832606A320;
	Wed, 18 Nov 2026 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaUuRmUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100491F000C4;
	Wed, 18 Nov 2026 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018479;
	bh=lIPxBi1fYMWQ9o8Ds+YOiq/oPHLDsN+Dzi0EizLNTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaUuRmUUB/m3J961WM60mBVX9EfydQb1zwVZte4GrKHjU4Ie6QZSFWXSuBTbP/Qgg
	 lH2HZ4kJSte///bUyJIji4/gvd82erIcVokbPmp3mP1lmQkrsKmYwrZ1GJ6NW7uwZs
	 a8FNIgQIwxqyveJ0uwMt9haAsbEMwmQ0CbSGRKsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1254/2651] perf/cxl: Fix the counter overflow delta fixup
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118150333.123392750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 0326269ed73529cdf821664b6176814cde9ca374 ]

The counter is masked to counter_width, so the subtraction in
__cxl_pmu_read() throws away the bit that records the wrap. A delta of one
whole period reads back as 0, the same as no events at all, and only the
overflow status tells the two apart - which is why __cxl_pmu_read() takes
an overflow argument.

The fixup keys off the delta rather than the operands:

	delta = (new_cnt - prev_cnt) & GENMASK_ULL(counter_width - 1, 0);
	if (overflow && delta < GENMASK_ULL(counter_width - 1, 0))
		delta += (1UL << counter_width);

so it cannot tell which of these it is looking at:

  event_start         polled read          wrap
  ctr = 0 ..........  ctr = P/2 .........  mask -> 0 (+r)
  prev = 0            prev = P/2                 IRQ reads new = r

  prev = 0    (no read yet):  new >= prev, fell short -> add period
  prev = P/2  (polled):       new <  prev, spans wrap -> add nothing

Both rows are the same interrupt and the old guard adds a period in both,
so a mid-period read makes the event over-count. 'perf stat -I' hits that.

Condition the fixup on new_cnt >= prev_cnt, the one case the subtraction
cannot express. Dropping it outright would break the first row. It stays
exact whatever the residual r is, which matters because some events
increment by more than 1 per cycle (CXL r4.0 8.2.7.2.1, Threshold) and can
step past 0 as they wrap.

Use mask + 1 for the period rather than a shift. It is 0 for a 64-bit
counter, and avoids the old 1UL << counter_width - undefined for width 64,
and for >= 32 on 32-bit kernels.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 8232dc566bd5f..4b1827d74bdee 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -802,7 +802,7 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
 {
 	struct cxl_pmu_info *info = pmu_to_cxl_pmu_info(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 new_cnt, prev_cnt, delta;
+	u64 new_cnt, prev_cnt, delta, mask;
 
 	do {
 		prev_cnt = local64_read(&hwc->prev_count);
@@ -810,12 +810,16 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
 	} while (local64_cmpxchg(&hwc->prev_count, prev_cnt, new_cnt) != prev_cnt);
 
 	/*
-	 * If we know an overflow occur then take that into account.
-	 * Note counter is not reset as that would lose events
+	 * The mask discards the bit that says the counter wrapped, so a delta of
+	 * one whole period reads back as 0 - the same as no events at all. Only
+	 * the overflow status separates them, and new_cnt >= prev_cnt is that
+	 * case, so add the period back. mask + 1 is 2^counter_width, which comes
+	 * out as 0 for a 64-bit counter and avoids an undefined 1 << 64.
 	 */
-	delta = (new_cnt - prev_cnt) & GENMASK_ULL(info->counter_width - 1, 0);
-	if (overflow && delta < GENMASK_ULL(info->counter_width - 1, 0))
-		delta += (1UL << info->counter_width);
+	mask = GENMASK_ULL(info->counter_width - 1, 0);
+	delta = (new_cnt - prev_cnt) & mask;
+	if (overflow && new_cnt >= prev_cnt)
+		delta += mask + 1;
 
 	local64_add(delta, &event->count);
 }
-- 
2.53.0



