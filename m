Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A50257849;
	Wed,  3 Dec 2025 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780520; cv=none; b=by5jnWHjQ76XF2F30UdC8j+gIJ6E6Rpj6fP6GPdf+BknwuNCYRuwzCUBOAWqEEMk94qri8aBFSrlr4VQ1leUPGcmRsnYS3xlQ1Tc/sr/zVuF0U59Blu7Bxr48q7UNYLN93ZfJ/w7knoDrjM6r5INug6Jhd+iTPpv92GWYfOmndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780520; c=relaxed/simple;
	bh=G1DlXEiv5FrpSYnUsFRJPr4wt1nQaAX4CWApaRtbeG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCyuHO2K93wiaI/+A6d5BAXgTTeMrUgvisN2spAcpejsp7yykCvXAPgxA56DB5KTuqdDqGs8TpYQ3KAygsmuSUBC+LND/QEkS+r6BGCZiQyHqQqcoNQf8fXM9FvCERCc2BQPQEgBQbtsDYdUEoPl/zrc6yNW2TLCe9vNL7Ua6Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIXkZSIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIXkZSIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88FCC4CEF5;
	Wed,  3 Dec 2025 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780520;
	bh=G1DlXEiv5FrpSYnUsFRJPr4wt1nQaAX4CWApaRtbeG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIXkZSIVJiyS++qIPxwYWME8H9Y6XYmb3FRxTzzSXueNlByDOHmsosHy+lBI2o6KE
	 8ut1cmjR5A1HFPLq6yX3U7Ba8oCHwWx9ewaWBesdBxSmBs5RdQBlrShsuUD5GbBTUw
	 D6uoxpgcZ1GslBSDJJpQ9NwOSOoXRanNBekuRlD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	syzbot+c4c7bf27f6b0c4bd97fe@syzkaller.appspotmail.com,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/132] veth: prevent NULL pointer dereference in veth_xdp_rcv
Date: Wed,  3 Dec 2025 16:28:10 +0100
Message-ID: <20251203152343.712241518@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit 9337c54401a5bb6ac3c9f6c71dd2a9130cfba82e ]

The veth peer device is RCU protected, but when the peer device gets
deleted (veth_dellink) then the pointer is assigned NULL (via
RCU_INIT_POINTER).

This patch adds a necessary NULL check in veth_xdp_rcv when accessing
the veth peer net_device.

This fixes a bug introduced in commit dc82a33297fc ("veth: apply qdisc
backpressure on full ptr_ring to reduce TX drops"). The bug is a race
and only triggers when having inflight packets on a veth that is being
deleted.

Reported-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Closes: https://lore.kernel.org/all/fecfcad0-7a16-42b8-bff2-66ee83a6e5c4@linux.dev/
Reported-by: syzbot+c4c7bf27f6b0c4bd97fe@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/683da55e.a00a0220.d8eae.0052.GAE@google.com/
Fixes: dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops")
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://patch.msgid.link/174964557873.519608.10855046105237280978.stgit@firesoul
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a14602fcae17 ("veth: reduce XDP no_direct return section to fix race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 44903e2b0925e..25b43036cc08b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -909,7 +909,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 
 	/* NAPI functions as RCU section */
 	peer_dev = rcu_dereference_check(priv->peer, rcu_read_lock_bh_held());
-	peer_txq = netdev_get_tx_queue(peer_dev, queue_idx);
+	peer_txq = peer_dev ? netdev_get_tx_queue(peer_dev, queue_idx) : NULL;
 
 	for (i = 0; i < budget; i++) {
 		void *ptr = __ptr_ring_consume(&rq->xdp_ring);
@@ -959,7 +959,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	rq->stats.vs.xdp_packets += done;
 	u64_stats_update_end(&rq->stats.syncp);
 
-	if (unlikely(netif_tx_queue_stopped(peer_txq)))
+	if (peer_txq && unlikely(netif_tx_queue_stopped(peer_txq)))
 		netif_tx_wake_queue(peer_txq);
 
 	return done;
-- 
2.51.0



