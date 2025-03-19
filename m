Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E132144DB;
	Wed, 19 Mar 2025 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395044; cv=none; b=IzH56APm1GIqQ1yrXLXVSi76yoS1ET0LOqZobv45WEmW0KWdKbcueWIm1cC8DWgk/D51tV1abjXUA/khnWeWohIgjWIZV27e6G6yS5lcWRqeefx4bFOgLIQT5sdc4EafBlq/Jjf5o8KAymdsFBqaNCBUig5EN5ff9+JtJ4HN968=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395044; c=relaxed/simple;
	bh=VeaTGD0ou/V63ug1bDJMRn4bwKJ9pp9QZxBdFrXP9sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcdlolFnOJ2cMzNyUq2sxw4wbvSdxIuq9mti6fhXScvfMF2V4mjH/kORPFulPN6143ESNGJH1O5WJGrutfo4iMc7tcFSZ6ce5kqHxxxP6qFo38oLT6O9vbK7C3cUO9pL21WfWQL8qRnEZ5ciuzkKkuU7UhF7hGVRvq90X1Tq8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVX3wvV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVX3wvV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9245C4CEE4;
	Wed, 19 Mar 2025 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395044;
	bh=VeaTGD0ou/V63ug1bDJMRn4bwKJ9pp9QZxBdFrXP9sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVX3wvV6YTc9AZ4IWenYz6T7h28aug8kYUAuB2EC/g+C7emhk0emasaCwzIfMp4xk
	 krVjUAiUdMg8Uu0sY9J+lAMTmRHrhIQYwjbXGkzGHa1XB4JKht/yZFJPC2Zy/tVyvc
	 YnGfYb1WYwRvNcJiENya2vri4orpaBR9+3YbAtHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/231] rtase: Fix improper release of ring list entries in rtase_sw_reset
Date: Wed, 19 Mar 2025 07:28:56 -0700
Message-ID: <20250319143027.878152871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit 415f135ace7fd824cde083184a922e39156055b5 ]

Since rtase_init_ring, which is called within rtase_sw_reset, adds ring
entries already present in the ring list back into the list, it causes
the ring list to form a cycle. This results in list_for_each_entry_safe
failing to find an endpoint during traversal, leading to an error.
Therefore, it is necessary to remove the previously added ring_list nodes
before calling rtase_init_ring.

Fixes: 079600489960 ("rtase: Implement net_device_ops")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306070510.18129-1-justinlai0215@realtek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index 14ffd45e9a25a..86dd034fdddc5 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1501,7 +1501,10 @@ static void rtase_wait_for_quiescence(const struct net_device *dev)
 static void rtase_sw_reset(struct net_device *dev)
 {
 	struct rtase_private *tp = netdev_priv(dev);
+	struct rtase_ring *ring, *tmp;
+	struct rtase_int_vector *ivec;
 	int ret;
+	u32 i;
 
 	netif_stop_queue(dev);
 	netif_carrier_off(dev);
@@ -1512,6 +1515,13 @@ static void rtase_sw_reset(struct net_device *dev)
 	rtase_tx_clear(tp);
 	rtase_rx_clear(tp);
 
+	for (i = 0; i < tp->int_nums; i++) {
+		ivec = &tp->int_vector[i];
+		list_for_each_entry_safe(ring, tmp, &ivec->ring_list,
+					 ring_entry)
+			list_del(&ring->ring_entry);
+	}
+
 	ret = rtase_init_ring(dev);
 	if (ret) {
 		netdev_err(dev, "unable to init ring\n");
-- 
2.39.5



