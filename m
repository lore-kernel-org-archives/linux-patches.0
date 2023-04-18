Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271892566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F82FC433D2;
	Tue, 18 Apr 2023 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821201;
	bh=rVjHGvB83N0yXhXQ08qcO4nCT+NACRnI4jJJ6uaYnVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGtBgF0RW/+TPpxwyFVtJ7qxIgH4lvq0EqJ2TowViVcDhZ2JLFHb5d4aKrW9kSlFh
	 FhY3z6yqDK89D8PN30WPvMu3SGHsw/FJt/BSajAbtC23wb+m1dRBK8qB6mDyTfiacg
	 qIhedayKDgq85piEcCc7UNCkQLszhvrCEWnJyMOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zhengjun Xing <zhengjun.xing@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/124] perf/core: Fix the same task check in perf_event_set_output
Date: Tue, 18 Apr 2023 14:20:56 +0200
Message-Id: <20230418120311.155232396@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 24d3ae2f37d8bc3c14b31d353c5d27baf582b6a6 ]

The same task check in perf_event_set_output has some potential issues
for some usages.

For the current perf code, there is a problem if using of
perf_event_open() to have multiple samples getting into the same mmap’d
memory when they are both attached to the same process.
https://lore.kernel.org/all/92645262-D319-4068-9C44-2409EF44888E@gmail.com/
Because the event->ctx is not ready when the perf_event_set_output() is
invoked in the perf_event_open().

Besides the above issue, before the commit bd2756811766 ("perf: Rewrite
core context handling"), perf record can errors out when sampling with
a hardware event and a software event as below.
 $ perf record -e cycles,dummy --per-thread ls
 failed to mmap with 22 (Invalid argument)
That's because that prior to the commit a hardware event and a software
event are from different task context.

The problem should be a long time issue since commit c3f00c70276d
("perk: Separate find_get_context() from event initialization").

The task struct is stored in the event->hw.target for each per-thread
event. It is a more reliable way to determine whether two events are
attached to the same task.

The event->hw.target was also introduced several years ago by the
commit 50f16a8bf9d7 ("perf: Remove type specific target pointers"). It
can not only be used to fix the issue with the current code, but also
back port to fix the issues with an older kernel.

Note: The event->hw.target was introduced later than commit
c3f00c70276d. The patch may cannot be applied between the commit
c3f00c70276d and commit 50f16a8bf9d7. Anybody that wants to back-port
this at that period may have to find other solutions.

Fixes: c3f00c70276d ("perf: Separate find_get_context() from event initialization")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Link: https://lkml.kernel.org/r/20230322202449.512091-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2e1371fbb9d3..f0df3bc0e6415 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11622,7 +11622,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 && output_event->hw.target != event->hw.target)
 		goto out;
 
 	/*
-- 
2.39.2



