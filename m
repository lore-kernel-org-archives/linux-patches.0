Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C058349AE0;
	Wed,  3 Dec 2025 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780597; cv=none; b=F2/KpqGN1kIIcOn3QTvE7DbKmg/JVQI0z3y7Y57u/RlcXBDk+7ypKJZKWuNplB/4mWDcC10DxpKS6kQjxe06tITKl6poEbwCM17O9dTQ+YxSnnL+ABsCogOgg0lSKEAsP05IqGZNxXdBkgGn/bvmx0xZIOB+JkTRn6lvPMmdvaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780597; c=relaxed/simple;
	bh=oICig/v+ikYFpAJeZ7QZktP7cMngW8eOoMdyjiQUxFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQxlytcR8yBgOjp5hOmlK1p/DxdSK4XMycScVGtAW4kd9ICnZzcGo2XMfGaufmsYdQpgZwkMfDO7YXbqvuqJ2JAniVuOuC1qoKXwqk+l3zDhU5ryNRJG6ye59BC719aFZtlEcypMicEc6D6mDbwgHtBUL9rphBWQTBgVeZ5tyNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKRx2dax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKRx2dax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03663C4CEF5;
	Wed,  3 Dec 2025 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780597;
	bh=oICig/v+ikYFpAJeZ7QZktP7cMngW8eOoMdyjiQUxFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKRx2daxGHbnXTVq5WLPc0T+9ecUlNeV6mgsXHCbiANIZlmI8dvSpw0Pvgk+t7AU6
	 WUOu8D5vZw03PzpW47GEK2pdVSnrHGnvHov44ApYPnrjGuoobwm0ItEVvSjy9iqyKw
	 DzbGf4pe2IfXnb0xIz2jn60AUMuSOlxZn9fYEuRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/132] net: sched: generalize check for no-queue qdisc on TX queue
Date: Wed,  3 Dec 2025 16:28:08 +0100
Message-ID: <20251203152343.637307392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit 34dd0fecaa02d654c447d43a7e4c72f9b18b7033 ]

The "noqueue" qdisc can either be directly attached, or get default
attached if net_device priv_flags has IFF_NO_QUEUE. In both cases, the
allocated Qdisc structure gets it's enqueue function pointer reset to
NULL by noqueue_init() via noqueue_qdisc_ops.

This is a common case for software virtual net_devices. For these devices
with no-queue, the transmission path in __dev_queue_xmit() will bypass
the qdisc layer. Directly invoking device drivers ndo_start_xmit (via
dev_hard_start_xmit).  In this mode the device driver is not allowed to
ask for packets to be queued (either via returning NETDEV_TX_BUSY or
stopping the TXQ).

The simplest and most reliable way to identify this no-queue case is by
checking if enqueue == NULL.

The vrf driver currently open-codes this check (!qdisc->enqueue). While
functionally correct, this low-level detail is better encapsulated in a
dedicated helper for clarity and long-term maintainability.

To make this behavior more explicit and reusable, this patch introduce a
new helper: qdisc_txq_has_no_queue(). Helper will also be used by the
veth driver in the next patch, which introduces optional qdisc-based
backpressure.

This is a non-functional change.

Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/174559293172.827981.7583862632045264175.stgit@firesoul
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a14602fcae17 ("veth: reduce XDP no_direct return section to fix race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c         | 4 +---
 include/net/sch_generic.h | 8 ++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 89dde220058a2..b62462d8eff26 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -352,15 +352,13 @@ static int vrf_ifindex_lookup_by_table_id(struct net *net, u32 table_id)
 static bool qdisc_tx_is_default(const struct net_device *dev)
 {
 	struct netdev_queue *txq;
-	struct Qdisc *qdisc;
 
 	if (dev->num_tx_queues > 1)
 		return false;
 
 	txq = netdev_get_tx_queue(dev, 0);
-	qdisc = rcu_access_pointer(txq->qdisc);
 
-	return !qdisc->enqueue;
+	return qdisc_txq_has_no_queue(txq);
 }
 
 /* Local traffic destined to local address. Reinsert the packet to rx
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index a9d7e9ecee6b5..1e002b1dea629 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -803,6 +803,14 @@ static inline bool qdisc_tx_changing(const struct net_device *dev)
 	return false;
 }
 
+/* "noqueue" qdisc identified by not having any enqueue, see noqueue_init() */
+static inline bool qdisc_txq_has_no_queue(const struct netdev_queue *txq)
+{
+	struct Qdisc *qdisc = rcu_access_pointer(txq->qdisc);
+
+	return qdisc->enqueue == NULL;
+}
+
 /* Is the device using the noop qdisc on all queues?  */
 static inline bool qdisc_tx_is_noop(const struct net_device *dev)
 {
-- 
2.51.0



