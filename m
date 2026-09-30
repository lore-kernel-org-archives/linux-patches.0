Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224FC5678C3;
	Wed, 30 Sep 2026 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790516; cv=none; b=X56S3M3yRShscxvxKTtCVo/TkqUwfn3mGKCNYDc8jRqG0o0+sU8BCozLj8GLTovvfCBsPJr6DD7BZpYRKm+E3xVHM12k/xo0RX84D8BwAW+ii2LT8RX07O7Z50tJDvHkBYbYZer7GuyGypdIFd8yyaQezWRR8pQD+2XQJ3honLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790516; c=relaxed/simple;
	bh=00QN40oxon8bIQvdLtwKBgpJg+uODoCdtuf1G03q7Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgZzH339nGC3xgKLYeRM1f9jWTfsnlaDPAg8qVFFz0f5EKh2bAHEZHwLJ3gxruWoTXZ3kNsEHa7yEpJR00Mc30EGtlEvaEPy38lEL0kT/6kddnsfUdJ0RaZDFlAENQqDbwyVPVkMiLDOCG5lYxdEfy8de7k1M/6u0ONo0vOOkfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2xzTQJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2xzTQJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F67D1F000FF;
	Wed, 30 Sep 2026 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790514;
	bh=xyV51mPyxRiDmC3tGtA8xNnsTm/hpqy/PNNRi/lJWFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2xzTQJ+P8h0OQBfPOg6GQbAT9ns0eNopK+k0LtxCqEHdy1+AsqS1S6Alk7oxp/2C
	 9kaFsiYioWgrn3WOsgy//lVxD55N8Z3QUltOiYyIKv0wLjjrU6XzCtXr1jMvUT6bMN
	 JhtbsU2SMiipwmD/koZiTkDHCKjiAFu9iBPGsIBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 856/877] rose: fix race between loopback timer and module removal
Date: Wed, 30 Sep 2026 17:29:27 +0200
Message-ID: <20260930152433.210534931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 47dd6ec1a77d77895afb00aa2e68373a48289108 upstream.

rose_loopback_clear() called timer_delete() which returns immediately
without waiting for any running callback to complete.  If the timer
fired concurrently with module removal, rose_loopback_timer() could
re-arm the timer after timer_delete() returned and then access
rose_loopback_neigh after it was freed.

Two complementary changes close the race:

1. Add a loopback_stopping atomic flag.  rose_loopback_timer() checks
   it at entry (before acquiring a reference) and again inside the
   loop; when set it drains the queue and exits without re-arming the
   timer.

2. Switch rose_loopback_clear() to timer_delete_sync() so it blocks
   until any in-flight callback has returned before freeing resources.

The smp_mb() between setting the flag and calling timer_delete_sync()
ensures the flag is visible to any callback that is about to run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -12,13 +12,15 @@
 #include <net/rose.h>
 #include <linux/init.h>
 
-static struct sk_buff_head loopback_queue;
 #define ROSE_LOOPBACK_LIMIT 1000
-static struct timer_list loopback_timer;
 
+static struct timer_list loopback_timer;
+static struct sk_buff_head loopback_queue;
 static void rose_set_loopback_timer(void);
 static void rose_loopback_timer(struct timer_list *unused);
 
+static atomic_t loopback_stopping = ATOMIC_INIT(0);
+
 void rose_loopback_init(void)
 {
 	skb_queue_head_init(&loopback_queue);
@@ -66,6 +68,9 @@ static void rose_loopback_timer(struct t
 	unsigned int lci_i, lci_o;
 	int count;
 
+	if (atomic_read(&loopback_stopping))
+		return;
+
 	if (rose_loopback_neigh)
 		rose_neigh_hold(rose_loopback_neigh);
 	else
@@ -75,6 +80,13 @@ static void rose_loopback_timer(struct t
 		skb = skb_dequeue(&loopback_queue);
 		if (!skb)
 			goto out;
+
+		if (atomic_read(&loopback_stopping)) {
+			kfree_skb(skb);
+			skb_queue_purge(&loopback_queue);
+			goto out;
+		}
+
 		if (skb->len < ROSE_MIN_LEN) {
 			kfree_skb(skb);
 			continue;
@@ -118,7 +130,7 @@ static void rose_loopback_timer(struct t
 out:
 	rose_neigh_put(rose_loopback_neigh);
 
-	if (!skb_queue_empty(&loopback_queue))
+	if (!atomic_read(&loopback_stopping) && !skb_queue_empty(&loopback_queue))
 		mod_timer(&loopback_timer, jiffies + 1);
 }
 
@@ -126,10 +138,15 @@ void __exit rose_loopback_clear(void)
 {
 	struct sk_buff *skb;
 
-	del_timer(&loopback_timer);
+	atomic_set(&loopback_stopping, 1);
+	/* Pairs with atomic_read() in rose_loopback_timer(): ensure the
+	 * stopping flag is visible before we cancel, so a concurrent
+	 * callback aborts its loop early rather than re-arming the timer.
+	 */
+	smp_mb();
+
+	timer_delete_sync(&loopback_timer);
 
-	while ((skb = skb_dequeue(&loopback_queue)) != NULL) {
-		skb->sk = NULL;
+	while ((skb = skb_dequeue(&loopback_queue)) != NULL)
 		kfree_skb(skb);
-	}
 }


