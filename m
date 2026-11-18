Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040797;
	b=Tzv9BFD0iMG8IM5V9JmyO28ES00jFZZHeqhuiEINTHyX5OcphLQe7+6MwVoeS9jhO+pM
	 9UWmb67Yv1tmKzRT+6dYEtsBAm1XTpRCWOoDMXQ0tStI7xlKFOSd9c08/DBo6+6ewg7il
	 EB/DhtJKxnLN7/tp/xu7x2ht8gJj+WqiGEPE7p+FEwLDAJ5EbmBqGnNRCfH7edNX6GEZD
	 VuBT92jwNeKfr71JIQ/uWIQ64lO2KZN8t14XDGSqN8VUn4rSfnT7Hdr0+m7IlqGgB2d4B
	 UWL4c0gYssVx7H1ujJruXw+rsGaor5wyxnD+CCee7OYW8O18glGxH7Sgg/oggNxWnyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHb9PWNZLKfEQvVJYl1mP6vMX1EdvlJJ4nzyE1N6/1c=;
	b=dNxHLpsEzRv0ENi61dntk6c59vrduks9pIlNVWft2Vp8VherGnTUAZElDFnbx1L6oGgu
	 w1lfte4IWfRfs5+WBiVy0qcOlaULJA42E+5ZqxbUKg5mVXHUfwc1XL9r0IdZ7ohRMA/k5
	 GEV/oHZ+lH4T9aIBRI17olgojGbi+7l0SuL5EAjGCxltZOFGT5QQvkQuDIPK3i1+vyjzv
	 Rb6gH1DcZ3TuiJwFXCA3BMweB+6ktC+b/9gWxqYGD7l3/nTA7PyszCbK8n1qiCV58lR76
	 Etk0wCcUc1YqMqXOxEXWni2wG+1aYDmYGhlz9YX7YhaD1CQvpV2gbZVzTr+lMYUPu2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k9sFSL1K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C51606A31C;
	Wed, 18 Nov 2026 22:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k9sFSL1K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC28C1F000C4;
	Wed, 18 Nov 2026 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040797;
	bh=uHb9PWNZLKfEQvVJYl1mP6vMX1EdvlJJ4nzyE1N6/1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9sFSL1Kuky/2sAzSHarQVQFgyujxfZqL/phWDmOweD1WZB30OSDApTIeqoHio91M
	 Fw7fjqqi4hO4W8tcx/ik8vSFcPBo6fLZJrjbSlX9qIwqS6keHDtRE39zHATM7KzniK
	 vmPkWEjnUssz3WAYJlAouzHGv4yME51nxLeb546s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2544/3318] perf/cxl: Fix the counter overflow delta fixup
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150437.622559494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d37d792c81f31..479ff92b64f01 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -697,7 +697,7 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
 {
 	struct cxl_pmu_info *info = pmu_to_cxl_pmu_info(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 new_cnt, prev_cnt, delta;
+	u64 new_cnt, prev_cnt, delta, mask;
 
 	do {
 		prev_cnt = local64_read(&hwc->prev_count);
@@ -705,12 +705,16 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
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



