Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5A7307AF8;
	Tue, 30 Sep 2025 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244422; cv=none; b=u7fmuCqSVl+BZP/chLz7ZHU4FN4Cwus3PpuIcL57umkzbD5oLX+7yiiFFkKZenz/CSj/MpJHRjEUn7jqKZ/w3dlPrjsfUahzk1CCOgw3lmsiqYCr0efbYQUkZ8CS8w5Gpbz7g6vD6CZhM0PfUFKCRumKQmL4i7fVLyQQeWzXoLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244422; c=relaxed/simple;
	bh=chPcqzFc1v6DnACeemljVWWDTeSeJ79MfH3+vIfzFyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLuyy2civhz2FhEriB22dRj9eKNKQZHj2vwHo5ldvfGmDhZ9vH2IOvCALopu5OMGRfzqSO7t/XCIfVQkucCSzSxktckvNh5ZAu9jzuGmB1hB8QuSJ5o4HL2h9QdKhP2DFgDU28/juRzIX+jRoo+N2tJyrQHtN+yFspZVYxkJ9FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07Ws7IgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07Ws7IgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F3C4CEF0;
	Tue, 30 Sep 2025 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244422;
	bh=chPcqzFc1v6DnACeemljVWWDTeSeJ79MfH3+vIfzFyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07Ws7IgFNiFZVWjXBMwOPWgWA+Hz3E+2qf4xklK3kYpZsaOgrwDMd/bXGgTOwBGxb
	 RtAu5kbu0VbzRJOFZXsbVYWBQY1W1KU2pXOupae1sWynQSTHZAsku7OTHP7kawordd
	 G6PGsVWflMNE9TSAKsBav5TK88Izaj64MqBzzmGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/122] mptcp: propagate shutdown to subflows when possible
Date: Tue, 30 Sep 2025 16:46:54 +0200
Message-ID: <20250930143826.399402633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit f755be0b1ff429a2ecf709beeb1bcd7abc111c2b ]

When the MPTCP DATA FIN have been ACKed, there is no more MPTCP related
metadata to exchange, and all subflows can be safely shutdown.

Before this patch, the subflows were actually terminated at 'close()'
time. That's certainly fine most of the time, but not when the userspace
'shutdown()' a connection, without close()ing it. When doing so, the
subflows were staying in LAST_ACK state on one side -- and consequently
in FIN_WAIT2 on the other side -- until the 'close()' of the MPTCP
socket.

Now, when the DATA FIN have been ACKed, all subflows are shutdown. A
consequence of this is that the TCP 'FIN' flag can be set earlier now,
but the end result is the same. This affects the packetdrill tests
looking at the end of the MPTCP connections, but for a good reason.

Note that tcp_shutdown() will check the subflow state, so no need to do
that again before calling it.

Fixes: 3721b9b64676 ("mptcp: Track received DATA_FIN sequence number and add related helpers")
Cc: stable@vger.kernel.org
Fixes: 16a9a9da1723 ("mptcp: Add helper to process acks of DATA_FIN")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-fix-sft-connect-v1-1-d40e77cbbf02@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -326,6 +326,20 @@ static void mptcp_stop_timer(struct sock
 	mptcp_sk(sk)->timer_ival = 0;
 }
 
+static void mptcp_shutdown_subflows(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
+
+		slow = lock_sock_fast(ssk);
+		tcp_shutdown(ssk, SEND_SHUTDOWN);
+		unlock_sock_fast(ssk, slow);
+	}
+}
+
 static void mptcp_check_data_fin_ack(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -348,6 +362,7 @@ static void mptcp_check_data_fin_ack(str
 			break;
 		case TCP_CLOSING:
 		case TCP_LAST_ACK:
+			mptcp_shutdown_subflows(msk);
 			inet_sk_state_store(sk, TCP_CLOSE);
 			sk->sk_state_change(sk);
 			break;
@@ -430,6 +445,7 @@ static void mptcp_check_data_fin(struct
 			inet_sk_state_store(sk, TCP_CLOSING);
 			break;
 		case TCP_FIN_WAIT2:
+			mptcp_shutdown_subflows(msk);
 			inet_sk_state_store(sk, TCP_CLOSE);
 			// @@ Close subflows now?
 			break;


