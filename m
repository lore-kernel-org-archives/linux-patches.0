Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056664;
	b=Tj2traVLuem0udLyaXeYAD6KN71Kiu6FluM6gctasYhdmiwWOLzXKqqUTmIZeGj9iwtE
	 f8uDG6DrbmeahrcJLg48w3UDJ2+Y1LXNTOG+TFSjOOzBUU8DBhMZSld2ojNN/07ZeGfF5
	 FIR5nQ65XWeAkMVRY/vMI9x2RqPRbw5aUscw16EBbUpbdXE3maDWVDIHzVFuziQr3IOd+
	 QRHSZkUw/SSjE4bFHqX16neQerAxoVwr7TteKuW/KmvFt8suQseCwfXujSK6lsIkdfUhj
	 3R85FDWm7kYrw0BQ8QJyKtJ5oyJ6Jh8/KbmAQQ9WgzG1Y4EpO5nQ3QzVjTXTGou09hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PMY7U/ojmpXcws/FnQ6949Yu8I21EpajZNjWn/wJce4=;
	b=qUsUwdnFf5PiZCX8Rd7l17Ztw4rk3/ImvNIhIReKdkbOBhM3ub9H/Qkd3jGIJ8hcH8BJ
	 eK7XUi9m2EzR7LPv0a6o96vIejKCvcPV6w5gVkZOQ/yWNQUU9EDcOraUfjEVBgyzZAIs9
	 mI0yLRC/ZQVTFnX7NEOLLF/YdUuPWkR9UtdbvGDeCY7GRBsRByuESE/3Y3Oi2qO2ZpXcA
	 HwZ3Q+3cwoHpECQuZLeHGQr1S/SlXGvCOaRXN3cwYLO9XQvdbJonehf+I82FqGAvq2fzJ
	 nmHT/SaurEoUFcWx7EamII7+SHFKvHY0mPj4kmIPfYY3rNqEHvJodQf6s0PJr+P22/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TydkiOvf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C70606A31C;
	Thu, 19 Nov 2026 02:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TydkiOvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550F41F000C4;
	Thu, 19 Nov 2026 02:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056663;
	bh=PMY7U/ojmpXcws/FnQ6949Yu8I21EpajZNjWn/wJce4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TydkiOvfdu+vzvGchU2oIVDdQWkq8Tz5EjVDf4Xm21emZbazm2bpqv7iNAG2idO4+
	 K8j9wW++5GECZtyq9sdneIG86Gb3cbenVqeynwPE8LdwDNC6W9QivR5Vqd4zFauxcQ
	 CwUYV/zFCV2mPyBobPlSayCRecIZb11t3pukKgQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2067/2214] tcp_metrics: use dst_dev_net_rcu()
Date: Wed, 18 Nov 2026 16:02:23 +0100
Message-ID: <20261118150133.331497766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50c127a69cd6285300931853b352a1918cfa180f ]

Replace three dst_dev() with a lockdep enabled helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 504bdcb8c156 ("tcp: tcp_metrics: use the socket netns, not the dst device netns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 2b7230308ea9b..e93ba4eca84f2 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -170,7 +170,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
-- 
2.53.0



