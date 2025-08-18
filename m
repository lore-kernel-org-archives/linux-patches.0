Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0B33218B8;
	Mon, 18 Aug 2025 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521991; cv=none; b=UucuP/ywtPaWh51LXt+WwfJhn2mN391SVY1x3Uab4oEAPjv00wWk7KW4oWkZNUTUsCgBurcdaL3XTkft6CFWUI9mFkSqo1YKFrITuFzGmUfnjYC18HRDa3vfJn1czKLV9Xg2rnmUUF9eQLXMjHpC81UjToND8RrPeI9YevrYJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521991; c=relaxed/simple;
	bh=E4Fzpmj5gGC5YKtoc0poLJnzNfYtP8Ibrxny5g3NYpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHEg5clc534jXoJi+95h1wKt9NkMCm3RZFjwEKgR6m9a7JSv1s5fbD4fHtTjeSJsY3fy9aHqmHgN0vvnKSO1Uv37tqgYqEuO4VVDQxZHEaWTBLt4ZueRi6Y0z9W46JakyUtZ/TcvleHW/50kwDH1r6yzT9/5Vd5lv19XRZKJfyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7n7keac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7n7keac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3969C4CEEB;
	Mon, 18 Aug 2025 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521991;
	bh=E4Fzpmj5gGC5YKtoc0poLJnzNfYtP8Ibrxny5g3NYpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7n7keacejvabE6c/ZUXj2gpY14WGXN7DIJaj2jTOG4KQ9h+xOkSoAFghYBoQJs/+
	 i+/3W5A393MERkcXndM5XqNfPbUAmPOHkvoL0xK8blZJK0WfDYXBCl7RglSvDfNR4E
	 ak+FvISlJV5eXd8fWGRNzZAw1w/tXcdljSmJi+ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/444] pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()
Date: Mon, 18 Aug 2025 14:42:56 +0200
Message-ID: <20250818124454.532675953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



