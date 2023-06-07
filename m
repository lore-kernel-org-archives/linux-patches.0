Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C503AE70
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B613AC433D2;
	Wed,  7 Jun 2023 20:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169924;
	bh=xMojdUi0r+s2wIaMmMZjaNBC84KPk/9zPMWyrmM6/Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+XliW/v8h7HbLC8w8C91EWS+roVbeZQSbYsk8+WHhp7+ov7oDTiK6CSEr3Legpxo
	 qC5SoiV+mHZwgJTB7O9Nma2rM+60pb5i94SnKFbTyKXiqVD7VFnWw+8YcVsOzi5mao
	 JWpmHa9JhILLN4ps7beFVhoUOK+l7gDPjmDRxvtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 258/286] mptcp: fix active subflow finalization
Date: Wed,  7 Jun 2023 22:15:57 +0200
Message-ID: <20230607200931.742381907@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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

commit 55b47ca7d80814ceb63d64e032e96cd6777811e5 upstream.

Active subflow are inserted into the connection list at creation time.
When the MPJ handshake completes successfully, a new subflow creation
netlink event is generated correctly, but the current code wrongly
avoid initializing a couple of subflow data.

The above will cause misbehavior on a few exceptional events: unneeded
mptcp-level retransmission on msk-level sequence wrap-around and infinite
mapping fallback even when a MPJ socket is present.

Address the issue factoring out the needed initialization in a new helper
and invoking the latter from __mptcp_finish_join() time for passive
subflow and from mptcp_finish_join() for active ones.

Fixes: 0530020a7c8f ("mptcp: track and update contiguous data status")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -812,6 +812,13 @@ void mptcp_data_ready(struct sock *sk, s
 	mptcp_data_unlock(sk);
 }
 
+static void mptcp_subflow_joined(struct mptcp_sock *msk, struct sock *ssk)
+{
+	mptcp_subflow_ctx(ssk)->map_seq = READ_ONCE(msk->ack_seq);
+	WRITE_ONCE(msk->allow_infinite_fallback, false);
+	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
+}
+
 static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -826,6 +833,7 @@ static bool __mptcp_finish_join(struct m
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
 	mptcp_sockopt_sync_locked(msk, ssk);
+	mptcp_subflow_joined(msk, ssk);
 	return true;
 }
 
@@ -3457,14 +3465,16 @@ bool mptcp_finish_join(struct sock *ssk)
 		return false;
 	}
 
-	if (!list_empty(&subflow->node))
-		goto out;
+	/* active subflow, already present inside the conn_list */
+	if (!list_empty(&subflow->node)) {
+		mptcp_subflow_joined(msk, ssk);
+		return true;
+	}
 
 	if (!mptcp_pm_allow_new_subflow(msk))
 		goto err_prohibited;
 
-	/* active connections are already on conn_list.
-	 * If we can't acquire msk socket lock here, let the release callback
+	/* If we can't acquire msk socket lock here, let the release callback
 	 * handle it
 	 */
 	mptcp_data_lock(parent);
@@ -3487,11 +3497,6 @@ err_prohibited:
 		return false;
 	}
 
-	subflow->map_seq = READ_ONCE(msk->ack_seq);
-	WRITE_ONCE(msk->allow_infinite_fallback, false);
-
-out:
-	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 	return true;
 }
 


