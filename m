Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403ED30BF7B;
	Mon, 13 Oct 2025 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369634; cv=none; b=hqsWbdXfWLmOrHoyBDqri/f9TWZbfqx3RoWD0703OZqwpxN1jvqcxhVhGOL95c2hVVZ9JP6p86DIqLe1uKdwBU+6R5qS2umf0yXaqDkMoZ2JfEIGeomp0ESrQ8XQPwBEYIJ3daaKY8Hf8RNyJ/HU3TzvQXmX3Snf8vkpYE6ThFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369634; c=relaxed/simple;
	bh=hVBR0VREb+J7VB6x7IJiOrgrGnsFCnwOdmFcZQyF874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9pOV35fjuOiTcFD4Hv3lEuQT19CPl5juzxcaXzrGEScQDHhegXkRfXuwcglsut0nbPIF+fHbOlFTuAE6/uGkXrGKe+ibZg36Mo99rJQoqazYTGnVpd0oHJFSSPDjrYXOCWV6owMh0dmZeqoqTs8hGkMXLu9Ld2lU5hotD3DdOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1RsBTg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1RsBTg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8B2C4CEE7;
	Mon, 13 Oct 2025 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369634;
	bh=hVBR0VREb+J7VB6x7IJiOrgrGnsFCnwOdmFcZQyF874=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1RsBTg5H4JPqgW4KBQDF0yEDYimhzgnyPdOIOkCA965AhgSKGVWMksOT1leaVgPu
	 INIs6kyMa2Tj9RV1kLv1H8wYbRTVGhRDKULTC5NhYb5GzDFQL/RcPwDEdsjuV3Jcrc
	 r3cTuf9Lh0B2nE3Bo4Fju6XtWPEK67QzHSEMwZMI=
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
Subject: [PATCH 6.17 316/563] tcp: fix __tcp_close() to only send RST when required
Date: Mon, 13 Oct 2025 16:42:57 +0200
Message-ID: <20251013144422.713115255@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index ad76556800f2b..89040007c7b70 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3099,8 +3099,8 @@ bool tcp_check_oom(const struct sock *sk, int shift)
 
 void __tcp_close(struct sock *sk, long timeout)
 {
+	bool data_was_unread = false;
 	struct sk_buff *skb;
-	int data_was_unread = 0;
 	int state;
 
 	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
@@ -3119,11 +3119,12 @@ void __tcp_close(struct sock *sk, long timeout)
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



