Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201311F3D56;
	Tue, 21 Jul 2026 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653762; cv=none; b=BlSp/3aoVwVTC9HcjQA8GXVqBxL7gDsqGha14M0ZYUXfDT0MEe4crW+MeeMW9plHusv1WyHmTPbbEg7AsjBy/bO+m2p5qcoZuVHwm9+bhpK7P09qRyUkLg58pbWwC8uYPO2Ome3bDo72xcsgshwjjkY+c2QSFWM6jXx81Uej2nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653762; c=relaxed/simple;
	bh=+2Fm2L2AXFx6j6X+XyriNrzmhNDFN6pIHsKT4aQfbTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbnitmM82T1+f4NC6aaeE9R4bg/peyQnfIbLzJC1QGYDnsThLsWw8pVNXAXvZprY+PzpJ/x+M5DGgN1ul7bffNuB8l3ltbgEOnBL8Btfrg4ongXmqFLLTXhtGyKngN5KYOtnJoVhiwndxGTAvzfVNhd88xu7oYbonKQC0tjSf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzZVNBb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzZVNBb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADE51F000E9;
	Tue, 21 Jul 2026 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653760;
	bh=2pb9ewCFZZl5JwdH2gwWLrsdDFx++qvYkDZnPH1CfSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzZVNBb3dECQ5ktu0DW+8ZrTRhF4v3nsItmAPEWX5lMXOepP2XmhsqF4knQDef/oS
	 +iqa2LdXc4dMqfWQwclJnZ5ULzoB9CI37AZnPnRoqt7C7Z6ZhqHpqVsj36Ig61aHL2
	 srg23qIhQZm69Q4vRY440PTjOcDOR8P17XmR2gZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1449/2077] net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152626.977895713@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 9d160b35cc34a2ba8229d07651468a7848325135 ]

smc_cdc_rx_handler() looks up the connection by token under the link
group's conns_lock, drops the lock, and then dereferences conn and the
smc_sock derived from it, ending in sock_hold(&smc->sk) inside
smc_cdc_msg_recv(). No reference is held across the lock release.

The only reference pinning the socket while the connection is
discoverable in the link group is taken in smc_lgr_register_conn()
(sock_hold) and dropped in __smc_lgr_unregister_conn() (sock_put), both
under conns_lock. Once the handler drops conns_lock, a concurrent
close() -> smc_release() -> smc_conn_free() -> smc_lgr_unregister_conn()
can drop that reference and free the smc_sock, so the handler's later
sock_hold() runs on freed memory:

  WARNING: lib/refcount.c:25 at refcount_warn_saturate
  Workqueue: rxe_wq do_work
   refcount_warn_saturate (lib/refcount.c:25)
   smc_cdc_msg_recv (net/smc/smc_cdc.c:430)
   smc_cdc_rx_handler (net/smc/smc_cdc.c:502)
   smc_wr_rx_tasklet_fn (net/smc/smc_wr.c:445)
   tasklet_action_common (kernel/softirq.c:938)
   handle_softirqs (kernel/softirq.c:622)
  Kernel panic - not syncing: panic_on_warn set

Only SMC-R is affected. The SMC-D receive tasklet is stopped by
tasklet_kill(&conn->rx_tsklet) in smc_conn_free() before the connection
is unregistered, so it cannot run concurrently with the free.

Take the socket reference while still holding conns_lock, so the
registration reference can no longer be the last one, and drop it once
the handler is done.

Fixes: d7b0e37c1ac1 ("net/smc: restructure CDC message reception")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260630183227.2044998-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 619b3bab38248b..32d6d03df32145 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -470,9 +470,9 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 {
 	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
 	struct smc_cdc_msg *cdc = buf;
+	struct smc_sock *smc = NULL;
 	struct smc_connection *conn;
 	struct smc_link_group *lgr;
-	struct smc_sock *smc;
 
 	if (wc->byte_len < offsetof(struct smc_cdc_msg, reserved))
 		return; /* short message */
@@ -483,21 +483,26 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 	lgr = smc_get_lgr(link);
 	read_lock_bh(&lgr->conns_lock);
 	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
-	read_unlock_bh(&lgr->conns_lock);
-	if (!conn || conn->out_of_sync)
+	if (!conn || conn->out_of_sync) {
+		read_unlock_bh(&lgr->conns_lock);
 		return;
+	}
 	smc = container_of(conn, struct smc_sock, conn);
+	sock_hold(&smc->sk);
+	read_unlock_bh(&lgr->conns_lock);
 
 	if (cdc->prod_flags.failover_validation) {
 		smc_cdc_msg_validate(smc, cdc, link);
-		return;
+		goto out;
 	}
 	if (smc_cdc_before(ntohs(cdc->seqno),
 			   conn->local_rx_ctrl.seqno))
 		/* received seqno is old */
-		return;
+		goto out;
 
 	smc_cdc_msg_recv(smc, cdc);
+out:
+	sock_put(&smc->sk);
 }
 
 static struct smc_wr_rx_handler smc_cdc_rx_handlers[] = {
-- 
2.53.0



