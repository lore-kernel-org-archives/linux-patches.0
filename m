Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741D913BC0B;
	Wed,  3 Jul 2024 11:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004474; cv=none; b=t8KnO0qVYLFRjgDRvJzbtY0dkK+o6waMepxLjhw/skD2uF7KTN8QsmSAjsv5TMsoJ5gaeOFexNd7tzrDUlKpFlBQSPbxAZV5wU9VULohW6ynKQ1t06Knp9w7X0GMVtEfxGdlw+8YA6ssqTPJZOZ69vEpiPIVUw5BJUQ1YzxE0pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004474; c=relaxed/simple;
	bh=Gky4cAErB8Q8OqWvhzoyITOpcyp7NsWNxN8HcWglb+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeVg1ejTE37APrzntYuRqVnNJZFmPjuI1iUmLSVDPYs71jRY9FbHWyy6h9KECsDMUNUGgJAxYTYa1ySsHpM52EiMtr56Sxp0oxBk1XH/zyb3vZ8YfB9JzWIXnkQtcoi9L59b43mc9G0Qy2//54rdnBhKNgGrCSI8UbNXSAB/0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqyrLWuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqyrLWuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD4C2BD10;
	Wed,  3 Jul 2024 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004474;
	bh=Gky4cAErB8Q8OqWvhzoyITOpcyp7NsWNxN8HcWglb+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqyrLWukMDizoKkT+/DkKcpWZ7rRjqr1VoVzep+BL3DiFnmWoWD5xpAhlsEYpO1lX
	 6HV9m3BiwKfInJt0rc3J0NqWvokPPkL+sr9RsEvwjjmrOZX2HSxkOHNrl9elWfiqcP
	 l1qWt2ebFaiJdYi2UcNcLn1BDXmvOucDRGnILcMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/290] af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().
Date: Wed,  3 Jul 2024 12:36:43 +0200
Message-ID: <20240703102905.029422366@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33dd6ed8de25d..2456170c9ddc4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1909,7 +1909,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out_err;
 
 	if (msg->msg_namelen) {
-		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
+		err = READ_ONCE(sk->sk_state) == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
 		err = -ENOTCONN;
@@ -2112,7 +2112,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (msg->msg_namelen)
@@ -2126,7 +2126,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	return unix_dgram_recvmsg(sock, msg, size, flags);
@@ -2326,7 +2326,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	size_t size = state->size;
 	unsigned int last_len;
 
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
2.43.0



