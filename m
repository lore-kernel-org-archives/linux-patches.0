Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808A982495;
	Wed, 19 Jun 2024 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803193; cv=none; b=B8C/ukn+b0PNRxzjZ56FABAXaL6l+TgbxcrjpKywgQK72WHXeDc425x0TadOiTMIkYPeXGPpsx16Od+LBKHB4r/NIdmkJ+vUuTAlBdufoIBXUPXEVmDTefxABJvodcUfbIrrvhnNkkGu2/8z4RM1mOviLSv0bwcjZZ87W42MK80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803193; c=relaxed/simple;
	bh=VCEQ4kbtCmSWwAt9pw+/LrJm66E8ZbCWKF/XkyQgM9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu1Cq6B36OT5PosL8jO4aZeub1SOGrJmwaN68nTH93mMa8ktcupYc8gr3cKsTQoGwuaXBslUSs9rW7eatMv/aMBqVk011eo1/DT57gRTTjHl8xpJj2GIcrNQqYKJiut2rh6WRZBpdBWS3sl5Sx8MKzAHpsWR3W84Hmccbf2Q/bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsrZw1Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsrZw1Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03136C2BBFC;
	Wed, 19 Jun 2024 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803193;
	bh=VCEQ4kbtCmSWwAt9pw+/LrJm66E8ZbCWKF/XkyQgM9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsrZw1FnjoFcVNqwXXpKrQ3dZnvsNVpKMgjM1kGZeirlio4E+ig18zorC5S9PnhX3
	 WsATS4Xa1OYFDQcJ7MczITNtgyEzt13gRg8AhF7cEJJ+zyZZiQ5zUx3qfH7vd8BcJs
	 /MVYZLGPInGO9au9GSFiB1MbSbAvqtynIBiKjYoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rao Shoaib <Rao.Shoaib@oracle.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 185/281] af_unix: Read with MSG_PEEK loops if the first unread byte is OOB
Date: Wed, 19 Jun 2024 14:55:44 +0200
Message-ID: <20240619125616.954220256@linuxfoundation.org>
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
@@ -2672,18 +2672,18 @@ static struct sk_buff *manage_oob(struct
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
 


