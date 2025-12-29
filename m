Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146D3191A7;
	Mon, 29 Dec 2025 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025047; cv=none; b=aZAQjgW+3eqFQOzL1WqWpM5velDMyL3kwOnUXQSBjYf2YYEasPWNeky3wSiag1TgraGCHwNRaWHrE5/5oMiAhbp/uH2cQAHzuIjnsEbn48t/RJQk76T5NT97wrfoqMU6Qj52We81QhhmvGY75XXAzQv4+JDkqtxwfO0Loo/xeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025047; c=relaxed/simple;
	bh=WG0i29/HTO4qXUS72GTXVzAvs4HuE9DVs0BFDjXew3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAjcT28cgow8z0eSgEnDX/82ODjGvS0JRac7CpesW4ND472B8LwrpEdMbt7XCTL/xR+NMQwMh4oGi81T/Iyq/1MjdAt/7CcJ+1aJtyx0b3aTgPu8UFm8e1qW12bEVruFYV7g94Q1FaeQ84dc4oPMBiAQ7V3+no00M0em+R9NTpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5I6vOxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5I6vOxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D3C4CEF7;
	Mon, 29 Dec 2025 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025047;
	bh=WG0i29/HTO4qXUS72GTXVzAvs4HuE9DVs0BFDjXew3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5I6vOxpLH6y7qJAa/11R52/mtdk+KFj/HLFiNAwYYONYEEJgmp0ziWfhJ1b/awne
	 6VgDs3DjwrWYfs8bhQgx/HAN1wnKG0ZjrNGruk/F3SCEigM4xzBrx+T+hhgLyUEtRJ
	 cPPVHHJ9HwBy0PGIww9vFqsIZ/h4zURwIXaDyt6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/430] inet: frags: avoid theoretical race in ip_frag_reinit()
Date: Mon, 29 Dec 2025 17:07:58 +0100
Message-ID: <20251229160727.162129008@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8ef522c8a59a048117f7e05eb5213043c02f986f ]

In ip_frag_reinit() we want to move the frag timeout timer into
the future. If the timer fires in the meantime we inadvertently
scheduled it again, and since the timer assumes a ref on frag_queue
we need to acquire one to balance things out.

This is technically racy, we should have acquired the reference
_before_ we touch the timer, it may fire again before we take the ref.
Avoid this entire dance by using mod_timer_pending() which only modifies
the timer if its pending (and which exists since Linux v2.6.30)

Note that this was the only place we ever took a ref on frag_queue
since Eric's conversion to RCU. So we could potentially replace
the whole refcnt field with an atomic flag and a bit more RCU.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251207010942.1672972-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_fragment.c | 4 +++-
 net/ipv4/ip_fragment.c   | 4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 025895eb6ec59..30f4fa50ee2d7 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -327,7 +327,9 @@ static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
 
 	timer_setup(&q->timer, f->frag_expire, 0);
 	spin_lock_init(&q->lock);
-	/* One reference for the timer, one for the hash table. */
+	/* One reference for the timer, one for the hash table.
+	 * We never take any extra references, only decrement this field.
+	 */
 	refcount_set(&q->refcnt, 2);
 
 	return q;
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index f7012479713ba..d7bccdc9dc693 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -242,10 +242,8 @@ static int ip_frag_reinit(struct ipq *qp)
 {
 	unsigned int sum_truesize = 0;
 
-	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
-		refcount_inc(&qp->q.refcnt);
+	if (!mod_timer_pending(&qp->q.timer, jiffies + qp->q.fqdir->timeout))
 		return -ETIMEDOUT;
-	}
 
 	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
 					      SKB_DROP_REASON_FRAG_TOO_FAR);
-- 
2.51.0



