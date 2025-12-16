Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421835970D;
	Tue, 16 Dec 2025 12:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886687; cv=none; b=P6DBbLQyYXkmpcGk7Oq67UqTEmYhClztLXDBunUV2bhvRI/hLPCmDBN6w5SBmMR6JE8jjd214xn0kvW3epEV/6KrE1dBqgIqbDh5/4jByk4UALEBPGof0ajGhP3DRtBbzkshj8M0r3AK1BZ7EI0wEdaLuHIp49w5c1kZ0ocNa44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886687; c=relaxed/simple;
	bh=gvx3IIxl54o/IK2IjtWIy2KvCEgiFwvGmk8bG5qmhF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogqka+SgLOVNMaSUAT4n5IePuWFljCT1S9c4I9b6RrWfEanrXpN65ehvLCQP8svA5bqqF7GYPWmNRDz/Ts4Bo5DojP6KLm0R/l4wFlVnsMOzV4HceVidFIVqILovBLLJz6Ca5gemLFYkTvHSU/Ht2Dk/Wf7ggjFND/43+2ThtTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIdWoVoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIdWoVoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60132C4CEF5;
	Tue, 16 Dec 2025 12:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886686;
	bh=gvx3IIxl54o/IK2IjtWIy2KvCEgiFwvGmk8bG5qmhF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIdWoVoGeG1q/fAchq6XyzMwtHuWXVcQV9YF0ogNqlvjfWxgqzI0+N0a5vxGOS8WU
	 JpDRpBuW98U2a/NL3HsA0vDKD7jnbDd+Ju5Mb3Tz2yOQQFo2r7/YhOYvoNCkhwDSvI
	 4GY1tIRI34wjz7hiJuxpFsvRu0Bk0C+psDsrFENY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kitta <kitta@linux.alibaba.com>,
	Evan Li <evan.li@linux.alibaba.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 497/507] perf/x86/intel: Fix NULL event dereference crash in handle_pmi_common()
Date: Tue, 16 Dec 2025 12:15:38 +0100
Message-ID: <20251216111403.445060892@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evan Li <evan.li@linux.alibaba.com>

[ Upstream commit 9415f749d34b926b9e4853da1462f4d941f89a0d ]

handle_pmi_common() may observe an active bit set in cpuc->active_mask
while the corresponding cpuc->events[] entry has already been cleared,
which leads to a NULL pointer dereference.

This can happen when interrupt throttling stops all events in a group
while PEBS processing is still in progress. perf_event_overflow() can
trigger perf_event_throttle_group(), which stops the group and clears
the cpuc->events[] entry, but the active bit may still be set when
handle_pmi_common() iterates over the events.

The following recent fix:

  7e772a93eb61 ("perf/x86: Fix NULL event access and potential PEBS record loss")

moved the cpuc->events[] clearing from x86_pmu_stop() to x86_pmu_del() and
relied on cpuc->active_mask/pebs_enabled checks. However,
handle_pmi_common() can still encounter a NULL cpuc->events[] entry
despite the active bit being set.

Add an explicit NULL check on the event pointer before using it,
to cover this legitimate scenario and avoid the NULL dereference crash.

Fixes: 7e772a93eb61 ("perf/x86: Fix NULL event access and potential PEBS record loss")
Reported-by: kitta <kitta@linux.alibaba.com>
Co-developed-by: kitta <kitta@linux.alibaba.com>
Signed-off-by: Evan Li <evan.li@linux.alibaba.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251212084943.2124787-1-evan.li@linux.alibaba.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220855
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 52270268144c2..76cd840e33e30 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3249,6 +3249,9 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
+		/* Event may have already been cleared: */
+		if (!event)
+			continue;
 
 		/*
 		 * There may be unprocessed PEBS records in the PEBS buffer,
-- 
2.51.0



