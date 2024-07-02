Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7D178381;
	Tue,  2 Jul 2024 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940131; cv=none; b=lDVeL3V1CLnaNrO/vUILJjzs8j0wC2HYdavbIoNq8PJadzl65cFjkc+M5bhIbUm6rHbSTR3s7xy2YhPRPvMXTAgJ0HZi+fqKpsRDSQfjTcyKJJdiOYeCBlW2ST4xdLkwOdinfw1f8kh9KK54tP6gd5XkBjXrnuwYZIwVgFPsQd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940131; c=relaxed/simple;
	bh=Z3pgO1sfuubEYt3JcV5z0P2bs/qF8XVc9ajFxCJi4SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKnmAZr2HzvRc2/SvjWEXwfC9UjvqlcjQMuhmOSwfi1przCeqPJ/rppAoS8ckmAUhOXR1pNELPWiWrNqw8zrNEIKBu+uPIpYiWy2dmUIDZsdnyVlEg9qa87eJCMi/R+scAqwIIP6yrffz/w+z31W93cf5t3odassF+pnLMa0RXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyIso/08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyIso/08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F11BC116B1;
	Tue,  2 Jul 2024 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940130;
	bh=Z3pgO1sfuubEYt3JcV5z0P2bs/qF8XVc9ajFxCJi4SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyIso/08XVII5XMwgNBlI4zlZxpN77jIznm58ps0F4T1WBVefEJ0gKs4j4LdtrUfD
	 al+YUYg6XRrigGWM8pB4b/rSmpnSeuCaTjXvvIz2KzCnaTkHkrpuXda8dRH/nhKSVg
	 v31NKJiRZCoCAAg5Jn4y+74EUg5SGBNLV6yyH3JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/222] af_unix: Dont stop recv() at consumed ex-OOB skb.
Date: Tue,  2 Jul 2024 19:01:40 +0200
Message-ID: <20240702170246.353376939@linuxfoundation.org>
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

[ Upstream commit 36893ef0b661671ee64eb37bf5f345f33d2cabb7 ]

Currently, recv() is stopped at a consumed OOB skb even if a new
OOB skb is queued and we can ignore the old OOB skb.

  >>> from socket import *
  >>> c1, c2 = socket(AF_UNIX, SOCK_STREAM)
  >>> c1.send(b'hellowor', MSG_OOB)
  8
  >>> c2.recv(1, MSG_OOB)  # consume OOB data stays at middle of recvq.
  b'r'
  >>> c1.send(b'ld', MSG_OOB)
  2
  >>> c2.recv(10)          # recv() stops at the old consumed OOB
  b'hellowo'               # should be 'hellowol'

manage_oob() should not stop recv() at the old consumed OOB skb if
there is a new OOB data queued.

Note that TCP behaviour is apparently wrong in this test case because
we can recv() the same OOB data twice.

Without fix:

  #  RUN           msg_oob.no_peek.ex_oob_ahead_break ...
  # msg_oob.c:138:ex_oob_ahead_break:AF_UNIX :hellowo
  # msg_oob.c:139:ex_oob_ahead_break:Expected:hellowol
  # msg_oob.c:141:ex_oob_ahead_break:Expected ret[0] (7) == expected_len (8)
  # ex_oob_ahead_break: Test terminated by assertion
  #          FAIL  msg_oob.no_peek.ex_oob_ahead_break
  not ok 11 msg_oob.no_peek.ex_oob_ahead_break

With fix:

  #  RUN           msg_oob.no_peek.ex_oob_ahead_break ...
  # msg_oob.c:146:ex_oob_ahead_break:AF_UNIX :hellowol
  # msg_oob.c:147:ex_oob_ahead_break:TCP     :helloworl
  #            OK  msg_oob.no_peek.ex_oob_ahead_break
  ok 11 msg_oob.no_peek.ex_oob_ahead_break

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 645ac77e4dda3..e0fea73317de8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2665,7 +2665,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 		spin_lock(&sk->sk_receive_queue.lock);
 
-		if (copied) {
+		if (copied && (!u->oob_skb || skb == u->oob_skb)) {
 			skb = NULL;
 		} else if (flags & MSG_PEEK) {
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
-- 
2.43.0



