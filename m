Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48E3C7DF5;
	Wed, 30 Sep 2026 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794979; cv=none; b=lD2tZxF5qLWk6mBAdeaJwvF+9hJQnVgXzRZ5T//A79LsLsipt5dCM5qcHlZKyZosApI2xzraEcuUqEZsTVPA4gmCrrgejRYleHDWFiw8WN1rqOqai49LYhCfzjOtM++APQhag9DWdkC/PqweLgKGhnVVAQ0PSFRr8neFDcCsWjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794979; c=relaxed/simple;
	bh=NjLFyP5lwTOiP2F3YJLrQdzh2QOyHAfAMo/jMYAxfUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ8dsMktSlHoVmeW7peBCY8PIxsGT3lgnuUvU+A8zoEw+jEej5uLycx1FIjbmQ4O/KxeXvgNTv/v3VqsRkNcTWz58AUMYcs6nTeTfsZdhcuNGIY1MsyVZmj0LVUTZT5rjN8FJgKo0P4303ZLsc+HNKduyUeoDoQGT5wmTbrAidY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CreX2gsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CreX2gsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351801F000FF;
	Wed, 30 Sep 2026 19:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794977;
	bh=7qUcsNUc1qNXI8zgdkwyZvftDVSkLpv70PqZMBrxqmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CreX2gsXQRzv7remW46altoSyq7z1mg4jafIbrmghQVEXCco/SHfrG/MQPARE1ATC
	 xTXO/vfqOqWYFdyLwEiCMe+8/BV48VhV9QvDyuXrNFkNTXZfWTX3Wo+BWhrUA5C9s3
	 X3LVEU2kWVGKd//56XP8rGP1euGYTZV5EXkBnNoE=
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
Subject: [PATCH 6.6 0400/1193] raw: annotate disconnect-side IPv4 match writers
Date: Wed, 30 Sep 2026 17:18:04 +0200
Message-ID: <20260930152443.081343523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f66dd581ba839..baea9acd7e85f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -660,7 +660,8 @@ static inline void ip_ipgre_mc_map(__be32 naddr, const unsigned char *broadcast,
 
 static __inline__ void inet_reset_saddr(struct sock *sk)
 {
-	inet_sk(sk)->inet_rcv_saddr = inet_sk(sk)->inet_saddr = 0;
+	inet_sk(sk)->inet_saddr = 0;
+	WRITE_ONCE(inet_sk(sk)->inet_rcv_saddr, 0);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 384b9f0f8a155..339d9db972e53 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1948,10 +1948,10 @@ int __udp_disconnect(struct sock *sk, int flags)
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



