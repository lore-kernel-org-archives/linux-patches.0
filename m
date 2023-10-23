Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D76818021
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQaH2avF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CF2C433C7;
	Mon, 23 Oct 2023 11:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061921;
	bh=qpaM67UQlyFuZZJHwSr76EOll8phKIA2JMxX2VBdZPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQaH2avFBPDbRNI2kW7oJZOOAytlL9PZSzP38/OzoMdsTW3flkY2AkclsXyhb8bmQ
	 U5PACEN1OAYX2AhYPzNv8amQmLUwnGHw8saJOv9YVZHMFWHL00m4wSvCnZ1LMX53h1
	 YmIfs7PYwL4TqlXrUQSFTrfm6Mmko5fY3azlXX9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 189/202] perf: Disallow mis-matched inherited group reads
Date: Mon, 23 Oct 2023 12:58:16 +0200
Message-ID: <20231023104831.966243287@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

commit 32671e3799ca2e4590773fd0e63aaa4229e50c06 upstream.

Because group consistency is non-atomic between parent (filedesc) and children
(inherited) events, it is possible for PERF_FORMAT_GROUP read() to try and sum
non-matching counter groups -- with non-sensical results.

Add group_generation to distinguish the case where a parent group removes and
adds an event and thus has the same number, but a different configuration of
events as inherited groups.

This became a problem when commit fa8c269353d5 ("perf/core: Invert
perf_read_group() loops") flipped the order of child_list and sibling_list.
Previously it would iterate the group (sibling_list) first, and for each
sibling traverse the child_list. In this order, only the group composition of
the parent is relevant. By flipping the order the group composition of the
child (inherited) events becomes an issue and the mis-match in group
composition becomes evident.

That said; even prior to this commit, while reading of a group that is not
equally inherited was not broken, it still made no sense.

(Ab)use ECHILD as error return to indicate issues with child process group
composition.

Fixes: fa8c269353d5 ("perf/core: Invert perf_read_group() loops")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20231018115654.GK33217@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -659,6 +659,7 @@ struct perf_event {
 	/* The cumulative AND of all event_caps for events in this group. */
 	int				group_caps;
 
+	unsigned int			group_generation;
 	struct perf_event		*group_leader;
 	struct pmu			*pmu;
 	void				*pmu_private;
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2053,6 +2053,7 @@ static void perf_group_attach(struct per
 
 	list_add_tail(&event->sibling_list, &group_leader->sibling_list);
 	group_leader->nr_siblings++;
+	group_leader->group_generation++;
 
 	perf_event__header_size(group_leader);
 
@@ -2245,6 +2246,7 @@ static void perf_group_detach(struct per
 	if (leader != event) {
 		list_del_init(&event->sibling_list);
 		event->group_leader->nr_siblings--;
+		event->group_leader->group_generation++;
 		goto out;
 	}
 
@@ -5222,7 +5224,7 @@ static int __perf_read_group_add(struct
 					u64 read_format, u64 *values)
 {
 	struct perf_event_context *ctx = leader->ctx;
-	struct perf_event *sub;
+	struct perf_event *sub, *parent;
 	unsigned long flags;
 	int n = 1; /* skip @nr */
 	int ret;
@@ -5232,6 +5234,33 @@ static int __perf_read_group_add(struct
 		return ret;
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
+	/*
+	 * Verify the grouping between the parent and child (inherited)
+	 * events is still in tact.
+	 *
+	 * Specifically:
+	 *  - leader->ctx->lock pins leader->sibling_list
+	 *  - parent->child_mutex pins parent->child_list
+	 *  - parent->ctx->mutex pins parent->sibling_list
+	 *
+	 * Because parent->ctx != leader->ctx (and child_list nests inside
+	 * ctx->mutex), group destruction is not atomic between children, also
+	 * see perf_event_release_kernel(). Additionally, parent can grow the
+	 * group.
+	 *
+	 * Therefore it is possible to have parent and child groups in a
+	 * different configuration and summing over such a beast makes no sense
+	 * what so ever.
+	 *
+	 * Reject this.
+	 */
+	parent = leader->parent;
+	if (parent &&
+	    (parent->group_generation != leader->group_generation ||
+	     parent->nr_siblings != leader->nr_siblings)) {
+		ret = -ECHILD;
+		goto unlock;
+	}
 
 	/*
 	 * Since we co-schedule groups, {enabled,running} times of siblings
@@ -5261,8 +5290,9 @@ static int __perf_read_group_add(struct
 			values[n++] = primary_event_id(sub);
 	}
 
+unlock:
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	return 0;
+	return ret;
 }
 
 static int perf_read_group(struct perf_event *event,
@@ -5281,10 +5311,6 @@ static int perf_read_group(struct perf_e
 
 	values[0] = 1 + leader->nr_siblings;
 
-	/*
-	 * By locking the child_mutex of the leader we effectively
-	 * lock the child list of all siblings.. XXX explain how.
-	 */
 	mutex_lock(&leader->child_mutex);
 
 	ret = __perf_read_group_add(leader, read_format, values);
@@ -12820,6 +12846,7 @@ static int inherit_group(struct perf_eve
 		    !perf_get_aux_event(child_ctr, leader))
 			return -EINVAL;
 	}
+	leader->group_generation = parent_event->group_generation;
 	return 0;
 }
 


