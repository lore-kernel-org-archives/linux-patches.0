Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5942EE262;
	Tue, 31 Mar 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974724; cv=none; b=dBD1O6cIVimV5Mx3/nDym7Vi5NVcZAka4xK752Xkn8u17bt1JA/rDT98A5PPJ9QuigAXuoROyaeZ3/Rt4nTSRD8mczL4Z6+QBxn52zqHtIdCfGtvAkPWSH8cFfwhSl7bup5tflljOhPRUIdmkxi6MnSx/qP3z5Nrpuxp3t2dFmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974724; c=relaxed/simple;
	bh=yNAioYHyMt9a+xKRysMcaYazigqequpv2Xqja5/vzls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGZzXgUadI2I6WrBzZfGkIbUj1HM4J3llh5tTGOMmYArNZ9I6yreZ8jvqpbhr/6I1MpJbbRtkaDx6jSYoj2iB4GUrs5Mk6BfGuDK1fA2JgabI7uGEbc9gKYZN1d937FQnEIQbnFcW6jM+TYfbFzZTVSqMxEf7ZFwU3FY19ao2jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbSykYj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbSykYj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C55C19423;
	Tue, 31 Mar 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974723;
	bh=yNAioYHyMt9a+xKRysMcaYazigqequpv2Xqja5/vzls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbSykYj3GoYpEtRm7EYeR0cWnDMt173/0lHCgFHznK/sfTNTvnmQCaUwcfZO4Mmkf
	 ro5n9XWBATGt40h0x5eNmsdkKdYA+3tDXhgx1jAn2o04oWuG91R3F+1OF29lTuXfTd
	 logfJCnaiESjbSP51J8yI4A0xtre5KixZIx2KJlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 005/342] x86/perf: Make sure to program the counter value for stopped events on migration
Date: Tue, 31 Mar 2026 18:17:18 +0200
Message-ID: <20260331161759.110873067@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f1cac6ac62d28a9a57b17f51ac5795bf250c12d3 ]

Both Mi Dapeng and Ian Rogers noted that not everything that sets HES_STOPPED
is required to EF_UPDATE. Specifically the 'step 1' loop of rescheduling
explicitly does EF_UPDATE to ensure the counter value is read.

However, then 'step 2' simply leaves the new counter uninitialized when
HES_STOPPED, even though, as noted above, the thing that stopped them might not
be aware it needs to EF_RELOAD -- since it didn't EF_UPDATE on stop.

One such location that is affected is throttling, throttle does pmu->stop(, 0);
and unthrottle does pmu->start(, 0); possibly restarting an uninitialized counter.

Fixes: a4eaf7f14675 ("perf: Rework the PMU methods")
Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260311204035.GX606826@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 818de24921a48..7a6b15b0f1c66 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1371,8 +1371,10 @@ static void x86_pmu_enable(struct pmu *pmu)
 
 			cpuc->events[hwc->idx] = event;
 
-			if (hwc->state & PERF_HES_ARCH)
+			if (hwc->state & PERF_HES_ARCH) {
+				static_call(x86_pmu_set_period)(event);
 				continue;
+			}
 
 			/*
 			 * if cpuc->enabled = 0, then no wrmsr as
-- 
2.51.0



