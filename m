Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECDA143C50;
	Thu, 13 Jun 2024 11:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279549; cv=none; b=XkZSxm8kkjIFPioB+O5N8n68fT6srptP+fEnJ/WijJQZ48uIyhCUHBA6tyoftIfw2viBHJW8MrgiTDcc39mMyGp9SYK2M0Dt/LuLsRRkkgvjROopNu0XY9pMswIluygXYY+TaDQfrGp+oZRf8vgs8jMS2Iku7R+gbq9pFrJ84VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279549; c=relaxed/simple;
	bh=ubiqn1o67vaqW2+4LHJNnYVicdnmWBkx4v5Bd9qznRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clIm6G8tXeOtMrmb8mLVjKO5lCwZREDN/DaG8xnwokmFh1/z1uYwQ1ERxjC6C/DFTqiqHp1IFGt2VUzuU0DAWyfo9osYLbLXWXjJgBX/iJhNYgiy9qTBA9WEGeQBZwxSaSRRUI0nU1z5BPpQ1pRBjRggSIvNKlKPxe2JL44ika8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWC3BKid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWC3BKid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C39C32786;
	Thu, 13 Jun 2024 11:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279548;
	bh=ubiqn1o67vaqW2+4LHJNnYVicdnmWBkx4v5Bd9qznRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWC3BKidtc4dZWlJkAk5dDhNEX9unxi17NsRSCm1eQSuxZPrLl1v2pZb7MbPhiVIW
	 g0mOka1rYGcuZRk7DU7dvYNQNIE2iqnHYDQDE4QlXvoH/cAPEppvjNfSmR8/pSb0bS
	 RUdReRvV6Op12vGTuNHaDYbonE09fMwYur1QHc9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuval El-Hanany <YuvalE@radware.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.9 113/157] Revert "xsk: Support redirect to any socket bound to the same umem"
Date: Thu, 13 Jun 2024 13:33:58 +0200
Message-ID: <20240613113231.791031267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 7fcf26b315bbb728036da0862de6b335da83dff2 upstream.

This reverts commit 2863d665ea41282379f108e4da6c8a2366ba66db.

This patch introduced a potential kernel crash when multiple napi instances
redirect to the same AF_XDP socket. By removing the queue_index check, it is
possible for multiple napi instances to access the Rx ring at the same time,
which will result in a corrupted ring state which can lead to a crash when
flushing the rings in __xsk_flush(). This can happen when the linked list of
sockets to flush gets corrupted by concurrent accesses. A quick and small fix
is not possible, so let us revert this for now.

Reported-by: Yuval El-Hanany <YuvalE@radware.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/xdp-newbies/8100DBDC-0B7C-49DB-9995-6027F6E63147@radware.com
Link: https://lore.kernel.org/bpf/20240604122927.29080-2-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 727aa20be4bd..7d1c0986f9bb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -313,13 +313,10 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 
 static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
-	struct net_device *dev = xdp->rxq->dev;
-	u32 qid = xdp->rxq->queue_index;
-
 	if (!xsk_is_bound(xs))
 		return -ENXIO;
 
-	if (!dev->_rx[qid].pool || xs->umem != dev->_rx[qid].pool->umem)
+	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
 	if (len > xsk_pool_get_rx_frame_size(xs->pool) && !xs->sg) {
-- 
2.45.2



