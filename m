Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E7322A1E;
	Tue, 26 Aug 2025 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214995; cv=none; b=cHYHXMQdPD5Gs5hHcxZXah8LMnSgsVsquVD9Z0LnbVYg1M3oET1xX5QcTtOF5Kqs1DpUU/IHOByX5Qmo8FxLoncyzCE8macz51a9ACuwsk8yiq94VVjZ+SV8ZdkFkTqTzT8c+GGGQQcHPhtCHuzHN6FCgjJrPzWqBWxD385qeqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214995; c=relaxed/simple;
	bh=Sz1wEg9qLpJj7KWIgpcoWkYFk2OhfgzyhzY38GwgMsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF/hGKC7/dYjFtFBvJinR3p1QKdA1H6qD2D8oGxa1G5o5a1CpULs9mrMjGd1CZcIlnqP4mJyx6KyfPeCHvShx59va6IpO1yRcwF31CleI5bc+3IBZUXYALSsie+iTc14+y/JxBzUe7aLV30HZEBIJOpIOKNwupML7V+udVLp+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jB1CjeXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jB1CjeXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8998C4CEF1;
	Tue, 26 Aug 2025 13:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214995;
	bh=Sz1wEg9qLpJj7KWIgpcoWkYFk2OhfgzyhzY38GwgMsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jB1CjeXLLAVaOaqcTIOwc9W2da9XpZn4v8XDzuIdNBa/OGJMIYrsF/9h71vYX8a4N
	 ePlF+3029Shk5Dk1WT8TngGq1u1P2jRsu+lbrDGvxdJd6AVLPivO3+IBK9/o2r+YIB
	 fRLgV7j5yMTWyT8kA/olBzWAosVrG0kElBeAD5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vince Weaver <vincent.weaver@maine.edu>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 346/482] perf/x86/intel: Fix crash in icl_update_topdown_event()
Date: Tue, 26 Aug 2025 13:09:59 +0200
Message-ID: <20250826110939.378195558@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit b0823d5fbacb1c551d793cbfe7af24e0d1fa45ed ]

The perf_fuzzer found a hard-lockup crash on a RaptorLake machine:

  Oops: general protection fault, maybe for address 0xffff89aeceab400: 0000
  CPU: 23 UID: 0 PID: 0 Comm: swapper/23
  Tainted: [W]=WARN
  Hardware name: Dell Inc. Precision 9660/0VJ762
  RIP: 0010:native_read_pmc+0x7/0x40
  Code: cc e8 8d a9 01 00 48 89 03 5b cd cc cc cc cc 0f 1f ...
  RSP: 000:fffb03100273de8 EFLAGS: 00010046
  ....
  Call Trace:
    <TASK>
    icl_update_topdown_event+0x165/0x190
    ? ktime_get+0x38/0xd0
    intel_pmu_read_event+0xf9/0x210
    __perf_event_read+0xf9/0x210

CPUs 16-23 are E-core CPUs that don't support the perf metrics feature.
The icl_update_topdown_event() should not be invoked on these CPUs.

It's a regression of commit:

  f9bdf1f95339 ("perf/x86/intel: Avoid disable PMU if !cpuc->enabled in sample read")

The bug introduced by that commit is that the is_topdown_event() function
is mistakenly used to replace the is_topdown_count() call to check if the
topdown functions for the perf metrics feature should be invoked.

Fix it.

Fixes: f9bdf1f95339 ("perf/x86/intel: Avoid disable PMU if !cpuc->enabled in sample read")
Closes: https://lore.kernel.org/lkml/352f0709-f026-cd45-e60c-60dfd97f73f3@maine.edu/
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: stable@vger.kernel.org # v6.15+
Link: https://lore.kernel.org/r/20250612143818.2889040-1-kan.liang@linux.intel.com
[ omitted PEBS check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2703,7 +2703,7 @@ static void intel_pmu_read_event(struct
 		if (pmu_enabled)
 			intel_pmu_disable_all();
 
-		if (is_topdown_event(event))
+		if (is_topdown_count(event))
 			static_call(intel_pmu_update_topdown_event)(event);
 		else
 			intel_pmu_drain_pebs_buffer();


