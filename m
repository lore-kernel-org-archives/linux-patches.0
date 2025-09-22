Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB6827B320;
	Mon, 22 Sep 2025 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569874; cv=none; b=O7X8+ybA/zQRp4+d1+8y+h3493g+uXxMj1kqvfdWUf/5tNLnKTaZofFGpwfFJd+czfngtssngpCo9CwQnw0cXG1IOSkqN1eyc4YdZHLSqa5ZBSl6icZk1HWpfxh3tMnd9xZNbaZ3Tm6R06uOhv1O1UFVJo14niod1LRtyDzvipo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569874; c=relaxed/simple;
	bh=cr60HvZ34oheV/X9RIZJPLj+48uUvrQ8eIkUBSIaXz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMzIbfiwy7SV2lqwna2zbh+fwKaL78yehcZAhQ+3dIqGxIEdG+x6oF9VVMHG/ZzgCikM3t7NqOpT84m4yLdaJUrTDn9+Vy9/lBOfs8P/sGekDwBroBQO+CaJKCXwNyNs/pFDtIjTmZzMfUB+sIXWQawl8VvXyXcNnVjoxgWsgTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5SyJdLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5SyJdLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3380AC4CEF0;
	Mon, 22 Sep 2025 19:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569874;
	bh=cr60HvZ34oheV/X9RIZJPLj+48uUvrQ8eIkUBSIaXz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5SyJdLaUDVunJsQ/i8AZNsiyEVr1CCwLkgXS7i197n8GHvccnbO26Tj/bHcfmYlL
	 RJt0EoqUahvZxtfxhKY44FsHQQqDeX3jC2ljL4Y3XUpjjsAkZVu6jwxQ3NkB3H3GMO
	 ieIvvT8igPB/FcdP7LBtZNqFSzpm8+TUw/+xyq8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vince Weaver <vincent.weaver@maine.edu>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Angel Adetula <angeladetula@google.com>
Subject: [PATCH 6.12 033/105] perf/x86/intel: Fix crash in icl_update_topdown_event()
Date: Mon, 22 Sep 2025 21:29:16 +0200
Message-ID: <20250922192409.779383460@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

commit b0823d5fbacb1c551d793cbfe7af24e0d1fa45ed upstream.

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
Signed-off-by: Angel Adetula <angeladetula@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2793,7 +2793,7 @@ static void intel_pmu_read_event(struct
 		if (pmu_enabled)
 			intel_pmu_disable_all();
 
-		if (is_topdown_event(event))
+		if (is_topdown_count(event))
 			static_call(intel_pmu_update_topdown_event)(event);
 		else
 			intel_pmu_drain_pebs_buffer();


