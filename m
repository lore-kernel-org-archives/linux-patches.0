Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C21313546;
	Wed,  3 Dec 2025 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780451; cv=none; b=ADRw40lE5bhAODgrMQ+j6AfGOld/1/yYvDZ8bigjkiparI6ZJzBivMNXQ5Kn2GJSevQ7h9RYL5WAOoOeidjgzP5eP2b06GZqgi+Famk75u3btMkDKVb03giH4modaSi1HAEc7ZL62W4eknLx50Jdyq+BjUYFeWZMZhv68g9phro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780451; c=relaxed/simple;
	bh=qx1nChWIlWLx1bdxH3rB1p3HaO0il9VgFW20qO7m5lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVfUCKuMbOxNL6rDBvQOuBDly8Et2lSiijlvKxkTEWdgS2jL/9wjVxXvjV11n7bQNXEoLlj93jTSitEWSnAUTfpUAWCdFp40GQttNvsPnLQVZq0f+ydqPoJZYWU4klfqr6QPMfATun2azL75JgDwXMEMD/KYZv2LZeTNwIgihPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAnCwhLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAnCwhLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D77EC4CEF5;
	Wed,  3 Dec 2025 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780450;
	bh=qx1nChWIlWLx1bdxH3rB1p3HaO0il9VgFW20qO7m5lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAnCwhLqS8PVWvnjVBXiysnX3MXbyFjC8+E7RNXtOTsAemoOWz5wCs+Bcg1AV+4PY
	 olF+dJ/d2tDJZM//oJKlR50nNZF5Hk1N8ZRVs58GJoH2nBWbQFcslEm5r0hV4Kup6g
	 YK3o3gNUWzaaPryoJz2LD1cjs1NuUqxAG7lE3QsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 559/568] mptcp: fix duplicate reset on fastclose
Date: Wed,  3 Dec 2025 16:29:21 +0100
Message-ID: <20251203152501.185702729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit ae155060247be8dcae3802a95bd1bdf93ab3215d upstream.

The CI reports sporadic failures of the fastclose self-tests. The root
cause is a duplicate reset, not carrying the relevant MPTCP option.
In the failing scenario the bad reset is received by the peer before
the fastclose one, preventing the reception of the latter.

Indeed there is window of opportunity at fastclose time for the
following race:

  mptcp_do_fastclose
    __mptcp_close_ssk
      __tcp_close()
        tcp_set_state() [1]
        tcp_send_active_reset() [2]

After [1] the stack will send reset to in-flight data reaching the now
closed port. Such reset may race with [2].

Address the issue explicitly sending a single reset on fastclose before
explicitly moving the subflow to close status.

Fixes: d21f83485518 ("mptcp: use fastclose on more edge scenarios")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/596
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-6-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in protocol.c, because commit bbd49d114d57 ("mptcp:
  consolidate transition to TCP_CLOSE in mptcp_do_fastclose()") is not
  in this version. It introduced a new line in the context. The same
  modification can still be applied.
  Also, tcp_send_active_reset() doesn't take a 3rd argument
  (sk_rst_reason) in this version, see commit 5691276b39da ("rstreason:
  prepare for active reset"). This argument is only helpful for tracing,
  it is fine to drop it. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2440,7 +2440,6 @@ bool __mptcp_retransmit_pending_data(str
 
 /* flags for __mptcp_close_ssk() */
 #define MPTCP_CF_PUSH		BIT(1)
-#define MPTCP_CF_FASTCLOSE	BIT(2)
 
 /* be sure to send a reset only if the caller asked for it, also
  * clean completely the subflow status when the subflow reaches
@@ -2451,7 +2450,7 @@ static void __mptcp_subflow_disconnect(s
 				       unsigned int flags)
 {
 	if (((1 << ssk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
-	    (flags & MPTCP_CF_FASTCLOSE)) {
+	    subflow->send_fastclose) {
 		/* The MPTCP code never wait on the subflow sockets, TCP-level
 		 * disconnect should never fail
 		 */
@@ -2498,14 +2497,8 @@ static void __mptcp_close_ssk(struct soc
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 
-	if ((flags & MPTCP_CF_FASTCLOSE) && !__mptcp_check_fallback(msk)) {
-		/* be sure to force the tcp_close path
-		 * to generate the egress reset
-		 */
-		ssk->sk_lingertime = 0;
-		sock_set_flag(ssk, SOCK_LINGER);
-		subflow->send_fastclose = 1;
-	}
+	if (subflow->send_fastclose && ssk->sk_state != TCP_CLOSE)
+		tcp_set_state(ssk, TCP_CLOSE);
 
 	need_push = (flags & MPTCP_CF_PUSH) && __mptcp_retransmit_pending_data(sk);
 	if (!dispose_it) {
@@ -2794,9 +2787,24 @@ static void mptcp_do_fastclose(struct so
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	mptcp_for_each_subflow_safe(msk, subflow, tmp)
-		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow),
-				  subflow, MPTCP_CF_FASTCLOSE);
+	/* Explicitly send the fastclose reset as need */
+	if (__mptcp_check_fallback(msk))
+		return;
+
+	mptcp_for_each_subflow_safe(msk, subflow, tmp) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(ssk);
+
+		/* Some subflow socket states don't allow/need a reset.*/
+		if ((1 << ssk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
+			goto unlock;
+
+		subflow->send_fastclose = 1;
+		tcp_send_active_reset(ssk, ssk->sk_allocation);
+unlock:
+		release_sock(ssk);
+	}
 }
 
 static void mptcp_worker(struct work_struct *work)


