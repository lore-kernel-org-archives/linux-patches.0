Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B74457CD;
	Tue, 25 Aug 2026 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665002; cv=none; b=fJHznfajMGkw0hACuB3AP+D4nPQzg3hFggTNstMqSkNIdJ6cAi0ijeUkeE0BbuVcbxvYw0lMVd53oUTZ2juE7TXdO2cf8dBHVyiu58TtLiOXYxRIRVyS/e8E8ISYTDiRAGVvOmU0VZn5S5bgqstR+ySA5IOIQuJ1JaQQxGpaKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665002; c=relaxed/simple;
	bh=LL/i1g4NxkKk9XZdX3cmDydFcN46aOdH+HA6HluJOXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2m3PzAeTguyvWx6NA1TYY4B1eZDEmwDUyhB3+F2SqnXKhpBNLC9JPccA+Atf8OG2fN5DNdICCZCqlHdISePVYW0tsQY0Mwvi0CkaN7P2PBZQ55SoRHjffnoLRjI/JpqBhCg3HAMUb4YnaZoHdXrsmR6yZc2Mk1oXdweUWUiyMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpxVasjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpxVasjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF431F000E9;
	Tue, 25 Aug 2026 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665000;
	bh=/wVHF53ZEqY0teVqwULjTTBG0H+HB6iBFE1H+G8CgmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpxVasjMVTcxJKobiG9vnR0wmCrc6Urtq7HTKldTY/J/ChfFatUJu6zoJyBkGyiIT
	 pD3t1FANU+r6kx+weB5CO7VqgaB0fP0vTB/dYESfEzL22SSnVVw6FxRpvDY5c4SXa5
	 Qt2zzgaNvnnQRtuETwCQkaaKzcz/J34VSTaNkDzk=
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
Subject: [PATCH 7.1 075/101] net/ionic: avoid OOB TX partner lookup for hwstamp RXQ
Date: Tue, 25 Aug 2026 15:25:53 +0200
Message-ID: <20260825132544.928789773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


