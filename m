Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505FF17B421;
	Wed,  3 Jul 2024 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003326; cv=none; b=Lz7Tl+H9dkIPRL3v0KxI4renZYudtawHJv/evHW56wzZ/O8orvCoa1+jBQqj1aulg0ivTBtSAa7GbF7lRBUiOgj0vMHmViVf54JYCgN1sfy7ipGaEk9bNbTdsGGwRtrUzZQS84jW31i6CDBLtDqwIYnEekUtwUfbkD36Kw4pE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003326; c=relaxed/simple;
	bh=TKrqwjrNB6IRJW2lCsb0yowVEymfGlVBEUUNWrs2cMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZnk0qrKTFkGnDUPnAstCRSyN5eT5N/w7s0VLFiy3HN8BDhQ+W3fu4T7B40OPFC1n4SZEz9bi/tZYAd9rNrQkfEtuxDZelgGlpd5zu2lCeCrOC6TVWe64AKF54A1MgFBjTozRJnlKm8rYRHvCVicx/PLOu7qt6czE1LJyxsTR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aw+4JRho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aw+4JRho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C277C2BD10;
	Wed,  3 Jul 2024 10:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003325;
	bh=TKrqwjrNB6IRJW2lCsb0yowVEymfGlVBEUUNWrs2cMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aw+4JRho42McF8916kjjYzoHOf9Kga3IFQHB4gdtoCG725j6zHXWfpBh7cz9NBT75
	 x6ubTGaRjuA4c+JT3DPeICuk8gQhAF+ArT6vIT84RS8jQqE/Wk75FD9b/2FQXBZDDg
	 LnHD/DsaFlo43z6vuPWcYV4Q8bk6tHeEY33zclcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/139] af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.
Date: Wed,  3 Jul 2024 12:38:29 +0200
Message-ID: <20240703102830.902885065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d6ceac688defc..f27b4e55da0e8 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -61,7 +61,7 @@ static int sk_diag_dump_icons(struct sock *sk, struct sk_buff *nlskb)
 	u32 *buf;
 	int i;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		spin_lock(&sk->sk_receive_queue.lock);
 
 		attr = nla_reserve(nlskb, UNIX_DIAG_ICONS,
@@ -99,7 +99,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 {
 	struct unix_diag_rqlen rql;
 
-	if (sk->sk_state == TCP_LISTEN) {
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
 		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
@@ -124,7 +124,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep = nlmsg_data(nlh);
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
-	rep->udiag_state = sk->sk_state;
+	rep->udiag_state = READ_ONCE(sk->sk_state);
 	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
@@ -202,7 +202,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 			if (num < s_num)
 				goto next;
-			if (!(req->udiag_states & (1 << sk->sk_state)))
+			if (!(req->udiag_states & (1 << READ_ONCE(sk->sk_state))))
 				goto next;
 			if (sk_diag_dump(sk, skb, req,
 					 NETLINK_CB(cb->skb).portid,
-- 
2.43.0



