Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FEB313520;
	Mon, 27 Oct 2025 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590503; cv=none; b=ozFiykg+mmxthMpKr06TgsPG6qApO7IQwrCmxyazEFPoJ5/sJ7ETinJK9qgcfAU1D+iCRN7c552yaLDdtEM8ss73ZD5cPIil4dAyrcJ9HSYcNyeMYGM7CNOZ3TFOSv9BE2G7NAw0G1FD0ADNwPb5qd7sNmiqHN1OBCQDQqL0/QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590503; c=relaxed/simple;
	bh=tmM4SBvXnBX9OwY5DKAgI0KWq81V4UfrR69REABzu0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtKHalA0md2t/j1if9U2Sbk96acqY++jo05M4zMbGZi61S8f/q9MWksYA+eaCNVflI9findvjDtNyydk22ypmTjXd95A8x6+3gmTv56Ji6S4g28zOqwwEWV2xT/km8LPC7dgciqWcD9Q94kFZg2LZsTdCKiV82GkgBBHDa9IVls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGQ6GX+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGQ6GX+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F79AC4CEF1;
	Mon, 27 Oct 2025 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590503;
	bh=tmM4SBvXnBX9OwY5DKAgI0KWq81V4UfrR69REABzu0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGQ6GX+P9sG/GgiVxZDP9y6XiRDz1LBYMRfbRMITRwsRmjNcrQvy0ptIvBR+6WAsq
	 LXFcz01Mxypi0C0e309Bz/Fsf1kvIwzrn8Oj3VutcwQKx5ePLfvLVFh8O2R6Q1l4dL
	 oc6XZ3cJ/VlJMSYadvlsF50f3BkhoBSDXt4H/mtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/224] tcp: fix __tcp_close() to only send RST when required
Date: Mon, 27 Oct 2025 19:33:06 +0100
Message-ID: <20251027183510.079800548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f9238530970f2993b23dd67fdaffc552a2d2e98 ]

If the receive queue contains payload that was already
received, __tcp_close() can send an unexpected RST.

Refine the code to take tp->copied_seq into account,
as we already do in tcp recvmsg().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20250903084720.1168904-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cc0efcb4a553c..a0a5590573b03 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2359,8 +2359,8 @@ bool tcp_check_oom(struct sock *sk, int shift)
 
 void __tcp_close(struct sock *sk, long timeout)
 {
+	bool data_was_unread = false;
 	struct sk_buff *skb;
-	int data_was_unread = 0;
 	int state;
 
 	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
@@ -2379,11 +2379,12 @@ void __tcp_close(struct sock *sk, long timeout)
 	 *  reader process may not have drained the data yet!
 	 */
 	while ((skb = __skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		u32 len = TCP_SKB_CB(skb)->end_seq - TCP_SKB_CB(skb)->seq;
+		u32 end_seq = TCP_SKB_CB(skb)->end_seq;
 
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
-			len--;
-		data_was_unread += len;
+			end_seq--;
+		if (after(end_seq, tcp_sk(sk)->copied_seq))
+			data_was_unread = true;
 		__kfree_skb(skb);
 	}
 
-- 
2.51.0



