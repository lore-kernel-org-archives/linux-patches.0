Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C331414290C;
	Sun,  1 Sep 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207898; cv=none; b=ALm8XrhfE33+ryk1Rf+e1I/LaYTmqRtYZzAquxMO+tz+YYxM1OzqxYCnRkbj7nCVB7O34kcyMqp7fcNMMMWrzYsrq3KnT0ioLj7DS8UL+/4kUjuZeqBTWQBpACwxgJ4pUYpL3DPyybDut6ahwANoTvhCnpNROwjCMwlmPxPVpe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207898; c=relaxed/simple;
	bh=RUgw2PfakD2E6SuEufAYHtfIcgchMS2RF/BEDIMdtWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDhwmHwMNsJ/C9lDjXnOP7U0C7Wg2QlGdHeW0vwNFKU5NhaaBMaESrTcyb4jB6Lh2qeb3KP+0zfv+aoE4t84kvgMcaDw75h2gJMJJMGyunbvpwTvmo2snYDrB0AdxcUqEkgcHtSX2p+hv9CSSLuh2Hhri9f/EeUHVbfGltcMrco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oO6Rz3NN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oO6Rz3NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC72C4CEC3;
	Sun,  1 Sep 2024 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207898;
	bh=RUgw2PfakD2E6SuEufAYHtfIcgchMS2RF/BEDIMdtWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oO6Rz3NN93sHbUUnKFe4Wv1fwbwq72mjopffLz2PLCm+ssTsgNm7knpDD7OwXch6Z
	 yxNHp07WlWD9/oTng+Cu8rkXKFsyLggJRkp5Bgph+X8dK3zeOSWdUEMc5q4D8fuUuM
	 Ucs7XcAZ8kB+SN8yJTB/QX4p491YWiCqyonHn0FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 12/93] mptcp: close subflow when receiving TCP+FIN
Date: Sun,  1 Sep 2024 18:15:59 +0200
Message-ID: <20240901160807.820287848@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit f09b0ad55a1196f5891663f8888463c0541059cb upstream.

When a peer decides to close one subflow in the middle of a connection
having multiple subflows, the receiver of the first FIN should accept
that, and close the subflow on its side as well. If not, the subflow
will stay half closed, and would even continue to be used until the end
of the MPTCP connection or a reset from the network.

The issue has not been seen before, probably because the in-kernel
path-manager always sends a RM_ADDR before closing the subflow. Upon the
reception of this RM_ADDR, the other peer will initiate the closure on
its side as well. On the other hand, if the RM_ADDR is lost, or if the
path-manager of the other peer only closes the subflow without sending a
RM_ADDR, the subflow would switch to TCP_CLOSE_WAIT, but that's it,
leaving the subflow half-closed.

So now, when the subflow switches to the TCP_CLOSE_WAIT state, and if
the MPTCP connection has not been closed before with a DATA_FIN, the
kernel owning the subflow schedules its worker to initiate the closure
on its side as well.

This issue can be easily reproduced with packetdrill, as visible in [1],
by creating an additional subflow, injecting a FIN+ACK before sending
the DATA_FIN, and expecting a FIN+ACK in return.

Fixes: 40947e13997a ("mptcp: schedule worker when subflow is closed")
Cc: stable@vger.kernel.org
Link: https://github.com/multipath-tcp/packetdrill/pull/154 [1]
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240826-net-mptcp-close-extra-sf-fin-v1-1-905199fe1172@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    5 ++++-
 net/mptcp/subflow.c  |    8 ++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2496,8 +2496,11 @@ static void __mptcp_close_subflow(struct
 
 	mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int ssk_state = inet_sk_state_load(ssk);
 
-		if (inet_sk_state_load(ssk) != TCP_CLOSE)
+		if (ssk_state != TCP_CLOSE &&
+		    (ssk_state != TCP_CLOSE_WAIT ||
+		     inet_sk_state_load(sk) != TCP_ESTABLISHED))
 			continue;
 
 		/* 'subflow_data_ready' will re-sched once rx queue is empty */
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1226,12 +1226,16 @@ out:
 /* sched mptcp worker to remove the subflow if no more data is pending */
 static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ssk)
 {
-	if (likely(ssk->sk_state != TCP_CLOSE))
+	struct sock *sk = (struct sock *)msk;
+
+	if (likely(ssk->sk_state != TCP_CLOSE &&
+		   (ssk->sk_state != TCP_CLOSE_WAIT ||
+		    inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		return;
 
 	if (skb_queue_empty(&ssk->sk_receive_queue) &&
 	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		mptcp_schedule_work((struct sock *)msk);
+		mptcp_schedule_work(sk);
 }
 
 static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)


