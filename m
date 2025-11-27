Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A6528135D;
	Thu, 27 Nov 2025 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255837; cv=none; b=KkqgXAjX0CUmh61AYp8cJPkzuRmXRAZwrTsKmMI0F5jj551vbijPBcVZ43Xp7BdS+aa1ZdK/YSVmC7ioN6PKx39XSI5XkuFjKfa5J62XpIxa6TSXVr8tVCDxlVlgQDaStuo4b6Hco/4cBvvvuvPLAwKPwINE+SNXSQ5Cte1eI2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255837; c=relaxed/simple;
	bh=wDgvoydGhkbkvl8xs/oyXNM9+OYlrPblm/PxmpTUAmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqBD6psMxtzaAGuCAOqAFH9ygWC08ClchIopysNgzyKKvIJAnJBxpbs0DIoSiKkYzRGMjj5YzWQc/FQpLxWJ4fRhn36NXCUR+QfaRLBr1GbvZeh3l1eU818H/uXYZeO3qM9OjoGZllWPezKDAEWcVC1iiXWKlyVKZuifq4C4Xpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzfKKy+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzfKKy+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8403EC4CEF8;
	Thu, 27 Nov 2025 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255837;
	bh=wDgvoydGhkbkvl8xs/oyXNM9+OYlrPblm/PxmpTUAmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzfKKy+3LXSm4fvwqaFciXfXj8OaMCka5JAasiLcQ3Fv8sN1fa568qP+8GbfrcgFj
	 LTqYHk3kABx9K5F2DPn6CF0rnQ8PEZGQCK9aFRn2MYNNBQVrJDsUkOWe93uw0OC0jD
	 YNRD5S8TQGnUj78rLroUn/jiE7XwMb66YKUHnFw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/175] perf: Fix 0 count issue of cpu-clock
Date: Thu, 27 Nov 2025 15:46:23 +0100
Message-ID: <20251127144047.706644888@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit f1f96511b1c4c33e53f05909dd267878e0643a9a ]

Currently cpu-clock event always returns 0 count, e.g.,

perf stat -e cpu-clock -- sleep 1

 Performance counter stats for 'sleep 1':
                 0      cpu-clock                        #    0.000 CPUs utilized
       1.002308394 seconds time elapsed

The root cause is the commit 'bc4394e5e79c ("perf: Fix the throttle
 error of some clock events")' adds PERF_EF_UPDATE flag check before
calling cpu_clock_event_update() to update the count, however the
PERF_EF_UPDATE flag is never set when the cpu-clock event is stopped in
counting mode (pmu->dev() -> cpu_clock_event_del() ->
cpu_clock_event_stop()). This leads to the cpu-clock event count is
never updated.

To fix this issue, force to set PERF_EF_UPDATE flag for cpu-clock event
just like what task-clock does.

Fixes: bc4394e5e79c ("perf: Fix the throttle error of some clock events")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20251112080526.3971392-1-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f13565d0eb699..970c4a5ab763b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11885,7 +11885,7 @@ static int cpu_clock_event_add(struct perf_event *event, int flags)
 
 static void cpu_clock_event_del(struct perf_event *event, int flags)
 {
-	cpu_clock_event_stop(event, flags);
+	cpu_clock_event_stop(event, PERF_EF_UPDATE);
 }
 
 static void cpu_clock_event_read(struct perf_event *event)
-- 
2.51.0



