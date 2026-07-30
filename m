Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D773B05B8;
	Thu, 30 Jul 2026 15:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427005; cv=none; b=ZvHuMlgAlAVqlGrWLN87aKPk5frCxpaKjGsX1tgZd942SerOmDBdGPOX3DYoCNLHLfl94noPgxgQ04lnU61FnrMuWaQLno+6z5VC0xiaBu0qW0D+marVYQShWW9cEdEcdhj0ToCV1av3pVnieLs/tTR6Qe+wqSMw38LwWvJ3V00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427005; c=relaxed/simple;
	bh=uuKATU8MT/TWnwCx3oH5m+n6rsYAxcFBMsfwnG7AKlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0k3t1JGfRTtSVWftcXiBc7ExltX66NjkcgVmlzwPUu3ZgCm0q+9AzDzberywaCPVXpiVIVAf6FRl8TD4BxvXWzSrXn+66Hfc8djRWPKchuXEN+sqSM2Mvok7hS7jeRQ6NqIQBPy24g2ddlIhdRuPrUZlKcJhj/M2MYwS45UJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE1eF3PO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE1eF3PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E2A1F000E9;
	Thu, 30 Jul 2026 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427004;
	bh=J3A0WfOK7kF3SHPr6cZ8I/W0iNPKzlIo640Li7C3feQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eE1eF3PODe4/ceNuvhhPo2EPlyixSVJF5XL2PBMnAjzsZoszyLChU8lXXhfZ+B6zx
	 ZjnMGy+KPoDpDl/mZfpvZJAqAPeli7JI/0T34LS0Qi8EpJcYyCIlI/ANjJvD+N+mO5
	 zg3o2u+pWxZzq5myGdl9Qo+Qu/gKYNFHZqWjFycg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/484] can: bcm: fix data race on rx_stamp/rx_ifindex in bcm_rx_handler()
Date: Thu, 30 Jul 2026 16:08:36 +0200
Message-ID: <20260730141423.842474111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 58fd6cbc8541216af1d7ed272ea7ac2b66d50fd8 upstream.

For an rx op subscribed on all interfaces (ifindex == 0), the same op
is registered once in the shared per-netns wildcard filter list, so
bcm_rx_handler() can run concurrently on different CPUs for frames
arriving on different net devices.

op->rx_stamp and op->rx_ifindex were written before bcm_rx_update_lock was
taken, allowing concurrent writers to race each other - including a torn
store of the 64-bit rx_stamp on 32-bit platforms.

Beyond a torn store bcm_send_to_user() must report the timestamp/ifindex
of the very same frame whose content it is delivering. So the assignment
is placed in the same unbroken bcm_rx_update_lock section as the content
comparison.

As a side effect, the RTR-request frame feature (which never reach
bcm_send_to_user()) no longer updates rx_stamp/rx_ifindex, since only
the notification path needs them.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-can/20260707145135.5BC831F00A3A@smtp.kernel.org/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-10-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 80d065b5ebe467..0869630a0dc06b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -761,11 +761,6 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 	/* disable timeout */
 	hrtimer_cancel(&op->timer);
 
-	/* save rx timestamp */
-	op->rx_stamp = skb->tstamp;
-	/* save originator for recvfrom() */
-	op->rx_ifindex = skb->dev->ifindex;
-
 	/* op->flags/op->frames may be updated concurrently by bcm_rx_setup() */
 	spin_lock_bh(&op->bcm_rx_update_lock);
 
@@ -789,6 +784,14 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 	 */
 	bcm_update_rx_stats(op);
 
+	/* save rx timestamp and originator for recvfrom() under lock.
+	 * For an op subscribed on all interfaces (ifindex == 0)
+	 * bcm_rx_handler() can run concurrently on different CPUs so
+	 * the CAN content and the meta data must be bundled correctly.
+	 */
+	op->rx_stamp = skb->tstamp;
+	op->rx_ifindex = skb->dev->ifindex;
+
 	if (op->flags & RX_FILTER_ID) {
 		/* the easiest case */
 		bcm_rx_update_and_send(op, op->last_frames, rxframe);
-- 
2.53.0



