Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D40043ADE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9sHtRKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE11C433C8;
	Wed, 15 Nov 2023 20:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081865;
	bh=MjRL+sffWBcCJ4Bsc133NNkMeT659P9yNnzlzhTDi54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9sHtRKOB2ccNZCjEruHgP6ixQHDvLqDMrnSk4LwWGVZRzmGizMr/GbKSjdl0T26f
	 DeuYs8gDLHJYXVDkhrNhBQsxw39uTMzkV9HyHevlXLok3Ww3Umvy0JO6VpBKCg6GSH
	 fPWltbg0n3QPRDvDGx62RfBXuXUojE/4qqrRNKww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/191] net/smc: allow cdc msg send rather than drop it with NULL sndbuf_desc
Date: Wed, 15 Nov 2023 15:47:30 -0500
Message-ID: <20231115204654.942715587@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit c5bf605ba4f9d6fbbb120595ab95002f4716edcb ]

This patch re-fix the issues mentioned by commit 22a825c541d7
("net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()").

Blocking sending message do solve the issues though, but it also
prevents the peer to receive the final message. Besides, in logic,
whether the sndbuf_desc is NULL or not have no impact on the processing
of cdc message sending.

Hence that, this patch allows the cdc message sending but to check the
sndbuf_desc with care in smc_cdc_tx_handler().

Fixes: 22a825c541d7 ("net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 78c212a7f617b..b92b2cee2079c 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -28,13 +28,15 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 {
 	struct smc_cdc_tx_pend *cdcpend = (struct smc_cdc_tx_pend *)pnd_snd;
 	struct smc_connection *conn = cdcpend->conn;
+	struct smc_buf_desc *sndbuf_desc;
 	struct smc_sock *smc;
 	int diff;
 
+	sndbuf_desc = conn->sndbuf_desc;
 	smc = container_of(conn, struct smc_sock, conn);
 	bh_lock_sock(&smc->sk);
-	if (!wc_status) {
-		diff = smc_curs_diff(cdcpend->conn->sndbuf_desc->len,
+	if (!wc_status && sndbuf_desc) {
+		diff = smc_curs_diff(sndbuf_desc->len,
 				     &cdcpend->conn->tx_curs_fin,
 				     &cdcpend->cursor);
 		/* sndbuf_space is decreased in smc_sendmsg */
@@ -104,9 +106,6 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	union smc_host_cursor cfed;
 	int rc;
 
-	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
-		return -ENOBUFS;
-
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
-- 
2.42.0



