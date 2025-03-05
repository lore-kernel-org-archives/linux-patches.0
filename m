Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20471C6FFE;
	Wed,  5 Mar 2025 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197422; cv=none; b=U0/WYn7dRnhlHLMR/M1GOtOYpKlrVzGuAOmIDiQkbAKP5HFPYukicR1A3vwIwOMUtlV7DXLpojBnfD/i5i8Bnxpde5KUCtYju7n408I8xMVdupiHnKOti5l0jEgCsKYREUMDzFRbOCpEFhvir6PQgyTJRBQH8uo3CI1g5df20ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197422; c=relaxed/simple;
	bh=ky/ecm6wlp5ZK7ur6pUfejkOqoV8cAT/KY09WPcPuHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZDQaDFwV14/2ZWTVeCTHSMjFftMZRPFSdNrssM5SeEOCv846mdRz491aG1fDm70v8nDsR9GcS65ANKRPjBkx1jYu6V4QiuPGNfUxlLw7G7RArMw6+SVGHITPedq2/5DhYt1rSkItCjEZDxQiy5p+BceylgrN0jsOcrK12Spxg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtrE56Ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtrE56Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C2C4CED1;
	Wed,  5 Mar 2025 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197421;
	bh=ky/ecm6wlp5ZK7ur6pUfejkOqoV8cAT/KY09WPcPuHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtrE56KsPEjPuj5Mlj/fCr5otKWEIsEdIoL9ZQuL9clvvPj1X6jg3WRZojOd587Oi
	 bREdbgRooV0IFZ3PvMrbHFORiSwUFod3Xz9bix9BBsGcJ4BnoShQD80VsOkII2VGeA
	 yxkNj2K8j9fs7FgvaymbHX/cS6sc94g8YgAmCw+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 151/176] perf/x86: Fix low freqency setting issue
Date: Wed,  5 Mar 2025 18:48:40 +0100
Message-ID: <20250305174511.501583581@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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


