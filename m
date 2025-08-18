Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68283335BAF;
	Mon, 18 Aug 2025 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525215; cv=none; b=Tbh/YklbSN6tBsfd6fpChyv2rHRP/Vkq1nfPRibJj92rjAmRhR7FBe5wYQwzK8XngjrAHRlg2+3VOQ2Hb2lrHCkF/tttlVyzvpUk7AAIiRNQEGnMSkP6In3qhR2T6dfxSJBtorlNzCnNXB0BH7f1RaVpE06ACa2if/WHmbYjrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525215; c=relaxed/simple;
	bh=sj6RwnaWB49B/YEtEW8HFGcqMPAU5EWSzsn6OjSLlCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co/q5XN2BMwTdA+8lJitl4NNdKkOOTJntZT8s8ruNOok9mLIhRhyV/Yp5MdnKRNakXnvMEyD6uGSlKyXOXil2woFRg/EKOn6qqLVmFcN3AH2HMn4n5cbEJv91ZcIZ9Fw2WibfztLulK39WttP63vaeC9zcRW5USMWOJQk6G0F00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl3tZHVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl3tZHVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DD0C4CEEB;
	Mon, 18 Aug 2025 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525215;
	bh=sj6RwnaWB49B/YEtEW8HFGcqMPAU5EWSzsn6OjSLlCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl3tZHVd/2rfvFT56y50kT4pGnhWgq5nz0b5GV6WEohcX4tzjBaJWXcFyr4DdaRsb
	 Pc2se0JrfolgHD8Gb2nEn8oFtboJLwz7g+PDFtIkJgDoYHdYoraIbNwGEN+XzPuEfB
	 HdEfvH0WYSuNUszV1a41DqQWvvrcINZ3nZ/KMtk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 194/570] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Mon, 18 Aug 2025 14:43:01 +0200
Message-ID: <20250818124513.273927184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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



