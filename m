Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72025335E;
	Wed,  5 Mar 2025 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198613; cv=none; b=SJ6D8gqTdFOFkO+L5D39xPnhyAPLHHN8X+GYQg7YMW4TVjaUpiLUQkafomyE2RgrenZTNbw8gpvKXQu169lxN4nf/zaBXqcACjiZu4UoVPNkLU55oEJW8iLBCbyg6ey4SN0ggMEOTJ77UfxGitn751b4Mxb6INqInxb63WKFXIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198613; c=relaxed/simple;
	bh=AdG6Q/CJ4+0H6Ql8t3a8MZEz72K7uQUsoxraESiITs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXEIDEyReVILJrShiv1CAdqW81LnoquJdOCmDyxjEfkznflMD4F934vT7/4bC0t6A8PmM6AXJVyM3/rj1+VdhMZme/D9S0nCHNT3TJohavzsF+iN/J6ssrAJW+ThGxsa+SeOYWiueZb98fG5YXbV556jgZv4b13E5d1L3cLr9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jl6iLsou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jl6iLsou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E64C4CED1;
	Wed,  5 Mar 2025 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198613;
	bh=AdG6Q/CJ4+0H6Ql8t3a8MZEz72K7uQUsoxraESiITs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jl6iLsouKofSUV31q3oxabnK4gHzQLmpDp3+pzTJUSedCTxETy4e8sISDVSJ0igTv
	 IJP3iu6jbDfl9taty8RcjdiJOxQ5Zfxtj0CSlWu1dXxlmF03Dkl8xMkDEQwSAZ1ZxI
	 dn4ZI+VdmGGOImZ6j+bkZGrgdRIUi67idH8Zy36g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.13 087/157] perf/x86: Fix low freqency setting issue
Date: Wed,  5 Mar 2025 18:48:43 +0100
Message-ID: <20250305174508.805127309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 88ec7eedbbd21cad38707620ad6c48a4e9a87c18 upstream.

Perf doesn't work at low frequencies:

  $ perf record -e cpu_core/instructions/ppp -F 120
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument)
  for event (cpu_core/instructions/ppp).
  "dmesg | grep -i perf" may provide additional information.

The limit_period() check avoids a low sampling period on a counter. It
doesn't intend to limit the frequency.

The check in the x86_pmu_hw_config() should be limited to non-freq mode.
The attr.sample_period and attr.sample_freq are union. The
attr.sample_period should not be used to indicate the frequency mode.

Fixes: c46e665f0377 ("perf/x86: Add INST_RETIRED.ALL workarounds")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250117151913.3043942-1-kan.liang@linux.intel.com
Closes: https://lore.kernel.org/lkml/20250115154949.3147-1-ravi.bangoria@amd.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -628,7 +628,7 @@ int x86_pmu_hw_config(struct perf_event
 	if (event->attr.type == event->pmu->type)
 		event->hw.config |= x86_pmu_get_event_config(event);
 
-	if (event->attr.sample_period && x86_pmu.limit_period) {
+	if (!event->attr.freq && x86_pmu.limit_period) {
 		s64 left = event->attr.sample_period;
 		x86_pmu.limit_period(event, &left);
 		if (left > event->attr.sample_period)


