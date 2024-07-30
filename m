Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B688BE8;
	Tue, 30 Jul 2024 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355390; cv=none; b=rZvsNdEonePivO5s6gjVEZ6eIAYqWiXDNujip1raM5C6qQtjMwkGDLn+CJ1s24Yv3f5yaQvVG/4+Q/2wjMEe/YCZg/rEETwZhaJ2qEd1AX31yYLal16Rso/u8nLKkDkRsc7heBjQs+7cOtuEZKsByW3q+Zx/qoAmYxTfGHD9Wyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355390; c=relaxed/simple;
	bh=qPrqfdkTebOdfV7yrGD7mX5buRqVnkR2LNTFrv6Stt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKwNiZIFwdLyxkvwGM1+deTbsvlmZyvnYVUpBD2gGQcc+AxHAEjP4hKRrKbXwGMSef2/nw1JNGeMFNZNgCRVAuJe0sb+0kYyBxu9MZQC3ZdUkf5xEBEKEUxcvLCOm08TWo86uKBhDdZoSz/YwGZFznlZDo4N9UXha4jnWqHPTGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5AczRhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5AczRhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1170CC32782;
	Tue, 30 Jul 2024 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355390;
	bh=qPrqfdkTebOdfV7yrGD7mX5buRqVnkR2LNTFrv6Stt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5AczRhd3uBaq/gcCDpW7fh9Owr45whOHRXR7euuo+ZRWvsqkPUYJ/YWD1jFxrpGM
	 Ja9IOC0OcM/F1Rr95vHNbBXBhVElWK/3jwepdO8/Q4CsYibRDgewiyvI4BfPVZJlXN
	 JnKQq80wZWRCHdiYQSNwsvxvSt/XHzcG0kRrT8mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/440] tcp: fix race in tcp_write_err()
Date: Tue, 30 Jul 2024 17:45:22 +0200
Message-ID: <20240730151619.236031967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 853c3bd7b7917670224c9fe5245bd045cac411dd ]

I noticed flakes in a packetdrill test, expecting an epoll_wait()
to return EPOLLERR | EPOLLHUP on a failed connect() attempt,
after multiple SYN retransmits. It sometimes return EPOLLERR only.

The issue is that tcp_write_err():
 1) writes an error in sk->sk_err,
 2) calls sk_error_report(),
 3) then calls tcp_done().

tcp_done() is writing SHUTDOWN_MASK into sk->sk_shutdown,
among other things.

Problem is that the awaken user thread (from 2) sk_error_report())
might call tcp_poll() before tcp_done() has written sk->sk_shutdown.

tcp_poll() only sees a non zero sk->sk_err and returns EPOLLERR.

This patch fixes the issue by making sure to call sk_error_report()
after tcp_done().

tcp_write_err() also lacks an smp_wmb().

We can reuse tcp_done_with_error() to factor out the details,
as Neal suggested.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20240528125253.1966136-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 117fc7031bc10..3662b49ce71ae 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,11 +67,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 
 static void tcp_write_err(struct sock *sk)
 {
-	WRITE_ONCE(sk->sk_err, READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT);
-	sk_error_report(sk);
-
-	tcp_write_queue_purge(sk);
-	tcp_done(sk);
+	tcp_done_with_error(sk, READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT);
 	__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONTIMEOUT);
 }
 
-- 
2.43.0



