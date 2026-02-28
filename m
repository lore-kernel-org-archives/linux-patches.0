Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA336C9EB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302379; cv=none; b=npXcqc4bpDJKVnwGn7++uSjwgtYBNI0sXW91L6JWoADLfwpSUBfZ79oJ+ttuA3xnb3qQhkgGq+vGH+Zx2vlaoEd0esnit31Rr99aXJ0kmdypKpiXW5fDhdgdPKKiHVwY+pJEpMgVCwEx40jRhFww3udOPBAkAcrx7ulpCl1+mBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302379; c=relaxed/simple;
	bh=ArYVW5f5A1eSZnUynj3MwZn4TW0rYLBKO2FCgW26DUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywy/clwurIlhMxPcVwdD1AobvV2BX3pZ6SFVefe6d5irh42+1Aa90spJKSuiyCF/uduLwThvRHE7zVXlWQEhR2hXuvsJnPJkBllqqjAEe034i59dL26G4uj5eQmksHaQPMI+ykC6ixH+THUqVFXjNSXdDuWIHDx3hpRDbJsv5vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLSzT4W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLSzT4W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64ACC19423;
	Sat, 28 Feb 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302379;
	bh=ArYVW5f5A1eSZnUynj3MwZn4TW0rYLBKO2FCgW26DUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLSzT4W3scLwlbDd3S57c6lVj72k98DeSTVASIn86R0bSS8gKSRhsUpQ+gDiUcOTp
	 4VQJ+2LYnvw7goEPEASTqgRWP3ELMFy6mG/MoWRB4l2M1p+jZaKqHcIZ8PT18dRz2P
	 O67qyTTWyaBi4MDUcDLBzlt1xSWfrJct8evK9t/DxQcXDWZTPQA60Y7rALinQwSt1s
	 4EgOfpdPvUo0KJoGbseAoLlf/lEruphi8MZ4l1AbAFyEkJGi6EEKWAEDCxcOb7fIXI
	 xv0I5yDTNs4TojCtDdW2FzxTjbbT+IhrLobJsOZOSgx9P5LhUAHMRfCh+MqnqI1OiZ
	 mFwIVvVvYi9jQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/232] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Sat, 28 Feb 2026 13:09:20 -0500
Message-ID: <20260228181127.1592657-107-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 838eb9687691d29915797a885b861fd09353386e ]

tcp_tx_timestamp() is only called at the end of tcp_sendmsg_locked()
before the final tcp_push().

By the time it is called, it is possible all the copied data
has been sent already (transmit queue is empty).

If this is the case, use the last skb in the rtx queue.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260127123828.4098577-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c195f85149519..6bef8514e29ad 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -467,6 +467,9 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 
+	if (unlikely(!skb))
+		skb = skb_rb_last(&sk->tcp_rtx_queue);
+
 	if (tsflags && skb) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 		struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.51.0

