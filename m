Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E7244664;
	Tue, 29 Apr 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948458; cv=none; b=fnqXFlO6Vm1YYU2ywf+h1QzCW/2276voCVyqaQx/Zar64e2SxNS2CY+wfS+Z8AzFAF4CcjrB9+iPDy3VkwzyIo4LvSG0AkjimrrFdSSyGWeB5+3JimezSFwZP886VJY4rCWGwjoGVrtk9RZ7ujT1XdPKBtgqzR8P7i9Rz4rE2Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948458; c=relaxed/simple;
	bh=nlft/leLtsc3LqgSBRdKRS9V6JYONN+PD8jKF8v3qi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNZAckOdy4OoaQrI1G6+biZC8DToCVKwq2PgFSgKfy0Dbg2UFwEd4p8ymGTVrwaWQT7BSDkZTnMUgv2YsT0m//mOL0eJryeK8gtR9sDKIasTJxlBIt4kjdlnW1useYGmgsgbMad7a8tVAcbW+VwDQlUwEscUyqAl4amMGvKTlpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0JI2S7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0JI2S7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F00AC4CEE3;
	Tue, 29 Apr 2025 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948458;
	bh=nlft/leLtsc3LqgSBRdKRS9V6JYONN+PD8jKF8v3qi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0JI2S7nGfnPFEDlP6NtDEvRcHfd7FT21KRk0w5Vyru9h0pPeD2yEzHLV2U++8Kuz
	 BBOR8UiZV+UUhpYP+nqGN8yF3V0o85cU6Rhs6IoKHDo1qEC/obwAkeUL3VFmwGEGzJ
	 oU/L3tlWSp0pb5qWgKybqWLuJ19LGgLfGXlCNiR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/373] perf: arm_pmu: Dont disable counter in armpmu_add()
Date: Tue, 29 Apr 2025 18:38:11 +0200
Message-ID: <20250429161123.720803637@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit dcca27bc1eccb9abc2552aab950b18a9742fb8e7 ]

Currently armpmu_add() tries to handle a newly-allocated counter having
a stale associated event, but this should not be possible, and if this
were to happen the current mitigation is insufficient and potentially
expensive. It would be better to warn if we encounter the impossible
case.

Calls to pmu::add() and pmu::del() are serialized by the core perf code,
and armpmu_del() clears the relevant slot in pmu_hw_events::events[]
before clearing the bit in pmu_hw_events::used_mask such that the
counter can be reallocated. Thus when armpmu_add() allocates a counter
index from pmu_hw_events::used_mask, it should not be possible to observe
a stale even in pmu_hw_events::events[] unless either
pmu_hw_events::used_mask or pmu_hw_events::events[] have been corrupted.

If this were to happen, we'd end up with two events with the same
event->hw.idx, which would clash with each other during reprogramming,
deletion, etc, and produce bogus results. Add a WARN_ON_ONCE() for this
case so that we can detect if this ever occurs in practice.

That possiblity aside, there's no need to call arm_pmu::disable(event)
for the new event. The PMU reset code initialises the counter in a
disabled state, and armpmu_del() will disable the counter before it can
be reused. Remove the redundant disable.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250218-arm-brbe-v19-v20-2-4e9922fc2e8e@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 57d20cf3da7a3..fd59f40f74435 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -338,12 +338,10 @@ armpmu_add(struct perf_event *event, int flags)
 	if (idx < 0)
 		return idx;
 
-	/*
-	 * If there is an event in the counter we are going to use then make
-	 * sure it is disabled.
-	 */
+	/* The newly-allocated counter should be empty */
+	WARN_ON_ONCE(hw_events->events[idx]);
+
 	event->hw.idx = idx;
-	armpmu->disable(event);
 	hw_events->events[idx] = event;
 
 	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
-- 
2.39.5



