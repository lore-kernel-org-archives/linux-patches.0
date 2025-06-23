Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2378C7482;
	Mon, 23 Jun 2025 21:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713434; cv=none; b=I7iyM5DJ7Kcd4wrkpKGCEQjsYc42xFATUzMnSnuI8XHxpVcWrpRaqKOsfIB1hTI8HeVWnl4aJdqFvxR/MD683C/Ok2MRAR5hA9FPNxn0ITtAXXG4CzXrzKO7OGrQJgleGVXRJzw9Vnw4tZfs7/w5JnFok5ST7FH9XW88fATmxWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713434; c=relaxed/simple;
	bh=75O6i1Ge4GR9dJM1rc/sQKGC4hxSMpclL+AOv2L4mz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJMvMV9ibLdAaFr/3k7r/7DH9tgHklgMVYxPV1MR5nNXHBL4aQtLGECDcNdLqVCryLKnIhL2KfBu5R1LYNDdArMsoOY+lJ2+X+QCu8IDyomdOCu8raZKjXoW/MD5AhfklZTXkv1rffvjOv371RtrvpvQm4P9qgAUVn/j/uYI0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olFj91ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olFj91ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04A6C4CEEA;
	Mon, 23 Jun 2025 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713434;
	bh=75O6i1Ge4GR9dJM1rc/sQKGC4hxSMpclL+AOv2L4mz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olFj91tyJNMvpBeCLVwb14ezYtrfMn5vhMBia6GKouorNkAxFUUl5ic9Aj5LxQNgC
	 uVm0lFnaNQUGvOOzV5UvE+JoBIkzFDe/A1AU8EQmkEytDiqL2LOrBLEb3iyitTvX4e
	 6xRVmtwI5H45zbmlUBvrtcggelGMYlBMBMmyC2ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 347/592] tcp: add receive queue awareness in tcp_rcv_space_adjust()
Date: Mon, 23 Jun 2025 15:05:05 +0200
Message-ID: <20250623130708.701975706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ea33537d82921e71f852ea2ed985acc562125efe ]

If the application can not drain fast enough a TCP socket queue,
tcp_rcv_space_adjust() can overestimate tp->rcvq_space.space.

Then sk->sk_rcvbuf can grow and hit tcp_rmem[2] for no good reason.

Fix this by taking into acount the number of available bytes.

Keeping sk->sk_rcvbuf at the right size allows better cache efficiency.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h  | 2 +-
 net/ipv4/tcp_input.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1669d95bb0f9a..5c7c5038d47b5 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -340,7 +340,7 @@ struct tcp_sock {
 	} rcv_rtt_est;
 /* Receiver queue space */
 	struct {
-		u32	space;
+		int	space;
 		u32	seq;
 		u64	time;
 	} rcvq_space;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ed5f0ffab60dc..49adcbd73074d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -748,8 +748,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 void tcp_rcv_space_adjust(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	u32 copied;
-	int time;
+	int time, inq, copied;
 
 	trace_tcp_rcv_space_adjust(sk);
 
@@ -760,6 +759,9 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 	/* Number of bytes copied to user in last RTT */
 	copied = tp->copied_seq - tp->rcvq_space.seq;
+	/* Number of bytes in receive queue. */
+	inq = tp->rcv_nxt - tp->copied_seq;
+	copied -= inq;
 	if (copied <= tp->rcvq_space.space)
 		goto new_measure;
 
-- 
2.39.5



