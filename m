Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB9A178374;
	Wed,  3 Jul 2024 11:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005283; cv=none; b=cllxda01ZAKKqz4iFedXnkWMr1ckFAD3mf8dtjZkTQSouEj18QWwu4PrLm1rQKlNcBcVXVAsbOEQZG094XgSvxSqN418DrFZLPIO8wG8JFkcn75+cQIVvuskSN0kIFlOzxfOLQ2cgClRE2l/3CcNRu967Q2vchcVV9R5+LICyHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005283; c=relaxed/simple;
	bh=KMyy2mbQ/W4LXTFXEBIS1f0JPp812RlSYlrvESoj/lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUKg2ZZaAQewvLMnpBPrKpsY8YgB2EOhpjQSgJS+0IEpcurLe/e18hgBJ+uxSckOcZLX8TudWYZJbrwlY9XaTCebDeemcNI/VR+NvOXPQGgRPJVbQfrWJweOJ7SEOX+xw9OC00QCG31yiFU/LEUJ2GdRbUYQ0u+h0Y90L7Xk6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o2+yW2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o2+yW2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD5C2BD10;
	Wed,  3 Jul 2024 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005283;
	bh=KMyy2mbQ/W4LXTFXEBIS1f0JPp812RlSYlrvESoj/lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o2+yW2r0zgLhURQ2Viglr+LKVa+FS+hG4L7hL8VjSKWlZ4/GG6d+9EeZ50yY2LMt
	 eZVigs/qRoJt9F8cme99ifVSx9nx5aYNoBL9ChtdwnRDcV8IiBPm3nm78sqwkrLCIX
	 o/11+yfcyWwj+FHoYsnT03a4EXPuQEqdfgXgXE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/356] af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.
Date: Wed,  3 Jul 2024 12:36:05 +0200
Message-ID: <20240703102914.200973921@linuxfoundation.org>
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

[ Upstream commit 0aa3be7b3e1f8f997312cc4705f8165e02806f8f ]

While dumping AF_UNIX sockets via UNIX_DIAG, sk->sk_state is read
locklessly.

Let's use READ_ONCE() there.

Note that the result could be inconsistent if the socket is dumped
during the state change.  This is common for other SOCK_DIAG and
similar interfaces.

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Fixes: 2aac7a2cb0d9 ("unix_diag: Pending connections IDs NLA")
Fixes: 45a96b9be6ec ("unix_diag: Dumping all sockets core")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -64,7 +64,7 @@ static int sk_diag_dump_icons(struct soc
 	u32 *buf;
 	int i;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		spin_lock(&sk->sk_receive_queue.lock);
 
 		attr = nla_reserve(nlskb, UNIX_DIAG_ICONS,
@@ -102,7 +102,7 @@ static int sk_diag_show_rqlen(struct soc
 {
 	struct unix_diag_rqlen rql;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
@@ -135,7 +135,7 @@ static int sk_diag_fill(struct sock *sk,
 	rep = nlmsg_data(nlh);
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
-	rep->udiag_state = sk->sk_state;
+	rep->udiag_state = READ_ONCE(sk->sk_state);
 	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
@@ -218,7 +218,7 @@ static int unix_diag_dump(struct sk_buff
 				continue;
 			if (num < s_num)
 				goto next;
-			if (!(req->udiag_states & (1 << sk->sk_state)))
+			if (!(req->udiag_states & (1 << READ_ONCE(sk->sk_state))))
 				goto next;
 			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,


