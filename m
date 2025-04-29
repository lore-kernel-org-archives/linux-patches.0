Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E55324E4AF;
	Tue, 29 Apr 2025 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946613; cv=none; b=LwUvwch+6k6z2WDb5Z2u01N3087TEEgX1HHPQ16byoAmlTigZh8MlJQuyUVHn7OpIffV2G6yfKWBgK7tNGPDXu6OLfz1fPoBndaVC4SbhZRVhEKKRfR0Wjo3hk8hGmNk0pph8yHvyronzO8P9G8Ed8E4Jq1DcJoF18FA2k6SUd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946613; c=relaxed/simple;
	bh=m9RK/eABfgx/NXEroODhCdjP9VtpHF3ixqv457ich2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=podlP8VtgmhK5SDIzb8ZtMzvSSw0LMzkrpYRLa53AFqMqhyQNgIO5UyYkHZmmQC8m1p6A4EEW5oNQG7MKqAzpwS6TAfY9PQyPSG7bNJUFuiBwRN7v1BgUOaCmG0K2ryLjyAX7JDwsi2MpfBe5SY1vAhupEAT6gQnqjuidpx+snw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaQb1cz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaQb1cz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0A9C4CEE9;
	Tue, 29 Apr 2025 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946613;
	bh=m9RK/eABfgx/NXEroODhCdjP9VtpHF3ixqv457ich2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaQb1cz7A3Kobl3jOQ+E9Yn2uRqlDPODbTkU4MQaHKqUAq8ZKnEJbMoEFMoyqMsl2
	 b173VLFfdr+7inI9WNuor97DdRRziPuxE+9FltwK2qUkIX6eCDueN1HTWcjxGCdBJb
	 peGm7wzfB117irgA4fLlntFyNKCBM+4BKNd5y9tA=
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
Subject: [PATCH 5.10 013/286] perf: arm_pmu: Dont disable counter in armpmu_add()
Date: Tue, 29 Apr 2025 18:38:37 +0200
Message-ID: <20250429161108.397961314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7fd11ef5cb8a2..8568b5a78c45b 100644
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



