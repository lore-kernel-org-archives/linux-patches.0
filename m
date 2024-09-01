Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FC17E900;
	Sun,  1 Sep 2024 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209136; cv=none; b=nUb0TeQBVrbSWdiyOYkJ+jBC/vZ3iqEgRyYAN6sYu/ojQxt6SWw2LDqZoMwQK92+91edTY6f8VV9f2UU12OK+au1Yq+Y6hBKo6rtNMsEqNOfAicxaENXksEn+lx5Nsr6HEmlWryZcLYPC8U8D3aHnJQ46i9QvT2sZp5D8uzM5ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209136; c=relaxed/simple;
	bh=lrVYpjvXe7uC8O3bSO5ENItPO1XxNHqL74O726V8eEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpG8HsaWax+08Y0/F6gC5qHYR73oQO/RE8owanUecmd0UhLY8yIa26niKFevMJRhSZCtt73mjzLZAotIA+QPjzJhdLj5kPjz/GrQTwKhoF7eU+BN3EGE1Nz6SJxXuwbU7PSWI0No7Uk6e/9K48avEG3a0lHDHg/+Bygk6VHmLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRHOG8kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRHOG8kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E09FC4CEC3;
	Sun,  1 Sep 2024 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209135;
	bh=lrVYpjvXe7uC8O3bSO5ENItPO1XxNHqL74O726V8eEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRHOG8kWofQqFe39vFM0CtE+BNgMqiqPw6edpLTCZhn13jKKcLrjeGgYKGSLuK/hL
	 gpUHdkatHSL6h90GDcDAN38mvx/llzftxS9DeKW6iu7xLBuZahMQL+Ddh3QuaBKm7i
	 vAjB3a5zJrId1fPmTYFw/Rs5D/l43UXiBMGt5dsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 11/71] mptcp: close subflow when receiving TCP+FIN
Date: Sun,  1 Sep 2024 18:17:16 +0200
Message-ID: <20240901160802.314142191@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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
@@ -2528,8 +2528,11 @@ static void __mptcp_close_subflow(struct
 
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
@@ -1137,12 +1137,16 @@ out:
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


