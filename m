Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C73C3F56;
	Wed, 30 Sep 2026 19:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795483; cv=none; b=X51LMZwo6SN8uSTHWZMhcHY2qKNq/QQeP1uYT1KkWpS+T3tWAiparK/+zHkh/xc4q9b6VQh8GKcpKbTxQpdV++LPM5mi4w9Rm3ElqbBKWGgPHziGJKL52/QdundC0tQTYJquO4MCvoo8O9Vv9VyYf0S9AFMVxIhxm3Q6zqclSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795483; c=relaxed/simple;
	bh=SVRocBfCK8TXoHm2r2ZCBOZTUxATamSIJMgMf5Bah7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mU8HWfvKT1T9VoNCxrKvM6ogpXA4E/vAXwdpupnHYeXoo13cgefcEYqfncb47IZ0MWqFUxmlHTdeHhyBpmTtBfEGh+8ruxyB4ntPGvHn1Bn8WoFYMf/WfM45WjfW5R7Y4Bjda4tPAp2aRXp1OZj6md17Cu9xgOVNY55BESYSSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8hnVJjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8hnVJjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B041F000FF;
	Wed, 30 Sep 2026 19:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795482;
	bh=3GaDz7gStaDaJgae2eprLguwL+I6MaqqYQ4Qq1YnmKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8hnVJjvCXAPZi6ew1C9ef/0YcG6tfQ5g4Btvm5W/hjOM2b9+OX8Caxh3GTiJVaa7
	 u6F2dQOX5ehFAkRHsTOGHMenLb+qFwE8nYI8sSjEXh0opGW6MctRyFZIJ/uLmJvm8k
	 kKB73ETYNF0tUyBNJ772M/dTf0GNtIIvPMp4hRkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Yabin Cui <yabinc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0578/1193] perf/core: Check sample_type in perf_sample_save_callchain
Date: Wed, 30 Sep 2026 17:21:02 +0200
Message-ID: <20260930152447.083495943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fac3d97111b09..ec1b8a193e612 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1135,8 +1135,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	 * recorded as part of interrupt regs. Thus we need to use rip from
 	 * interrupt regs while unwinding call stack.
 	 */
-	if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(&data, event, iregs);
+	perf_sample_save_callchain(&data, event, iregs);
 
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7dcf5305d695d..025a82d55981a 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1656,8 +1656,7 @@ static void setup_pebs_fixed_sample_data(struct perf_event *event,
 	 * previous PMI context or an (I)RET happened between the record and
 	 * PMI.
 	 */
-	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(data, event, iregs);
+	perf_sample_save_callchain(data, event, iregs);
 
 	/*
 	 * We use the interrupt regs as a base because the PEBS record does not
@@ -1824,8 +1823,7 @@ static void setup_pebs_adaptive_sample_data(struct perf_event *event,
 	 * previous PMI context or an (I)RET happened between the record and
 	 * PMI.
 	 */
-	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		perf_sample_save_callchain(data, event, iregs);
+	perf_sample_save_callchain(data, event, iregs);
 
 	*regs = *iregs;
 	/* The ip in basic is EventingIP */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 90c782749b055..3fdc58cc57831 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1229,6 +1229,11 @@ static inline void perf_sample_save_callchain(struct perf_sample_data *data,
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



