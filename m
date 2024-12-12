Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FBD212D6A;
	Thu, 12 Dec 2024 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017541; cv=none; b=td1W4eyGlIItFnAYIZTGXIfCoyesoVk9d2PZjtW7B68oongv0ayl8h+qj63Mxz/xY+EZmJdHwOM424KNAuQyE3nwhayeFYDMjqw/wPXqw0ic8stTAlVZCQxn7dNCKU6a54LVJoNotYkdH+3FGe/POnHmau9+ktGaJtTVAuoOuPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017541; c=relaxed/simple;
	bh=44VPj4jdnUtq9yWamfYo3E5tgJZTA68AXxwWIZqrqLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl4EFZz7RFiooK1UVDqU7SD2OZWr2rCMCmYd0d/EcGDTpZAEH5N5ed67g4DCa888+CfQijz4V3XNLX2VJVyPR/A7vxp21xRT3ob0JICuyKdUEtrZFF2j0nelDT0bsTY1y+rg8MpFluToqSfuNNwJu6qVL0wxDPgdLb+e1V6CtcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcf99dQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcf99dQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0C7C4CECE;
	Thu, 12 Dec 2024 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017541;
	bh=44VPj4jdnUtq9yWamfYo3E5tgJZTA68AXxwWIZqrqLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcf99dQy5i2kjrxPJcsxc3AWvdx+KXCUgd9x26K49Myj6wcdexZyqo0DDgvMWI9ft
	 gGYEREBqJjaOM4wo6DtNfTZhYRcwIwB5gtSEu3d9mhbMbE7K2V5R2qift8BFHQz/Xg
	 bsrUFKATMkSAUTW6BiyiRU/Ess0LeG/5owglbGcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/356] net/smc: initialize close_work early to avoid warning
Date: Thu, 12 Dec 2024 15:56:02 +0100
Message-ID: <20241212144246.330987611@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 0541db8ee32c09463a72d0987382b3a3336b0043 ]

We encountered a warning that close_work was canceled before
initialization.

  WARNING: CPU: 7 PID: 111103 at kernel/workqueue.c:3047 __flush_work+0x19e/0x1b0
  Workqueue: events smc_lgr_terminate_work [smc]
  RIP: 0010:__flush_work+0x19e/0x1b0
  Call Trace:
   ? __wake_up_common+0x7a/0x190
   ? work_busy+0x80/0x80
   __cancel_work_timer+0xe3/0x160
   smc_close_cancel_work+0x1a/0x70 [smc]
   smc_close_active_abort+0x207/0x360 [smc]
   __smc_lgr_terminate.part.38+0xc8/0x180 [smc]
   process_one_work+0x19e/0x340
   worker_thread+0x30/0x370
   ? process_one_work+0x340/0x340
   kthread+0x117/0x130
   ? __kthread_cancel_work+0x50/0x50
   ret_from_fork+0x22/0x30

This is because when smc_close_cancel_work is triggered, e.g. the RDMA
driver is rmmod and the LGR is terminated, the conn->close_work is
flushed before initialization, resulting in WARN_ON(!work->func).

__smc_lgr_terminate             | smc_connect_{rdma|ism}
-------------------------------------------------------------
                                | smc_conn_create
				| \- smc_lgr_register_conn
for conn in lgr->conns_all      |
\- smc_conn_kill                |
   \- smc_close_active_abort    |
      \- smc_close_cancel_work  |
         \- cancel_work_sync    |
            \- __flush_work     |
	         (close_work)   |
	                        | smc_close_init
	                        | \- INIT_WORK(&close_work)

So fix this by initializing close_work before establishing the
connection.

Fixes: 46c28dbd4c23 ("net/smc: no socket state changes in tasklet context")
Fixes: 413498440e30 ("net/smc: add SMC-D support in af_smc")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f343e91eec0e4..755659703a625 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -383,6 +383,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 	smc->limit_smc_hs = net->smc.limit_smc_hs;
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
+	smc_close_init(smc);
 }
 
 static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
@@ -1298,7 +1299,6 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		goto connect_abort;
 	}
 
-	smc_close_init(smc);
 	smc_rx_init(smc);
 
 	if (ini->first_contact_local) {
@@ -1434,7 +1434,6 @@ static int smc_connect_ism(struct smc_sock *smc,
 			goto connect_abort;
 		}
 	}
-	smc_close_init(smc);
 	smc_rx_init(smc);
 	smc_tx_init(smc);
 
@@ -2486,7 +2485,6 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_decl;
 
 	mutex_lock(&smc_server_lgr_pending);
-	smc_close_init(new_smc);
 	smc_rx_init(new_smc);
 	smc_tx_init(new_smc);
 
-- 
2.43.0



