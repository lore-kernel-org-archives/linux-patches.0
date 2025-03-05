Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E61C6FF9;
	Wed,  5 Mar 2025 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197693; cv=none; b=CMff5pMsFM6i6omZTfcvBWM7skmbKgIlTEmCTg9Jrgfkc+IjGaRFfkOW7YzEcqRUNllC4kryXeVMdua39xF+UM+2323YRTUoi8Rf6RwDVh2z3e5QyOi0+i3QBXLzyL5tg3O6HFKhNiUUpHrKllfrnafcgs144s43sFDfgXX6p8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197693; c=relaxed/simple;
	bh=F/Jf79ynabxlSZrqzXtvsRh0KzsZwE9KdQeSJ0ylb58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyKe1bL2Z8z8K2ST/x6c24+PFsG7G9GHpFo7aC+dXZl8vuevTEE4TXoOW0o51k57dzZzPY/NiLzLrgWmnDVFqgLTBnFEKcROru82JKnY0AM6aGMT++CnCd0CYrmCmbs/l9j3+quVqxxHdGvTtp/0QBbXI8r/qN/bhTQ66SaavpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3LSCEL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3LSCEL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B362BC4CED1;
	Wed,  5 Mar 2025 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197693;
	bh=F/Jf79ynabxlSZrqzXtvsRh0KzsZwE9KdQeSJ0ylb58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3LSCEL48Sg7hx7wAJtfzMLnAD2fghvEKBBIMme28gdB6ypBZDdOHvI1PcsT8IvlZ
	 uiPYrmxI/5kp1/+17bwWAaZTJXYMh1NUZopyPLWLvTavph87S4Ti+hg6GBHwPM21/P
	 tips4oA8aQgHnha+rjlfg2EzGm6u3hCaa/9A54QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.6 066/142] perf/x86: Fix low freqency setting issue
Date: Wed,  5 Mar 2025 18:48:05 +0100
Message-ID: <20250305174502.991314150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -623,7 +623,7 @@ int x86_pmu_hw_config(struct perf_event
 	if (event->attr.type == event->pmu->type)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-	if (event->attr.sample_period && x86_pmu.limit_period) {
+	if (!event->attr.freq && x86_pmu.limit_period) {
 		s64 left = event->attr.sample_period;
 		x86_pmu.limit_period(event, &left);
 		if (left > event->attr.sample_period)


