Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727091494DF;
	Wed,  5 Feb 2025 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764474; cv=none; b=TdWjpT47uxhC0n7WlywitKOvmL9nbRfeX1cIeWZLUuYkGQZh4F66H4G0hLPv3i84ALBdVBhUaPayI7oyPJTkVR+OG9fY141oIY9bLKHey96+CdkAX9ujBrc52DfzAS5LdFRXsUoh/4luN1dUwwGaGqjUyltvsYmbCF1sb7nsdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764474; c=relaxed/simple;
	bh=2u7GhkIRR3LSWZfQfSonk1IaNElBz/iaCBsOKxyO2xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODK/fU+E/Nvsyl4T6qojXsUVKaL30oFRVvLN18ukjijHmX8+be9iZXalWhERIATHqHwP1sGpK60HOkv7ijac+NTOTZ6S8ws0MUhVAniionvs32WXY1XovGahJ4bXsCOWJrNad1RBcTvzhDGew77h+4/gRngczow+WLb0iBf3UD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzhZklGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzhZklGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7051C4CED1;
	Wed,  5 Feb 2025 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764474;
	bh=2u7GhkIRR3LSWZfQfSonk1IaNElBz/iaCBsOKxyO2xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzhZklGMCtz6Uv+vcXdyxmvx3aRZCOaer5t4/aH8p4X6W0VV0gFoujUyo00XZS9lF
	 kqbQoWSwUpA5eQqNJg7mwqAoeOhYtXkuxTZNLD9KQQZbp27Rcq8oHzDSxKv0mmCAx0
	 BrTJW30l20zxnpUinSudAQ7rVlFBvcL9l6u80H9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/590] inetpeer: update inetpeer timestamp in inet_getpeer()
Date: Wed,  5 Feb 2025 14:37:43 +0100
Message-ID: <20250205134459.388995303@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 411a194f9c999..f4cfc10293b85 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -95,6 +95,7 @@ static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
 {
 	struct rb_node **pp, *parent, *next;
 	struct inet_peer *p;
+	u32 now;
 
 	pp = &base->rb_root.rb_node;
 	parent = NULL;
@@ -110,6 +111,9 @@ static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
 		if (cmp == 0) {
 			if (!refcount_inc_not_zero(&p->refcnt))
 				break;
+			now = jiffies;
+			if (READ_ONCE(p->dtime) != now)
+				WRITE_ONCE(p->dtime, now);
 			return p;
 		}
 		if (gc_stack) {
@@ -155,9 +159,6 @@ static void inet_peer_gc(struct inet_peer_base *base,
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
-		/* The READ_ONCE() pairs with the WRITE_ONCE()
-		 * in inet_putpeer()
-		 */
 		delta = (__u32)jiffies - READ_ONCE(p->dtime);
 
 		if (delta < ttl || !refcount_dec_if_one(&p->refcnt))
@@ -229,11 +230,6 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
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



