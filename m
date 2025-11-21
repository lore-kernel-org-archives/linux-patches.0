Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835B350297;
	Fri, 21 Nov 2025 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732224; cv=none; b=qDualoJwnl6iGaeuThTNh4VgM6uQSedZwUtSi9pgn244IfXn9fyoBgSjtS/gA0bGC+A7SJ+N/Q3QYivhJY04ueULpRZJDvdaMHE2WT/bwHqs5C8CWt1rQaPf1KVefI+21lQdBGWTRCTe1rNKbIn5ewfqCwvXqfVHoCnNPzMO52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732224; c=relaxed/simple;
	bh=2Aa1kij/+NvxxkhJX9XwXFQx5mPSfzm4RtSJ0RDYr0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT0cTfXjzH9o3990JnaQ2fMP7oZq7QPLhrL6A3zFQUsX+WGAkN+njl1WYRHUpQ9L3H3NH4ryRURPApBcseYX0f0kKSdIVz9g++UlNdfigUC+76x1ydDkmDdBGMhr0MBlEsBXvxvoGNjqPmoOsnY/IoZYBpZoUH4to9wKGg4RIPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3e03g4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3e03g4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A24CC116C6;
	Fri, 21 Nov 2025 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732224;
	bh=2Aa1kij/+NvxxkhJX9XwXFQx5mPSfzm4RtSJ0RDYr0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3e03g4sEau/lS0r3sX0is22Iozu7RH4hKY/cVpbeAAreF+jveH5ygCGFbKfMQ1Hk
	 sBI2WPCvF5aj7vLKd3MnHPtO22JvWfV+09a26hrxEt395cHZqkNzz3bqX/hMkYFw8K
	 oZHUiXcjtC4Sj+W+hbvxCAdQXcG2HZrXQ7AoqIcc=
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
Subject: [PATCH 6.6 046/529] mptcp: fix MSG_PEEK stream corruption
Date: Fri, 21 Nov 2025 14:05:45 +0100
Message-ID: <20251121130232.642413050@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1940,19 +1940,35 @@ static void mptcp_rcv_space_adjust(struc
 
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
-				size_t len, int flags,
+				size_t len, int flags, int copied_total,
 				struct scm_timestamping_internal *tss,
 				int *cmsg_flags)
 {
 	struct sk_buff *skb, *tmp;
+	int total_data_len = 0;
 	int copied = 0;
 
 	skb_queue_walk_safe(&msk->receive_queue, skb, tmp) {
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
+
 		if (!(flags & MSG_TRUNC)) {
 			err = skb_copy_datagram_msg(skb, offset, msg, count);
 			if (unlikely(err < 0)) {
@@ -1969,22 +1985,19 @@ static int __mptcp_recvmsg_mskq(struct m
 
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
 			/* we will bulk release the skb memory later */
 			skb->destructor = NULL;
 			WRITE_ONCE(msk->rmem_released, msk->rmem_released + skb->truesize);
 			__skb_unlink(skb, &msk->receive_queue);
 			__kfree_skb(skb);
-			msk->bytes_consumed += count;
 		}
 
 		if (copied >= len)
@@ -2208,7 +2221,8 @@ static int mptcp_recvmsg(struct sock *sk
 	while (copied < len) {
 		int err, bytes_read;
 
-		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags, &tss, &cmsg_flags);
+		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags,
+						  copied, &tss, &cmsg_flags);
 		if (unlikely(bytes_read < 0)) {
 			if (!copied)
 				copied = bytes_read;


