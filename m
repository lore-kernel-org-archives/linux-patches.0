Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD301F8722;
	Mon, 23 Jun 2025 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715984; cv=none; b=ux0OBic0GMwYHsi6I4Y+pdyTuIVnWcWI7NdCjCYIoqf6wOHr5MoWHZCOGa+qaF+HbrYpurhVAV8FDg5+J3OPHsD4NF6v8I2K0oMZ9nckxe4I9mHg9zuaLHcbfSImyJKQT2qWSUVQszhRW9r4jIs6yZEDPNri0SvrzmcqQDKHURY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715984; c=relaxed/simple;
	bh=/8i2kUYxnbmnxSrjmb61/vVmkzxrYjaNPUsC53AcMWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG3WCxRenWJFp1Z0HX7tPYIqW2PA280M3KpDcYMWHusCb6Qu9+Pl121n9cAvxEMVZ9TjgL7XE2wMwntxYo++hfVkQth2q7ZhaxgedzxDQa9/bxToy6WiJXDWjVoUhxDgkysoQ+XwDJJaEiVEwbEfru8omiP+m1IifII/KekAQIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZRi3d01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZRi3d01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B35C4CEEA;
	Mon, 23 Jun 2025 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715983;
	bh=/8i2kUYxnbmnxSrjmb61/vVmkzxrYjaNPUsC53AcMWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZRi3d01Wn8XjnTio45CPNyCc0Jrt5Al8vtMOPJHC6hi9p4MzZpY37OsejCt1YNAk
	 PCzSCelShmNhRJqfsQrxG9Vm240qFO9H+SriunM3prZlI997exQc2qOpLrdO8Rgbf1
	 cm59N1AvC6IiYz0cf8A3JzMpvP0/RYYnT85fV4/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/414] tcp: add receive queue awareness in tcp_rcv_space_adjust()
Date: Mon, 23 Jun 2025 15:05:57 +0200
Message-ID: <20250623130647.522060415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6a5e08b937b31..5f56fa8780131 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -336,7 +336,7 @@ struct tcp_sock {
 	} rcv_rtt_est;
 /* Receiver queue space */
 	struct {
-		u32	space;
+		int	space;
 		u32	seq;
 		u64	time;
 	} rcvq_space;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7e772b6cb45b6..c59c1cc1a8fed 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -749,8 +749,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 void tcp_rcv_space_adjust(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	u32 copied;
-	int time;
+	int time, inq, copied;
 
 	trace_tcp_rcv_space_adjust(sk);
 
@@ -761,6 +760,9 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 	/* Number of bytes copied to user in last RTT */
 	copied = tp->copied_seq - tp->rcvq_space.seq;
+	/* Number of bytes in receive queue. */
+	inq = tp->rcv_nxt - tp->copied_seq;
+	copied -= inq;
 	if (copied <= tp->rcvq_space.space)
 		goto new_measure;
 
-- 
2.39.5



