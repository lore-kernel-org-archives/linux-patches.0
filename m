Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF6547042;
	Thu, 17 Sep 2026 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670789; cv=none; b=dYzKh1YAzNDpLP9jRbBIWFstz/l64Kk6e+Kmv8LpjS9iDi/DsevVWc3Xfcji8Gs2/vVv/aRb3RkcLtEUoGJSq0XlD90dK+i8cjKJW1kGW/BRYQ6V709+NTaBnJIUjK6i5I3BJc8f1kGjijaiB0IYWxEgi+v7yEW/XokPIbhBuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670789; c=relaxed/simple;
	bh=inOhPOEpk9jJsr0+RNlrbZUNNUDgcZ0lEr6HbXQxk8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO+1wYYMIrJ4y5l42ZmPhobs2iNkTDnziNYB+86O1XMuGzt0OHdLH+//ubHOeto6Bjgp0uZPw6A6fpZiTeJFwuYOAzR6t4o9QswowysOfzesjD88SKOFTMloW3RNkb2Uki6v80QTsbuPvB5B9Rs/E0GIrUuF7c/uJ9felG0fqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecEud7an; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecEud7an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D331F000FF;
	Thu, 17 Sep 2026 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670788;
	bh=RNi4cZTLD3oNJC2PdiyOp7cxQo5W7S1ub9xMye+sS6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecEud7annZsZfnHGl0j0jwOqHSxNyjSKqjs11jFt13IC3Bqnj6Wu7gGVa1UZpXdTh
	 Cy6eEVxcbM7t/UZfppZcePPevyZr4CKsSHH7zMXwqdjFTYG/KPW4imhWrK29Xvbmml
	 LQCvv8jk5qsWu+kBUyAA5dNQz/e/bPxpz/xzeYHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Yabin Cui <yabinc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0771/1102] perf/core: Check sample_type in perf_sample_save_callchain
Date: Thu, 17 Sep 2026 16:11:54 +0100
Message-ID: <20260917151559.804931464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yabin Cui <yabinc@google.com>

[ Upstream commit f226805bc5f60adf03783d8e4cbfe303ccecd64e ]

Check sample_type in perf_sample_save_callchain() to prevent
saving callchain data when it isn't required.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240515193610.2350456-3-yabinc@google.com
Stable-dep-of: 88aa1223bfff ("perf/x86/intel: Correct pt_regs->flags update for PEBS path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c  | 3 +--
 arch/x86/events/intel/ds.c | 6 ++----
 include/linux/perf_event.h | 5 +++++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index d34ee6f04f18f..1022d1dcbe447 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1138,8 +1138,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	 * recorded as part of interrupt regs. Thus we need to use rip from
 	 * interrupt regs while unwinding call stack.
 	 */
-	if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(&data, event, iregs);
+	perf_sample_save_callchain(&data, event, iregs);
 
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index d9e37ae5181f7..8a25b56a91dcf 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1771,8 +1771,7 @@ static void setup_pebs_fixed_sample_data(struct perf_event *event,
 	 * previous PMI context or an (I)RET happened between the record and
 	 * PMI.
 	 */
-	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(data, event, iregs);
+	perf_sample_save_callchain(data, event, iregs);
 
 	/*
 	 * We use the interrupt regs as a base because the PEBS record does not
@@ -1939,8 +1938,7 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	 * previous PMI context or an (I)RET happened between the record and
 	 * PMI.
 	 */
-	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(data, event, iregs);
+	perf_sample_save_callchain(data, event, iregs);
 
 	*regs = *iregs;
 	/* The ip in basic is EventingIP */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 79994d079e505..e0af9788e656e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1286,6 +1286,11 @@ static inline void perf_sample_save_callchain(struct perf_sample_data *data,
 {
 	int size = 1;
 
+	if (!(event->attr.sample_type & PERF_SAMPLE_CALLCHAIN))
+		return;
+	if (WARN_ON_ONCE(data->sample_flags & PERF_SAMPLE_CALLCHAIN))
+		return;
+
 	data->callchain = perf_callchain(event, regs);
 	size += data->callchain->nr;
 
-- 
2.53.0



