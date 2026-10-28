Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208300;
	b=sQdh/piIOnfSBNXROKLEPTyYMmf2XlO4rY2c5n2eHLS1GjRpetYw5QUNHIFzHkq60W0g
	 Y6QipqpP7dHJpeLf32scvjDl7erG8D75CsKA/KfI+iB/1fzoKoMUGrsqgRjdfoB/zvM1c
	 Zd8C8oDPc2l/o1v6cJ4p8JF91+peTHX0EfPb9jmoACt6cxsmVd7g7AdR59Ok8woxlQR0M
	 L2dwsmvx8CjrmYO5DpZiwfyZ3OiYU5t1VE7Qx5gQ7VfmrDeR93d9pU/N06+LNk/RDz4du
	 bON49ayoYl/IEPSTQn0TYz56SayZEdjQxsCzB3e1ArzHnH25E0HmakG9peDCvp6Swgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TdD5EWOiL1G0iK7dnNtVV6vpY5zpogboPxvQseJMMQ0=;
	b=XY8wTVNsE6x6S8J8G/6iRXlbUqcE8n0TF6GRuSmyo1c5fgPU6CHl7f08aTMn2qkSPIoM
	 OC66Lw19LrExRzN6e0/yuMI9KqSGA+kS64/ayln5t0/jw8WuHkClMflaCi5+7AeDHhmng
	 xEPrjYMlc35RBUJEyPGi6uxzPiC7k/rJkotqg20E8Eb5QxC617tYs24wG7chlKtKx9GaK
	 lObrz44RpPOyFdHQpfAA9+ZiY/LTyiJEj+XDVqrMr9doOqi30DuqlIIy8lUrp2Y+TUwCv
	 7PSKBMai0P/YRrcCzpzF4e/UiDW+siRFbfNqiizra+gTU+GsC0fNNVE/Z7mSxnRpTTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0G+Jc+Aa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF58606A31C;
	Wed, 28 Oct 2026 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0G+Jc+Aa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3FE1F031E0;
	Wed, 28 Oct 2026 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208300;
	bh=TdD5EWOiL1G0iK7dnNtVV6vpY5zpogboPxvQseJMMQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0G+Jc+Aa46kx6hOlpVInCFV5EzOfH13AKAbzrabvoB8AAEOUE2hRe8es32qthPpPT
	 BwqTpRojivXzXu7Kpsv/hfSlCO2jYHpI/eyKicL+cTPk3J1lWfr6sIOLb+Cm3idpxx
	 q5t/RGwMEF9U5Wzp5PNY0O/W661xXTc2yiJE5swE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/516] net/smc: fix socket refcount leak in smc_switch_conns()
Date: Wed, 28 Oct 2026 17:53:43 +0100
Message-ID: <20261028170005.205721397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

[ Upstream commit 719296c4aa8213d4ac8002e77d5956d436bc98d0 ]

smc_switch_conns() takes a reference on the SMC socket before dropping
lgr->conns_lock, so the connection stays alive while the CDC slot is
fetched:

        sock_hold(&smc->sk);
        read_unlock_bh(&lgr->conns_lock);
        /* pre-fetch buffer outside of send_lock, might sleep */
        rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
        if (rc)
                goto err_out;

The err_out label only drops the wr_tx link reference, so this early exit
returns without the matching sock_put(). The second error exit is not
affected, because sock_put() has already run by then.

A leaked sk_refcnt means the smc_sock is never destroyed. Its send and
receive buffers stay allocated, and for a user socket the reference held
on the network namespace is never released, so the netns can no longer be
torn down.

smc_cdc_get_free_slot() fails when the target link goes down or when the
connection has been killed while the switch is in progress. Both are
reachable during the link failover this function implements, so the leak
is triggered by the same hardware events that make smc_switch_conns() run
in the first place.

Restructure so there is a single sock_put() covering both outcomes,
instead of adding a second one to the error path.

Fixes: 95f7f3e7dc6b ("net/smc: improved fix wait on already cleared link")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260820144729.1019399-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Replaced smc_switch_link_and_count() with the existing conn->lnk = to_lnk assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 995c48388885c..c138a0ab0369d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -582,13 +582,13 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc)
-			goto err_out;
-		/* avoid race with smcr_tx_sndbuf_nonempty() */
-		spin_lock_bh(&conn->send_lock);
-		conn->lnk = to_lnk;
-		rc = smc_switch_cursor(smc, pend, wr_buf);
-		spin_unlock_bh(&conn->send_lock);
+		if (!rc) {
+			/* avoid race with smcr_tx_sndbuf_nonempty() */
+			spin_lock_bh(&conn->send_lock);
+			conn->lnk = to_lnk;
+			rc = smc_switch_cursor(smc, pend, wr_buf);
+			spin_unlock_bh(&conn->send_lock);
+		}
 		sock_put(&smc->sk);
 		if (rc)
 			goto err_out;
-- 
2.53.0



