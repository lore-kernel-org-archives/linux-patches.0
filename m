Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D81D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A784C433C8;
	Tue, 25 Jul 2023 11:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283230;
	bh=0cslL2EWonfupcowMD3E/ReUvs436IJ9rIhgf+Lr03c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMdfPvw1BK+LNLifCptar2tLD3ce0s5BO4kD/Y19wMz9xJiMurFucgbJo6l9XOAcQ
	 hD4EN3iHofrmrm7r0zvItrl+dOc3rn/C92eA51+V7EnPSUQ0vn/ug4KlPK3Wdq43AO
	 +IXtMUQumgJfQobWJwLmb2BFXy2nyw+SZcSv3vCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/183] tcp: annotate data-races around tp->notsent_lowat
Date: Tue, 25 Jul 2023 12:46:28 +0200
Message-ID: <20230725104513.579443315@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
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

[ Upstream commit 1aeb87bc1440c5447a7fa2d6e3c2cca52cbd206b ]

tp->notsent_lowat can be read locklessly from do_tcp_getsockopt()
and tcp_poll().

Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-10-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 6 +++++-
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9733d8e4f10af..e9c8f88f47696 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2059,7 +2059,11 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
-	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
+	u32 val;
+
+	val = READ_ONCE(tp->notsent_lowat);
+
+	return val ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
 bool tcp_stream_memory_free(const struct sock *sk, int wake);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bc3ad48f92389..6f3a494b965ae 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3770,7 +3770,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		err = tcp_repair_set_window(tp, optval, optlen);
 		break;
 	case TCP_NOTSENT_LOWAT:
-		tp->notsent_lowat = val;
+		WRITE_ONCE(tp->notsent_lowat, val);
 		sk->sk_write_space(sk);
 		break;
 	case TCP_INQ:
@@ -4266,7 +4266,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		val = tcp_time_stamp_raw() + READ_ONCE(tp->tsoffset);
 		break;
 	case TCP_NOTSENT_LOWAT:
-		val = tp->notsent_lowat;
+		val = READ_ONCE(tp->notsent_lowat);
 		break;
 	case TCP_INQ:
 		val = tp->recvmsg_inq;
-- 
2.39.2



