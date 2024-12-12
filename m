Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92F31487CD;
	Thu, 12 Dec 2024 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016861; cv=none; b=qZtGGzfwE9k7QvnWkPLXi4dfTam0c5siSgxCJO8NSjGg2r80iCfPoZYeTJ0sH5tul91vUAfIbxoPWohV+solSGoEcv01qYdneTKOnVK1J9DWek/7Bnt6ElmAexsvHKjfpuKm8892IRDTWQOrM0FkjqBGvF6Y4wSQuunsYfoqlRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016861; c=relaxed/simple;
	bh=9opIeZQQCjvRzjjJFBw+08b1kGpn+xrfIIaU+LyiE1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA2mK2IhuOfOUtoo0axydsQ451UiH0FeRP0UoCJxtFyMuk+yrM97vZzT0lewNWxYunkElVafFDMPHiRcLmX+KEKgvoL1vruFcvtSayJUOITONM1TyNkOgqMSRHJXfSz+/JDcSGQz1hUoNcBkquHc+Uzvw+jz8/NenvE/u7YBrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIYtljJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIYtljJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ACDC4CECE;
	Thu, 12 Dec 2024 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016861;
	bh=9opIeZQQCjvRzjjJFBw+08b1kGpn+xrfIIaU+LyiE1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIYtljJuXStCIh+oXHKIz7w/7eV5ZlhP2KbhD2zk+7u7ggygwJWygcwH75Veu05n7
	 YpsE89h2UfaZF/rjuVKnNm0HDvMCTrmj6T5ZHncMzp5xTGVW7mF3tJhH0D54ZcNchL
	 3UtDcAMdUW6FqeX0qpgrtV8Vi+xiLHLFNBghnrzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/466] mptcp: annotate data-races around subflow->fully_established
Date: Thu, 12 Dec 2024 15:58:06 +0100
Message-ID: <20241212144319.322738048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

[ Upstream commit 581c8cbfa934aaa555daa4e843242fcecc160f05 ]

We introduce the same handling for potential data races with the
'fully_established' flag in subflow as previously done for
msk->fully_established.

Additionally, we make a crucial change: convert the subflow's
'fully_established' from 'bit_field' to 'bool' type. This is
necessary because methods for avoiding data races don't work well
with 'bit_field'. Specifically, the 'READ_ONCE' needs to know
the size of the variable being accessed, which is not supported in
'bit_field'. Also, 'test_bit' expect the address of 'bit_field'.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/516
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241021-net-next-mptcp-misc-6-13-v1-2-1ef02746504a@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/diag.c     | 2 +-
 net/mptcp/options.c  | 4 ++--
 net/mptcp/protocol.c | 2 +-
 net/mptcp/protocol.h | 6 +++---
 net/mptcp/subflow.c  | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/diag.c b/net/mptcp/diag.c
index 2d3efb405437d..02205f7994d75 100644
--- a/net/mptcp/diag.c
+++ b/net/mptcp/diag.c
@@ -47,7 +47,7 @@ static int subflow_get_info(struct sock *sk, struct sk_buff *skb)
 		flags |= MPTCP_SUBFLOW_FLAG_BKUP_REM;
 	if (sf->request_bkup)
 		flags |= MPTCP_SUBFLOW_FLAG_BKUP_LOC;
-	if (sf->fully_established)
+	if (READ_ONCE(sf->fully_established))
 		flags |= MPTCP_SUBFLOW_FLAG_FULLY_ESTABLISHED;
 	if (sf->conn_finished)
 		flags |= MPTCP_SUBFLOW_FLAG_CONNECTED;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 370c3836b7712..1603b3702e220 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -461,7 +461,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		return false;
 
 	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
-	if (subflow->fully_established || snd_data_fin_enable ||
+	if (READ_ONCE(subflow->fully_established) || snd_data_fin_enable ||
 	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
 	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
@@ -930,7 +930,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
 	 * will make the subflow fully established
 	 */
-	if (likely(subflow->fully_established)) {
+	if (likely(READ_ONCE(subflow->fully_established))) {
 		/* on passive sockets, check for 3rd ack retransmission
 		 * note that msk is always set by subflow_syn_recv_sock()
 		 * for mp_join subflows
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 48d480982b787..47ee616f69c2d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3519,7 +3519,7 @@ static void schedule_3rdack_retransmission(struct sock *ssk)
 	struct tcp_sock *tp = tcp_sk(ssk);
 	unsigned long timeout;
 
-	if (mptcp_subflow_ctx(ssk)->fully_established)
+	if (READ_ONCE(mptcp_subflow_ctx(ssk)->fully_established))
 		return;
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 568a72702b080..a93e661ef5c43 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -513,7 +513,6 @@ struct mptcp_subflow_context {
 		request_bkup : 1,
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		mp_join : 1,	    /* remote is JOINing */
-		fully_established : 1,	    /* path validated */
 		pm_notified : 1,    /* PM hook called for established status */
 		conn_finished : 1,
 		map_valid : 1,
@@ -532,10 +531,11 @@ struct mptcp_subflow_context {
 		is_mptfo : 1,	    /* subflow is doing TFO */
 		close_event_done : 1,       /* has done the post-closed part */
 		mpc_drop : 1,	    /* the MPC option has been dropped in a rtx */
-		__unused : 8;
+		__unused : 9;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
+	bool	fully_established;  /* path validated */
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
@@ -780,7 +780,7 @@ static inline bool __tcp_can_send(const struct sock *ssk)
 static inline bool __mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 {
 	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
-	if (subflow->request_join && !subflow->fully_established)
+	if (subflow->request_join && !READ_ONCE(subflow->fully_established))
 		return false;
 
 	return __tcp_can_send(mptcp_subflow_tcp_sock(subflow));
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6170f2fff71e4..860903e064225 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -800,7 +800,7 @@ void __mptcp_subflow_fully_established(struct mptcp_sock *msk,
 				       const struct mptcp_options_received *mp_opt)
 {
 	subflow_set_remote_key(msk, subflow, mp_opt);
-	subflow->fully_established = 1;
+	WRITE_ONCE(subflow->fully_established, true);
 	WRITE_ONCE(msk->fully_established, true);
 
 	if (subflow->is_mptfo)
@@ -2062,7 +2062,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	} else if (subflow_req->mp_join) {
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->mp_join = 1;
-		new_ctx->fully_established = 1;
+		WRITE_ONCE(new_ctx->fully_established, true);
 		new_ctx->remote_key_valid = 1;
 		new_ctx->backup = subflow_req->backup;
 		new_ctx->request_bkup = subflow_req->request_bkup;
-- 
2.43.0



