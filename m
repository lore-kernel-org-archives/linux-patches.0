Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010CB502761;
	Thu, 17 Sep 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665232; cv=none; b=Bi0lFk083PCX2dZA7AD9Wbvqsoby6VKecpVwr8r3JbalW8+Ag5xZvtV5h/VIHJ8boNKoAr5hfornMunusEWy53GTGTFpr0EV0sHcDgEZUqw0RrAHJ4cCsDmzYBSEn9zUNyDICGPYxNMadAAS946FCF6Ca8cYzQMfnrxwdQDI71I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665232; c=relaxed/simple;
	bh=FpU2RZJFTeRlxMXcfeOhqieHRpJdCslekejzuHZ0xQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvRJUZHYcE4GJWlQnlOvQVImjYRRyVik9GumxMrjRcKjeqPFvT8m1syAbmnqyK/szJG108y5fFNQOp/4Tv2HmKZxMfpW7Y9vGag/FkMaAM+p6rDnDmYSJbXRvBi639rmZRYz2YZxolR2mfhpxgaCVQG3LZ/R/8ogFqbK4njAt/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1VZbEZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1VZbEZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE6B1F000FF;
	Thu, 17 Sep 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665230;
	bh=IYG8oVFdryAovOzOikAqducdYWYIRQVoY/fATIqp6VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1VZbEZlOtxCwNgoMYNEQlU8OPBhcxDYX8h5Ue1/XIyI5k//rFziCMm/finlN2Nc/
	 7M3tsUPmIO6QyDRQBk4QR9fFdYpmtcR33oO9Wp0n2MUjHRJhYcrza6I7CCcriutrE4
	 0+Dn9fNTbCdVCHooK35waYQmImV4we9dgzTQfR08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0635/1250] raw: annotate disconnect-side IPv4 match writers
Date: Thu, 17 Sep 2026 16:07:10 +0100
Message-ID: <20260917151609.097596404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit ac08d183dac0441e41f77bbad50798fe609d90f1 ]

raw_v4_match() reads inet_daddr, inet_rcv_saddr and
sk_bound_dev_if locklessly under RCU. Bind and connect writers are
annotated, but __udp_disconnect() still clears the same fields using
plain stores.

Commit 18f116931f52e ("raw: annotate lockless match fields in
raw_v4_match()") added the lockless readers and annotated the raw bind
and datagram connect writers. Its v4 revision intentionally left the
shared disconnect-side IPv4 writers for follow-up cleanup.

Complete that follow-up by using WRITE_ONCE() for the disconnect-side
stores, including the inet_rcv_saddr reset in inet_reset_saddr(), to
pair with the lockless raw socket matcher.

Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
Link: https://lore.kernel.org/netdev/20260716142958.3064224-1-runyu.xiao@seu.edu.cn/
Suggested-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260828012918.1461-1-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 3 ++-
 net/ipv4/udp.c   | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index bb900da108af4..25a71c46792bb 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -704,7 +704,8 @@ static inline void ip_ipgre_mc_map(__be32 naddr, const unsigned char *broadcast,
 
 static __inline__ void inet_reset_saddr(struct sock *sk)
 {
-	inet_sk(sk)->inet_rcv_saddr = inet_sk(sk)->inet_saddr = 0;
+	inet_sk(sk)->inet_saddr = 0;
+	WRITE_ONCE(inet_sk(sk)->inet_rcv_saddr, 0);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2f5c91ba0ce92..ea7585f6ec32a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2200,10 +2200,10 @@ int __udp_disconnect(struct sock *sk, int flags)
 	 */
 
 	sk->sk_state = TCP_CLOSE;
-	inet->inet_daddr = 0;
+	WRITE_ONCE(inet->inet_daddr, 0);
 	inet->inet_dport = 0;
 	sock_rps_reset_rxhash(sk);
-	sk->sk_bound_dev_if = 0;
+	WRITE_ONCE(sk->sk_bound_dev_if, 0);
 	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
 		inet_reset_saddr(sk);
 		if (sk->sk_prot->rehash &&
-- 
2.53.0



