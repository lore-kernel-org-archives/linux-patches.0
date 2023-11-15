Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7443BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLZ9axPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F64C433C9;
	Wed, 15 Nov 2023 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078015;
	bh=dHJzs51YDpuma3mMm8YzRWrHJ+J5Sp7EQ7mh4BkMnTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLZ9axPoUW2UtJMrXbkoo3XIoHja1Gn0ohM2uXA+FZOs8gmQRZXTC4XhJ84lcVXUu
	 H6ELaVrcUl0pc77fpghfUTygzIfIcob5QbE2/ZcuPTxgoOLUEgvXlfwaKRrO4KGlS1
	 edlHBP3nodt0K8aBIw02FblSDjiYKPHYLVsuAbkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aananth V <aananthv@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/379] tcp: call tcp_try_undo_recovery when an RTOd TFO SYNACK is ACKed
Date: Wed, 15 Nov 2023 14:21:47 -0500
Message-ID: <20231115192647.062091992@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aananth V <aananthv@google.com>

[ Upstream commit e326578a21414738de45f77badd332fb00bd0f58 ]

For passive TCP Fast Open sockets that had SYN/ACK timeout and did not
send more data in SYN_RECV, upon receiving the final ACK in 3WHS, the
congestion state may awkwardly stay in CA_Loss mode unless the CA state
was undone due to TCP timestamp checks. However, if
tcp_rcv_synrecv_state_fastopen() decides not to undo, then we should
enter CA_Open, because at that point we have received an ACK covering
the retransmitted SYNACKs. Currently, the icsk_ca_state is only set to
CA_Open after we receive an ACK for a data-packet. This is because
tcp_ack does not call tcp_fastretrans_alert (and tcp_process_loss) if
!prior_packets

Note that tcp_process_loss() calls tcp_try_undo_recovery(), so having
tcp_rcv_synrecv_state_fastopen() decide that if we're in CA_Loss we
should call tcp_try_undo_recovery() is consistent with that, and
low risk.

Fixes: dad8cea7add9 ("tcp: fix TFO SYNACK undo to avoid double-timestamp-undo")
Signed-off-by: Aananth V <aananthv@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d63942202493d..65dae3d43684f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6420,22 +6420,23 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
 	struct request_sock *req;
 
 	/* If we are still handling the SYNACK RTO, see if timestamp ECR allows
 	 * undo. If peer SACKs triggered fast recovery, we can't undo here.
 	 */
-	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Loss)
-		tcp_try_undo_loss(sk, false);
+	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Loss && !tp->packets_out)
+		tcp_try_undo_recovery(sk);
 
 	/* Reset rtx states to prevent spurious retransmits_timed_out() */
-	tcp_sk(sk)->retrans_stamp = 0;
+	tp->retrans_stamp = 0;
 	inet_csk(sk)->icsk_retransmits = 0;
 
 	/* Once we leave TCP_SYN_RECV or TCP_FIN_WAIT_1,
 	 * we no longer need req so release it.
 	 */
-	req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk,
+	req = rcu_dereference_protected(tp->fastopen_rsk,
 					lockdep_sock_is_held(sk));
 	reqsk_fastopen_remove(sk, req, false);
 
-- 
2.42.0



