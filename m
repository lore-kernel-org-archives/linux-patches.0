Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE3430ACE6;
	Mon, 13 Apr 2026 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097700; cv=none; b=sgobf7i2Pq3C5sRI/APchlYseYVxsmcXzGf5oOKM8XAgltDADOZY+tBGcbrwLumK3SMUkTKRwsENnPAXDhZu08141kwaMToly9wyZBJUdcKlBJ3sy3/z/g8smeUwnVAG68zYZsmnXrOPyt/fIvshhgp6q7By1iTuL/IZzVMbEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097700; c=relaxed/simple;
	bh=jTNkRTCZ0aIjf/OqaFXTj07Ov64bAGAckXHEKoEUFvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO/eUrRDMM5jAW9oKJ8UYQjPGaL46tlLv9Kg2I65e7ps86qpDU3qnMD+URdAAsp6MaC6q2DyTysm04Nd5KN86fJkmY5MgzC79Kz6YFnhUtZq3YZSMLTiG1IvYUI/50T9DGKRXAsPxBL7BTVIP+aWoLYL/JUQGO+HE9Sla486rX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3dVWoaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3dVWoaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96162C2BCAF;
	Mon, 13 Apr 2026 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097699;
	bh=jTNkRTCZ0aIjf/OqaFXTj07Ov64bAGAckXHEKoEUFvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3dVWoaU6A5vVasBqBV+6MikD5FPaFgd0z+biFYO5TJFwWSOGuy3mUhEB9CseRiIZ
	 HBi3A5QL2XxfXqgBsO/Ca30mIA8bXMq8H4fOXoz8Qum4K0c0WsK9tuVLPfRy6GJrp5
	 /aa8Plyy8B5+OazKcnvSA+vlzWPWdXZN0oaFEPkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Lorenz <lorenz-frank@web.de>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/570] mptcp: pm: avoid sending RM_ADDR over same subflow
Date: Mon, 13 Apr 2026 17:56:10 +0200
Message-ID: <20260413155839.420340663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit fb8d0bccb221080630efcd9660c9f9349e53cc9e ]

RM_ADDR are sent over an active subflow, the first one in the subflows
list. There is then a high chance the initial subflow is picked. With
the in-kernel PM, when an endpoint is removed, a RM_ADDR is sent, then
linked subflows are closed. This is done for each active MPTCP
connection.

MPTCP endpoints are likely removed because the attached network is no
longer available or usable. In this case, it is better to avoid sending
this RM_ADDR over the subflow that is going to be removed, but prefer
sending it over another active and non stale subflow, if any.

This modification avoids situations where the other end is not notified
when a subflow is no longer usable: typically when the endpoint linked
to the initial subflow is removed, especially on the server side.

Fixes: 8dd5efb1f91b ("mptcp: send ack for rm_addr")
Cc: stable@vger.kernel.org
Reported-by: Frank Lorenz <lorenz-frank@web.de>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/612
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-2-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ pm.c => pm_netlink.c + replaced subflow_get_local_id() with subflow->local_id ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c         |    2 -
 net/mptcp/pm_netlink.c |   57 +++++++++++++++++++++++++++++++++++++++----------
 net/mptcp/protocol.h   |    2 +
 3 files changed, 49 insertions(+), 12 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -55,7 +55,7 @@ int mptcp_pm_remove_addr(struct mptcp_so
 	msk->pm.rm_list_tx = *rm_list;
 	rm_addr |= BIT(MPTCP_RM_ADDR_SIGNAL);
 	WRITE_ONCE(msk->pm.addr_signal, rm_addr);
-	mptcp_pm_nl_addr_send_ack(msk);
+	mptcp_pm_nl_addr_send_ack_avoid_list(msk, rm_list);
 	return 0;
 }
 
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -753,9 +753,23 @@ bool mptcp_pm_nl_is_init_remote_addr(str
 	return addresses_equal(&mpc_remote, remote, remote->port);
 }
 
-void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
+static bool subflow_in_rm_list(const struct mptcp_subflow_context *subflow,
+			       const struct mptcp_rm_list *rm_list)
+{
+	u8 i, id = subflow->local_id;
+
+	for (i = 0; i < rm_list->nr; i++) {
+		if (rm_list->ids[i] == id)
+			return true;
+	}
+
+	return false;
+}
+
+void mptcp_pm_nl_addr_send_ack_avoid_list(struct mptcp_sock *msk,
+					  const struct mptcp_rm_list *rm_list)
 {
-	struct mptcp_subflow_context *subflow;
+	struct mptcp_subflow_context *subflow, *same_id = NULL;
 
 	msk_owned_by_me(msk);
 	lockdep_assert_held(&msk->pm.lock);
@@ -766,18 +780,39 @@ void mptcp_pm_nl_addr_send_ack(struct mp
 
 	__mptcp_flush_join_list(msk);
 	mptcp_for_each_subflow(msk, subflow) {
-		if (__mptcp_subflow_active(subflow)) {
-			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		if (!__mptcp_subflow_active(subflow))
+			continue;
 
-			spin_unlock_bh(&msk->pm.lock);
-			pr_debug("send ack for %s\n",
-				 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr");
-
-			mptcp_subflow_send_ack(ssk);
-			spin_lock_bh(&msk->pm.lock);
-			break;
+		if (unlikely(rm_list &&
+			     subflow_in_rm_list(subflow, rm_list))) {
+			if (!same_id)
+				same_id = subflow;
+		} else {
+			goto send_ack;
 		}
 	}
+
+	if (same_id)
+		subflow = same_id;
+	else
+		return;
+
+send_ack:
+	{
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		spin_unlock_bh(&msk->pm.lock);
+		pr_debug("send ack for %s\n",
+			 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr");
+
+		mptcp_subflow_send_ack(ssk);
+		spin_lock_bh(&msk->pm.lock);
+	}
+}
+
+void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
+{
+	mptcp_pm_nl_addr_send_ack_avoid_list(msk, NULL);
 }
 
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -753,6 +753,8 @@ void mptcp_pm_add_addr_send_ack(struct m
 bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
 				     const struct mptcp_addr_info *remote);
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
+void mptcp_pm_nl_addr_send_ack_avoid_list(struct mptcp_sock *msk,
+					  const struct mptcp_rm_list *rm_list);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);
 void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup);


