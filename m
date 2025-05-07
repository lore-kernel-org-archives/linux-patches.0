Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EC442A83;
	Wed,  7 May 2025 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643878; cv=none; b=YsNlxAin0QWG0a71C1dgd6UZKDDwSvzqxTcxA9SNGGzR/zkazKdUmdBlJwteA+yZ0ZQjruaIz9o5E9sFyWfWr6IZ6ndgTUEU9SipggQyn0A41FK3dLFJvhv+IkrdijXE/DEZuQOkKnQfcj49UYBnQKwJmNZeKziMY3/IW5tc7RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643878; c=relaxed/simple;
	bh=a7fW2RTD7cbLC975lUNhG+forLaPNR8i+JBBWPbcSuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKnkJXb/H+w02gT4/Ys5oySiKB2bMaaR3bOGcprFejGp0YuXNILf0MpvTTISu16DE4S5qLieiqYJfWGvvXcoEHyutNTX6CdzXTETkwaAS5CLavwSnVl+yQT4ePoUDvpG0txEObGT+jxlRwhwyqCFiSHFBvI2+VUveaRHNtrfTbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvExMGoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvExMGoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BA9C4CEE2;
	Wed,  7 May 2025 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643878;
	bh=a7fW2RTD7cbLC975lUNhG+forLaPNR8i+JBBWPbcSuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvExMGoFOt6XEKNNdAV9ETtuBtnKFAGsX1TVht9NqIP3sgyRUWHfdA0F/96Jw4Ca9
	 6fAEYRN17+qi0CXdDTg5DceHhsVIfYuVrxYaUvd7cdT7vWsQIlHKzlgv5hYHVs/8aJ
	 Pr97cdtytbZYuipGATZ0cGtckgzvGMX+xDYUZBoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.14 017/183] perf/x86/intel: Only check the group flag for X86 leader
Date: Wed,  7 May 2025 20:37:42 +0200
Message-ID: <20250507183825.391916528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 75aea4b0656ead0facd13d2aae4cb77326e53d2f upstream.

A warning in intel_pmu_lbr_counters_reorder() may be triggered by below
perf command.

perf record -e "{cpu-clock,cycles/call-graph="lbr"/}" -- sleep 1

It's because the group is mistakenly treated as a branch counter group.

The hw.flags of the leader are used to determine whether a group is a
branch counters group. However, the hw.flags is only available for a
hardware event. The field to store the flags is a union type. For a
software event, it's a hrtimer. The corresponding bit may be set if the
leader is a software event.

For a branch counter group and other groups that have a group flag
(e.g., topdown, PEBS counters snapshotting, and ACR), the leader must
be a X86 event. Check the X86 event before checking the flag.
The patch only fixes the issue for the branch counter group.
The following patch will fix the other groups.

There may be an alternative way to fix the issue by moving the hw.flags
out of the union type. It should work for now. But it's still possible
that the flags will be used by other types of events later. As long as
that type of event is used as a leader, a similar issue will be
triggered. So the alternative way is dropped.

Fixes: 33744916196b ("perf/x86/intel: Support branch counters logging")
Closes: https://lore.kernel.org/lkml/20250412091423.1839809-1-luogengkun@huaweicloud.com/
Reported-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250424134718.311934-2-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c       |    2 +-
 arch/x86/events/perf_event.h |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -753,7 +753,7 @@ void x86_pmu_enable_all(int added)
 	}
 }
 
-static inline int is_x86_event(struct perf_event *event)
+int is_x86_event(struct perf_event *event)
 {
 	int i;
 
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -110,9 +110,16 @@ static inline bool is_topdown_event(stru
 	return is_metric_event(event) || is_slots_event(event);
 }
 
+int is_x86_event(struct perf_event *event);
+
+static inline bool check_leader_group(struct perf_event *leader, int flags)
+{
+	return is_x86_event(leader) ? !!(leader->hw.flags & flags) : false;
+}
+
 static inline bool is_branch_counters_group(struct perf_event *event)
 {
-	return event->group_leader->hw.flags & PERF_X86_EVENT_BRANCH_COUNTERS;
+	return check_leader_group(event->group_leader, PERF_X86_EVENT_BRANCH_COUNTERS);
 }
 
 struct amd_nb {


