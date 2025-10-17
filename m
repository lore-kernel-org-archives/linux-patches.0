Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F6330B1E;
	Fri, 17 Oct 2025 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716069; cv=none; b=osX2wlkwq+0l3GOhuHNDsr8B2kwS11g2T0AJLqs1MhrJXDW63U5Mzkl/s0gQZfUSuk6FQ8NcalNKxQ338/yGYzzp5N9EPoyClCWVAELdGxZJIhevw8Rf9m1x7hFO7Bk5g3JoqIaYxSGf1xD/JQLpvBSVnR28k2Gy404vF8/FC0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716069; c=relaxed/simple;
	bh=YYCrFpBOyPkgRohNCK964Be7iJBFZFh1syVDvpp0mag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW+8GnYU+NRVQdyyCC48Z0iDmS64hj4yo46zGBU864SKCOzdJvREXcoIOJO6BHf2AZIr8XLOUFYWTU+DQOZ9MTx+Qv+AQcM5Hv8vfQ5yz/mzDHL3ooLPbhAGrFpTK/rFIiwK6gO30+h3VoqHbYiDaUQg5fkZ03NPoVAAtadNS/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRXfDxhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRXfDxhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF7C4CEFE;
	Fri, 17 Oct 2025 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716069;
	bh=YYCrFpBOyPkgRohNCK964Be7iJBFZFh1syVDvpp0mag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRXfDxhLhGwX3D9z8VsXmFPdbYFh7anrMuVPDa89uXwWz25X5ME+AsiNacZ7h9hyD
	 +5v2eopHflv2oR7LCyxxXwYak2h6s/iadM32kXaDt0TE/FQw3RFE6kH3YmdLl1PNzA
	 Jt0G5Vgsp9z1tzScyosiC4g+nojQ1NRSVYojDuFQ=
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
Subject: [PATCH 5.15 062/276] tcp: fix __tcp_close() to only send RST when required
Date: Fri, 17 Oct 2025 16:52:35 +0200
Message-ID: <20251017145144.753755014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
index 9508e2c90b840..b3d373372e841 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2747,8 +2747,8 @@ bool tcp_check_oom(struct sock *sk, int shift)
 
 void __tcp_close(struct sock *sk, long timeout)
 {
+	bool data_was_unread = false;
 	struct sk_buff *skb;
-	int data_was_unread = 0;
 	int state;
 
 	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
@@ -2767,11 +2767,12 @@ void __tcp_close(struct sock *sk, long timeout)
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



