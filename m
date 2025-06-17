Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F9B2ECE9A;
	Tue, 17 Jun 2025 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174759; cv=none; b=qIunjQnvDn0hrcBGfmhd1wTHIqcZ8bEMaPi5DoFgDMVcgMbjS1+9h7EPqx8v7Y8mOMqW4ASkBwURqry+iT3DhR/tVBMzSZwmrV8uuYUbZBoHqFrghnJuStIwOT3S8QB4NvQdRezRVnEdfynvt+WCH6N0BRbfH6eR24bRqCnmB2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174759; c=relaxed/simple;
	bh=s4ximPgTK536oVJgACUBm2S/ZBA/C8sQ/kVtMROLKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxBkjFmVODqgcVo4czezr1bShpcubYaRShi43iAAt9lYB8gnLrQ52CZ15cDl/w+c3pv+pV7acXqocvCrt7TSNBxmUi4dYb7cqmYMAMMDQwZ3i6tvpUmmkbNe12Xzb9QymeKZuL7FwRnWEUT9CRZhOg24qRpt/A7cU3qDLTFoUwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idT+jHda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idT+jHda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA43C4CEF0;
	Tue, 17 Jun 2025 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174759;
	bh=s4ximPgTK536oVJgACUBm2S/ZBA/C8sQ/kVtMROLKG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idT+jHda+uRhCoptyCVG1DtRFquAh+n/q1VL/dhwwDrfK5GicuBzToWtRv/8U607I
	 oMOnyEpkh/Z6JOy7hmvMtFH4vxNR6yqYiWIpKZPlm3BdQe0+o4vO28qIfx8lPJlJsm
	 T5MrkzDXENrHXVnloh6RR6PhzlgryNjSnrsMljQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing7171@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 018/780] perf/core: Fix broken throttling when max_samples_per_tick=1
Date: Tue, 17 Jun 2025 17:15:26 +0200
Message-ID: <20250617152452.242035509@linuxfoundation.org>
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
index 95e703891b24f..881d768e45564 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10029,14 +10029,14 @@ __perf_event_account_interrupt(struct perf_event *event, int throttle)
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



