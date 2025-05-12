Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565FF2512EF;
	Mon, 12 May 2025 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072777; cv=none; b=lMtlg3N4lPPZsSkjmj1fb2oGCa5zxBxJ26H3MThFkUc+x3Ev5WLE7SM38PxQMn0jHE4JUSw6GTSkhsxSz/Zo+CSiyqWeUE5LEF5KvwRgkttcOC1FOEg49ixubuZ4G+5gOyhHffJiQf3igYMWadVDUGzoKwJR0yjorakdWAIlZac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072777; c=relaxed/simple;
	bh=3Q3TRPDFOubwGF1/wg2ePVfybWY6XXt4h+7LoJbFmlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHbiVxUe8ErOw+/p/k/3CAKbclxlO+TXZIEtOuPX0BBlt/XNWblzOa1kV36RVx1iV5OHS0JABF/oa/ymwdpJa45vZsnz9b6cWJIvXkJuP5zppSc5G6PiN+Mv60vtJI9hCzkzADnIwiHd5NYd7Wm82oZ/rwSrSSL5k9HLVMrrG5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLvS14iL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLvS14iL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED49C4CEE7;
	Mon, 12 May 2025 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072777;
	bh=3Q3TRPDFOubwGF1/wg2ePVfybWY6XXt4h+7LoJbFmlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLvS14iLW0SSrlNcx7NH72rGcRqOQOgWhRX6RbMM9jj2GHj/q3LDo1o4nHuDsNFfN
	 HrL1J+h0RRVy4VNzMch56MfXmxEuTWBOJ07Uj7lO0mz1je7SSx5+zEz/A284hsfQDI
	 9reFGnJXmglbCims6rqBfHBOSdFDjSDhMy7M7bFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/184] virtio-net: fix total qstat values
Date: Mon, 12 May 2025 19:44:14 +0200
Message-ID: <20250512172043.898159631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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
index 9493b1134875e..fbd1150c33cce 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5427,6 +5427,10 @@ static void virtnet_get_base_stats(struct net_device *dev,
 
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



