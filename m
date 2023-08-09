Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC2214F8E
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E630BC433C7;
	Wed,  9 Aug 2023 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579383;
	bh=1IUMNmdFwOtg/94KXDGssOd6SH5ZsVuXD5wRZx1pzE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RirB/jM1oUzMzhOPlBrTpW6DrnJ0zGxmyHBA+R+T5qczra8NDrFceniED+p8U/KnQ
	 IoCIIJhklOixCm0qoXtgPjO7vFa19lklK4uKG0cs+lhGIxzEQdi4e2uBrDbD+6i5GS
	 a3JiWMfgDTreKBSf+CjFR3gmVYOTqMkJL7ushSHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/204] tcp: annotate data-races around tp->notsent_lowat
Date: Wed,  9 Aug 2023 12:41:23 +0200
Message-ID: <20230809103647.434903993@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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
index 4f97c0e2d5f34..b1a9e6b1a1533 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1887,7 +1887,11 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
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
 
 static inline bool tcp_stream_memory_free(const struct sock *sk)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 98811b5f2451a..bcc2a3490323b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2810,7 +2810,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		err = tcp_repair_set_window(tp, optval, optlen);
 		break;
 	case TCP_NOTSENT_LOWAT:
-		tp->notsent_lowat = val;
+		WRITE_ONCE(tp->notsent_lowat, val);
 		sk->sk_write_space(sk);
 		break;
 	default:
@@ -3204,7 +3204,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		val = tcp_time_stamp_raw() + tp->tsoffset;
 		break;
 	case TCP_NOTSENT_LOWAT:
-		val = tp->notsent_lowat;
+		val = READ_ONCE(tp->notsent_lowat);
 		break;
 	case TCP_SAVE_SYN:
 		val = tp->save_syn;
-- 
2.39.2



