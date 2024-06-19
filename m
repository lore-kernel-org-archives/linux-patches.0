Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872512FB31;
	Wed, 19 Jun 2024 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802113; cv=none; b=rqJHSiRXfkjyFaN5nIVy0QxZchtwVD1g3aaPYr3UixXNpEdVutJmwF680zhT9A5F+/QLz421v18SOunrRLjXoKSvD4vdTixjfHJhq5jjgvjbQtDGF6+hga0V/jtLOFZ5aAMzFRl4UB8U6nytsyGv82IPyxOXDXDf4uWyMCwYLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802113; c=relaxed/simple;
	bh=CZFZutbLbJINf75HyVVXtYhPtgz7q3tsmElpoVCnAFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXFyFzIiq2dzkF4McmVCsPLbDu5IhQbYhmeFtifA2uaxplG5M8kI4Yi0jWCjvEmC8UZUccdn5MguyzO6e28EgWADzMF8KTcouPJaNl2c4jVACf3ApwUzUAl6e8BAYYhhcbGkSktJyezIFxziSX4Ii29lFHVoWoRLh8NeOTku6iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsU/Z/o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsU/Z/o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC944C2BBFC;
	Wed, 19 Jun 2024 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802113;
	bh=CZFZutbLbJINf75HyVVXtYhPtgz7q3tsmElpoVCnAFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsU/Z/o9lgbgYYGi/Ei4gj2kTl7Wy/bnfvCDCJ5nwX7dybpg5hSnDRLgonAUxJlWq
	 +8MrgV9yCQtiCSmsvr/xDqH9nyMmCCEmi0r8bYBvw53zyMFfHOtty0ulIO3aqAF+VU
	 202jtpXT8uz4qiqWrLfxSPLd/SFLipBp5Lkl9aJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/267] af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.
Date: Wed, 19 Jun 2024 14:53:26 +0200
Message-ID: <20240619125608.473422552@linuxfoundation.org>
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
 net/unix/diag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 3438b7af09af5..9151c72e742fc 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -65,7 +65,7 @@ static int sk_diag_dump_icons(struct sock *sk, struct sk_buff *nlskb)
 	u32 *buf;
 	int i;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		spin_lock(&sk->sk_receive_queue.lock);
 
 		attr = nla_reserve(nlskb, UNIX_DIAG_ICONS,
@@ -103,7 +103,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 {
 	struct unix_diag_rqlen rql;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
@@ -136,7 +136,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep = nlmsg_data(nlh);
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
-	rep->udiag_state = sk->sk_state;
+	rep->udiag_state = READ_ONCE(sk->sk_state);
 	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
@@ -215,7 +215,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		sk_for_each(sk, &net->unx.table.buckets[slot]) {
 			if (num < s_num)
 				goto next;
-			if (!(req->udiag_states & (1 << sk->sk_state)))
+			if (!(req->udiag_states & (1 << READ_ONCE(sk->sk_state))))
 				goto next;
 			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,
-- 
2.43.0



