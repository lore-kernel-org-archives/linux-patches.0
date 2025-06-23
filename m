Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A14252900;
	Mon, 23 Jun 2025 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685173; cv=none; b=hx9lNHlEZqGgBJmM/FxWwyUYR2N3yLZNoZMQzGkoaW2yeSMcwaWB6ye223jCbLuI+3ehWy8TFYFkCXG336e+GVV6dNLjirNYmMbHYbSOoduIfS5/6fwnlVdr16FCdMJRr1CJYx9ssdr0KMMFvHAA1bdvelRmTeZEcrB/h9BQkJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685173; c=relaxed/simple;
	bh=RvmHqah1k52SuUT4rQI7X5+6X8iX10rdRGKvesLzN/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWK/Q5LLK9sq/UfQcqjNeoJWLPzNPpnalPGQLdCWMrJksZiLbcFrUjYwci+HWCA1ionomBP5/gvD+uTJQbl3kMVYc7pA5kZGMXoVnTWJGqPRdJlY6kGh58paXV/kl7Pzu9jYcgthaTy9WDua2So2mKA1fsNHLT8oP6AL+XIh2Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGGLGbXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGGLGbXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D204C4CEF0;
	Mon, 23 Jun 2025 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685173;
	bh=RvmHqah1k52SuUT4rQI7X5+6X8iX10rdRGKvesLzN/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGGLGbXvZe21imiHSmP8p88qtDJ0ea+ogOSfYYoKW/uTtVmgAfCtrxDzMxrYCPdyF
	 dA5TdFKM273V3oGj8Bndx9RLeAyBkOZskyuCz5gWHPKpffZq/P2vP1P6BemV0DI7qR
	 4AId6yDlI7fJpQND3RX1HKJPOEICuUpzQ8XvEMkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing7171@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/411] perf/core: Fix broken throttling when max_samples_per_tick=1
Date: Mon, 23 Jun 2025 15:02:37 +0200
Message-ID: <20250623130633.390726036@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Qing Wang <wangqing7171@gmail.com>

[ Upstream commit f51972e6f8b9a737b2b3eb588069acb538fa72de ]

According to the throttling mechanism, the pmu interrupts number can not
exceed the max_samples_per_tick in one tick. But this mechanism is
ineffective when max_samples_per_tick=1, because the throttling check is
skipped during the first interrupt and only performed when the second
interrupt arrives.

Perhaps this bug may cause little influence in one tick, but if in a
larger time scale, the problem can not be underestimated.

When max_samples_per_tick = 1:
Allowed-interrupts-per-second max-samples-per-second  default-HZ  ARCH
200                           100                     100         X86
500                           250                     250         ARM64
...
Obviously, the pmu interrupt number far exceed the user's expect.

Fixes: e050e3f0a71b ("perf: Fix broken interrupt rate throttling")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250405141635.243786-3-wangqing7171@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 520a890a2a6f7..cb0c8aa71c98b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9401,14 +9401,14 @@ __perf_event_account_interrupt(struct perf_event *event, int throttle)
 		hwc->interrupts = 1;
 	} else {
 		hwc->interrupts++;
-		if (unlikely(throttle &&
-			     hwc->interrupts > max_samples_per_tick)) {
-			__this_cpu_inc(perf_throttled_count);
-			tick_dep_set_cpu(smp_processor_id(), TICK_DEP_BIT_PERF_EVENTS);
-			hwc->interrupts = MAX_INTERRUPTS;
-			perf_log_throttle(event, 0);
-			ret = 1;
-		}
+	}
+
+	if (unlikely(throttle && hwc->interrupts >= max_samples_per_tick)) {
+		__this_cpu_inc(perf_throttled_count);
+		tick_dep_set_cpu(smp_processor_id(), TICK_DEP_BIT_PERF_EVENTS);
+		hwc->interrupts = MAX_INTERRUPTS;
+		perf_log_throttle(event, 0);
+		ret = 1;
 	}
 
 	if (event->attr.freq) {
-- 
2.39.5



