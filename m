Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDED2F28F9;
	Mon, 22 Sep 2025 19:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570354; cv=none; b=NTbXaAoqkXyEQGpuZr6P88OVCMuYo0sK123fWMt1HkCtNKaT1fdtNZwWAOHO1i9BMUcAkt/t/hdzl59Ieae6n7YQLNZlIudgYaSnAck4JzsbBEWAGyfgMv90CXYCasAxsDvinAl8y2cpw8ZhSlxFm9h2VAi27dYXqO3EF2PBxJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570354; c=relaxed/simple;
	bh=C+AL0rUzkl8WGZFBx4yyhiM/WlVQyQe/C524mNeWe60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUM3nWSizw+R+Fp9APQyMHUtASulhGEsyrHM5pOjJ19TePn+qq4OmMARfI8an9K6AFz7Xo++Lz43/7jUwavlNZqBdy1X38lzetV64dsQS5SqFs/4MPi+I1da7/Fps950ejXEORwcr/Oz+9/xNhUm9vcpu+bzlOAxz6awzi3JFmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDPk+uxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDPk+uxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C3CC4CEF0;
	Mon, 22 Sep 2025 19:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570354;
	bh=C+AL0rUzkl8WGZFBx4yyhiM/WlVQyQe/C524mNeWe60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDPk+uxGXsdogBRbFROeIwq1YFoGD7jKuFsR+l+vBnJRrz93gyPL6I4zFLXMQXR8l
	 mDR9DgkUrc8TixvZpql5T2753BEPbSHogwLWELci6ESGU2GnIjVwzqjXYHcgzoaaFc
	 Rht1KHMyqhml7ql1UYYU7L2ME9V1hvCS/QbLzn58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 104/149] mptcp: propagate shutdown to subflows when possible
Date: Mon, 22 Sep 2025 21:30:04 +0200
Message-ID: <20250922192415.506681916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit f755be0b1ff429a2ecf709beeb1bcd7abc111c2b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -350,6 +350,20 @@ static void mptcp_close_wake_up(struct s
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
+
 /* called under the msk socket lock */
 static bool mptcp_pending_data_fin_ack(struct sock *sk)
 {
@@ -374,6 +388,7 @@ static void mptcp_check_data_fin_ack(str
 			break;
 		case TCP_CLOSING:
 		case TCP_LAST_ACK:
+			mptcp_shutdown_subflows(msk);
 			mptcp_set_state(sk, TCP_CLOSE);
 			break;
 		}
@@ -542,6 +557,7 @@ static bool mptcp_check_data_fin(struct
 			mptcp_set_state(sk, TCP_CLOSING);
 			break;
 		case TCP_FIN_WAIT2:
+			mptcp_shutdown_subflows(msk);
 			mptcp_set_state(sk, TCP_CLOSE);
 			break;
 		default:


