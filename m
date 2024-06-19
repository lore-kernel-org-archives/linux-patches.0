Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F41A14C584;
	Wed, 19 Jun 2024 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802104; cv=none; b=HAuJrS4lvSKxD1rRaChVazBbG5JNolBtI+pCuZJEuvKAPBhzAF7GyHPY+WURPWr/CHaR04/QfcLyijU1aD2e48BQzUtylL2IUYuczZPPVwHw/G3pmwkKjvO6wcdb/uHPHaizPAPy485bZh1N2ZHsRhpbIAbTIbqLO+z0itr+who=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802104; c=relaxed/simple;
	bh=IDbr/WqVn8HdctqIFFnVbvQhp5UQ+5lOHABkT2+ymjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ/UHyxtu19OZjGv0qKF1580pW/5B1y2vuq7eBi5kuAK3g8cwBhOBxUKzT+WIBDSHuBo6k/69MPxBrZmaU4cTf8SdUrq+QszasETjQfY0YoVfEAuL3oY/sPipzrMGSGbDSBbxz5LTX7UHhDQKDaoYj3W/3tNILpPQNsNeds7cp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKIrTEFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKIrTEFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0576DC2BBFC;
	Wed, 19 Jun 2024 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802104;
	bh=IDbr/WqVn8HdctqIFFnVbvQhp5UQ+5lOHABkT2+ymjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKIrTEFLrLYFvWH9cyfyJCyikBUry4D1v7he/SZCVBiv4RCpTP28ZGrN43qdL6q1P
	 NXi0iMX288QM0ms8Oc04VzDQpc58QCeqn48aD9jaFtoxwFud0PB9wwBR658RsRxRI2
	 Rik5Beysm8PRYr26+aaAvH62nN9qRUvz5snM5jb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/267] af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().
Date: Wed, 19 Jun 2024 14:53:23 +0200
Message-ID: <20240619125608.359549776@linuxfoundation.org>
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
index 4a43091c95419..53d67d540a574 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1491,7 +1491,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct sk_buff *skb = NULL;
 	long timeo;
 	int err;
-	int st;
 
 	err = unix_validate_addr(sunaddr, addr_len);
 	if (err)
@@ -1577,9 +1576,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	   Well, and we have to recheck the state after socket locked.
 	 */
-	st = sk->sk_state;
-
-	switch (st) {
+	switch (READ_ONCE(sk->sk_state)) {
 	case TCP_CLOSE:
 		/* This is ok... continue with connect */
 		break;
@@ -1594,7 +1591,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	unix_state_lock_nested(sk, U_LOCK_SECOND);
 
-	if (sk->sk_state != st) {
+	if (sk->sk_state != TCP_CLOSE) {
 		unix_state_unlock(sk);
 		unix_state_unlock(other);
 		sock_put(other);
-- 
2.43.0



