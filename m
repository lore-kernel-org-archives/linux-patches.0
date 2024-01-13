Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7887715AF;
	Sat, 13 Jan 2024 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPyJWiL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA301C43394;
	Sat, 13 Jan 2024 09:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139815;
	bh=OSMOv2cGfLkePejzxu5Alh4WLQtxgK9BjSgJ4O81As0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPyJWiL+PJ9YqGDYHYybMntjPHxVeP4yQSb8LoAIcfjZwre3IXJoy7gKzUnza95rv
	 P9vmjAiW4CeUOuiH7Eczjn2klMgHB/kMjGv/XzR85zoZNcPCK1oX/jzl+v38XTZnSu
	 o1KlLVZECsaPuKX+RbhptO+amIEdKueBTT1oY7h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/38] can: raw: add support for SO_TXTIME/SCM_TXTIME
Date: Sat, 13 Jan 2024 10:49:41 +0100
Message-ID: <20240113094206.619467945@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 51a0d5e51178fcd147c1b8fdab2ed16b561326db ]

This patch calls into sock_cmsg_send() to parse the user supplied
control information into a struct sockcm_cookie. Then assign the
requested transmit time to the skb.

This makes it possible to use the Earliest TXTIME First (ETF) packet
scheduler with the CAN_RAW protocol. The user can send a CAN_RAW frame
with a TXTIME and the kernel (with the ETF scheduler) will take care
of sending it to the network interface.

Link: https://lore.kernel.org/all/20220502091946.1916211-3-mkl@pengutronix.de
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 7f6ca95d16b9 ("net: Implement missing getsockopt(SO_TIMESTAMPING_NEW)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/raw.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index bb837019d1724..2700153262771 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -770,6 +770,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
+	struct sockcm_cookie sockc;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	int ifindex;
@@ -815,11 +816,19 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err < 0)
 		goto free_skb;
 
-	skb_setup_tx_timestamp(skb, sk->sk_tsflags);
+	sockcm_init(&sockc, sk);
+	if (msg->msg_controllen) {
+		err = sock_cmsg_send(sk, msg, &sockc);
+		if (unlikely(err))
+			goto free_skb;
+	}
 
 	skb->dev = dev;
 	skb->sk  = sk;
 	skb->priority = sk->sk_priority;
+	skb->tstamp = sockc.transmit_time;
+
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	err = can_send(skb, ro->loopback);
 
-- 
2.43.0



