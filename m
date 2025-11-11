Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378964C97;
	Tue, 11 Nov 2025 00:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822456; cv=none; b=NQ4pwifnKmBy55o+R5trhASaMjt1/wPwrTI/1rXUhAEasCoo6bf4F3EfFZbVL8YlJNuqXdwp6lbyi21xKqvgepL33l0XczJOrnfw7TN+gVrK41NIsYZdk1kDtah2D51MmfamheJ9Cwq/BmUbKvk41PIgXwA1bsrlU4uj3Y3Blvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822456; c=relaxed/simple;
	bh=98EQEt4bQ3INBvq+i+HPZn0oSW/ctpWV1LgFaUqOzIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLV2OjFmwVxBz7djgWR5Z6OdA9plPeEuJHztTBAFLi4Y+P5/PQGLx+le8C8oBJ4WRe0zZvTpqW98v4uB+kIMP7+/oWLVY1l8zL74vXCHOUALIQQPm/csYHerOuLevWSvMJQWC6GQ2IPmIFeBDTHZPBZ6I2zCt+asi8HkbKxccNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYpSd164; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYpSd164"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E90C4CEF5;
	Tue, 11 Nov 2025 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822456;
	bh=98EQEt4bQ3INBvq+i+HPZn0oSW/ctpWV1LgFaUqOzIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYpSd164KKY6k2XP+RVKl7dSRen2eIwwwv0TDMSdjem2gf7s2WVatzE9PpKUSykX1
	 9LlKH4zryAMyyzNdmvu3wpGJZuAUOHGlrL+iKP8MlLkOJ8iVejSNAYWbgAk30nVi3d
	 0ISmvUvB37qoiS9PLQeCTR8SsQC/etMCUTNRC8jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/849] mptcp: fix MSG_PEEK stream corruption
Date: Tue, 11 Nov 2025 09:34:41 +0900
Message-ID: <20251111004539.077847171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8e04ce45a8db7a080220e86e249198fa676b83dc ]

If a MSG_PEEK | MSG_WAITALL read operation consumes all the bytes in the
receive queue and recvmsg() need to waits for more data - i.e. it's a
blocking one - upon arrival of the next packet the MPTCP protocol will
start again copying the oldest data present in the receive queue,
corrupting the data stream.

Address the issue explicitly tracking the peeked sequence number,
restarting from the last peeked byte.

Fixes: ca4fb892579f ("mptcp: add MSG_PEEK support")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-2-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1892,22 +1892,36 @@ do_error:
 
 static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
 
-static int __mptcp_recvmsg_mskq(struct sock *sk,
-				struct msghdr *msg,
-				size_t len, int flags,
+static int __mptcp_recvmsg_mskq(struct sock *sk, struct msghdr *msg,
+				size_t len, int flags, int copied_total,
 				struct scm_timestamping_internal *tss,
 				int *cmsg_flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct sk_buff *skb, *tmp;
+	int total_data_len = 0;
 	int copied = 0;
 
 	skb_queue_walk_safe(&sk->sk_receive_queue, skb, tmp) {
-		u32 offset = MPTCP_SKB_CB(skb)->offset;
+		u32 delta, offset = MPTCP_SKB_CB(skb)->offset;
 		u32 data_len = skb->len - offset;
-		u32 count = min_t(size_t, len - copied, data_len);
+		u32 count;
 		int err;
 
+		if (flags & MSG_PEEK) {
+			/* skip already peeked skbs */
+			if (total_data_len + data_len <= copied_total) {
+				total_data_len += data_len;
+				continue;
+			}
+
+			/* skip the already peeked data in the current skb */
+			delta = copied_total - total_data_len;
+			offset += delta;
+			data_len -= delta;
+		}
+
+		count = min_t(size_t, len - copied, data_len);
 		if (!(flags & MSG_TRUNC)) {
 			err = skb_copy_datagram_msg(skb, offset, msg, count);
 			if (unlikely(err < 0)) {
@@ -1924,16 +1938,14 @@ static int __mptcp_recvmsg_mskq(struct s
 
 		copied += count;
 
-		if (count < data_len) {
-			if (!(flags & MSG_PEEK)) {
+		if (!(flags & MSG_PEEK)) {
+			msk->bytes_consumed += count;
+			if (count < data_len) {
 				MPTCP_SKB_CB(skb)->offset += count;
 				MPTCP_SKB_CB(skb)->map_seq += count;
-				msk->bytes_consumed += count;
+				break;
 			}
-			break;
-		}
 
-		if (!(flags & MSG_PEEK)) {
 			/* avoid the indirect call, we know the destructor is sock_rfree */
 			skb->destructor = NULL;
 			skb->sk = NULL;
@@ -1941,7 +1953,6 @@ static int __mptcp_recvmsg_mskq(struct s
 			sk_mem_uncharge(sk, skb->truesize);
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			skb_attempt_defer_free(skb);
-			msk->bytes_consumed += count;
 		}
 
 		if (copied >= len)
@@ -2164,7 +2175,8 @@ static int mptcp_recvmsg(struct sock *sk
 	while (copied < len) {
 		int err, bytes_read;
 
-		bytes_read = __mptcp_recvmsg_mskq(sk, msg, len - copied, flags, &tss, &cmsg_flags);
+		bytes_read = __mptcp_recvmsg_mskq(sk, msg, len - copied, flags,
+						  copied, &tss, &cmsg_flags);
 		if (unlikely(bytes_read < 0)) {
 			if (!copied)
 				copied = bytes_read;


