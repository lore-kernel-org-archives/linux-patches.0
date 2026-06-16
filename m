Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4188544B681;
	Tue, 16 Jun 2026 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623778; cv=none; b=hTWfxveAJil3vvq0HFzAAxKz637GxRoBTFu0dxsvpKnDC1w27P/4h953JcPN60xzHh28KZOwxqzdjtSE/4SAVCZAbQFyIRqFNTswx7XjmUoONyToN7Vm/VQWGk5k48tnScsMBCWMbWx6BtIJAkSWpdLt+FauUNK77kltWlgF4jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623778; c=relaxed/simple;
	bh=R+GQkx3puef57+9b3VSVVZDTg6EQ9j/hZFuE+EpWHL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iH+UsTUOadc3SUpGp0ZMRZfqqgY+IyO/nlvJoZUPbfTYPWjK/UDfadZ4L8CLyVeQ+iz1Uh84a3mEPuANAeo39sPx1+nRxeVurHwviJSI076cz+qDdxamqtJ4fBYjSjVgPJow+lGcZoxqsZMtwiQAtgp8ewL6uoCqVgYofq9c5Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDWzZqkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDWzZqkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132661F000E9;
	Tue, 16 Jun 2026 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623776;
	bh=pzSGFYfj80yoRt053EK3cfCiQqKULiRZUa9VRXABaCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDWzZqkDPMhrFXKiu7TwCzKXTJ2gnvbrwgB9SeNHGXiQeNIyKIba7/tpt0jDqb3/2
	 27tp2VwwlKcRFQsdiLZits/lctcyOlkXCpfO6qVI5V9uND+Mikx2HYaIyQsNFseSAT
	 kmI+q3dwT7qezsVNoXaP0x/nyDqAF9mamF3egPmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hopps <chopps@labn.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 7.0 206/378] xfrm: iptfs: fix ABBA deadlock in iptfs_destroy_state()
Date: Tue, 16 Jun 2026 20:27:17 +0530
Message-ID: <20260616145121.226888248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristmd@gmail.com>

commit c8a8a75b733467b00c08b91a38dbaf207a08ed6e upstream.

iptfs_destroy_state() calls hrtimer_cancel() while holding a spinlock
that the timer callback also acquires, leading to an ABBA deadlock on
SMP systems.

For the output timer (iptfs_timer):
  - iptfs_destroy_state() holds x->lock, calls hrtimer_cancel()
  - iptfs_delay_timer() callback takes x->lock

For the drop timer (drop_timer):
  - iptfs_destroy_state() holds drop_lock, calls hrtimer_cancel()
  - iptfs_drop_timer() callback takes drop_lock

Both timers use HRTIMER_MODE_REL_SOFT, so their callbacks run in softirq
context.  When hrtimer_cancel() is called for a soft timer that is
currently executing on another CPU, hrtimer_cancel_wait_running() spins
on softirq_expiry_lock -- the same lock held by the softirq running the
callback.  If the callback is blocked waiting for the spinlock held by
the caller of hrtimer_cancel(), a circular dependency forms:

  CPU 0: holds lock_A -> waits for softirq_expiry_lock
  CPU 1: holds softirq_expiry_lock -> waits for lock_A

Fix by calling hrtimer_cancel() before acquiring the respective locks.
hrtimer_cancel() is safe to call without holding any lock and will wait
for any in-progress callback to complete.  For the output timer, the
lock is still acquired afterwards to drain the packet queue.  For the
drop timer, the lock/unlock pair is removed entirely since it only
existed to serialize with the timer callback, which hrtimer_cancel()
already guarantees.

Found by source code audit.

Fixes: 4b3faf610cc6 ("xfrm: iptfs: add new iptfs xfrm mode impl")
Cc: Christian Hopps <chopps@labn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2730,8 +2730,9 @@ static void iptfs_destroy_state(struct x
 	if (!xtfs)
 		return;
 
-	spin_lock_bh(&xtfs->x->lock);
 	hrtimer_cancel(&xtfs->iptfs_timer);
+
+	spin_lock_bh(&xtfs->x->lock);
 	__skb_queue_head_init(&list);
 	skb_queue_splice_init(&xtfs->queue, &list);
 	spin_unlock_bh(&xtfs->x->lock);
@@ -2739,9 +2740,7 @@ static void iptfs_destroy_state(struct x
 	while ((skb = __skb_dequeue(&list)))
 		kfree_skb(skb);
 
-	spin_lock_bh(&xtfs->drop_lock);
 	hrtimer_cancel(&xtfs->drop_timer);
-	spin_unlock_bh(&xtfs->drop_lock);
 
 	if (xtfs->ra_newskb)
 		kfree_skb(xtfs->ra_newskb);


