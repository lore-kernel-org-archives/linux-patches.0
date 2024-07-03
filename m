Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48CD1799F;
	Wed,  3 Jul 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005271; cv=none; b=uFxqyfidYkCYH7N6Z4JIp97oBhXHA4QYwsZMKxsc8fbTJBUHtpPnX0vTxrJ9A5pxCS2HNAgCUVd1OKE7k37FrN3KIbqvjbWTGpxuLG94iH+0GWC9aKKJ215J5M1UHXNHWmPsoqSjYfQQC5V2ICDvEe0qh/4H6goDG1Pd2XY70gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005271; c=relaxed/simple;
	bh=vmHl2C1Cl2RI3QcieTqn5CngWLhV41CJDu2+lZfFLuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEx8zM7CE8gLG+RlYikMvg8oSvY0+A/3+3pKewbxnUULrca8/abhDHRvJWyb18sWBZEr0K1I6qZ821shhV8vcNYfBffbrXsHwFUECjpjMpLYqc/69Zg02miWrnJO/JnJ488V4OSIV4PbzLsaMnVsSHFspRHOtBblzVFjFXmzu9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRk1bbtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRk1bbtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EB4C2BD10;
	Wed,  3 Jul 2024 11:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005271;
	bh=vmHl2C1Cl2RI3QcieTqn5CngWLhV41CJDu2+lZfFLuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRk1bbtndl+wW3i1zrAmyeJC7agnXR2/I9ziz/THUyKbKKY8PYsSgmNytwkFBCrXT
	 JbRKoIh091/r5vSiBnObouyabtlI85d6oanrCZ0S1pTGT2hmhGyW2J3BPWz8G6teD4
	 vJFRcrclsCdUeSS261JcPAR3/be52va5F5nAsTPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/356] af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().
Date: Wed,  3 Jul 2024 12:36:02 +0200
Message-ID: <20240703102914.089787997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/af_unix.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1331,7 +1331,6 @@ static int unix_stream_connect(struct so
 	struct sock *other = NULL;
 	struct sk_buff *skb = NULL;
 	unsigned int hash;
-	int st;
 	int err;
 	long timeo;
 
@@ -1413,9 +1412,7 @@ restart:
 
 	   Well, and we have to recheck the state after socket locked.
 	 */
-	st = sk->sk_state;
-
-	switch (st) {
+	switch (READ_ONCE(sk->sk_state)) {
 	case TCP_CLOSE:
 		/* This is ok... continue with connect */
 		break;
@@ -1430,7 +1427,7 @@ restart:
 
 	unix_state_lock_nested(sk, U_LOCK_SECOND);
 
-	if (sk->sk_state != st) {
+	if (sk->sk_state != TCP_CLOSE) {
 		unix_state_unlock(sk);
 		unix_state_unlock(other);
 		sock_put(other);


