Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56633AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555DAC433EF;
	Wed,  7 Jun 2023 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169345;
	bh=X/Yg9/v/aCZnNutjLWGZLcrdBo8Jogfza8GY0HxrKRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeqEmfEF0sdAuvJixq/6LAFpAVfQtk5I+HTEIJHMR51Xug7JxT6WV/8U2f6YdlCqG
	 n1odCluphOdCcz8uqFGVowS5bt8AsPRlUO4t92+ZxyZZRA5U9PdayC0BW7egxF/qk9
	 hhtHRoUkE23eqa/sLssEAKOgHrQCYpMeKhA+Xg2g=
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
Subject: [PATCH 6.3 046/286] af_packet: do not use READ_ONCE() in packet_bind()
Date: Wed,  7 Jun 2023 22:12:25 +0200
Message-ID: <20230607200924.553128205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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
index f3513316743ad..b79d2fa788061 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3193,6 +3193,9 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 
 	lock_sock(sk);
 	spin_lock(&po->bind_lock);
+	if (!proto)
+		proto = po->num;
+
 	rcu_read_lock();
 
 	if (po->fanout) {
@@ -3291,7 +3294,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
 	name[sizeof(uaddr->sa_data_min)] = 0;
 
-	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, name, 0, 0);
 }
 
 static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
@@ -3308,8 +3311,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
 	if (sll->sll_family != AF_PACKET)
 		return -EINVAL;
 
-	return packet_do_bind(sk, NULL, sll->sll_ifindex,
-			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, NULL, sll->sll_ifindex, sll->sll_protocol);
 }
 
 static struct proto packet_proto = {
-- 
2.39.2



