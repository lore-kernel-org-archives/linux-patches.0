Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4B18C005;
	Tue, 10 Sep 2024 09:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961270; cv=none; b=Z9NyTEyP558UDnJ80RKBVPzGzYIxFvImj1TZ9xdegQmiCBzk9b1Fon71dA15JcbeP8AfoBXQEJMpOCivWBiaqC+o5wCJCC6ipStXo3NFBOfGvgWRs8f7LAyzNveX5SiZMR6jCXyTq+HZ2LeTKkl9lIN/MRZEh7bdPFwIjWoGCg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961270; c=relaxed/simple;
	bh=KBBjihkbmNOyV0dX8IJEOv4QvJTjghomZKm8hbIGnuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuMvCfoSEl9dyNV56FrNyNxrO37rdTvMe0V6yEAycH1S5bDG8i3TR0W5amc8D74d+ncVbPDkj/YvEHgGalYgi4vtE6q/eL6qmkquo/a9aHrBLoaSrraQJiO/jReSJT2RG4RF2hCg2blnzx7p05pS76A/We38oE5dMInP5C96noA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a07Oz9iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a07Oz9iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00234C4CEC3;
	Tue, 10 Sep 2024 09:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961270;
	bh=KBBjihkbmNOyV0dX8IJEOv4QvJTjghomZKm8hbIGnuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a07Oz9iWhFGm9Lto7vNr5UvHz4z3ZFwYCKiQjKIXaV4lmlPT+WggRMq09dIvoFEoF
	 eXVeZoeXfc2YDEqeHV+7aVJ34n53bW9yYAqRewxHwlqx49VIbdtkwUWjcvywT2AWgT
	 rE4lGbde93WHxrnQxxJk189SB3szA4rG85jvIBsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Julien Panis <jpanis@baylibre.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 004/375] net: ethernet: ti: am65-cpsw: Fix NULL dereference on XDP_TX
Date: Tue, 10 Sep 2024 11:26:41 +0200
Message-ID: <20240910092622.416028901@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

commit 0a50c35277f96481a5a6ed5faf347f282040c57d upstream.

If number of TX queues are set to 1 we get a NULL pointer
dereference during XDP_TX.

~# ethtool -L eth0 tx 1
~# ./xdp-trafficgen udp -A <ipv6-src> -a <ipv6-dst> eth0 -t 2
Transmitting on eth0 (ifindex 2)
[  241.135257] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030

Fix this by using actual TX queues instead of max TX queues
when picking the TX channel in am65_cpsw_ndo_xdp_xmit().

Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Julien Panis <jpanis@baylibre.com>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1918,12 +1918,13 @@ static int am65_cpsw_ndo_bpf(struct net_
 static int am65_cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
 				  struct xdp_frame **frames, u32 flags)
 {
+	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_tx_chn *tx_chn;
 	struct netdev_queue *netif_txq;
 	int cpu = smp_processor_id();
 	int i, nxmit = 0;
 
-	tx_chn = &am65_ndev_to_common(ndev)->tx_chns[cpu % AM65_CPSW_MAX_TX_QUEUES];
+	tx_chn = &common->tx_chns[cpu % common->tx_ch_num];
 	netif_txq = netdev_get_tx_queue(ndev, tx_chn->id);
 
 	__netif_tx_lock(netif_txq, cpu);


