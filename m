Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D0C134C6;
	Sat,  3 Feb 2024 04:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933738; cv=none; b=Vq3N9yqWpB58cb2Nt+Iki/5dDPsgI3yir/rQbJE1r2OSSqgGwGG6dUvkPHQuGOXtBSSB5tc9DR4/mcnCUe32ubFfFbi1oGwV5uCEBxoH3Q7k/rV7Q8rjmT4gtfojMRk0DhSZm/yUeHmhoCDNeOSfVZOkXEkQERZJkEjYC22Ykjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933738; c=relaxed/simple;
	bh=9aLKuRlm3SHCw20GC8ZtBfbXRfDxiJkBzekA5a23dCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBxMXoaSh9/ZxnxxEvYEbJKRCBvn9RMP/vVLcGQVv+C5qVJB9G3Ddwga95D4RaGaJIl5B476+3bY3/fE/YXWZ6jrF/PQKhFTr4hO7G8V6QpPpYmJtWJ22K1hwpG0aANbUgPAdrch5IC252zDlu8D9Ib6gYMbg6CdZkmNGSD1NHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/y4z6eG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/y4z6eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBC5C433C7;
	Sat,  3 Feb 2024 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933738;
	bh=9aLKuRlm3SHCw20GC8ZtBfbXRfDxiJkBzekA5a23dCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/y4z6eGhDbnR84kP66TndJbRSj+cB1bmi+RcbB9aarUDJ7S2EXd5P+OUwiAJ32FE
	 oElBe9jJw7o6K4sQ+YimcmegfOa1GfdXNEh7/DvWDNNFUHjW1WZDJDKWmrV+8OTZu+
	 kX9DBdG5raerf3foAiBfy7hZqd8dTbMRiCAZQWE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 004/353] drivers/perf: pmuv3: dont expose SW_INCR event in sysfs
Date: Fri,  2 Feb 2024 20:02:02 -0800
Message-ID: <20240203035403.813228675@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ca6f537e459e2da4b331fe8928d1a0b0f9301f42 ]

The SW_INCR event is somewhat unusual, and depends on the specific HW
counter that it is programmed into. When programmed into PMEVCNTR<n>,
SW_INCR will count any writes to PMSWINC_EL0 with bit n set, ignoring
writes to SW_INCR with bit n clear.

Event rotation means that there's no fixed relationship between
perf_events and HW counters, so this isn't all that useful.

Further, we program PMUSERENR.{SW,EN}=={0,0}, which causes EL0 writes to
PMSWINC_EL0 to be trapped and handled as UNDEFINED, resulting in a
SIGILL to userspace.

Given that, it's not a good idea to expose SW_INCR in sysfs. Hide it as
we did for CHAIN back in commit:

  4ba2578fa7b55701 ("arm64: perf: don't expose CHAIN event in sysfs")

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20231204115847.2993026-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 6ca7be05229c..0e80fdc9f9ca 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -169,7 +169,11 @@ armv8pmu_events_sysfs_show(struct device *dev,
 	PMU_EVENT_ATTR_ID(name, armv8pmu_events_sysfs_show, config)
 
 static struct attribute *armv8_pmuv3_event_attrs[] = {
-	ARMV8_EVENT_ATTR(sw_incr, ARMV8_PMUV3_PERFCTR_SW_INCR),
+	/*
+	 * Don't expose the sw_incr event in /sys. It's not usable as writes to
+	 * PMSWINC_EL0 will trap as PMUSERENR.{SW,EN}=={0,0} and event rotation
+	 * means we don't have a fixed event<->counter relationship regardless.
+	 */
 	ARMV8_EVENT_ATTR(l1i_cache_refill, ARMV8_PMUV3_PERFCTR_L1I_CACHE_REFILL),
 	ARMV8_EVENT_ATTR(l1i_tlb_refill, ARMV8_PMUV3_PERFCTR_L1I_TLB_REFILL),
 	ARMV8_EVENT_ATTR(l1d_cache_refill, ARMV8_PMUV3_PERFCTR_L1D_CACHE_REFILL),
-- 
2.43.0



