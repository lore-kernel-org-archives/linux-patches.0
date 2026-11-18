Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057713;
	b=dVmB7VFdw/H8YyejmTJZKB9bU9m4hmnLMomsOXCF4QqfWmQyhgTSv6cMu03BKbJ2YY6M
	 3EIT6+KL5JrUb8YXYW/fv2ibk9TsWqHXNZH/weiY31rjXKBoG91+dv1/8wGn2CABm2xRO
	 cqPJUyxANdANDvYvwFE8Hh69K2AfkjuhUvXpdmW2eoxEGNp5qxMnUBEvBY+C0BDtrLJ+b
	 Tsabhwrm2VzKXvj2R8KHLumHAqrWOwu/EojMhefvOblUuUhLTCvSgEK06VzHQdu7IoQJ3
	 0RWgpRjScrCDnP28bBxbUKDPrxWuwjz8dPqF909Vjq6kfMB4VNnY/gta4YOnGlmtgGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAwoKWH5hZJATjqPbzN2/Xb1sxvrpBESNWW3NKzQ16s=;
	b=uEXyeJYtj0/1ESJPObDNgIUgqiQfVv+fNe/eBWJLUQgPdvDZz2kdz+xx0fQ1CXFcfGMt
	 Nd5XDGP9Ts6Xq1KYNhbKwoSZhqBg0yrbM7ZWsn3lkSPjuepCJmX6zKbcIABrkmaxhR0mw
	 K/uQ6YwwHSkahzPizTPNlC5H/nE69ayfVktuSzqzfsGttEzNbFbeIi5x7Jue5oLqcvza/
	 slCfcsoYxzhljhg6TsujuDV/kLQBCGptpU50lpdL3s1tKxlj/9PFkt1/ihryQJHbf8PZd
	 Zsb7eTbbH5NDee+4v0JlqAkuT1pxNqfFBsDHvVVf4UlpUTTXBJ6tTnsVSrwGuyxIURw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yln4yVup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD2606A32A;
	Thu, 19 Nov 2026 03:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yln4yVup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B8B1F000C4;
	Thu, 19 Nov 2026 03:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057713;
	bh=vAwoKWH5hZJATjqPbzN2/Xb1sxvrpBESNWW3NKzQ16s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yln4yVupuTgM0Zx7oIU0r2krUHDdcWhtDCKnAMPTocV1OjP3Qy1wxPD7J4cGYDjfl
	 lyAf6vp59LlTa9PpdtehRpk9B19opLgxWd0TxrNJqS3FMN4H5q2U7j5ydO1u/3pJc7
	 78B3/jD7h7ouf6AnCwQPeeBq7Sjh720v7IyxSMDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Manjunath Patil <manjunath.b.patil@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0229/1848] net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless qdiscs
Date: Wed, 18 Nov 2026 15:37:47 +0100
Message-ID: <20261118145921.582688989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 7f083faf59d14c04e01ec05a7507f036c965acf8 ]

When shrinking the number of real tx queues,
netif_set_real_num_tx_queues() calls qdisc_reset_all_tx_gt() to flush
qdiscs for queues which will no longer be used.

qdisc_reset_all_tx_gt() currently serializes qdisc_reset() with
qdisc_lock(). However, for lockless qdiscs, the dequeue path is
serialized by qdisc_run_begin/end() using qdisc->seqlock instead, so
qdisc_reset() can run concurrently with __qdisc_run() and free skbs
while they are still being dequeued, leading to UAF.

Serialize qdisc_reset_all_tx_gt() against the lockless dequeue path by
taking qdisc->seqlock for TCQ_F_NOLOCK qdiscs, matching the
serialization model already used by dev_reset_queue().

Additionally clear QDISC_STATE_NON_EMPTY after reset so the qdisc state
reflects an empty queue, avoiding needless re-scheduling.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260228145307.3955532-1-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 7f083faf59d14c04e01ec05a7507f036c965acf8)

Conflicts:
 - include/net/sch_generic.h: retain the older qdisc state model. It has
   no __QDISC_STATE_DRAINING or QDISC_STATE_NON_EMPTY, so serialize reset
   with seqlock and clear __QDISC_STATE_MISSED, matching dev_reset_queue().

Assisted-by: Codex:gpt-6
Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -745,13 +745,22 @@ static inline bool skb_skip_tc_classify(
 static inline void qdisc_reset_all_tx_gt(struct net_device *dev, unsigned int i)
 {
 	struct Qdisc *qdisc;
+	bool nolock;
 
 	for (; i < dev->num_tx_queues; i++) {
 		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, i)->qdisc);
 		if (qdisc) {
+			nolock = qdisc->flags & TCQ_F_NOLOCK;
+
+			if (nolock)
+				spin_lock_bh(&qdisc->seqlock);
 			spin_lock_bh(qdisc_lock(qdisc));
 			qdisc_reset(qdisc);
 			spin_unlock_bh(qdisc_lock(qdisc));
+			if (nolock) {
+				clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+				spin_unlock_bh(&qdisc->seqlock);
+			}
 		}
 	}
 }


