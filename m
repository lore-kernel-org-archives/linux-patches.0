Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B2C4339B;
	Mon, 20 Feb 2023 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901189;
	bh=CKXPtMPsyjxt5m/mjliJGJhzn1rjocrOsDVJj7es5YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jioy+IO1rOUmi7XFtYL90+sOGnnNtFv/cUWn6WuqTcbfaZobJHEjo3yM1IrOiAlci
	 fMdxKA7CzPPpsssM6eHWqnRwntWacxRb9PJEWS1kcq9yOFwVQpInnB01+4W1GNQe56
	 coFisdYByyDjEXz3Yo0KG8cOqJlwmciSrrh7zSPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 34/83] mptcp: do not wait for bare sockets timeout
Date: Mon, 20 Feb 2023 14:36:07 +0100
Message-Id: <20230220133554.844189134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

commit d4e85922e3e7ef2071f91f65e61629b60f3a9cf4 upstream.

If the peer closes all the existing subflows for a given
mptcp socket and later the application closes it, the current
implementation let it survive until the timewait timeout expires.

While the above is allowed by the protocol specification it
consumes resources for almost no reason and additionally
causes sporadic self-tests failures.

Let's move the mptcp socket to the TCP_CLOSE state when there are
no alive subflows at close time, so that the allocated resources
will be freed immediately.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mptcp/protocol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2726,6 +2726,7 @@ static void mptcp_close(struct sock *sk,
 {
 	struct mptcp_subflow_context *subflow;
 	bool do_cancel_work = false;
+	int subflows_alive = 0;
 
 	lock_sock(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
@@ -2747,11 +2748,19 @@ cleanup:
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		subflows_alive += ssk->sk_state != TCP_CLOSE;
+
 		sock_orphan(ssk);
 		unlock_sock_fast(ssk, slow);
 	}
 	sock_orphan(sk);
 
+	/* all the subflows are closed, only timeout can change the msk
+	 * state, let's not keep resources busy for no reasons
+	 */
+	if (subflows_alive == 0)
+		inet_sk_state_store(sk, TCP_CLOSE);
+
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (sk->sk_state == TCP_CLOSE) {


