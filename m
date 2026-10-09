Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D71A682B;
	Fri,  9 Oct 2026 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556351; cv=none; b=b+UU5LG8DqfU01OgJdJ72pu2xWbLdDDSztQHOOv+wOmi+cbRbUAQe3UkHZS5iyLo8Nn+UgbqEaIwyY31ORh37sDe+/dtzxooFWNbnJwJU7jJl+q/1AAjF+MMFGS8uxBUBTZYLXRgHjZO9SPkbdquS5I5FqA1bTgbYY51XH4bXU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556351; c=relaxed/simple;
	bh=+DGsLZDYvrQbPBXFIVCRuXdEP3iuqSg+iYHT1d53vRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv1cbBu82Ty+quD3viXnKdYfpjq6oWTpsO2PPTBT0xFNQghQrRP0oVKGNXt/BH8A/TiB7T0S38z3fxFP2g2nrdWQ3mO/CcG+7RyHrBZAW1/uq7Nh+IjD/w9mClBzCk0+hHCYgQkGNsYZDgTzafLktIl97pvRwZl+udhYh5gRpg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts1FoODw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts1FoODw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244721F000FF;
	Fri,  9 Oct 2026 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556348;
	bh=D9RLf6/PBR7BHl40H2ZmnWW5aF4kxE7+0NeN9XryvGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ts1FoODwal089rrK+6ePshugGARu5XdoBWjLbgX863cweo4YJ3NlxSFd8vMawZ540
	 8PQ1dY1FUSOnMu7i3Db41enRX/WUk8NIfkFGgvQcQY4Cyee5Gk6vu7NiRoF6cUlSI1
	 x2ieeJM+Ofykj+jC7iaFYFvu7ctSZopD3gcdvCx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 162/428] bpf: Factor out __do_call_rcu_ttrace()
Date: Fri,  9 Oct 2026 16:08:19 +0200
Message-ID: <20261009140949.718882917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 47f4f695cec1eb82d961fdb466cd7c99d2865b7c ]

Move the part of do_call_rcu_ttrace() that runs after
call_rcu_ttrace_in_progress is set into __do_call_rcu_ttrace().
The next patch will call it from __free_rcu().
No functional change.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260930095920.601738-2-alexei.starovoitov@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Stable-dep-of: fbd97dd1d3ce ("bpf: Fix objects stuck in free_by_rcu_ttrace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 8a8f088e83e6f..08e4dde66cd52 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -298,19 +298,10 @@ static void enque_to_free(struct bpf_mem_cache *c, void *obj)
 	llist_add(llnode, &c->free_by_rcu_ttrace);
 }
 
-static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
+static void __do_call_rcu_ttrace(struct bpf_mem_cache *c)
 {
 	struct llist_node *llnode, *t;
 
-	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 1)) {
-		if (unlikely(READ_ONCE(c->draining))) {
-			scoped_guard(raw_spinlock_irqsave, &c->lock)
-				llnode = llist_del_all(&c->free_by_rcu_ttrace);
-			free_all(c, llnode, !!c->percpu_size);
-		}
-		return;
-	}
-
 	WARN_ON_ONCE(!llist_empty(&c->waiting_for_gp_ttrace));
 	llist_for_each_safe(llnode, t, llist_del_all(&c->free_by_rcu_ttrace))
 		llist_add(llnode, &c->waiting_for_gp_ttrace);
@@ -328,6 +319,22 @@ static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
 	call_rcu_tasks_trace(&c->rcu_ttrace, __free_rcu);
 }
 
+static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
+{
+	struct llist_node *llnode;
+
+	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 1)) {
+		if (unlikely(READ_ONCE(c->draining))) {
+			scoped_guard(raw_spinlock_irqsave, &c->lock)
+				llnode = llist_del_all(&c->free_by_rcu_ttrace);
+			free_all(c, llnode, !!c->percpu_size);
+		}
+		return;
+	}
+
+	__do_call_rcu_ttrace(c);
+}
+
 static void free_bulk(struct bpf_mem_cache *c)
 {
 	struct bpf_mem_cache *tgt = c->tgt;
-- 
2.53.0



