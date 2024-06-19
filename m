Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BECB12FB31;
	Wed, 19 Jun 2024 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802116; cv=none; b=G6346QKy7Nbv4CPM6XmNtk7TWFZ0HJ9zTTfpV1yPsVAkatQzvqzyVfeE4Ev8HX24CV3LR7vjhWjjTVUAvkTtKL/KvshjqQTux18AIY6e2TcRl1tuh8qCpE8+2HU5Ds7+XujL06ZwrZk6mdXgV0e6nA7oRT7GdxRzNQG+7gkNvPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802116; c=relaxed/simple;
	bh=anQPLxKB/k1o2BSyizCGWW3NQYXzvMuXnx3KS/jKrG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhhGjNKMtsPbppmDE4/l1CYcDITk9nBsphctXX5FSpV8BkGvdObX4V3pJOzWE3+1dm9jbqeuzF3OxrxES/snSxAplPqugMSlCcl4E0NobSztHrnlsbsTxXIyg6AcqSmJw/VIr0r28lajy95+SOuK1qr4G6KCLQRiaT29v1Udazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/wGfH2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/wGfH2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E472EC2BBFC;
	Wed, 19 Jun 2024 13:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802116;
	bh=anQPLxKB/k1o2BSyizCGWW3NQYXzvMuXnx3KS/jKrG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/wGfH2zZhqTO1dRLKq9w/T6tpcnbVx0Aownv6vqdJw8YZcKM+9UjgDWH2srREWkP
	 RaPZ9pYIk//iYkC14Ta/izeqWNU2EPLSXuW4snEcI00hm2Vv7AGwMNlJBuoh2/qcQQ
	 QaBFOIPyD49fqDmASpsSbEm+QpzMZzQSK+VLOo3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/267] af_unix: Annotate data-races around sk->sk_sndbuf.
Date: Wed, 19 Jun 2024 14:53:27 +0200
Message-ID: <20240619125608.511972435@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b0632e53e0da8054e36bc973f0eec69d30f1b7c6 ]

sk_setsockopt() changes sk->sk_sndbuf under lock_sock(), but it's
not used in af_unix.c.

Let's use READ_ONCE() to read sk->sk_sndbuf in unix_writable(),
unix_dgram_sendmsg(), and unix_stream_sendmsg().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2299a464c602e..4640497c29da4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -534,7 +534,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 static int unix_writable(const struct sock *sk, unsigned char state)
 {
 	return state != TCP_LISTEN &&
-	       (refcount_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
+		(refcount_read(&sk->sk_wmem_alloc) << 2) <= READ_ONCE(sk->sk_sndbuf);
 }
 
 static void unix_write_space(struct sock *sk)
@@ -1944,7 +1944,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	err = -EMSGSIZE;
-	if (len > sk->sk_sndbuf - 32)
+	if (len > READ_ONCE(sk->sk_sndbuf) - 32)
 		goto out;
 
 	if (len > SKB_MAX_ALLOC) {
@@ -2223,7 +2223,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 						   &err, 0);
 		} else {
 			/* Keep two messages in the pipe so it schedules better */
-			size = min_t(int, size, (sk->sk_sndbuf >> 1) - 64);
+			size = min_t(int, size, (READ_ONCE(sk->sk_sndbuf) >> 1) - 64);
 
 			/* allow fallback to order-0 allocations */
 			size = min_t(int, size, SKB_MAX_HEAD(0) + UNIX_SKB_FRAGS_SZ);
-- 
2.43.0



