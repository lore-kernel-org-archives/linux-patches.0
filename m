Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ECD30E84D;
	Mon, 23 Jun 2025 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684922; cv=none; b=ZAILADeun2D/Tv8HI0Ns+VIJ7rv4Xcaq1ZWEgGiussy/BZigGB75DUGkd7C8jW+NGyfstjg4/mTjXdMzU/p/Y1rbdQ8VLEbHImhgIbNWogM4zC01zf66lF8JED+Z6ggwAkBnD/WqyGIF1w1Ae3pguJXgxcY6Lvv7EaIQ26/VYDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684922; c=relaxed/simple;
	bh=tGOHNyVCnxrmrHG/OgPivLq6C41Z/WVO3dP+malVlB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivXQFHccRW0H5KCYNSWfpujI0mcAen3lUpTU8sw7TMBTXfVt6/Env2ZZqOg5O6wlnsZqsy0u2pIb/Lp8OW9z1/DM08IO+ioUMMn1vrtOufDuIjsfIehXxGkc9kt41G+fImWXGuXm5/oDVkkS6YIQzFPJVRcsW0Jr42Pld+P6Qzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpJPW2hO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpJPW2hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E2C4CEEA;
	Mon, 23 Jun 2025 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684922;
	bh=tGOHNyVCnxrmrHG/OgPivLq6C41Z/WVO3dP+malVlB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpJPW2hOgJO+sA6lb0buqJh1fvEEdJfOKIyJqcNoVvIN1TUsFvLWurLfJrw6NF/uN
	 29zoABgtNcLhLqzyM23Ds4OSvg8WHJD5jCO0TCUII35+sDhokmI0SVXawd0kep0f+S
	 nOIdgHNihbH4Pl+DJkq/toAt0gVk4GPThI6vFBeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing7171@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/355] perf/core: Fix broken throttling when max_samples_per_tick=1
Date: Mon, 23 Jun 2025 15:03:32 +0200
Message-ID: <20250623130627.094426138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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
index 8f19d6ab039ef..21f56dd6c05a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9031,14 +9031,14 @@ __perf_event_account_interrupt(struct perf_event *event, int throttle)
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



