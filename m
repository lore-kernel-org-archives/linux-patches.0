Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F631799F;
	Wed,  3 Jul 2024 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005274; cv=none; b=oU0F7d/h9OvfBIT65gZzIqRK1694J3GuiTlXL/4iEeqyuVoJbg1Gfpq8NOa+XPhrei6YHOlOEJBjom4eOskYAGI1tlEXycDjHxtQh/z7yZdGJIHAQA48pFLHENFgINdDtJFdiprcLB/qvq8fP5j+Z7Yj9VienOrTYpY8vuhphgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005274; c=relaxed/simple;
	bh=Vj38b4YQ/Xhj9fxCkwjq/+CQqEUSq6F/cqRqm6rhuag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiUGcm5azoXIqapSlk+qeC4AVaOFTtPo00MOEn0+vbgKKr0dBPPMIANFnwSTlexrW2wc+/pPOuQinmDiluzMJOH0+J/QDiWzMsV8iIPPChZo1gYPhRqHTs67CoHs9eBZEi8fpP6qFiVjtf2HgNTQfeyvvjOtQPtv4N0dSLqm2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdhmdFaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdhmdFaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DBCC2BD10;
	Wed,  3 Jul 2024 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005274;
	bh=Vj38b4YQ/Xhj9fxCkwjq/+CQqEUSq6F/cqRqm6rhuag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdhmdFazZ4mBakKgLj0Lusvx2PHIAgg8ZREXjq0gWIE5QSqzMmFiKgHoyVgBp039g
	 c1sqnqhfvChgwvmh2W/044qmsY1ds/eDyrZw1XVVKrWHnrd+hgNPsShKNWS7hnbTpI
	 RBXgYeMwZ1CEpFVIwCjocVNylSHwDTBQhOjl069w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/356] af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().
Date: Wed,  3 Jul 2024 12:36:03 +0200
Message-ID: <20240703102914.127113780@linuxfoundation.org>
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

[ Upstream commit 8a34d4e8d9742a24f74998f45a6a98edd923319b ]

The following functions read sk->sk_state locklessly and proceed only if
the state is TCP_ESTABLISHED.

  * unix_stream_sendmsg
  * unix_stream_read_generic
  * unix_seqpacket_sendmsg
  * unix_seqpacket_recvmsg

Let's use READ_ONCE() there.

Fixes: a05d2ad1c1f3 ("af_unix: Only allow recv on connected seqpacket sockets.")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2051,7 +2051,7 @@ static int unix_stream_sendmsg(struct so
 	}
 
 	if (msg->msg_namelen) {
-		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
+		err = READ_ONCE(sk->sk_state) == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
 		err = -ENOTCONN;
@@ -2263,7 +2263,7 @@ static int unix_seqpacket_sendmsg(struct
 	if (err)
 		return err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (msg->msg_namelen)
@@ -2277,7 +2277,7 @@ static int unix_seqpacket_recvmsg(struct
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	return unix_dgram_recvmsg(sock, msg, size, flags);
@@ -2624,7 +2624,7 @@ static int unix_stream_read_generic(stru
 	size_t size = state->size;
 	unsigned int last_len;
 
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
 		goto out;
 	}


