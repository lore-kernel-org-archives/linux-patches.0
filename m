Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E1525178A;
	Mon, 12 May 2025 17:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071857; cv=none; b=efb214fq/eOwGIlDHd5mj5aZIQoLWCq9VPtNGj1Vk8ZJQ4KFefHqQULbvN2JhNaE3Vlf1TvfsJGavCE19EZH9HE5XTeTyjlu77LgPFSEbGk8ApaHpjJM+m8/gtJ5AeZVN1sIWIdbYkTiZ0w2OyPfRlNAVj2ZOZ6SZ7Te2B754+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071857; c=relaxed/simple;
	bh=XLYv7Gy4IfNRRFQUjRJHwgMs+6rEmOA4u9oBxJ42FZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/q8o96rguV57SNcTfz6a2nsVNtHtlCBbOIp1j8ss00IG54rpEp3XLWds/HGy8SppFM0bTNUJvUQgNq3FZEJtYyTj8uPLmg1c0VGH5z7Y9Lr7KnIdqgxY+MlLIcZ3/y2hZQC5HltIPVm7QIxHMWk+FmA8ov+AmdgmPxZH2Y43rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/1Fxk3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/1Fxk3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C0C4CEE7;
	Mon, 12 May 2025 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071857;
	bh=XLYv7Gy4IfNRRFQUjRJHwgMs+6rEmOA4u9oBxJ42FZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/1Fxk3lTUZrw3ev2LaphYVxdZ5RQv6gtACn077Y0UHFp/eYdRlUu8r6aIyvSja+H
	 PtmIFCWcfRaf9kPhBWSME08gbyei7BazZ+UupS+s7Q0cwElAd4cdem82nkTky0/yfb
	 tU7AYwBkLah4wAw2DAXtqAmD5Kvv/oMxuPUH+VEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 053/197] virtio-net: fix total qstat values
Date: Mon, 12 May 2025 19:38:23 +0200
Message-ID: <20250512172046.550659457@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 001160ec8c59115efc39e197d40829bdafd4d7f5 ]

NIPA tests report that the interface statistics reported
via qstat are lower than those reported via ip link.
Looks like this is because some tests flip the queue
count up and down, and we end up with some of the traffic
accounted on disabled queues.

Add up counters from disabled queues.

Fixes: d888f04c09bb ("virtio-net: support queue stat")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250507003221.823267-3-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 54f883c962373..8879af5292b49 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5663,6 +5663,10 @@ static void virtnet_get_base_stats(struct net_device *dev,
 
 	if (vi->device_stats_cap & VIRTIO_NET_STATS_TYPE_TX_SPEED)
 		tx->hw_drop_ratelimits = 0;
+
+	netdev_stat_queue_sum(dev,
+			      dev->real_num_rx_queues, vi->max_queue_pairs, rx,
+			      dev->real_num_tx_queues, vi->max_queue_pairs, tx);
 }
 
 static const struct netdev_stat_ops virtnet_stat_ops = {
-- 
2.39.5



