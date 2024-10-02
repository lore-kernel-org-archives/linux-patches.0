Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1EF29CE7;
	Wed,  2 Oct 2024 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876940; cv=none; b=Qh85nIBoaXEEW0ot6cUUu53CvW1eVLdy8KZU0nlpF0DmaVl8vmA0brLVVKTWRfUDlV/hvDxig9WAwz3otERGgQo3MWA2vnMHg6A0Z8x05C7tkgBrhYO7g+ds/+mK//XR9kcrN1dnwOzII8CpFS/XBppyqbc7288IwkZ0fNuW734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876940; c=relaxed/simple;
	bh=fk/M+HGG0IhK7TRKcn2tdJifL3IRa6BDTssLVy6XgaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWsXfFSJPJvryl59iAVaE3H104dF6dO/hxSe9N1wEzGfBA6Vj4++PRfy49ImkeKOqdFwZXkNi0upJkRvbPY2b25wrj3UX/hFg3vxY/axuoz1HSBU/UKQKsRmLIQAOqgqzQiM9WWZgKNfuhyj2oHlMS3OguA/AziRLHEg+e8ZpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra/mO2zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra/mO2zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A5EC4CEC2;
	Wed,  2 Oct 2024 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876939;
	bh=fk/M+HGG0IhK7TRKcn2tdJifL3IRa6BDTssLVy6XgaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ra/mO2zuQpnltygKTABb+WhrCnPhG/hNxL1OAIro46ITeHRLPd2I6ufeAZ1/vjDS1
	 UFgH00zQHuj7gOYoR8idQRWScLfr+z62qk99IY3fTp0fVBHa6Sb2OdQsE/RtG024bw
	 Iqy+mUBJF8sRNRqS7MRTpTEXNEC7ceLYkqxqhLjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.11 611/695] perf/x86/intel: Allow to setup LBR for counting event for BPF
Date: Wed,  2 Oct 2024 15:00:09 +0200
Message-ID: <20241002125846.903382310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3972,8 +3972,12 @@ static int intel_pmu_hw_config(struct pe
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


