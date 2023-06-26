Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CD113AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C22C433C9;
	Mon, 26 Jun 2023 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804144;
	bh=6kzFPY5wPvlO+ZvPUuJVlfEL/70LjeVKtlWzsLdyAwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8rfJcoT2mDLnDlWzG7qdAekh/Z44mqBPbd/OoJshY5N77yAg/wOj/YY0n56pYXW1
	 nLIIO4CSFmGWcN2247PY4+bSYYUg1A4LJCFR1BypFfjcSFzAw9vjqtVqeqE/kp1fWN
	 12LJy8wyNZ5IZmo8zGkBayocZqL0/uJ1pz7oAzIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Christoph Paasch <cpaasch@apple.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 057/170] mptcp: handle correctly disconnect() failures
Date: Mon, 26 Jun 2023 20:10:26 +0200
Message-ID: <20230626180803.141430398@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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
@@ -1708,7 +1708,13 @@ static int mptcp_sendmsg_fastopen(struct
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
@@ -2375,7 +2381,10 @@ static void __mptcp_close_ssk(struct soc
 
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
@@ -2799,7 +2808,7 @@ void mptcp_subflow_shutdown(struct sock
 			break;
 		fallthrough;
 	case TCP_SYN_SENT:
-		tcp_disconnect(ssk, O_NONBLOCK);
+		WARN_ON_ONCE(tcp_disconnect(ssk, O_NONBLOCK));
 		break;
 	default:
 		if (__mptcp_check_fallback(mptcp_sk(sk))) {
@@ -3053,11 +3062,10 @@ static int mptcp_disconnect(struct sock
 
 	/* We are on the fastopen error path. We can't call straight into the
 	 * subflows cleanup code due to lock nesting (we are already under
-	 * msk->firstsocket lock). Do nothing and leave the cleanup to the
-	 * caller.
+	 * msk->firstsocket lock).
 	 */
 	if (msk->fastopening)
-		return 0;
+		return -EBUSY;
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 


