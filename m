Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9294F55B6;
	Wed, 30 Sep 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787247; cv=none; b=Lk9KtxbIti1sm0lQM8s/Ae80pYDgcsSyQ80weTG8rr0slC2zfiTzTJ6hlbyZzRnl0mh6VtnKkxmVPKAgzgv5DNorQ2ofNkZM/9SVvcsXxEjtVfZ6e+FdtpE74Wu/jPdt/ik1vZJU5WoOaK2paLTJ6yaJZq9G8LFVbgJ9aK67uhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787247; c=relaxed/simple;
	bh=DZC69UUL5A637Vt+a1AFU54Pf5bsSplYL/Q80mXjlXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScxWvsKRoaUszbdGabhqQ0dRQD06za4sybq1kyhme+lOwXpjjgUTVgCEZJzPgJ8MhPvNZnmEv4pgMdwtJz/0y5tc1MdONiLP11QIRlNbcWVBBxJFEg3YNmuhP/PqTT5UF0qexwYMDUUi++rKFrUPmSo0Cz123D05LdonE0PRvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OC/P6c4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OC/P6c4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420181F000FF;
	Wed, 30 Sep 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787245;
	bh=ASzd9+wXGz6rtgxXKeCjWrU86Wlb2QN7LSmn35tzyws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OC/P6c4z5iFaXMQf+3TB2kHCD1HIOsQpK2FJOxJRGMjVY7B45zq/XiXAfRj7pVujm
	 mnrhp98q1Ebh5WuvTtDBajjLpzI5qJvMUsvhQeJC9RPs5MWrNEqV4aPaH/5+zrlaz4
	 JIx5t+h/PIenvTH96+/Be9ZbBMOWQyUaBx2cfMD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 164/457] eth: fbnic: Avoid rounding zero ring sizes
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152349.589055870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 0160953d8eec75c3c55562158c46442ff1fd410b ]

roundup_pow_of_two() is undefined for zero. ethtool permits a zero ring
size to reach the driver, where the minimum-size check should reject it.

Leave zero unchanged while rounding nonzero ring sizes. The minimum-size
check then rejects zero deterministically without changing the established
behavior for other values.

Fixes: 6cbf18a05c06 ("eth: fbnic: support ring size configuration")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Link: https://lore.kernel.org/netdev/178971206933.22033.236948278674126701@kernel.org/
Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260918114641.1281172-1-bjorn@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
index 423f179c9d475..76e9a545bb165 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
@@ -313,6 +313,11 @@ fbnic_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 	kernel_ring->hds_thresh = fbn->hds_thresh;
 }
 
+static u32 fbnic_ring_size_pow2(u32 size)
+{
+	return size ? roundup_pow_of_two(size) : 0;
+}
+
 static void fbnic_set_rings(struct fbnic_net *fbn,
 			    struct ethtool_ringparam *ring,
 			    struct kernel_ethtool_ringparam *kernel_ring)
@@ -334,10 +339,10 @@ fbnic_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 	struct fbnic_net *clone;
 	int err;
 
-	ring->rx_pending	= roundup_pow_of_two(ring->rx_pending);
-	ring->rx_mini_pending	= roundup_pow_of_two(ring->rx_mini_pending);
-	ring->rx_jumbo_pending	= roundup_pow_of_two(ring->rx_jumbo_pending);
-	ring->tx_pending	= roundup_pow_of_two(ring->tx_pending);
+	ring->rx_pending	= fbnic_ring_size_pow2(ring->rx_pending);
+	ring->rx_mini_pending	= fbnic_ring_size_pow2(ring->rx_mini_pending);
+	ring->rx_jumbo_pending	= fbnic_ring_size_pow2(ring->rx_jumbo_pending);
+	ring->tx_pending	= fbnic_ring_size_pow2(ring->tx_pending);
 
 	/* These are absolute minimums allowing the device and driver to operate
 	 * but not necessarily guarantee reasonable performance. Settings below
-- 
2.53.0



