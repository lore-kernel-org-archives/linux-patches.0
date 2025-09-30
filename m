Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579362FFDE6;
	Tue, 30 Sep 2025 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245210; cv=none; b=XULIx+T40Y9bMwjZvzDnKq9uP0O01rggnH7AKjtddnKoaZIcIumcNrqc26IpJxIVjFsQ3Hr0g6Uxco7g41D7t3xTkgGqMXy8js7LniZlfFPkhTUmhS9VNhi0gLcAi1IK8mA4hFYdnkMF8LDIBPNmzFu39BTURkeNR2wBQfcUbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245210; c=relaxed/simple;
	bh=6peGh7Hp6WdCqz9eVeH4l9t5DQrKwtvGg3UvS8rzSWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQPzRgGtFqVFC641a3jmJp9+MF0kU1fDQy5WFdNMizezVDvcXQ363vjuGl+R+8VU1SWzB/jRGGhGurCodSEU6DADXjf76C83yTFiXJDGASYQ35WD4RaPrVrcPluR+3CIKTsaUUot9m8/J0+WxxIjyUdWOiZlJG+eA/rxtX+5ulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPJCHPXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPJCHPXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD9C4CEF0;
	Tue, 30 Sep 2025 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245210;
	bh=6peGh7Hp6WdCqz9eVeH4l9t5DQrKwtvGg3UvS8rzSWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPJCHPXkPyAJaDXoxmkg/s8C6iamip8XViRVZg/laivhxk2nzxSaeLQP5Kbw8PlbO
	 CykDAsOjjGclkxPxSBj5KoXPTX36ER+mkmsv/olO5y2q925TndFBxk4az6yQzk8yQ7
	 oCJyzSIU0dJBbW/eLNhzIkozg5ra9THObfLT8/hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/151] mptcp: propagate shutdown to subflows when possible
Date: Tue, 30 Sep 2025 16:47:10 +0200
Message-ID: <20250930143831.581421085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
 net/mptcp/protocol.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -354,6 +354,19 @@ static void mptcp_close_wake_up(struct s
 		sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
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
 static bool mptcp_pending_data_fin_ack(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -377,6 +390,7 @@ static void mptcp_check_data_fin_ack(str
 			break;
 		case TCP_CLOSING:
 		case TCP_LAST_ACK:
+			mptcp_shutdown_subflows(msk);
 			inet_sk_state_store(sk, TCP_CLOSE);
 			break;
 		}
@@ -539,6 +553,7 @@ static bool mptcp_check_data_fin(struct
 			inet_sk_state_store(sk, TCP_CLOSING);
 			break;
 		case TCP_FIN_WAIT2:
+			mptcp_shutdown_subflows(msk);
 			inet_sk_state_store(sk, TCP_CLOSE);
 			break;
 		default:


