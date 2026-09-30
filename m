Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AFC51EE0F;
	Wed, 30 Sep 2026 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793105; cv=none; b=R9t2ek9w0OIcMA5WTj/mW81IwRfeJJAhPjTpbSxFSQMfNMnw23uc/HVi2v6/DqFY+KpWGoL155KU1mfPU9fky16PbremliB4Gk5a76HpBD5oXj41gnG9GnBncpnG8lZtTw7CdHyvIP72h2IOHVWKuRvb1NLm6oVzNf/RBov0450=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793105; c=relaxed/simple;
	bh=DEiuukHFnx1I1J7pkEkGIZRcSdB0HSHt4s5iTJ6aPwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=czKDQrzgOOIn65IL9kpZPdtSCMUzCPea0dCtSYJzO+KOM2OMNFW1Or0em0R8c0g120ZwmR9bdyHGh8FTVMMqfOqERKSDICcQOR690wC2ON4zxXjfSVYCWr2Qam2oCW33m3PPFX+nd/zbkCe1x36si4QKy5bIfROy3sLMVprIE0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCxxS+u3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCxxS+u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B01F000FF;
	Wed, 30 Sep 2026 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793104;
	bh=IhDZ+MZjxftWzbxlF4y4PoHSJhU0QpszEjTrlHnQ+9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCxxS+u3M1NrX6uhay07EjFjm51W2RhWLTQc/O2q/8PWPdp9ZmolEoa7Jayly4O9S
	 YpvuZIOM3JOKu+nLMJO/c2g+alyiFN8LGR3R3t8XjbPhYk0XfCKjogayfQLynyf+d+
	 7CV3sj+hbbBkA4xZcBZqNBBgOPDcGrhm6EhVQ3Wc=
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
Subject: [PATCH 6.18 138/395] eth: fbnic: Avoid rounding zero ring sizes
Date: Wed, 30 Sep 2026 17:26:40 +0200
Message-ID: <20260930152343.638700013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08aed4103323e..d67be9f1a575f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
@@ -299,6 +299,11 @@ fbnic_get_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
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
@@ -320,10 +325,10 @@ fbnic_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
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



