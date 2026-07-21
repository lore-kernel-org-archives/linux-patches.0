Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC2543B6E0;
	Tue, 21 Jul 2026 21:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669806; cv=none; b=XZDqxeEjU0JvD0rsRsXdK2WQqMNcuyKbgNjE785BaRtroRV6WnNka32M6AXhxN+X/mZYmRr2KuyGiFzeSF0Zx3ZeEu2wlxnXa3+IWfMEi9PJZi7uWKWJF/WPxtT/J+WCDX7QSUzhpSr2BKMhD1QcDzq77flQFqbt3LI2HBAv6w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669806; c=relaxed/simple;
	bh=RUqKfqHx3W3VzEyNancXWD6ISaIVRG0SEOFmbO3XzOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1icQv6RWs5AWw/kigEuB8ZmeODE3vuSXlogfenWNidxQGTtobMrQoEHyyixIRC4Dri8mznd1vr0gC+SnfsEDvtCupROTQG2QPmO0PcMAk/fxfuBvFdx+sbMdbcgqDFMSuuS1RpPnIi/7HsAQGcaBfd/gVMfNH6RbInGa2pdrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1PUgi53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1PUgi53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01041F000E9;
	Tue, 21 Jul 2026 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669804;
	bh=pFZ8GF518oSLattF00MuJFeznh/rfCG7rGYTy1MKhgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1PUgi53Lc7WVpqWYyzt7IFJUEAG62/Sckz6OoCY9xPRedCMCwywJBc/ZSOpUwaYe
	 q40KVMJxsXlY/Fyb8Jz5ZkwRAfiVHlOmYP3VOg1aLFqflUAa/tSTFKlInWw+pPHVCA
	 EG6ixWk7EfaRlRs5yjrLewHFQMapNsAyWejUcbI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0692/1067] net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket
Date: Tue, 21 Jul 2026 17:21:33 +0200
Message-ID: <20260721152440.077073088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c06625ceb200e..65d6d388adf891 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -438,9 +438,9 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 {
 	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
 	struct smc_cdc_msg *cdc = buf;
+	struct smc_sock *smc = NULL;
 	struct smc_connection *conn;
 	struct smc_link_group *lgr;
-	struct smc_sock *smc;
 
 	if (wc->byte_len < offsetof(struct smc_cdc_msg, reserved))
 		return; /* short message */
@@ -451,21 +451,26 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
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



