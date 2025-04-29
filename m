Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91A524113C;
	Tue, 29 Apr 2025 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945930; cv=none; b=QXYo39UpGrF70CAxOnGlvoHsBXEpw1Ag+EZKd8cdjJ5AtMx84w8NWg7zJUR1uBOoybpwGRwr7ixjyJb1+aCmCfoefOWjJNFwBKH2x3KA6xJ3x0TiVbeme2oJFrrGzKS+opgW11PjoZXdrx68tyqVYvVKG815o9AApXlaBeWNdys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945930; c=relaxed/simple;
	bh=HhpsSZ96xsXWKXGfVN5t+004QE2KNRi5n8KxK0eeha8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/cvwYr69GP3zEZLW66E+UWuzGNP+zuTjBqVNBViAsys5n7Rj22YSG/xtN4w/KMHoM9LEp3e3LvWAVA2dfk8kowO4qJyiH/AIq5F7RzP/TU/R14fTSUE6tJP4uvtom6O+9xY6oIaW47ktNO3htvinu3a5Y/qbPW6qjQQllsFAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQbRmw1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQbRmw1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA24C4CEE9;
	Tue, 29 Apr 2025 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945930;
	bh=HhpsSZ96xsXWKXGfVN5t+004QE2KNRi5n8KxK0eeha8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQbRmw1j83Ly4glvRP0ClU0GLOKNg3HJVdV4rwV/D6aSMMcIi83gvHNBdMW2Dxzo1
	 qmgLyhXIybxUGtKp2Hk/NJQuy2SnppgSS0ZGPMCqcVbakX8C2WC6PW9JD8jdd8QgZF
	 fog7Svnh8QRanwhOiILZrTTQ733QuE1/HR52p21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 098/311] perf/x86: Fix non-sampling (counting) events on certain x86 platforms
Date: Tue, 29 Apr 2025 18:38:55 +0200
Message-ID: <20250429161125.055247325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 1a97fea9db9e9b9c4839d4232dde9f505ff5b4cc ]

Perf doesn't work at perf stat for hardware events on certain x86 platforms:

 $perf stat -- sleep 1
 Performance counter stats for 'sleep 1':
             16.44 msec task-clock                       #    0.016 CPUs utilized
                 2      context-switches                 #  121.691 /sec
                 0      cpu-migrations                   #    0.000 /sec
                54      page-faults                      #    3.286 K/sec
   <not supported>	cycles
   <not supported>	instructions
   <not supported>	branches
   <not supported>	branch-misses

The reason is that the check in x86_pmu_hw_config() for sampling events is
unexpectedly applied to counting events as well.

It should only impact x86 platforms with limit_period used for non-PEBS
events. For Intel platforms, it should only impact some older platforms,
e.g., HSW, BDW and NHM.

Fixes: 88ec7eedbbd2 ("perf/x86: Fix low freqency setting issue")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250423064724.3716211-1-luogengkun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3a27c50080f4f..ce8d4fdf54fbb 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -628,7 +628,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == event->pmu->type)
 		event->hw.config |= x86_pmu_get_event_config(event);
 
-	if (!event->attr.freq && x86_pmu.limit_period) {
+	if (is_sampling_event(event) && !event->attr.freq && x86_pmu.limit_period) {
 		s64 left = event->attr.sample_period;
 		x86_pmu.limit_period(event, &left);
 		if (left > event->attr.sample_period)
-- 
2.39.5



