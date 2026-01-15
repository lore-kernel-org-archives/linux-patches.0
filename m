Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F31349B0A;
	Thu, 15 Jan 2026 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496290; cv=none; b=JvJ97yBHQ2ICPe7QZAGmVY8AL3QU+WblfpIIUIjx6v5+xO5y36ED3Iq4FzPrE7TWJ/qck78eT8tC/txiGaUkhoeggYTRKcFXC/9C7r9DZwGNVCwmWc+ra7BhIJMGryE1uRcIch7r+zU5UTbWUmbVL+/vqPGg7rvlMzLBEhTmfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496290; c=relaxed/simple;
	bh=c4biU20CUYBK4x6OJIQYmXvkP6jT/wLCbjIVAtADkCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQJe0tUGhSGeKe4Y8hmNoGG164d8FTwUkUCZSuEl2dwuXf+SlZV6sEL+TvFMFtYVJVBDzD2UFwbiqIbRtq+rwvpz4ixmHRla/cLP44htYIsKv+M9GWorSPpeH8gSVkfEwWOBzBq2VE/Ithh99D8OHfpifSt5FqigHvH45OtRCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RESIg1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RESIg1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAEFC116D0;
	Thu, 15 Jan 2026 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496290;
	bh=c4biU20CUYBK4x6OJIQYmXvkP6jT/wLCbjIVAtADkCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RESIg1W3e52ILnwsPf/CMTDvJvtf7oJtUXYIute9Eh5ev06xWso2Adv9SP60z11V
	 MlDMIN+q0A4QF0IdLErb6JT9qAlXXvwM7ga+kBIJ7P67ElWX8NiG+DrS38Yybob4x/
	 tYmG7aAFWeeC2zs/ugjySjH96i1EZwCO6XEybwi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CyberUnicorns <a101e_iotvul@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.18 111/181] perf: Ensure swevent hrtimer is properly destroyed
Date: Thu, 15 Jan 2026 17:47:28 +0100
Message-ID: <20260115164206.324486902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ff5860f5088e9076ebcccf05a6ca709d5935cfa9 ]

With the change to hrtimer_try_to_cancel() in
perf_swevent_cancel_hrtimer() it appears possible for the hrtimer to
still be active by the time the event gets freed.

Make sure the event does a full hrtimer_cancel() on the free path by
installing a perf_event::destroy handler.

Fixes: eb3182ef0405 ("perf/core: Fix system hang caused by cpu-clock usage")
Reported-by: CyberUnicorns <a101e_iotvul@163.com>
Tested-by: CyberUnicorns <a101e_iotvul@163.com>
Debugged-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 413b88a4e00fb..d95f9dce018f4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11835,6 +11835,11 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 	}
 }
 
+static void perf_swevent_destroy_hrtimer(struct perf_event *event)
+{
+	hrtimer_cancel(&event->hw.hrtimer);
+}
+
 static void perf_swevent_init_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -11843,6 +11848,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 		return;
 
 	hrtimer_setup(&hwc->hrtimer, perf_swevent_hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
+	event->destroy = perf_swevent_destroy_hrtimer;
 
 	/*
 	 * Since hrtimers have a fixed rate, we can do a static freq->period
-- 
2.51.0



