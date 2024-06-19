Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED414373E;
	Wed, 19 Jun 2024 13:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803687; cv=none; b=L+JYGxUvSlbJNp8Eaua2rxeBtYDFhLjPccBRKHg7hvspMxI2+o4QDMr4GlpB4RX4OpmEBT9igZd4O9+p/dNeHQj4BniQTgeqjyTcr4yEFbF0e1/+DlrhoG2mr0jB8aoCoeBuDUgbC1DIBslKRswdrgV+nt/BqR2fEiG9VrSG5O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803687; c=relaxed/simple;
	bh=dKFvKeF0NpWh3GVB9SKfYGzDM9ZVOwM9T76QfbOEFu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTxx98n+8oXAQhdqnAs7+XvX/uAL8zWBSmCxGL/NvmjiuiE6c4RIf0nB6Alh8IwHSUSTiXNg0f5VF0+HSdwXXMQr9/7lf3Gas+xf4lxm4ehUmr4dbRuRiA+Ne4cICVRZ35u+adUfsLpq2a8uNSLp1Z/u1HhcE6T4ZWG9cVjAC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssjCTYLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssjCTYLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D80C2BBFC;
	Wed, 19 Jun 2024 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803686;
	bh=dKFvKeF0NpWh3GVB9SKfYGzDM9ZVOwM9T76QfbOEFu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssjCTYLZX8QfFPW6Ap4cxL2s/L83ZgLaVNmqYBEvLG7byMPf6wSpAo+TSjvGPaVwr
	 qAG4uMxFHLEbKrTeybLiad4sK766mvpvF8mI9IBiYVJAVSssbYXUmP94ACmESOb3bB
	 pmuj5H1OAy9GYNbBJoktCOieyzcjYQjHRc6GnUn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/217] af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().
Date: Wed, 19 Jun 2024 14:54:42 +0200
Message-ID: <20240619125558.165676434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit a9bf9c7dc6a5899c01cb8f6e773a66315a5cd4b7 ]

As small optimisation, unix_stream_connect() prefetches the client's
sk->sk_state without unix_state_lock() and checks if it's TCP_CLOSE.

Later, sk->sk_state is checked again under unix_state_lock().

Let's use READ_ONCE() for the first check and TCP_CLOSE directly for
the second check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67a2a0e842e4f..6e03b364bb727 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1469,7 +1469,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct sk_buff *skb = NULL;
 	long timeo;
 	int err;
-	int st;
 
 	err = unix_validate_addr(sunaddr, addr_len);
 	if (err)
@@ -1553,9 +1552,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	   Well, and we have to recheck the state after socket locked.
 	 */
-	st = sk->sk_state;
-
-	switch (st) {
+	switch (READ_ONCE(sk->sk_state)) {
 	case TCP_CLOSE:
 		/* This is ok... continue with connect */
 		break;
@@ -1570,7 +1567,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	unix_state_lock_nested(sk, U_LOCK_SECOND);
 
-	if (sk->sk_state != st) {
+	if (sk->sk_state != TCP_CLOSE) {
 		unix_state_unlock(sk);
 		unix_state_unlock(other);
 		sock_put(other);
-- 
2.43.0



