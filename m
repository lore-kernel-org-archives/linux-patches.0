Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBF483CD9;
	Tue, 14 May 2024 11:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687299; cv=none; b=RD9uxBmFil0lOrFStfjFlZlNDlEwDKO5qlKD2T38uO6of1jl1ql5a/Y2kbbEUXMcgQBZ/yd0mVsACwwbdBAANshMW2CGR/Yv0AyQJHVciy1oWpw2EirIHxk2nGVmMFVoEHZ3qWw3ge+zocuiFLB8WoY9X6CU4Y6MQYCqFuxkm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687299; c=relaxed/simple;
	bh=FhaD9m55F5MKEUDatC10O7fRu5QT+bKzJwRjDcZyxYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cr2W8TeTjHL5JYynJNNd+n0s1O3Kt0orySXNteT4kP+bMhVxFogwL//aSxlI3Ioxh0r6awLuSllZhN6pDmBFxiVSeUFTCfxybvMr2Di4COcUx+8iXzQD0b28QBz2s0iW1Pf1mEOFteBEYNmO3nbYf7zlfJZSrvz/+0nHyPiILwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCprg5rY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCprg5rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455F1C2BD10;
	Tue, 14 May 2024 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687299;
	bh=FhaD9m55F5MKEUDatC10O7fRu5QT+bKzJwRjDcZyxYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCprg5rYTLhFkshXF3uxI7nGTIsWNWyd6QTditvV+xWW2SoUKcdokulB7oHrU8MXc
	 8Uu0+0zQL+HqNLYePWc3vIVnqKrelg5T8ChVhCxvR46+oiL+hFICSxyHjLcFeTov36
	 VFTvbgIYuwlS6eQaL+tX/jjQus9Ma3UxxPTSYEe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/111] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:19:46 +0200
Message-ID: <20240514100958.959108029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit c2deb2e971f5d9aca941ef13ee05566979e337a4 ]

sk->sk_rcvbuf in __sock_queue_rcv_skb() and __sk_receive_skb() can be
changed by other threads. Mark this as benign using READ_ONCE().

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 016c0b9e01b70..b4ecd0071e220 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -440,7 +440,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -492,7 +492,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



