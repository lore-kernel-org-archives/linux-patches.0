Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8039A37DAD0;
	Fri,  4 Sep 2026 05:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499954; cv=none; b=YPJhT43HQkKrD9i28boPf4ArROW+ZLQp271qgW0ojfCjjatVQjlP+o/MfOet3g7RIhTDbnGiONAr3Vto2Zi0kKvdOkweDzvGJO8cGYfUrP6n4LT4AMyGD8SrTIJYRr8COhQ/NMzdGS9rhYLgoCmwXpEDuAU27/o8i4gU/be8/TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499954; c=relaxed/simple;
	bh=F5IEiCvAdmJkgEokerPwh/XJ6/TvjCZqMqlJBq7JPDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TakQkFPt0nhXDHL+kgDiGTiYvW0OwJh6LyePpR5KbPAmw8tNZCghYDOA/8GBDkb1Pz3YhzQ2wXeXH6xgV8hf8e4FRkAzI93OkVHS1J7wumHebLF8NtKPaLUlpi6fKypeugoZeNFpGUQxTdgFk9H+bqIxGjP+VeuUeY3YlN9vFU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi+eX90j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi+eX90j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D955B1F00A3D;
	Fri,  4 Sep 2026 05:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499953;
	bh=sgjFeg4VJp+NM9xheBYCnoewT3gsWb8FA6cTi9emJvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi+eX90jJJmNIi28N2P/OXFjMi2An1i2CUTZOOWgtQ7PbgnPX1Xbmlo3HSqMSVFD8
	 wrz9C5PRqwhkqGT1fuv4rTEaQTrwQH4UKiRF9lfZ9Ea6rIlHnwaRT+2GeH0dSqnUkO
	 G+3Zno+kBy0wg/PO3KlhlYnvpWGOZmcep9EWdd/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 600/713] net: bnxt: ring the doorbell when SW USO exits early
Date: Fri,  4 Sep 2026 06:59:28 +0200
Message-ID: <20260904045817.276939046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 4e15e89faac9f308baeb01f46c13a051814d2449 upstream.

When a burst of packets is handed down to the driver, the driver defers
the doorbell to the end by setting txr->kick_pending = 1. The normal TX
path handles this, but the SW USO path can miss it if it returns
early.

If bnxt_sw_udp_gso_xmit runs but returns early with NETDEV_TX_BUSY and
txr->kick_pending was previously set to 1, then the TX queue can
stall because the driver wrote some BDs but never wrote the doorbell.
The device won't know to do the TX which would generate the completion
that would wake the queue back up.

Simplify bnxt_sw_udp_gso_xmit to set txr->kick_pending in its success
case and check the flag on return. The added check after
bnxt_sw_udp_gso_xmit returns ensures that any pending doorbells are
written handling both successful USO and any early returns, which
prevents the TX queue stall mentioned above.

This TX queue stall was observed on a production system with a netdev TX
watchdog informing about the queue stall.

Fixes: cc5d90667db8 ("net: bnxt: Implement software USO")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260819233213.3673149-1-joe@dama.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c |    4 +---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -485,6 +485,7 @@ static netdev_tx_t bnxt_start_xmit(struc
 	struct bnxt_sw_tx_bd *tx_buf;
 	__le32 lflags = 0;
 	skb_frag_t *frag;
+	netdev_tx_t ret;
 
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
@@ -507,8 +508,13 @@ static netdev_tx_t bnxt_start_xmit(struc
 #endif
 	if (skb_is_gso(skb) &&
 	    (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) &&
-	    !(bp->flags & BNXT_FLAG_UDP_GSO_CAP))
-		return bnxt_sw_udp_gso_xmit(bp, txr, txq, skb);
+	    !(bp->flags & BNXT_FLAG_UDP_GSO_CAP)) {
+		ret = bnxt_sw_udp_gso_xmit(bp, txr, txq, skb);
+		if (txr->kick_pending)
+			bnxt_txr_db_kick(bp, txr, txr->tx_prod);
+
+		return ret;
+	}
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c
@@ -223,9 +223,7 @@ netdev_tx_t bnxt_sw_udp_gso_xmit(struct
 	netdev_tx_sent_queue(txq, skb->len);
 
 	WRITE_ONCE(txr->tx_prod, prod);
-	/* Sync BDs before doorbell */
-	wmb();
-	bnxt_db_write(bp, &txr->tx_db, prod);
+	txr->kick_pending = 1;
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= bp->tx_wake_thresh))
 		netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),


