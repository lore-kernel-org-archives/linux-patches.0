Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2454C8635C;
	Tue, 26 Aug 2025 13:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214350; cv=none; b=OqsgxLIVgVIvdftDd4DPQ1jvxC4If1iJgpEvHC/4Inw/vK+CSTKYnNI25tiQWa5mkxFfd+H65FgRbyE5IQvjzRVQXzdDJp9Q7p17vWb2/rRgoTK+fYoiIDvv39kioDoGNRXsaGrDNpTKdzStTaoICtrPXwbRk6DyQvSMv5R3wmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214350; c=relaxed/simple;
	bh=JE5r3DTSTQDH6/GDGNI/N/cWRsauOm6IT8VP9uzk9Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J76/h9ybsCne6iJfH/ZYeHkvtaRWWRL+0ZpiTBkHFPNflNw0mk4dnAukp+zoYFUBzlUXt63/L8zdNN3YCiO2S0HT+Ftx/Jl5cWJDg7NMuc6y38dycrJvI8st+ImMJVTYSrLePe+cBjnFZh523Fmtzy8hS4Fazapb0YkWphhDASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+zfLqbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+zfLqbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C1C113CF;
	Tue, 26 Aug 2025 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214350;
	bh=JE5r3DTSTQDH6/GDGNI/N/cWRsauOm6IT8VP9uzk9Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+zfLqbBnJcvKT7YLQIAbHstUlMjEW1O8zxU5TFifzjppfQI2/flN1dHp/ly3vVxW
	 p6W8NWlI0lU1vKuTV6EngUTaNZVOj4yyezR/u+Ul+2tjX/xg8gcxMJctHfHDS517Dc
	 o1IAzPDcqcveX7iZXvzmMLsvu1J6AjFs6yGAuNL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/482] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Tue, 26 Aug 2025 13:05:58 +0200
Message-ID: <20250826110933.420995798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08a399b0be28..6ab9139f16af 100644
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



