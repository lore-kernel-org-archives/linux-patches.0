Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4E30C626;
	Mon, 13 Oct 2025 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368334; cv=none; b=gvmP/7b/c8utBQ/JOPB8ApK024lUeDT+3LwA0r9Bx9B9Hv07jjVNkzPJ7OhRW84K/IMsBFPCHYPR3m9LxHjw29r/r510l1DDAs8/LLuCp1zcdnzgrHjgofWVMLhEtB+YsPrkUwdX6XU9TQqFLgmcl8qis2joRLa4aGm63eXk/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368334; c=relaxed/simple;
	bh=ebop7vL4RDNGc9OaM3jNZeMfNDxQ47GdSQKgEXULDII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwpwk85J49V7cm7Cb83kv9WRxLeCKnm6DasZREakrprZxcAiSC5GhSRLQx3pTF/HFRlmhxJFA3eUmZsVh/OZvniWcgyU6xEl8/k7ygPToTIals0AtvfyDjIwzNCOgTnZujIJTwl8zyrOZjdxaOUog+qsJ9bASi9rl5gbHS+U3ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZTl3OPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZTl3OPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A0C4CEE7;
	Mon, 13 Oct 2025 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368334;
	bh=ebop7vL4RDNGc9OaM3jNZeMfNDxQ47GdSQKgEXULDII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZTl3OPqy9Au5po0GBAsr5iQFV1wV8HL23DMJyZGLmdDxhGECMqVFzRAKPID12hlk
	 0BfYV/u057dt76jd9fRebuzoUz21cY6MfNy2gOZbFCb/2y0b9fCAs+CN3Om2kWhx4E
	 u2C8YTAV7kGqSai/YmFVNItpkO2Gb0rWWVhCRB+s=
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
Subject: [PATCH 6.12 125/262] tcp: fix __tcp_close() to only send RST when required
Date: Mon, 13 Oct 2025 16:44:27 +0200
Message-ID: <20251013144330.626693106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 988992ff898b3..739931aabb4e3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3058,8 +3058,8 @@ bool tcp_check_oom(const struct sock *sk, int shift)
 
 void __tcp_close(struct sock *sk, long timeout)
 {
+	bool data_was_unread = false;
 	struct sk_buff *skb;
-	int data_was_unread = 0;
 	int state;
 
 	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
@@ -3078,11 +3078,12 @@ void __tcp_close(struct sock *sk, long timeout)
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



