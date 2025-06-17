Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D192EA487;
	Tue, 17 Jun 2025 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174930; cv=none; b=OfakJ9QPfcsqpQ53zCAwZ8EQkRG8B/1eahwZbxKpbQaSiT2IC6C59GZt2SFfDWVlfJm1C6tZxT8CALEaVcCd/EjGB7tEoY6Vtv/VZzqljkMsCi2YBkSiv4qE2IAF9SRoYLVsJwW38XKMmsMkUn8/SyLs5SbSP+ul/v5IwLek6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174930; c=relaxed/simple;
	bh=c0QGdAnKV9Ss/q8xRlHvmoIUrn8CVfAV+Pm4nIaORrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhtHHUiBnpL4Gbnrpcyt2LwOw9n16zrDc0MwcrOzZzf6fkIZ4tjTl8I/Cag9UQqUSQ4Y7/gF5H0/w55jj0qNd0mr0xN23jj+W/zN084lVx+KSkmo4X7iY6exKaVjnGfE0pmyK+OgG1gH3G2z/+8iQS8DTpGyceRL69/NQLF+e3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNLChzm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNLChzm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3ECC4CEE3;
	Tue, 17 Jun 2025 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174929;
	bh=c0QGdAnKV9Ss/q8xRlHvmoIUrn8CVfAV+Pm4nIaORrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNLChzm7P/BIEL4+FNHRBdRH1xEnv64AF7X0E/olocxuNaC7mpOXJ4dgX7ua1cDZg
	 SDnaZiqFbqHVDuA32+5HDzOdhDX7I1rFNkagMxhNApXncIKofmbeWXcifH6AUOdx+0
	 FO58NWsUCQdfn4mURw9OdClksA9Z64byswQEVHXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Song Liu <song@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 012/780] perf/x86/amd/uncore: Prevent UMC counters from saturating
Date: Tue, 17 Jun 2025 17:15:20 +0200
Message-ID: <20250617152451.993400449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 2492e5aba2be064d0604ae23ae0770ecc0168192 ]

Unlike L3 and DF counters, UMC counters (PERF_CTRs) set the Overflow bit
(bit 48) and saturate on overflow. A subsequent pmu->read() of the event
reports an incorrect accumulated count as there is no difference between
the previous and the current values of the counter.

To avoid this, inspect the current counter value and proactively reset
the corresponding PERF_CTR register on every pmu->read(). Combined with
the periodic reads initiated by the hrtimer, the counters never get a
chance saturate but the resolution reduces to 47 bits.

Fixes: 25e56847821f ("perf/x86/amd/uncore: Add memory controller support")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Song Liu <song@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/dee9c8af2c6d66814cf4c6224529c144c620cf2c.1744906694.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 010024f09f2c4..a6fa01ef35a10 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -889,6 +889,39 @@ static void amd_uncore_umc_start(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
+static void amd_uncore_umc_read(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 prev, new, shift;
+	s64 delta;
+
+	shift = COUNTER_SHIFT + 1;
+	prev = local64_read(&hwc->prev_count);
+
+	/*
+	 * UMC counters do not have RDPMC assignments. Read counts directly
+	 * from the corresponding PERF_CTR.
+	 */
+	rdmsrl(hwc->event_base, new);
+
+	/*
+	 * Unlike the other uncore counters, UMC counters saturate and set the
+	 * Overflow bit (bit 48) on overflow. Since they do not roll over,
+	 * proactively reset the corresponding PERF_CTR when bit 47 is set so
+	 * that the counter never gets a chance to saturate.
+	 */
+	if (new & BIT_ULL(63 - COUNTER_SHIFT)) {
+		wrmsrl(hwc->event_base, 0);
+		local64_set(&hwc->prev_count, 0);
+	} else {
+		local64_set(&hwc->prev_count, new);
+	}
+
+	delta = (new << shift) - (prev << shift);
+	delta >>= shift;
+	local64_add(delta, &event->count);
+}
+
 static
 void amd_uncore_umc_ctx_scan(struct amd_uncore *uncore, unsigned int cpu)
 {
@@ -967,7 +1000,7 @@ int amd_uncore_umc_ctx_init(struct amd_uncore *uncore, unsigned int cpu)
 				.del		= amd_uncore_del,
 				.start		= amd_uncore_umc_start,
 				.stop		= amd_uncore_stop,
-				.read		= amd_uncore_read,
+				.read		= amd_uncore_umc_read,
 				.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 				.module		= THIS_MODULE,
 			};
-- 
2.39.5



