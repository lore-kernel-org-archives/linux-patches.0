Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AD0156644;
	Wed, 15 Jan 2025 10:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938533; cv=none; b=HazOktPYPGevqEF9bjHMX9Kz93IOmoLKT7fhpW3Y9FtWe0N3ftCGv3loRQLA5lyk0YKGrGeSXqpej8RcfrNczjJNDpqldBEcmUR6LSCIl1K2OhgZhsz+ePqJsNWFLyREi07eXDRQSkSPZio2RWdDMWORFCJoOi+EvtgL7Fqhc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938533; c=relaxed/simple;
	bh=b3Otez9F8iJs5MKdNcUQMAlZyahyp11xU4lGnjVGGfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKEykVV0Jtw6mf4LX3dUP74CIfhSfHQLjYjF2tjeQNUYwxzm2xX/OEyB0Q0D9oAikHAfuWfSLbOtdj6m9aWFuSxYKJVMocXIPZ2UN9xSZ5Awqn1RglOsfYwQUj7dqkqipqlbNGUOFfHg+zuf40SMxH7RxitJbTGW4fuMiAEFh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0STQa4MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0STQa4MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB308C4CEDF;
	Wed, 15 Jan 2025 10:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938533;
	bh=b3Otez9F8iJs5MKdNcUQMAlZyahyp11xU4lGnjVGGfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0STQa4MCREg8x2jgCKDJ3qq2bwqe5JF0CDNBV5mv6iKvXn7ihQuFKy8wLI2ZCYLdP
	 fAhMuHauJIZauzJu8NqUzNLKcR+cISVe+FC37N5F6c0nAW6E6LVpujlpeLv+lCzdCS
	 vGvgnepIP1v44lGDTEaWUJOEDdS3qe9MttIjGvqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/129] tcp/dccp: complete lockless accesses to sk->sk_max_ack_backlog
Date: Wed, 15 Jan 2025 11:36:35 +0100
Message-ID: <20250115103555.175348782@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 9a79c65f00e2b036e17af3a3a607d7d732b7affb ]

Since commit 099ecf59f05b ("net: annotate lockless accesses to
sk->sk_max_ack_backlog") decided to handle the sk_max_ack_backlog
locklessly, there is one more function mostly called in TCP/DCCP
cases. So this patch completes it:)

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240331090521.71965-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3479c7549fb1 ("tcp/dccp: allow a connection when sk_max_ack_backlog is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index fee1e5650551..7b5e783ea24d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
+	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



