Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A870E12FB31;
	Wed, 19 Jun 2024 13:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802361; cv=none; b=bTq4QFk3N3cz9g6XxWSVuaJbjeWcCab0Uu7/oOXwyv0ddAAprpqTuZE8GncQL32gnI4y9MMreLxiKoh7/msBKhVgzauWyqIXVFrRJKHE/2OcFjPuytcGwPAD9Njxw6s3y4Uwko+gZAK559fUlE+2ukhwimHLn7vSBiwiRU9knfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802361; c=relaxed/simple;
	bh=YwMu2Vad0/oPVu/BkPL/dD1ejUnSmX+SLEUZZHQpCyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpjFEq0AnLiha2YT/s+81FYr24hxTttS1B31eOQLxGvtIRaxN7YrYP/0b3kyX9b9SE9dBsOFO7TOYrMb1GT6YzrF9re7rYwhC1NJS0T5obKqgx1WYQaIx9lsiVfFareABPOkq1QkdVFC5rW3jW0UJvY7WsxbvuzCDxC2oe59A/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQnztSe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQnztSe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B1DC2BBFC;
	Wed, 19 Jun 2024 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802361;
	bh=YwMu2Vad0/oPVu/BkPL/dD1ejUnSmX+SLEUZZHQpCyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQnztSe+D1ldz0gIWZDGIwcIImihqZD7tvvJWrMaJbw32k4CM+S2qOtbhaf0GnHnO
	 qPVkxkFsbaRitjo+98JVG7Mrg1TvpeeHowd3MSPoKs0hEOcI00u7MrwV2NMG9alp31
	 JmpdIByu5+f2QUA8NbYOMKL3Lu7Ra0XsYan/Jk5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rao Shoaib <Rao.Shoaib@oracle.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/267] af_unix: Read with MSG_PEEK loops if the first unread byte is OOB
Date: Wed, 19 Jun 2024 14:55:21 +0200
Message-ID: <20240619125612.866818876@linuxfoundation.org>
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

From: Rao Shoaib <Rao.Shoaib@oracle.com>

[ Upstream commit a6736a0addd60fccc3a3508461d72314cc609772 ]

Read with MSG_PEEK flag loops if the first byte to read is an OOB byte.
commit 22dd70eb2c3d ("af_unix: Don't peek OOB data without MSG_OOB.")
addresses the loop issue but does not address the issue that no data
beyond OOB byte can be read.

>>> from socket import *
>>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
>>> c1.send(b'a', MSG_OOB)
1
>>> c1.send(b'b')
1
>>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
b'b'

>>> from socket import *
>>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
>>> c2.setsockopt(SOL_SOCKET, SO_OOBINLINE, 1)
>>> c1.send(b'a', MSG_OOB)
1
>>> c1.send(b'b')
1
>>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
b'a'
>>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
b'a'
>>> c2.recv(1, MSG_DONTWAIT)
b'a'
>>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
b'b'
>>>

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Rao Shoaib <Rao.Shoaib@oracle.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240611084639.2248934-1-Rao.Shoaib@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2596,18 +2596,18 @@ static struct sk_buff *manage_oob(struct
 		if (skb == u->oob_skb) {
 			if (copied) {
 				skb = NULL;
-			} else if (sock_flag(sk, SOCK_URGINLINE)) {
-				if (!(flags & MSG_PEEK)) {
+			} else if (!(flags & MSG_PEEK)) {
+				if (sock_flag(sk, SOCK_URGINLINE)) {
 					WRITE_ONCE(u->oob_skb, NULL);
 					consume_skb(skb);
+				} else {
+					__skb_unlink(skb, &sk->sk_receive_queue);
+					WRITE_ONCE(u->oob_skb, NULL);
+					unlinked_skb = skb;
+					skb = skb_peek(&sk->sk_receive_queue);
 				}
-			} else if (flags & MSG_PEEK) {
-				skb = NULL;
-			} else {
-				__skb_unlink(skb, &sk->sk_receive_queue);
-				WRITE_ONCE(u->oob_skb, NULL);
-				unlinked_skb = skb;
-				skb = skb_peek(&sk->sk_receive_queue);
+			} else if (!sock_flag(sk, SOCK_URGINLINE)) {
+				skb = skb_peek_next(skb, &sk->sk_receive_queue);
 			}
 		}
 


