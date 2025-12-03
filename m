Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1AE273D73;
	Wed,  3 Dec 2025 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781243; cv=none; b=GtRj50c09cijwrUNhCHZuyBtwlJONcJE6RAV8jRSQczCvQIwXYGT2lDPDP/0tqFiyh/lXDmUFJ36ZrWxzigeWoo0v6lYMitaIEKyripxuqoCQ9Co0txDY8C/c9etcF/yT5vGpRwOKY1xDLtk6rsTT+IqCBmytNgFPqKDF47zYvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781243; c=relaxed/simple;
	bh=BETUEVG7wOkotDNyX6ZHpgwsw1ZQGpFFgAOdB5Y1S2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFsbPFNd14zjCs8U/uTmqB9vF8i/3ztvZaa8QtSxfxcqSruRSWOscl/1PyV+DgRUOVECZ9bjdD0PMiVtyXyJEaUp/1guCucb+gzkMB3VJ8udk13SB+tD+frCah8tBEmg0iHa8QUhwJXaALdVnfMJw4Td6L/neCOzQsQkX5Bj5SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbA8ws/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbA8ws/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222D8C4CEF5;
	Wed,  3 Dec 2025 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781243;
	bh=BETUEVG7wOkotDNyX6ZHpgwsw1ZQGpFFgAOdB5Y1S2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbA8ws/sblvsZa/bPD1qBEYFXMJLEBvjyQ0/DGgLg/hsjOuozsBbYNw+iZ/+KeXSN
	 A07DA/tmoH97E9qZ2Qy4QBb/C01Atnor9MtZubQx2+xFZyTabsupbEi+ogWglSxR/d
	 +kB0S143y+HvKLKAxWstHOznIHmRJIBbov/0UCwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 89/93] mptcp: fix duplicate reset on fastclose
Date: Wed,  3 Dec 2025 16:30:22 +0100
Message-ID: <20251203152339.848426958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ No conflicts, but tcp_send_active_reset() doesn't take a 3rd argument
  (sk_rst_reason) in this version, see commit 5691276b39da ("rstreason:
  prepare for active reset"). This argument is only helpful for tracing,
  it is fine to drop it. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2431,7 +2431,6 @@ bool __mptcp_retransmit_pending_data(str
 
 /* flags for __mptcp_close_ssk() */
 #define MPTCP_CF_PUSH		BIT(1)
-#define MPTCP_CF_FASTCLOSE	BIT(2)
 
 /* be sure to send a reset only if the caller asked for it, also
  * clean completely the subflow status when the subflow reaches
@@ -2442,7 +2441,7 @@ static void __mptcp_subflow_disconnect(s
 				       unsigned int flags)
 {
 	if (((1 << ssk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
-	    (flags & MPTCP_CF_FASTCLOSE)) {
+	    subflow->send_fastclose) {
 		/* The MPTCP code never wait on the subflow sockets, TCP-level
 		 * disconnect should never fail
 		 */
@@ -2489,14 +2488,8 @@ static void __mptcp_close_ssk(struct soc
 
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
@@ -2809,9 +2802,25 @@ static void mptcp_do_fastclose(struct so
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	mptcp_set_state(sk, TCP_CLOSE);
-	mptcp_for_each_subflow_safe(msk, subflow, tmp)
-		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow),
-				  subflow, MPTCP_CF_FASTCLOSE);
+
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


