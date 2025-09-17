Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B53A31A802;
	Wed, 17 Sep 2025 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112740; cv=none; b=aiulv2zJ5vkRddnqn4dDxoceinWN8G743vPHmNThHWl2A5af3Whwa2oRvC9O10EryKyhUmHWD5mCFODk9jeEg06AlKCXmS/dvAWJnTOQ0Ad2yRECdPyw04Kiapb2PrD6IYFY1mgfNyRYJYs6BkZCsomn2WaPJR9EToJJRv1wrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112740; c=relaxed/simple;
	bh=iuquBeNz2V57I13aORsLBAgS8CJ4Ish+l/fZlV9xYes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3iBZwLagOYf9wUuuYLLLyY+nIn16Kp3Xy9jr5/IaM5z+tXS3LmzZn/f9rN5+GrY+y0Vy4/6uJYmBsHzlyhFrEIWqgCuPEYGGph2wiRMNRZHS4lAcUamasrZBE9NSCDRFfQEBmqgQNHBwUiap6ygNxV7WAqBfltB1K8RL6avFwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roZcNEKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roZcNEKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3171BC4CEF0;
	Wed, 17 Sep 2025 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112739;
	bh=iuquBeNz2V57I13aORsLBAgS8CJ4Ish+l/fZlV9xYes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roZcNEKd/iCexS7UUmJvF8Kv2mm2huSrWBHCgA3JxbTuLzamn2SeXS4iv1DZKqhhb
	 TW48R+dWSZ0Uayheus9L5a11wgXp44id/D/XYFJUkZ0NjITCB4PExPEBPpFsxwJ+KV
	 X3+PO1YaTiY+ic9MNEyyEYxUqW3QSOv5CV+sgaz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 007/189] perf: Fix the POLL_HUP delivery breakage
Date: Wed, 17 Sep 2025 14:31:57 +0200
Message-ID: <20250917123352.030002653@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 18dbcbfabfffc4a5d3ea10290c5ad27f22b0d240 ]

The event_limit can be set by the PERF_EVENT_IOC_REFRESH to limit the
number of events. When the event_limit reaches 0, the POLL_HUP signal
should be sent. But it's missed.

The corresponding counter should be stopped when the event_limit reaches
0. It was implemented in the ARCH-specific code. However, since the
commit 9734e25fbf5a ("perf: Fix the throttle logic for a group"), all
the ARCH-specific code has been moved to the generic code. The code to
handle the event_limit was lost.

Add the event->pmu->stop(event, 0); back.

Fixes: 9734e25fbf5a ("perf: Fix the throttle logic for a group")
Closes: https://lore.kernel.org/lkml/aICYAqM5EQUlTqtX@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com/
Reported-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Link: https://lkml.kernel.org/r/20250811182644.1305952-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 872122e074e5f..820127536e62b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10330,6 +10330,7 @@ static int __perf_event_overflow(struct perf_event *event,
 		ret = 1;
 		event->pending_kill = POLL_HUP;
 		perf_event_disable_inatomic(event);
+		event->pmu->stop(event, 0);
 	}
 
 	if (event->attr.sigtrap) {
-- 
2.51.0



