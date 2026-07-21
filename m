Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F252388E40;
	Tue, 21 Jul 2026 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661157; cv=none; b=thEWEG1w57RUnfdsCCD6X3Mdw2JFoRj67PW5sNjug7sb2IOJ+WtLdGKLCMboUCnNh3Tspp7GXMYDlhtXUd2f4AueVFHnCeQ4W2julF0BKdeCqruQdLvP1+/ll988mV4YPTuH7Qu1JnzWV15u6sWoL/7ZKhvhHgK3NMJhtJxxUt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661157; c=relaxed/simple;
	bh=eiqPoMYT5t3srSENrBa7KEoc93mKYTXdfpm5Z+EItMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4I9rXpYvKdv0QjLRdLCVC+o6VzLlAR6QMC41ovjFvyCuSAaRh4SLnhfu8Zmp1JbyHTjfZSB4AxpB4LjMbg7kpD6Invmq74+YgjgYYyy1LeQ5+2V7unWKPSP6m26Ccj+jFnDdvNONimoComzRg1nZcYXLM4TrJYE+mPJ58+/Qzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WadKj+kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WadKj+kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B577B1F000E9;
	Tue, 21 Jul 2026 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661156;
	bh=kkqDr1YCEj974aiVHeZ7V9IOEwtHNPwFhLgbPKteKv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WadKj+kz4XjfpZMBeZfDTiWboPxeDuim/fjG8STzvpFs1T9AORA8cJ2YMf/xiNIjn
	 yIq8WU5cX+OXrYlBWGsCqSuSf+jskRSGSPz/qljLjoZlAihK13EjJ98VqgSBdbx4E9
	 Xh8OXelastAHJLgAqobZeBOK6DS2OaywGbT0X4sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1253/2077] net: ti: icssg: Fix XSK zero copy TX during application wakeup
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152622.368387739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit d95ea4bc09e88fe00f8e1c4e27c021313a4139c7 ]

emac_xsk_xmit_zc() handles tx xmit for zero copy and gets called
inside napi context. User application wakes up the kernel while
initiating the transmit which triggers napi to start processing
the tx packets. The num_tx check inside emac_tx_complete_packets()
returns early if no packet transfer happen hindering the call
to emac_xsk_xmit_zc(). Remove this check to let application
wakeup initiate zero copy xmit traffic.

Add __netif_tx_lock() to ensure that the TX queue is protected
from concurrent access during the transmission of XDP frames.
This fixes netdev watchdog timeout for long runs.

Fixes: e2dc7bfd677f ("net: ti: icssg-prueth: Move common functions into a separate file")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260618100348.2209907-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 23 ++++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 82ddef9c17d54e..6973d47142463c 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -93,8 +93,8 @@ void prueth_ndev_del_tx_napi(struct prueth_emac *emac, int num)
 }
 EXPORT_SYMBOL_GPL(prueth_ndev_del_tx_napi);
 
-static int emac_xsk_xmit_zc(struct prueth_emac *emac,
-			    unsigned int q_idx)
+static void emac_xsk_xmit_zc(struct prueth_emac *emac,
+			     unsigned int q_idx)
 {
 	struct prueth_tx_chn *tx_chn = &emac->tx_chns[q_idx];
 	struct xsk_buff_pool *pool = tx_chn->xsk_pool;
@@ -115,7 +115,7 @@ static int emac_xsk_xmit_zc(struct prueth_emac *emac,
 	 * necessary
 	 */
 	if (descs_avail <= MAX_SKB_FRAGS)
-		return 0;
+		return;
 
 	descs_avail -= MAX_SKB_FRAGS;
 
@@ -170,8 +170,8 @@ static int emac_xsk_xmit_zc(struct prueth_emac *emac,
 		num_tx++;
 	}
 
-	xsk_tx_release(tx_chn->xsk_pool);
-	return num_tx;
+	if (num_tx)
+		xsk_tx_release(tx_chn->xsk_pool);
 }
 
 void prueth_xmit_free(struct prueth_tx_chn *tx_chn,
@@ -279,9 +279,6 @@ int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
 		num_tx++;
 	}
 
-	if (!num_tx)
-		return 0;
-
 	netif_txq = netdev_get_tx_queue(ndev, chn);
 	netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
 
@@ -297,16 +294,18 @@ int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
 		__netif_tx_unlock(netif_txq);
 	}
 
-	if (tx_chn->xsk_pool) {
-		if (xsk_frames_done)
+	if (budget && tx_chn->xsk_pool) {
+		if (xsk_frames_done) {
 			xsk_tx_completed(tx_chn->xsk_pool, xsk_frames_done);
+			txq_trans_cond_update(netif_txq);
+		}
 
 		if (xsk_uses_need_wakeup(tx_chn->xsk_pool))
 			xsk_set_tx_need_wakeup(tx_chn->xsk_pool);
 
-		netif_txq = netdev_get_tx_queue(ndev, chn);
-		txq_trans_cond_update(netif_txq);
+		__netif_tx_lock(netif_txq, smp_processor_id());
 		emac_xsk_xmit_zc(emac, chn);
+		__netif_tx_unlock(netif_txq);
 	}
 
 	return num_tx;
-- 
2.53.0



