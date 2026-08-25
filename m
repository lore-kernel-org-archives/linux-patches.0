Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333E3481A98;
	Tue, 25 Aug 2026 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665385; cv=none; b=brU8UgOBF+QylmiGS/1LIPMzqbhowf7MtRJcl/EoJ+93O2FQRblKq4z8c+nt9xqin+NKAvhx/omU9auqhW/tZCFvyk4pl2dz94G594V8lpgaFBUGbURZklNYCzJWUxQBH4I5dyl3tx1w66MgLSIEof5Q6lzz8Hszx5wetFcBuXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665385; c=relaxed/simple;
	bh=oyl0dycRzjYUNCEXBhrxqqTn1lMVpClB11E/YeQm7bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNBXGpO8eEdlsrR544MTG65DZQzv3awWVCKryS8ENVlgkmwvW6L2VZnpxfBTrfw9B2eFOvGhiSPxPSGffCJvScfSY73uaGSqXzcyZVPwnMXp5prPXU3e9BPhziyZ/427JktmDWgVY5Qj7nDbk63n1VB/dBtEP5Xb++rBOYVYB8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wPfm4gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wPfm4gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E03E1F000E9;
	Tue, 25 Aug 2026 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665384;
	bh=hz45FCNEJxhTWU2j+vpooKGX9eDty9IwzktitHiyzNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wPfm4gkB4fDuN4AZOwwx8MDXPr64fbX9El9WhME52gB3tLp/OURuyr/wHGftYzOy
	 loPVSZE7z/pfGw2jezQAHCtRTtTUo6877Qaeu2JJrnkH7AiPk9CQyPkgJFyUueEXEJ
	 uHaNi68REgh4MPpkbohFbcI0UL8RjlzJKGR3j/ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Shannon Nelson <sln@onemain.com>,
	Anand Khoje <anand.a.khoje@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 71/94] net/ionic: avoid OOB TX partner lookup for hwstamp RXQ
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132544.669621938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Khoje <anand.a.khoje@oracle.com>

commit d92255b405fb6f5acca408239ccd742e0a42c9cb upstream.

The dedicated hardware timestamp RX queue is allocated with q->index
equal to lif->ionic->nrxqs_per_lif. The normal txqcqs array only
contains the regular queue pairs, so using that index to set rxq->partner
can read one entry past txqcqs[] and then write through the derived
pointer.
Only link RX/TX partners for normal queue-pair indexes. Leave the hwstamp
RX queue unpaired, and make the XDP_TX path abort cleanly if an RX queue
has no TX partner.

Fixes: 8eeed8373e1c ("ionic: Add XDP_TX support")
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Reviewed-by: Shannon Nelson <sln@onemain.com>
Cc: stable@vger.kernel.org
Signed-off-by: Anand Khoje <anand.a.khoje@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20260813083705.454897-1-anand.a.khoje@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  |   17 +++++++++++++++--
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |    7 ++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -918,8 +918,21 @@ static int ionic_lif_rxq_init(struct ion
 	};
 	int err;
 
-	q->partner = &lif->txqcqs[q->index]->q;
-	q->partner->partner = q;
+	q->partner = NULL;
+
+	/* Only normal RX queues have matching TX queue partners. */
+	if (q->index < lif->nxqs) {
+		if (!lif->txqcqs ||
+		    q->index >= lif->ionic->ntxqs_per_lif ||
+		    !lif->txqcqs[q->index]) {
+			dev_err(dev, "missing TX queue partner for RX queue %u\n",
+				q->index);
+			return -ENXIO;
+		}
+
+		q->partner = &lif->txqcqs[q->index]->q;
+		q->partner->partner = q;
+	}
 
 	if (!lif->xdp_prog ||
 	    (lif->xdp_prog->aux && lif->xdp_prog->aux->xdp_has_frags))
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -545,13 +545,18 @@ static bool ionic_run_xdp(struct ionic_r
 		break;
 
 	case XDP_TX:
+		txq = rxq->partner;
+		if (unlikely(!txq)) {
+			err = -EIO;
+			break;
+		}
+
 		xdpf = xdp_convert_buff_to_frame(&xdp_buf);
 		if (!xdpf) {
 			err = -ENOSPC;
 			break;
 		}
 
-		txq = rxq->partner;
 		nq = netdev_get_tx_queue(netdev, txq->index);
 		__netif_tx_lock(nq, smp_processor_id());
 		txq_trans_cond_update(nq);


