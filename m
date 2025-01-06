Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71563146D6B;
	Mon,  6 Jan 2025 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176945; cv=none; b=IRuVzy8Kf84hKD9w+eZTEYc22epazbpRMYdZoPdZp+P0Ljvt67JJdFnvu4Vh+sfVmHlelJdzH3K+vvSgPCHQjYXSeEFt8EE8iSSn8rQKNHmzbL8028GuzjfEh6dDhgvLIQQOHC0zHKvLrRLPDyX5Uhb86CfR00+ILoFH3WE9Duc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176945; c=relaxed/simple;
	bh=If8srUaQw4qDGJ3/OiQ59Hc01gAyBsWcxpIHK99Ir5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0FPtQiIlpArq1FXDskhE+B5y5oZ2YQAOzLfoER28HkLKq4o9C5SNZojO7/MWOmcG1nH0fseezOhWDgEdQJfHcUsMnnqtUMrrp2XSB3Q2xbTjmVaSIOGU4LV1XDnDEdh3Zu56xHnEr8PPkh/G1EWxfOz1XOLQcLS0do4GN3ao5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnprFfdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnprFfdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAC4C4CED2;
	Mon,  6 Jan 2025 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176945;
	bh=If8srUaQw4qDGJ3/OiQ59Hc01gAyBsWcxpIHK99Ir5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnprFfdyVpbd/Ecj7T+l8XTlYhR1ij8/R6X35Lmas2H6G3xOur/jNm3m09ZIuGUu9
	 S+/z6kwiNUdqUd7pToVAqqAgqVjKWyTOjuFWwgyvkGXUv+Mr/skzcQBk2on3+OSpBO
	 eCURHAJjAM0l/HymCisv+vtZu165zX3pC63DNVXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 81/81] mptcp: dont always assume copied data in mptcp_cleanup_rbuf()
Date: Mon,  6 Jan 2025 16:16:53 +0100
Message-ID: <20250106151132.485412831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 551844f26da2a9f76c0a698baaffa631d1178645 upstream.

Under some corner cases the MPTCP protocol can end-up invoking
mptcp_cleanup_rbuf() when no data has been copied, but such helper
assumes the opposite condition.

Explicitly drop such assumption and performs the costly call only
when strictly needed - before releasing the msk socket lock.

Fixes: fd8976790a6c ("mptcp: be careful on MPTCP-level ack.")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241230-net-mptcp-rbuf-fixes-v1-2-8608af434ceb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -538,13 +538,13 @@ static void mptcp_send_ack(struct mptcp_
 		mptcp_subflow_send_ack(mptcp_subflow_tcp_sock(subflow));
 }
 
-static void mptcp_subflow_cleanup_rbuf(struct sock *ssk)
+static void mptcp_subflow_cleanup_rbuf(struct sock *ssk, int copied)
 {
 	bool slow;
 
 	slow = lock_sock_fast(ssk);
 	if (tcp_can_send_ack(ssk))
-		tcp_cleanup_rbuf(ssk, 1);
+		tcp_cleanup_rbuf(ssk, copied);
 	unlock_sock_fast(ssk, slow);
 }
 
@@ -561,7 +561,7 @@ static bool mptcp_subflow_could_cleanup(
 			      (ICSK_ACK_PUSHED2 | ICSK_ACK_PUSHED)));
 }
 
-static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
+static void mptcp_cleanup_rbuf(struct mptcp_sock *msk, int copied)
 {
 	int old_space = READ_ONCE(msk->old_wspace);
 	struct mptcp_subflow_context *subflow;
@@ -569,14 +569,14 @@ static void mptcp_cleanup_rbuf(struct mp
 	int space =  __mptcp_space(sk);
 	bool cleanup, rx_empty;
 
-	cleanup = (space > 0) && (space >= (old_space << 1));
-	rx_empty = !__mptcp_rmem(sk);
+	cleanup = (space > 0) && (space >= (old_space << 1)) && copied;
+	rx_empty = !__mptcp_rmem(sk) && copied;
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 		if (cleanup || mptcp_subflow_could_cleanup(ssk, rx_empty))
-			mptcp_subflow_cleanup_rbuf(ssk);
+			mptcp_subflow_cleanup_rbuf(ssk, copied);
 	}
 }
 
@@ -2195,9 +2195,6 @@ static int mptcp_recvmsg(struct sock *sk
 
 		copied += bytes_read;
 
-		/* be sure to advertise window change */
-		mptcp_cleanup_rbuf(msk);
-
 		if (skb_queue_empty(&msk->receive_queue) && __mptcp_move_skbs(msk))
 			continue;
 
@@ -2249,6 +2246,7 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 
 		pr_debug("block timeout %ld\n", timeo);
+		mptcp_cleanup_rbuf(msk, copied);
 		err = sk_wait_data(sk, &timeo, NULL);
 		if (err < 0) {
 			err = copied ? : err;
@@ -2256,6 +2254,8 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 	}
 
+	mptcp_cleanup_rbuf(msk, copied);
+
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)


