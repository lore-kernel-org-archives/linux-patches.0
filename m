Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE75178381;
	Tue,  2 Jul 2024 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940127; cv=none; b=UyQSBWHYMLqkNcay9LyJjo56HSZIssgp42BuDFHfhV64fEaR/ffolDm1Vo7x1VdVfO4zdXaG8EJAaDXZUFOG18W62oqcoOogkqbQScxhAvMj+sbxAt9wL7Wvv+VqYMgRWlChtSD+jzdMRIJ/Q+hIk5u7lGX7N+df+YEZa0H75dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940127; c=relaxed/simple;
	bh=w62SZLvxlJKzrvfhmaZ4a11g7Nx5/jv3zvQUqv8Q/hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWYi7Qvgyy6u5HEQAjm0ZrhXUk5d86EIzL9SQhgin9aI1FCDS4CFYYLKJOMc6KbSd4TctpSmI+XXttAKAfATjV1KwGNIk33MyN9cUD/Pz43ONfMWqPdX2I54uv0+nd+Cq5e4nxXuiHN9JqUCmWRgpdtHGrA8llEn39Z/i4Pw3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGS3JnYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGS3JnYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F177BC116B1;
	Tue,  2 Jul 2024 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940127;
	bh=w62SZLvxlJKzrvfhmaZ4a11g7Nx5/jv3zvQUqv8Q/hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGS3JnYLV7GSbMjCMMCwgH6yc+/Xx4583QpkLCMtMiedfl22qD8uxK7m4BGlFWHND
	 +2eGdeOD5wbhFk1gT81Tm108rfE698BWZWe0c9bslOQuhYGYMKbmIxBBVGY+M+A7IC
	 A0KYr/12dxxJSoWkweB0Jxd1jKueJcFIeIv9dg9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 061/222] af_unix: Dont stop recv(MSG_DONTWAIT) if consumed OOB skb is at the head.
Date: Tue,  2 Jul 2024 19:01:39 +0200
Message-ID: <20240702170246.315812956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

[ Upstream commit 93c99f21db360957d49853e5666b5c147f593bda ]

Let's say a socket send()s "hello" with MSG_OOB and "world" without flags,

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX)
  >>> c1.send(b'hello', MSG_OOB)
  5
  >>> c1.send(b'world')
  5

and its peer recv()s "hell" and "o".

  >>> c2.recv(10)
  b'hell'
  >>> c2.recv(1, MSG_OOB)
  b'o'

Now the consumed OOB skb stays at the head of recvq to return a correct
value for ioctl(SIOCATMARK), which is broken now and fixed by a later
patch.

Then, if peer issues recv() with MSG_DONTWAIT, manage_oob() returns NULL,
so recv() ends up with -EAGAIN.

  >>> c2.setblocking(False)  # This causes -EAGAIN even with available data
  >>> c2.recv(5)
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  BlockingIOError: [Errno 11] Resource temporarily unavailable

However, next recv() will return the following available data, "world".

  >>> c2.recv(5)
  b'world'

When the consumed OOB skb is at the head of the queue, we need to fetch
the next skb to fix the weird behaviour.

Note that the issue does not happen without MSG_DONTWAIT because we can
retry after manage_oob().

This patch also adds a test case that covers the issue.

Without fix:

  #  RUN           msg_oob.no_peek.ex_oob_break ...
  # msg_oob.c:134:ex_oob_break:AF_UNIX :Resource temporarily unavailable
  # msg_oob.c:135:ex_oob_break:Expected:ld
  # msg_oob.c:137:ex_oob_break:Expected ret[0] (-1) == expected_len (2)
  # ex_oob_break: Test terminated by assertion
  #          FAIL  msg_oob.no_peek.ex_oob_break
  not ok 8 msg_oob.no_peek.ex_oob_break

With fix:

  #  RUN           msg_oob.no_peek.ex_oob_break ...
  #            OK  msg_oob.no_peek.ex_oob_break
  ok 8 msg_oob.no_peek.ex_oob_break

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d687670e84990..645ac77e4dda3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2661,12 +2661,23 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 	struct unix_sock *u = unix_sk(sk);
 
 	if (!unix_skb_len(skb)) {
-		if (!(flags & MSG_PEEK)) {
-			skb_unlink(skb, &sk->sk_receive_queue);
-			consume_skb(skb);
+		struct sk_buff *unlinked_skb = NULL;
+
+		spin_lock(&sk->sk_receive_queue.lock);
+
+		if (copied) {
+			skb = NULL;
+		} else if (flags & MSG_PEEK) {
+			skb = skb_peek_next(skb, &sk->sk_receive_queue);
+		} else {
+			unlinked_skb = skb;
+			skb = skb_peek_next(skb, &sk->sk_receive_queue);
+			__skb_unlink(unlinked_skb, &sk->sk_receive_queue);
 		}
 
-		skb = NULL;
+		spin_unlock(&sk->sk_receive_queue.lock);
+
+		consume_skb(unlinked_skb);
 	} else {
 		struct sk_buff *unlinked_skb = NULL;
 
-- 
2.43.0



