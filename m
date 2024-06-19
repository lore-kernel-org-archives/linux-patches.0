Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9645414389C;
	Wed, 19 Jun 2024 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802833; cv=none; b=VYm7WwX+cqSriPBHfn/WfR6Bz+CdEufdqpj9Y438VoEI2265dFWWgVZQEBywCdfqREh9wKX8eRWenFJkZNv1JJGaTCrDhxA+Ywd89yqptnnA/GiwM0am/TxgxIwn0hxeZTRBEPbBlo2hrsTlbG8MTg6UzeGg8TSsMUluci1p47A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802833; c=relaxed/simple;
	bh=LOIrDQfDBG+tyruSnMgDLlmI64W0Edlq9nVVLFy0tmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgi8AxzrrG/o4R3K87krvBnnigY2MDovB5IJ72xu3bbFcMtNiXfOx1qpVrXw4VxQzsIckaZ7JxwOMjOe2STLmWdxFnavCRgIHAKxHXtVhaR8ljGFHvDBICmUGBuRCTqzCWviPLEWECrvQTDLPWPy2R67bo220BS8UmAGlyPBYdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJ+cd/n7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJ+cd/n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A854C2BBFC;
	Wed, 19 Jun 2024 13:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802833;
	bh=LOIrDQfDBG+tyruSnMgDLlmI64W0Edlq9nVVLFy0tmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJ+cd/n7fYbiQJebldLkqrhN+xUSG27F3OU+M02yYDn0D9NZ+Sb0dBpBpSYex01i4
	 Ugf0jrhQJa9N34e92V7Qm153vWeEt4FT51Z+w74RSZEIFGFflmq4u3mGPlFthL/Qoz
	 4VpjnoCY6WlKp7WtadOApGiHYwhkRYbWr1NyJK3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/281] af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().
Date: Wed, 19 Jun 2024 14:53:41 +0200
Message-ID: <20240619125612.234049951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/af_unix.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f95aba56425fa..d92e664032121 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2273,7 +2273,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	if (msg->msg_namelen) {
-		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
+		err = READ_ONCE(sk->sk_state) == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
 		err = -ENOTCONN;
@@ -2387,7 +2387,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (msg->msg_namelen)
@@ -2401,7 +2401,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	return unix_dgram_recvmsg(sock, msg, size, flags);
@@ -2730,7 +2730,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	size_t size = state->size;
 	unsigned int last_len;
 
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
2.43.0



