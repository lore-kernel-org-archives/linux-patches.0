Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827182;
	b=k+CzJtUqYl+pIW1KswuboDtlCcWW1pZNulVsk5I4jvLHceKYD5ivmPmbKU4gxWLWApHr
	 ZtPG68mxThhuQ9nUcY4d9+h8lPOA05mciEALb40IEdU0pjEb7Cy2iPpebDXADBThw3aHY
	 jV1XhFfjypGDH39eUMWkSwD/WLlDT3scRH5pOc426Q+UHtMQU1SJIlYkxqSlEm+BVHO5v
	 QnaS4haEBNErNiF7IhhCwqzgaHv6JOcSStgRG4h79C13i7ysJ5acrTCg5PYs3BPGy5koc
	 Mc+uBtRxdSPaa2IWtn319aaspsEhWydeqgR5uVtIruVbHmCBPeo3tq4gJe1t3xeZUTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iy009OI28TStQH+dAvn/7McWuWTh94+ax7gBqacmQNI=;
	b=nGL4QepN1b+hpPNE2He2Y8xwcfyFHMyXcPDbQTCMk3nfJXYxCu45gmpL6RE7pWn2lV84
	 A6JwGpY7Wvm1r8Rh2iz/GY0ma3Z/xYjCiuGO5ilYjPlRjcxyEgZ/nkoGdOmcVYhRgviyZ
	 rGUbnidkGIiAUkBMbVu45PLPbmFrhAQhLV5+k2AelZ57HqT2qJdwhyv3t9WkRhJyl2E5L
	 +w+33Ll8FyTZecHkbHfqTCA3i3y+HbA3NKUBNo5K5LAkC5lBQvmZkrH4mA+cWI17UoMhr
	 HSuFx1MA7cYz0VU/BfDSr1BvaD2QY7Wt4O7KU3SdoGGe5VaYFV1hi18Yt4nDtfA93iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3F82tgG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49613606A846;
	Wed,  4 Nov 2026 21:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3F82tgG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C225E1F00919;
	Wed,  4 Nov 2026 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827182;
	bh=Iy009OI28TStQH+dAvn/7McWuWTh94+ax7gBqacmQNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3F82tgGAme97dbBzdW4iU8sf3xaj8tkRlZHvmH/RJYZUHzjBxGddkT3BIgP+9Uax
	 pseiGTWwzmwGlt41QI7HDXDv8pp3RzqY6nqX/awnUKFVgRZJ7G6PytViuAdQ4ak9rz
	 NIHMhRymkBURQkgY0G9WABTOLeeADw+2bbCqZ6zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 243/547] net: sched: prevent scheduling deactivated qdiscs
Date: Wed,  4 Nov 2026 16:07:07 -0500
Message-ID: <20261104211045.074338978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit d6f81fd6abe209f9803d8f74ce9ec69b8126bad3 upstream.

TAPRIO can schedule a deactivated qdisc after some_qdisc_is_busy() has
reported it idle.

Commit 47e8dbb6e763 ("net/sched: do not reset queues in graft operations")
made graft deactivation skip queue reset, leaving TAPRIO's timer armed.

A late callback schedules NET_TX softirq work, whose dequeue path can
race the unlocked child-queue reset in taprio_reset(). The same skb can
be queued for deferred freeing by RTNL and dequeued for transmission.
In the reproducer, the TAP reader frees it before __rtnl_unlock() reads
its next pointer. KASAN reports a slab-use-after-free in
__rtnl_unlock+0xa3/0xd0, with a read of size 8 from the freed skb.

Reject deactivated qdiscs in __netif_schedule(). Callers' RCU protection
lets the existing grace period join earlier scheduling calls before the
busy check. Restart nonempty transmit queues on reactivation so suppressed
scheduling does not strand packets.

Fixes: 47e8dbb6e763 ("net/sched: do not reset queues in graft operations")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260805102514.740834-1-david.lee@trailofbits.com/
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c          |    3 +++
 net/sched/sch_generic.c |    4 ++++
 2 files changed, 7 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3440,6 +3440,9 @@ static void __netif_reschedule(struct Qd
 
 void __netif_schedule(struct Qdisc *q)
 {
+	if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
+		return;
+
 	/* If q->defer_list is not empty, at least one thread is
 	 * in __dev_xmit_skb() before llist_del_all(&q->defer_list).
 	 * This thread will attempt to run the queue.
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1288,6 +1288,10 @@ static void transition_one_qdisc(struct
 	if (need_watchdog_p) {
 		WRITE_ONCE(dev_queue->trans_start, jiffies);
 		*need_watchdog_p = 1;
+
+		/* Resume backlog left by a suppressed schedule while deactivated. */
+		if (!qdisc_is_empty(new_qdisc))
+			netif_schedule_queue(dev_queue);
 	}
 }
 


