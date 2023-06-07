Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067B13922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F368C433EF;
	Wed,  7 Jun 2023 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171450;
	bh=szlVYix1N6/BxvW8L6ngB0ilvdQCBlX1BXl+fRtmKSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+AaAAV5Dr4CvAtjSIiK5V/j/h1pB58mCoXjH46IZV4tjRvawbyexqTJkgzGYx2jL
	 XBetfWujE/V0Vd+eInVtrEKam+BOp5mzAyIJCIPCmCtyLwhWn8g3hKo9q2yY1UflLI
	 1EzNdAW2YvOVRAup9zOvsAMwzXhCtIqI71W5XGto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/159] af_packet: do not use READ_ONCE() in packet_bind()
Date: Wed,  7 Jun 2023 22:15:26 +0200
Message-ID: <20230607200904.430320593@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6ffc57ea004234d9373c57b204fd10370a69f392 ]

A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()

This is better handled by reading pkt_sk(sk)->num later
in packet_do_bind() while appropriate lock is held.

READ_ONCE() in writers are often an evidence of something being wrong.

Fixes: 822b5a1c17df ("af_packet: Fix data-races of pkt_sk(sk)->num.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230526154342.2533026-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 05a0b1d8c3721..ccf84ce41fd71 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3159,6 +3159,9 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 
 	lock_sock(sk);
 	spin_lock(&po->bind_lock);
+	if (!proto)
+		proto = po->num;
+
 	rcu_read_lock();
 
 	if (po->fanout) {
@@ -3259,7 +3262,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data));
 	name[sizeof(uaddr->sa_data)] = 0;
 
-	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, name, 0, 0);
 }
 
 static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
@@ -3276,8 +3279,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
 	if (sll->sll_family != AF_PACKET)
 		return -EINVAL;
 
-	return packet_do_bind(sk, NULL, sll->sll_ifindex,
-			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, NULL, sll->sll_ifindex, sll->sll_protocol);
 }
 
 static struct proto packet_proto = {
-- 
2.39.2



