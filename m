Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00B6321F56;
	Mon, 18 Aug 2025 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523462; cv=none; b=RYEKWzzqne8nRNIRCrx8bOAEYGoTzTi4yishuWBywA1ZDoJCtst+VCZs5RLK5K9TJKt6uULNa+2Xj6x4TcEAxK1vA45MnT8gDAktQwvD1B+rpNcQMQIH/AmgEC0DvIOZKB089DziDc3i84iHBg/mMSdIELSWr2pOgILVkKBkJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523462; c=relaxed/simple;
	bh=AXoz0UBU1wMnMabt9I+4TRFyLvg5zkLv9cGtLQDRSmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWQpNxT0xBOX2VD5BMk/5wcitJkJyh7QMS2+JTYyHwu6pTNoGZdsdEabhPTq/+18vx60BuSch/mqk7V/eipqP7rLkuu1b2kLZH2RONqqr7gRflFG+7lUyBtNr1/nMY6rvVrD9K7OkQ/uRiKm6fi1O/MwOQ84AMbT2z/lvCNH8xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slnn8lIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slnn8lIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33845C4CEEB;
	Mon, 18 Aug 2025 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523462;
	bh=AXoz0UBU1wMnMabt9I+4TRFyLvg5zkLv9cGtLQDRSmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slnn8lIE6KT+YqMkhPmpA2UxwBpqRdui5qw3SiHncuSozxUD6nvtTISZEfblJQaN2
	 1VNhEJdlXjOR2EVA8ZA4BN9OQpksd4xIyjl13EbEwfIO0eb1gFA/fK7OvX79vLQrdb
	 sWQhLV0af5whf8HOrGyeyXeuno/6phSL/CTGFt4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 178/515] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Mon, 18 Aug 2025 14:42:44 +0200
Message-ID: <20250818124505.218947102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit cda7ac8ce7de84cf32a3871ba5f318aa3b79381e ]

In the function mperf_start(), mperf_monitor snapshots the time, tsc
and finally the aperf,mperf MSRs. However, this order of snapshotting
in is reversed in mperf_stop(). As a result, the C0 residency (which
is computed as delta_mperf * 100 / delta_tsc) is under-reported on
CPUs that is 100% busy.

Fix this by snapshotting time, tsc and then aperf,mperf in
mperf_stop() in the same order as in mperf_start().

Link: https://lore.kernel.org/r/20250612122355.19629-2-gautham.shenoy@amd.com
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/idle_monitor/mperf_monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index 73b6b10cbdd2..5ae02c3d5b64 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -240,9 +240,9 @@ static int mperf_stop(void)
 	int cpu;
 
 	for (cpu = 0; cpu < cpu_count; cpu++) {
-		mperf_measure_stats(cpu);
-		mperf_get_tsc(&tsc_at_measure_end[cpu]);
 		clock_gettime(CLOCK_REALTIME, &time_end[cpu]);
+		mperf_get_tsc(&tsc_at_measure_end[cpu]);
+		mperf_measure_stats(cpu);
 	}
 
 	return 0;
-- 
2.39.5



