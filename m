Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8327C8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0993AC433EF;
	Tue, 28 Mar 2023 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014735;
	bh=TGTNbBL6H/o3J1CIcLehJoqJCnLI6Dr0L7NIHlrv5go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m66u7W+/hgnervqV+KEkYZ9gbrMfSDb5xg8TDDKDLJWONq162JuKJ0d852TmykPD8
	 tGPURhJddSBINya7917vgbqCop5Onc891kiTA7n9GzVjB9Xb/TK1EbE6DP+IL6fIkc
	 z1uR18YtWXb2cK3TmaiElZunatNq3+2s2DeAVadM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 005/240] perf: fix perf_event_context->time
Date: Tue, 28 Mar 2023 16:39:28 +0200
Message-Id: <20230328142619.885082459@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Liu <song@kernel.org>

[ Upstream commit baf1b12a67f5b24f395baca03e442ce27cab0c18 ]

Time readers rely on perf_event_context->[time|timestamp|timeoffset] to get
accurate time_enabled and time_running for an event. The difference between
ctx->timestamp and ctx->time is the among of time when the context is not
enabled. __update_context_time(ctx, false) is used to increase timestamp,
but not time. Therefore, it should only be called in ctx_sched_in() when
EVENT_TIME was not enabled.

Fixes: 09f5e7dc7ad7 ("perf: Fix perf_event_read_local() time")
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/r/20230313171608.298734-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 002eb9b9faa09..fad170b475921 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3872,7 +3872,7 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
 	if (likely(!ctx->nr_events))
 		return;
 
-	if (is_active ^ EVENT_TIME) {
+	if (!(is_active & EVENT_TIME)) {
 		/* start ctx time */
 		__update_context_time(ctx, false);
 		perf_cgroup_set_timestamp(cpuctx);
-- 
2.39.2



