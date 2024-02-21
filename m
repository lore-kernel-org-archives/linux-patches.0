Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE7C7BB14;
	Wed, 21 Feb 2024 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523955; cv=none; b=tVSiWoe0XNKAdVNnzD7uqXWUf0uWyTeIwQTOlaQwP39In43NCJqpoLB8njQCobFF87y8zdMW6U35fqJMFPcit7/dKVWtnM8RF/8XOpqPQQsJ7KSEBmlhg/q3l5MaCTqDk8NtXIHaibya84A2tpSzDFYDZmjy3tOvrejB/g/6KFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523955; c=relaxed/simple;
	bh=Ova3qjBy4sH8lUNFXVnn9RLp2KVmpai2CrRk09U860M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLWrUUKTZ3mb3Uu+JAliI//LWeQuIMjJIHU27Yvxd6TBZXdGtUPcAfKgVKT72LqlBcICMlAfPXe9k+PQTAMxs8SmCIFy08tqmvCVbUsW7kSDe8AUBkGfFPZ2ajijc0JPxCSTO/NKuNEI+eNPRDuBOQ5ogOOTWFiGHJ8bFbCoMMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAVgN2wP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAVgN2wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE92C433F1;
	Wed, 21 Feb 2024 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523954;
	bh=Ova3qjBy4sH8lUNFXVnn9RLp2KVmpai2CrRk09U860M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAVgN2wPVTaWwA/OUckZW0nxBhaim0ehw51o5QzdfSaMNpq21Fy1XPkpyH6rHEer4
	 ftvmGLzHvu+kEMymWAaN6SfNlvQ8ihFQezMT4ulxU7asyivYbfTXArKnVKe4EcyV0j
	 qEDo8pnZCur0KVk+gDZtR/7Pp2zh7JMuXnYrPL6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/379] drivers/perf: pmuv3: dont expose SW_INCR event in sysfs
Date: Wed, 21 Feb 2024 14:04:41 +0100
Message-ID: <20240221125957.937776051@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/kernel/perf_event.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index cdb3d4549b3a..8e428f8dd108 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -171,7 +171,11 @@ armv8pmu_events_sysfs_show(struct device *dev,
 	}).attr.attr)
 
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



