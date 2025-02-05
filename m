Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51B9FC0B;
	Wed,  5 Feb 2025 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763541; cv=none; b=g9PSvlbNV1VywZqfcqD1DIs2AJLDVc9xtA2laVk5hzjueA0BYY8AaqEoBQMinO0Yf6OFxhTURorehJlatsDY9pWIBcGUdJhXiyVE5+wcsKg0ANLr3i97MwhMw0N+YGrTxrXEx+oPxszxK+lnxeH3pHoGZTuYhTIM19CakYe86mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763541; c=relaxed/simple;
	bh=lNKt98lz4oiwu4F7ANTbtNd0VuEZCf8HHBX7lBE0U8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVO4B3EKkkGlIajay6pzya8fZjUUd2vO5uVFu2VDYaZlNPCRmM5xreI3Kadd/+b2n4gWhtyzkuk962XZ7LiwempZ7VYZSNCZ/bOWfGDjmX0jpWgOlbJ0b5L6P1zDCwTz7yZMLkK5ASI4wZ6WYq18yKyPCueXbk7s165ndfAFmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2mrwPJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2mrwPJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1214EC4CED1;
	Wed,  5 Feb 2025 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763541;
	bh=lNKt98lz4oiwu4F7ANTbtNd0VuEZCf8HHBX7lBE0U8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2mrwPJdVxQovg+UvQhEqvkUjpvXqO6Li9e52JWa0ajKKWZ2EODdonEFbtNgDPSH0
	 jOr4JnXnSDrXDeCY4YXo4mx6P2GnfepHCEUrY0XA1AVf/WLENMn0HY9C8FEyh/YMeU
	 9VJMcGAxk1xKpXb798Lb4mPjn0Sv60oVwtOvBhJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/393] inetpeer: update inetpeer timestamp in inet_getpeer()
Date: Wed,  5 Feb 2025 14:39:58 +0100
Message-ID: <20250205134423.317711455@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50b362f21d6c10b0f7939c1482c6a1b43da82f1a ]

inet_putpeer() will be removed in the following patch,
because we will no longer use refcounts.

Update inetpeer timestamp (p->dtime) at lookup time.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241215175629.1248773-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a853c609504e ("inetpeer: do not get a refcount in inet_getpeer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inetpeer.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 5670571ee5fbe..596e2c3a8551f 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -98,6 +98,7 @@ static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
 {
 	struct rb_node **pp, *parent, *next;
 	struct inet_peer *p;
+	u32 now;
 
 	pp = &base->rb_root.rb_node;
 	parent = NULL;
@@ -113,6 +114,9 @@ static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
 		if (cmp == 0) {
 			if (!refcount_inc_not_zero(&p->refcnt))
 				break;
+			now = jiffies;
+			if (READ_ONCE(p->dtime) != now)
+				WRITE_ONCE(p->dtime, now);
 			return p;
 		}
 		if (gc_stack) {
@@ -158,9 +162,6 @@ static void inet_peer_gc(struct inet_peer_base *base,
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
-		/* The READ_ONCE() pairs with the WRITE_ONCE()
-		 * in inet_putpeer()
-		 */
 		delta = (__u32)jiffies - READ_ONCE(p->dtime);
 
 		if (delta < ttl || !refcount_dec_if_one(&p->refcnt))
@@ -232,11 +233,6 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
 void inet_putpeer(struct inet_peer *p)
 {
-	/* The WRITE_ONCE() pairs with itself (we run lockless)
-	 * and the READ_ONCE() in inet_peer_gc()
-	 */
-	WRITE_ONCE(p->dtime, (__u32)jiffies);
-
 	if (refcount_dec_and_test(&p->refcnt))
 		call_rcu(&p->rcu, inetpeer_free_rcu);
 }
-- 
2.39.5



