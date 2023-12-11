Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D03B524D4;
	Mon, 11 Dec 2023 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX7+iIw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C87C433CB;
	Mon, 11 Dec 2023 18:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319998;
	bh=BqFQSB+9g7Y5bWP1rDlUqcdGqwBSMBfJNU7v/t7LQfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX7+iIw/vHHS5FQsPusG1Kcd6avWxX5+J716Kd15mqbUsNfIDaVwrYgiMXpBv6KAq
	 52z9K+oxiYV1UzO65CAZiT4OyqTOam7mHddsbsjJkMNJ/cG820e16OUCEyOvWxP8dQ
	 LH7i29ipygiEdR7ImjVtvfznOTszLH4E8e04pCEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 66/97] perf: Fix perf_event_validate_size()
Date: Mon, 11 Dec 2023 19:22:09 +0100
Message-ID: <20231211182022.598273078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 382c27f4ed28f803b1f1473ac2d8db0afc795a1b ]

Budimir noted that perf_event_validate_size() only checks the size of
the newly added event, even though the sizes of all existing events
can also change due to not all events having the same read_format.

When we attach the new event, perf_group_attach(), we do re-compute
the size for all events.

Fixes: a723968c0ed3 ("perf: Fix u16 overflows")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 61 +++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f7ac1b24f93e0..0a6855d648031 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1912,31 +1912,34 @@ static inline void perf_event__state_init(struct perf_event *event)
 					      PERF_EVENT_STATE_INACTIVE;
 }
 
-static void __perf_event_read_size(struct perf_event *event, int nr_siblings)
+static int __perf_event_read_size(u64 read_format, int nr_siblings)
 {
 	int entry = sizeof(u64); /* value */
 	int size = 0;
 	int nr = 1;
 
-	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
 		size += sizeof(u64);
 
-	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		size += sizeof(u64);
 
-	if (event->attr.read_format & PERF_FORMAT_ID)
+	if (read_format & PERF_FORMAT_ID)
 		entry += sizeof(u64);
 
-	if (event->attr.read_format & PERF_FORMAT_LOST)
+	if (read_format & PERF_FORMAT_LOST)
 		entry += sizeof(u64);
 
-	if (event->attr.read_format & PERF_FORMAT_GROUP) {
+	if (read_format & PERF_FORMAT_GROUP) {
 		nr += nr_siblings;
 		size += sizeof(u64);
 	}
 
-	size += entry * nr;
-	event->read_size = size;
+	/*
+	 * Since perf_event_validate_size() limits this to 16k and inhibits
+	 * adding more siblings, this will never overflow.
+	 */
+	return size + nr * entry;
 }
 
 static void __perf_event_header_size(struct perf_event *event, u64 sample_type)
@@ -1980,8 +1983,9 @@ static void __perf_event_header_size(struct perf_event *event, u64 sample_type)
  */
 static void perf_event__header_size(struct perf_event *event)
 {
-	__perf_event_read_size(event,
-			       event->group_leader->nr_siblings);
+	event->read_size =
+		__perf_event_read_size(event->attr.read_format,
+				       event->group_leader->nr_siblings);
 	__perf_event_header_size(event, event->attr.sample_type);
 }
 
@@ -2012,24 +2016,35 @@ static void perf_event__id_header_size(struct perf_event *event)
 	event->id_header_size = size;
 }
 
+/*
+ * Check that adding an event to the group does not result in anybody
+ * overflowing the 64k event limit imposed by the output buffer.
+ *
+ * Specifically, check that the read_size for the event does not exceed 16k,
+ * read_size being the one term that grows with groups size. Since read_size
+ * depends on per-event read_format, also (re)check the existing events.
+ *
+ * This leaves 48k for the constant size fields and things like callchains,
+ * branch stacks and register sets.
+ */
 static bool perf_event_validate_size(struct perf_event *event)
 {
-	/*
-	 * The values computed here will be over-written when we actually
-	 * attach the event.
-	 */
-	__perf_event_read_size(event, event->group_leader->nr_siblings + 1);
-	__perf_event_header_size(event, event->attr.sample_type & ~PERF_SAMPLE_READ);
-	perf_event__id_header_size(event);
+	struct perf_event *sibling, *group_leader = event->group_leader;
 
-	/*
-	 * Sum the lot; should not exceed the 64k limit we have on records.
-	 * Conservative limit to allow for callchains and other variable fields.
-	 */
-	if (event->read_size + event->header_size +
-	    event->id_header_size + sizeof(struct perf_event_header) >= 16*1024)
+	if (__perf_event_read_size(event->attr.read_format,
+				   group_leader->nr_siblings + 1) > 16*1024)
 		return false;
 
+	if (__perf_event_read_size(group_leader->attr.read_format,
+				   group_leader->nr_siblings + 1) > 16*1024)
+		return false;
+
+	for_each_sibling_event(sibling, group_leader) {
+		if (__perf_event_read_size(sibling->attr.read_format,
+					   group_leader->nr_siblings + 1) > 16*1024)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.42.0



