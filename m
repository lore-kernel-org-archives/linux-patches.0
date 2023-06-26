Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30461134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5470AC433C8;
	Mon, 26 Jun 2023 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803462;
	bh=rETuzVcX12314GtalFMQien40k2C25yqlrDrg5bOBcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2RSLu/VYjwQd6rJQEvWz421HD5m3VGCYihjDo4wvRjlMyFGaiFA6/9gpykmaHeYY
	 BLF+azllyrvSMpYSTpG4Uh3WL49TOre7b7hmvLQ/JnUHyAocqvBKezj6HBkY61+4YJ
	 rZP5avuiOTyz0hZeWKD6O0Bpy2PIIWKnTgr9ifV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Christoph Paasch <cpaasch@apple.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 070/199] mptcp: handle correctly disconnect() failures
Date: Mon, 26 Jun 2023 20:09:36 +0200
Message-ID: <20230626180808.600098813@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit c2b2ae3925b65070adb27d5a31a31c376f26dec7 upstream.

Currently the mptcp code has assumes that disconnect() can fail only
at mptcp_sendmsg_fastopen() time - to avoid a deadlock scenario - and
don't even bother returning an error code.

Soon mptcp_disconnect() will handle more error conditions: let's track
them explicitly.

As a bonus, explicitly annotate TCP-level disconnect as not failing:
the mptcp code never blocks for event on the subflows.

Fixes: 7d803344fdc3 ("mptcp: fix deadlock in fastopen error path")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1696,7 +1696,13 @@ static int mptcp_sendmsg_fastopen(struct
 		if (ret && ret != -EINPROGRESS && ret != -ERESTARTSYS && ret != -EINTR)
 			*copied_syn = 0;
 	} else if (ret && ret != -EINPROGRESS) {
-		mptcp_disconnect(sk, 0);
+		/* The disconnect() op called by tcp_sendmsg_fastopen()/
+		 * __inet_stream_connect() can fail, due to looking check,
+		 * see mptcp_disconnect().
+		 * Attempt it again outside the problematic scope.
+		 */
+		if (!mptcp_disconnect(sk, 0))
+			sk->sk_socket->state = SS_UNCONNECTED;
 	}
 
 	return ret;
@@ -2360,7 +2366,10 @@ static void __mptcp_close_ssk(struct soc
 
 	need_push = (flags & MPTCP_CF_PUSH) && __mptcp_retransmit_pending_data(sk);
 	if (!dispose_it) {
-		tcp_disconnect(ssk, 0);
+		/* The MPTCP code never wait on the subflow sockets, TCP-level
+		 * disconnect should never fail
+		 */
+		WARN_ON_ONCE(tcp_disconnect(ssk, 0));
 		msk->subflow->state = SS_UNCONNECTED;
 		mptcp_subflow_ctx_reset(subflow);
 		release_sock(ssk);
@@ -2787,7 +2796,7 @@ void mptcp_subflow_shutdown(struct sock
 			break;
 		fallthrough;
 	case TCP_SYN_SENT:
-		tcp_disconnect(ssk, O_NONBLOCK);
+		WARN_ON_ONCE(tcp_disconnect(ssk, O_NONBLOCK));
 		break;
 	default:
 		if (__mptcp_check_fallback(mptcp_sk(sk))) {
@@ -3047,11 +3056,10 @@ static int mptcp_disconnect(struct sock
 
 	/* We are on the fastopen error path. We can't call straight into the
 	 * subflows cleanup code due to lock nesting (we are already under
-	 * msk->firstsocket lock). Do nothing and leave the cleanup to the
-	 * caller.
+	 * msk->firstsocket lock).
 	 */
 	if (msk->fastopening)
-		return 0;
+		return -EBUSY;
 
 	mptcp_listen_inuse_dec(sk);
 	inet_sk_state_store(sk, TCP_CLOSE);


