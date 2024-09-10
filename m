Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75C1A0AE1;
	Tue, 10 Sep 2024 10:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963568; cv=none; b=DNg1n7XHX2cmW0vDhwI5c9930Dq9pQW2bsqWT3H0MRsLMJGgaMD3fvPTDGPwuSO7CQs+Hlb88Q7v0LYswylfe87H9iJzr9SXgEqy+jGNNOv52hn4uBad4vYLr7nXsXdsqpmjxILlVXtDklK2pcsoaASCHdKGwQpK9qGDE262vm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963568; c=relaxed/simple;
	bh=uc9z6TxQVGIEDfi88IFUMjcL4t3DvG253ojhPeUaX8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It45QoXV7V3kwutr6KUCBD2PlPE1cW7fanzLirlUtlrbViE7j9T08pYkr3zCc9gDnnrgpfmD7+a/zHG6gcUAL+j35TXijauqfuEqqab6Z7ZEul4BvO3RLFhqin6WOEFUDUxSXf7uiuBmkcLf1Xq/mqBKQ2MEmZ/Y/ATbRTEjIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6bBvqf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6bBvqf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9AEC4CEC3;
	Tue, 10 Sep 2024 10:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963567;
	bh=uc9z6TxQVGIEDfi88IFUMjcL4t3DvG253ojhPeUaX8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6bBvqf4nVb7tDOZDwO03ZIZQq3JC5rCXexi6SZM63S4afeykG8eekes2XR43752o
	 aMhHBrpd8W3zs2sQFVJ9YM7qdOAJxZyaQPFCwk/aCG0NbC4VW6MvRsbsVde4fd8QEW
	 j5IfXnVS4TMTzoUW3RriM3O+O35SUpl0bTdRVZVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 102/214] mptcp: pm: send ACK on an active subflow
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092602.959282110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit c07cc3ed895f9bfe0c53b5ed6be710c133b4271c upstream.

Taking the first one on the list doesn't work in some cases, e.g. if the
initial subflow is being removed. Pick another one instead of not
sending anything.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in pm_netlink.c, because the code has been refactored in
  commit f5360e9b314c ("mptcp: introduce and use mptcp_pm_send_ack()")
  which is difficult to backport in this version. The same adaptations
  have been applied: iterating over all subflows, and send the ACK on
  the first active subflow. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -693,16 +693,18 @@ void mptcp_pm_nl_addr_send_ack(struct mp
 		return;
 
 	__mptcp_flush_join_list(msk);
-	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
-	if (subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+	mptcp_for_each_subflow(msk, subflow) {
+		if (__mptcp_subflow_active(subflow)) {
+			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		spin_unlock_bh(&msk->pm.lock);
-		pr_debug("send ack for %s\n",
-			 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr");
+			spin_unlock_bh(&msk->pm.lock);
+			pr_debug("send ack for %s\n",
+				 mptcp_pm_should_add_signal(msk) ? "add_addr" : "rm_addr");
 
-		mptcp_subflow_send_ack(ssk);
-		spin_lock_bh(&msk->pm.lock);
+			mptcp_subflow_send_ack(ssk);
+			spin_lock_bh(&msk->pm.lock);
+			break;
+		}
 	}
 }
 


