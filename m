Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F1B1D0F46;
	Wed,  2 Oct 2024 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878917; cv=none; b=nh30wuGCNVWOS3kCm0wviPtXEj08kcq6dH86rKdUMzbFze4p71Ghz0TWBF/BbQZEs+u8US+mV8f2H8qQmPUjZ0vi0VYwfG1UWCPjx6HBm8jr1SdrOMltTDcWjGn6YMavGPeA0M84UlB53NrG08ZzV42MfrsrsWFpTzKsWJ2BX1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878917; c=relaxed/simple;
	bh=b3kL94vaT015T6POcEaNWIouC54DJmMw/YxMUXWjHLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2Mn358fln+l1F4VUcJj8McTlbwt0aZLi0giGWbyf3X2oNUEJryOZ5ln/LhnUOAcFsl2U0xTB1TWI3LLVruTuirJYOAJxj2tSvjb8HBNV/1uVeP/a6Px6GeRL8fnN2gAOlHWs3AT7POpzHSvH4p5JT828Fr0wOOb/MaDDsU6PrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAUtKygC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAUtKygC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26BCC4CEC2;
	Wed,  2 Oct 2024 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878917;
	bh=b3kL94vaT015T6POcEaNWIouC54DJmMw/YxMUXWjHLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAUtKygCxq3kWHoG0MFgPmFh1KxKRS9YUFFO8qAbrn2VZcUdfnuT2uNtBe/qQeMA+
	 eR4f6miDtocXLI3BnLYm4yX1+mpzeFxzlxfZliwMF6fWxhY5rezYOJH2+tdXqjUvh0
	 /HvwOn6sozDh/dBrGUsHc46Vy12HfOvLGrE+h4G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.10 545/634] perf/x86/intel: Allow to setup LBR for counting event for BPF
Date: Wed,  2 Oct 2024 15:00:45 +0200
Message-ID: <20241002125832.621627303@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit ef493f4b122d6b14a6de111d1acac1eab1d673b0 upstream.

The BPF subsystem may capture LBR data on a counting event. However, the
current implementation assumes that LBR can/should only be used with
sampling events.

For instance, retsnoop tool ([0]) makes an extensive use of this
functionality and sets up perf event as follows:

	struct perf_event_attr attr;

	memset(&attr, 0, sizeof(attr));
	attr.size = sizeof(attr);
	attr.type = PERF_TYPE_HARDWARE;
	attr.config = PERF_COUNT_HW_CPU_CYCLES;
	attr.sample_type = PERF_SAMPLE_BRANCH_STACK;
	attr.branch_sample_type = PERF_SAMPLE_BRANCH_KERNEL;

To limit the LBR for a sampling event is to avoid unnecessary branch
stack setup for a counting event in the sample read. Because LBR is only
read in the sampling event's overflow.

Although in most cases LBR is used in sampling, there is no HW limit to
bind LBR to the sampling mode. Allow an LBR setup for a counting event
unless in the sample read mode.

Fixes: 85846b27072d ("perf/x86: Add PERF_X86_EVENT_NEEDS_BRANCH_STACK flag")
Closes: https://lore.kernel.org/lkml/20240905180055.1221620-1-andrii@kernel.org/
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240909155848.326640-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3912,8 +3912,12 @@ static int intel_pmu_hw_config(struct pe
 			x86_pmu.pebs_aliases(event);
 	}
 
-	if (needs_branch_stack(event) && is_sampling_event(event))
-		event->hw.flags  |= PERF_X86_EVENT_NEEDS_BRANCH_STACK;
+	if (needs_branch_stack(event)) {
+		/* Avoid branch stack setup for counting events in SAMPLE READ */
+		if (is_sampling_event(event) ||
+		    !(event->attr.sample_type & PERF_SAMPLE_READ))
+			event->hw.flags |= PERF_X86_EVENT_NEEDS_BRANCH_STACK;
+	}
 
 	if (branch_sample_counters(event)) {
 		struct perf_event *leader, *sibling;


