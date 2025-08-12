Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2761DF27F;
	Tue, 12 Aug 2025 18:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023348; cv=none; b=SIHRDaPh7TN6Zeninfywkov1umQiYr61vfRJ9HoUs0NhJl/K7GXFzSbs1NoNP/sf9ARC3MeRMnrfhiG7e5jOXfWrVEtgIZb/IqLFAC8jP14zrSg5d1J5Dp1nKfrZExE7GUt7XV0Q5E364QZh3cqgUcZkq6UeroDsCn27oa1AajQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023348; c=relaxed/simple;
	bh=OQFnwdE/hqIkAKBLQ4eddPGXeyjSxV/xPCoj44JPcQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9188a9hrsNZnGLcpdT/XegUXcgk3NBAqdFLg42yIKXnANWK1B+3QdO2k+7kKATSXoHClriTcfVsXNCJkLGpmgRWvDKZzCypY+HYbjrKo9mntrsuMG36Phqu64IlVLcY03JuCJmIGc564GTgrPx1/9qQMhASvYF2Txdq5m1PWis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0vw5c3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0vw5c3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A8DC4CEF0;
	Tue, 12 Aug 2025 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023348;
	bh=OQFnwdE/hqIkAKBLQ4eddPGXeyjSxV/xPCoj44JPcQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0vw5c3fXOnjChpBxNvNFqYz9djpnrAy9lr9kDw8Ds6SLUS85S4dM3S8mDiaYOAxs
	 f74xmon9LSDsroW0dXx6fgDbRT00JCBGx+ktd7+PpKa7TLEOelFvP4ab6g80J92T4m
	 F/iY8bvB2Mbuqtt3JY6M971c+YB9cGms1VZkb79I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 026/627] eventpoll: Fix semi-unbounded recursion
Date: Tue, 12 Aug 2025 19:25:21 +0200
Message-ID: <20250812173420.323333374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit f2e467a48287c868818085aa35389a224d226732 ]

Ensure that epoll instances can never form a graph deeper than
EP_MAX_NESTS+1 links.

Currently, ep_loop_check_proc() ensures that the graph is loop-free and
does some recursion depth checks, but those recursion depth checks don't
limit the depth of the resulting tree for two reasons:

 - They don't look upwards in the tree.
 - If there are multiple downwards paths of different lengths, only one of
   the paths is actually considered for the depth check since commit
   28d82dc1c4ed ("epoll: limit paths").

Essentially, the current recursion depth check in ep_loop_check_proc() just
serves to prevent it from recursing too deeply while checking for loops.

A more thorough check is done in reverse_path_check() after the new graph
edge has already been created; this checks, among other things, that no
paths going upwards from any non-epoll file with a length of more than 5
edges exist. However, this check does not apply to non-epoll files.

As a result, it is possible to recurse to a depth of at least roughly 500,
tested on v6.15. (I am unsure if deeper recursion is possible; and this may
have changed with commit 8c44dac8add7 ("eventpoll: Fix priority inversion
problem").)

To fix it:

1. In ep_loop_check_proc(), note the subtree depth of each visited node,
and use subtree depths for the total depth calculation even when a subtree
has already been visited.
2. Add ep_get_upwards_depth_proc() for similarly determining the maximum
depth of an upwards walk.
3. In ep_loop_check(), use these values to limit the total path length
between epoll nodes to EP_MAX_NESTS edges.

Fixes: 22bacca48a17 ("epoll: prevent creating circular epoll structures")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/20250711-epoll-recursion-fix-v1-1-fb2457c33292@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: ecb6cc0fd8cd ("eventpoll: fix sphinx documentation build warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 60 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0fbf5dfedb24..7a7b044daadc 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -218,6 +218,7 @@ struct eventpoll {
 	/* used to optimize loop detection check */
 	u64 gen;
 	struct hlist_head refs;
+	u8 loop_check_depth;
 
 	/*
 	 * usage count, used together with epitem->dying to
@@ -2140,23 +2141,24 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 }
 
 /**
- * ep_loop_check_proc - verify that adding an epoll file inside another
- *                      epoll structure does not violate the constraints, in
- *                      terms of closed loops, or too deep chains (which can
- *                      result in excessive stack usage).
+ * ep_loop_check_proc - verify that adding an epoll file @ep inside another
+ *                      epoll file does not create closed loops, and
+ *                      determine the depth of the subtree starting at @ep
  *
  * @ep: the &struct eventpoll to be currently checked.
  * @depth: Current depth of the path being checked.
  *
- * Return: %zero if adding the epoll @file inside current epoll
- *          structure @ep does not violate the constraints, or %-1 otherwise.
+ * Return: depth of the subtree, or INT_MAX if we found a loop or went too deep.
  */
 static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 {
-	int error = 0;
+	int result = 0;
 	struct rb_node *rbp;
 	struct epitem *epi;
 
+	if (ep->gen == loop_check_gen)
+		return ep->loop_check_depth;
+
 	mutex_lock_nested(&ep->mtx, depth + 1);
 	ep->gen = loop_check_gen;
 	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
@@ -2164,13 +2166,11 @@ static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
 			struct eventpoll *ep_tovisit;
 			ep_tovisit = epi->ffd.file->private_data;
-			if (ep_tovisit->gen == loop_check_gen)
-				continue;
 			if (ep_tovisit == inserting_into || depth > EP_MAX_NESTS)
-				error = -1;
+				result = INT_MAX;
 			else
-				error = ep_loop_check_proc(ep_tovisit, depth + 1);
-			if (error != 0)
+				result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1);
+			if (result > EP_MAX_NESTS)
 				break;
 		} else {
 			/*
@@ -2184,9 +2184,27 @@ static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 			list_file(epi->ffd.file);
 		}
 	}
+	ep->loop_check_depth = result;
 	mutex_unlock(&ep->mtx);
 
-	return error;
+	return result;
+}
+
+/**
+ * ep_get_upwards_depth_proc - determine depth of @ep when traversed upwards
+ */
+static int ep_get_upwards_depth_proc(struct eventpoll *ep, int depth)
+{
+	int result = 0;
+	struct epitem *epi;
+
+	if (ep->gen == loop_check_gen)
+		return ep->loop_check_depth;
+	hlist_for_each_entry_rcu(epi, &ep->refs, fllink)
+		result = max(result, ep_get_upwards_depth_proc(epi->ep, depth + 1) + 1);
+	ep->gen = loop_check_gen;
+	ep->loop_check_depth = result;
+	return result;
 }
 
 /**
@@ -2202,8 +2220,22 @@ static int ep_loop_check_proc(struct eventpoll *ep, int depth)
  */
 static int ep_loop_check(struct eventpoll *ep, struct eventpoll *to)
 {
+	int depth, upwards_depth;
+
 	inserting_into = ep;
-	return ep_loop_check_proc(to, 0);
+	/*
+	 * Check how deep down we can get from @to, and whether it is possible
+	 * to loop up to @ep.
+	 */
+	depth = ep_loop_check_proc(to, 0);
+	if (depth > EP_MAX_NESTS)
+		return -1;
+	/* Check how far up we can go from @ep. */
+	rcu_read_lock();
+	upwards_depth = ep_get_upwards_depth_proc(ep, 0);
+	rcu_read_unlock();
+
+	return (depth+1+upwards_depth > EP_MAX_NESTS) ? -1 : 0;
 }
 
 static void clear_tfile_check_list(void)
-- 
2.39.5



