Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A138B7D4;
	Fri,  4 Sep 2026 06:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501637; cv=none; b=M6Jk98FgAwnxD2F8jzEzdBtyNQQAxKp3PpmdXziqO8KVbcneGn2723zz9c0AWHK+CZMmbUK80vc2sjscoX3Yot4K4ntSknPrFWnyTB0Y/ARXbO4ftmVV3E8QTwpiffo/2HsEnNigLeTQ9WlppWZgMyN7fejFoO2zyS+1FHsdlkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501637; c=relaxed/simple;
	bh=ZWXJn9dzLt80Fbwa2i2jEud75w6lwEdVXcRzo/NyCzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SowVtLHZQZjyfcU8YOp8T0QW7FA3dVylGrzFMivYzm4UxsBpIg9XHMtWTwoH9R2dSZriv332HDg7fROjpclHj0rYmZEmtcDJXruliGyXn098fj2tzgkpMS+CHtTp6PS9LZa5dYPDYEPcfP4VumCiNSm9USxckIa5iIx/HsP9rfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDANmxaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDANmxaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3181F00A3D;
	Fri,  4 Sep 2026 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501635;
	bh=0SqXpyecDwbHBZkh/a/w7PRLbUaQqnHaNHIxGdAgcTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDANmxaDEXWX94sgcW3ufmggMK+5iZLcZ9L0J8YUeI2GvqokxyveKA4Kd2b4vVHns
	 tPHH7u3vLceF7ePgKLvU4VCxTfQ6RPwFRbC+TKQfGGx2D0DW6budmtr1zl+hvwwAGb
	 vZL4SW/GCaO40bz9G7WcD/SdYSzXzceKVC7VTC0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 478/552] net/smc: unregister the connection before draining the rx tasklet
Date: Fri,  4 Sep 2026 07:00:35 +0200
Message-ID: <20260904045801.517353158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 36cdf5d48ca191dcd71c28cadbe0981b1d25318d upstream.

smc_conn_free() calls smc_ism_unset_conn() only while the link group is
still on its device list, and never sets conn->killed.
smc_lgr_terminate_sched() unlinks the group immediately and defers killing
its connections to a work item, so a connection freed in that window keeps
its smcd->conn[] slot with both gates in smcd_handle_irq() open, and the
device can re-arm the receive tasklet after tasklet_kill() has returned. On
the DMB-nocopy path the ghost send buffer is freed right after that drain,
so the re-armed tasklet dereferences it.

Unregister unconditionally and drain before the detach at both teardown
sites, mirroring rmb_desc, which smc_buf_unuse() releases after the drain.
Clear conn->sndbuf_desc before freeing it as well, so a reader that samples
the pointer cannot get one that is already freed.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Link: https://patch.msgid.link/20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1195,14 +1195,16 @@ static void smcd_buf_detach(struct smc_c
 {
 	struct smcd_dev *smcd = conn->lgr->smcd;
 	u64 peer_token = conn->peer_token;
+	struct smc_buf_desc *buf_desc;
 
 	if (!conn->sndbuf_desc)
 		return;
 
 	smc_ism_detach_dmb(smcd, peer_token);
 
-	kfree(conn->sndbuf_desc);
+	buf_desc = conn->sndbuf_desc;
 	conn->sndbuf_desc = NULL;
+	kfree(buf_desc);
 }
 
 static void smc_buf_unuse(struct smc_connection *conn,
@@ -1254,11 +1256,10 @@ void smc_conn_free(struct smc_connection
 		goto lgr_put;
 
 	if (lgr->is_smcd) {
-		if (!list_empty(&lgr->list))
-			smc_ism_unset_conn(conn);
+		smc_ism_unset_conn(conn);
+		tasklet_kill(&conn->rx_tsklet);
 		if (smc_ism_support_dmb_nocopy(lgr->smcd))
 			smcd_buf_detach(conn);
-		tasklet_kill(&conn->rx_tsklet);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 		if (current_work() != &conn->abort_work)
@@ -1511,12 +1512,12 @@ static void smc_conn_kill(struct smc_con
 	smc_sk_wake_ups(smc);
 	if (conn->lgr->is_smcd) {
 		smc_ism_unset_conn(conn);
-		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
-			smcd_buf_detach(conn);
 		if (soft)
 			tasklet_kill(&conn->rx_tsklet);
 		else
 			tasklet_unlock_wait(&conn->rx_tsklet);
+		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
+			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 	}


