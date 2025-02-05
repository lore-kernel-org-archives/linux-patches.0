Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE31519AA;
	Wed,  5 Feb 2025 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764850; cv=none; b=k454ny7hJAwSIQ8RbFtQFl8oKXjEBrbJEOlONjunHe7ZWGVAPJm7RhT5OBYDZw0m3AeFfaXVZwIeiZq7D/XaIFCpVTeV/Pnw5PlDdzU1ZgVlv7xp/z9KyjrJeB+Q8Mplln5ogEkGqlrWBGOecun9yXGTKHCEZ9/rt7XX9DhnOQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764850; c=relaxed/simple;
	bh=iGdu366h5LqlRUxMgHwHMnqBFCnIvJjSu/M/2NilJD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoR6Qt7bLD5VPZekdwktfzKtjmeD9x0+M8X1tRX1ZeqpRn4UCI3QHwsNhjzAPdoADTMruW+P7LVaRUsuOdRRLbHp/c7ee9hybSziiGgMILVyxKRcKvtZJKN6ZBkOkn8QbtajBcxkggHJ76nOZ6u9eX1pRkgcsVEHLxtUu7RydaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1BgHrFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1BgHrFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC375C4CED1;
	Wed,  5 Feb 2025 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764850;
	bh=iGdu366h5LqlRUxMgHwHMnqBFCnIvJjSu/M/2NilJD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1BgHrFfErrF9LhoSsT/m8UysjLrcaB5/9RJHv4H/cUNvxvStOcBCOkMhgVL+6QE5
	 /5hshhiFrGgXNCmmP7vx59M/3CeBiBMZ68bT3GO3nER1Th65fnoeRUwrHnxSv2dZFk
	 QmLdS9xvrKEd3v/J4A9RmqC9wl/8ZcQ0ANQaQ0tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 119/623] inetpeer: update inetpeer timestamp in inet_getpeer()
Date: Wed,  5 Feb 2025 14:37:41 +0100
Message-ID: <20250205134500.773829226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index bc79cc9d13ebb..28c3ae5bc4a0b 100644
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
@@ -150,9 +154,6 @@ static void inet_peer_gc(struct inet_peer_base *base,
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
-		/* The READ_ONCE() pairs with the WRITE_ONCE()
-		 * in inet_putpeer()
-		 */
 		delta = (__u32)jiffies - READ_ONCE(p->dtime);
 
 		if (delta < ttl || !refcount_dec_if_one(&p->refcnt))
@@ -224,11 +225,6 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
 void inet_putpeer(struct inet_peer *p)
 {
-	/* The WRITE_ONCE() pairs with itself (we run lockless)
-	 * and the READ_ONCE() in inet_peer_gc()
-	 */
-	WRITE_ONCE(p->dtime, (__u32)jiffies);
-
 	if (refcount_dec_and_test(&p->refcnt))
 		kfree_rcu(p, rcu);
 }
-- 
2.39.5



