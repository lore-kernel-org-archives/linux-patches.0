Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5F134CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C1CC4339B;
	Wed,  7 Jun 2023 20:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170726;
	bh=g9LGI75BIM5SX5ze7eo+NTRTv7UipykGKXBL4tNzLgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYBoOQsth0R08juIS+ZEPPsKXwEEIK0wPDUhGW3btODRhdt6bw6ifoiky0iuagOEM
	 P11+70Wdx3ildFJbbpnfE8ORDJQFicTop4bYrGi5sQAMfeq9tRN+BnugR13LsQe9mX
	 fmFRjObXr0DHsFOqXTbtCJnuWac6ldLTJuKxHX80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 195/225] mptcp: fix active subflow finalization
Date: Wed,  7 Jun 2023 22:16:28 +0200
Message-ID: <20230607200920.752005378@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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
@@ -821,6 +821,13 @@ void mptcp_data_ready(struct sock *sk, s
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
@@ -835,6 +842,7 @@ static bool __mptcp_finish_join(struct m
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
 	mptcp_sockopt_sync_locked(msk, ssk);
+	mptcp_subflow_joined(msk, ssk);
 	return true;
 }
 
@@ -3485,14 +3493,16 @@ bool mptcp_finish_join(struct sock *ssk)
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
@@ -3515,11 +3525,6 @@ err_prohibited:
 		return false;
 	}
 
-	subflow->map_seq = READ_ONCE(msk->ack_seq);
-	WRITE_ONCE(msk->allow_infinite_fallback, false);
-
-out:
-	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 	return true;
 }
 


