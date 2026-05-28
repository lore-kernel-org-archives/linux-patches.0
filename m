Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D6E3290B0;
	Thu, 28 May 2026 19:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998103; cv=none; b=eB7LmFuGsZwAknllygRlfYrFEF8vc0csxAy3/MYDaUeBFsdBkFugHJE/hQAowjeWtcsiu4X59kkZX8dodMYd5adXJUxnZVq5ewG0exywwko7FsO3KVglZoZJNHsCtq5YmGGXqnqBiODjfAiR/oTBTCIcjrWI9PAPBpZMrzHnkIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998103; c=relaxed/simple;
	bh=G3fSPnKk43HJOFieDTXOcVjiN31lIcekdLc9+h7ltrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTlH7Z11WyH4u6ISLmOX/ojParmm4CoiqMyPemiuIdMlzCtdMSIx5G3kz5N1kMQxfRWqNlBoyGhnDEdCzWhP3SPehm5zUYe/l3AOj0YNOJTrXmq9Tmf73Zc6D3iaEvP9bOwHjmCO9JqbS5UWEdCbpJfxYI7ejZFKoQ+IR6sDr14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHfi9ZwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHfi9ZwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C98C1F00ADB;
	Thu, 28 May 2026 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998102;
	bh=fxiyrGB2ljAxC3mJEnENXNOexBrokPJ/RuaTR/CnUeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHfi9ZwRLkQl4ADgesua51/laptPGvZa44cZbkOFnfwWERpZmvvMVXRXos3cGt70S
	 VuTWTETnNLCQEPuzJtGfvOBjuG/fCOOnJIFcnrQvsK0gpnjqJOPZu2Kf8dFA2Wh/ol
	 WSqo39yl0xav7/nX8DmNClna/w6PNiGBi+0f5xAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 055/461] net: ifb: report ethtool stats over num_tx_queues
Date: Thu, 28 May 2026 21:43:04 +0200
Message-ID: <20260528194648.503127209@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 5db89c99566fc4728cc92e941d8e1975711e24b5 upstream.

ifb_dev_init() allocates dp->tx_private to dev->num_tx_queues
entries via kzalloc_objs(*txp, dev->num_tx_queues). Both IFB
per-queue RX and TX stats live in those entries: ifb_xmit() updates
txp->rx_stats using the skb queue mapping, ifb_ri_tasklet() updates
txp->tx_stats, and ifb_stats64() aggregates both over
dev->num_tx_queues.

The ethtool stats callbacks instead size and walk the per-queue
stats with dev->real_num_rx_queues and dev->real_num_tx_queues. With
an asymmetric device where the RX queue count exceeds the TX queue
count, for example:

    ip link add name ifb10 numtxqueues 1 numrxqueues 8 type ifb
    ethtool -S ifb10

ifb_get_ethtool_stats() indexes past the tx_private allocation and
copies adjacent slab data through ETHTOOL_GSTATS.

Use dev->num_tx_queues consistently for the stats strings, the
stats count, and the stats data walks. This reports one RX stats
group and one TX stats group for each backing ifb_q_private entry,
which is the queue set IFB can actually populate.

Reproduced under UML+KASAN at v7.1-rc2:

  BUG: KASAN: slab-out-of-bounds in ifb_fill_stats_data+0x3c/0xae
  Read of size 8 at addr 0000000062dbd228 by task ethtool/36
  ifb_fill_stats_data+0x3c/0xae
  ifb_get_ethtool_stats+0xc0/0x129
  __dev_ethtool+0x1ca5/0x363c
  dev_ethtool+0x123/0x1b3
  dev_ioctl+0x56c/0x744
  sock_do_ioctl+0x15f/0x1b2
  sock_ioctl+0x4d5/0x50a
  sys_ioctl+0xd8b/0xde9

With the patch applied, the same UML+KASAN repro is silent and
ethtool -S ifb10 reports only the stats backed by the single
allocated tx_private entry.

Fixes: a21ee5b2fcb8 ("net: ifb: support ethtools stats")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260514013739.3549624-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ifb.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -211,12 +211,12 @@ static void ifb_get_strings(struct net_d
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < dev->real_num_rx_queues; i++)
+		for (i = 0; i < dev->num_tx_queues; i++)
 			for (j = 0; j < IFB_Q_STATS_LEN; j++)
 				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
 						i, ifb_q_stats_desc[j].desc);
 
-		for (i = 0; i < dev->real_num_tx_queues; i++)
+		for (i = 0; i < dev->num_tx_queues; i++)
 			for (j = 0; j < IFB_Q_STATS_LEN; j++)
 				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
 						i, ifb_q_stats_desc[j].desc);
@@ -229,8 +229,7 @@ static int ifb_get_sset_count(struct net
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return IFB_Q_STATS_LEN * (dev->real_num_rx_queues +
-					  dev->real_num_tx_queues);
+		return IFB_Q_STATS_LEN * dev->num_tx_queues * 2;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -262,12 +261,12 @@ static void ifb_get_ethtool_stats(struct
 	struct ifb_q_private *txp;
 	int i;
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = 0; i < dev->num_tx_queues; i++) {
 		txp = dp->tx_private + i;
 		ifb_fill_stats_data(&data, &txp->rx_stats);
 	}
 
-	for (i = 0; i < dev->real_num_tx_queues; i++) {
+	for (i = 0; i < dev->num_tx_queues; i++) {
 		txp = dp->tx_private + i;
 		ifb_fill_stats_data(&data, &txp->tx_stats);
 	}


