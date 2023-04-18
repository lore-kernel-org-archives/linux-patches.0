Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4F22572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BE8C433D2;
	Tue, 18 Apr 2023 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821608;
	bh=iJuQrTY1lO/JWYUD6M5tLQvZw7lvxAk4dK9KP1FihoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiNWm/T8lBWVcIwgO2xhhelDXzdMn9VdvLS+KXyDQtDjWAuWS28sIHQuQ2/niGYtn
	 uFQvhFIcnszmMHjhidfSMNgGwiDn5aeRn/GqY8zt92bIZcoFDIbykXTxwVCeMnodO6
	 ErOCCl0f8Fhw0Fk1nzrHH7gf4wBJY8I5cURjm9KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 65/91] mptcp: use mptcp_schedule_work instead of open-coding it
Date: Tue, 18 Apr 2023 14:22:09 +0200
Message-Id: <20230418120307.834929922@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit a5cb752b125766524c921faab1a45cc96065b0a7 upstream.

Beyond reducing code duplication this also avoids scheduling
the mptcp_worker on a closed socket on some edge scenarios.

The addressed issue is actually older than the blamed commit
below, but this fix needs it as a pre-requisite.

Fixes: ba8f48f7a4d7 ("mptcp: introduce mptcp_schedule_work")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    5 ++---
 net/mptcp/subflow.c |   18 ++++++------------
 2 files changed, 8 insertions(+), 15 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1156,9 +1156,8 @@ bool mptcp_incoming_options(struct sock
 	 */
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		if (mp_opt.data_fin && mp_opt.data_len == 1 &&
-		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64) &&
-		    schedule_work(&msk->work))
-			sock_hold(subflow->conn);
+		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq, mp_opt.dsn64))
+			mptcp_schedule_work((struct sock *)msk);
 
 		return true;
 	}
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -360,9 +360,8 @@ void mptcp_subflow_reset(struct sock *ss
 
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
-	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
-	    schedule_work(&mptcp_sk(sk)->work))
-		return; /* worker will put sk for us */
+	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags))
+		mptcp_schedule_work(sk);
 
 	sock_put(sk);
 }
@@ -1010,8 +1009,8 @@ static enum mapping_status get_mapping_s
 				skb_ext_del(skb, SKB_EXT_MPTCP);
 				return MAPPING_OK;
 			} else {
-				if (updated && schedule_work(&msk->work))
-					sock_hold((struct sock *)msk);
+				if (updated)
+					mptcp_schedule_work((struct sock *)msk);
 
 				return MAPPING_DATA_FIN;
 			}
@@ -1114,17 +1113,12 @@ static void mptcp_subflow_discard_data(s
 /* sched mptcp worker to remove the subflow if no more data is pending */
 static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ssk)
 {
-	struct sock *sk = (struct sock *)msk;
-
 	if (likely(ssk->sk_state != TCP_CLOSE))
 		return;
 
 	if (skb_queue_empty(&ssk->sk_receive_queue) &&
-	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags)) {
-		sock_hold(sk);
-		if (!schedule_work(&msk->work))
-			sock_put(sk);
-	}
+	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		mptcp_schedule_work((struct sock *)msk);
 }
 
 static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)


