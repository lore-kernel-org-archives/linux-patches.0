Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC7F3DCD86;
	Thu, 17 Sep 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668763; cv=none; b=QOSc+rGFHxP+94Kr+cozoIWmIOkyGOtDzJDE9+sYEfKa/DYtdb5eYJypGV5nJo/tCgDjFUB1khUVseKVpplV+R29aV1ufio0upsDVGGD1D3cxHRqxbbVvKLChr+5yg3776SGOV+D+zNpR2dAHqnh6opfOpbq2Kgzf0YdDXZeAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668763; c=relaxed/simple;
	bh=++drMzTmrIAF01xo5HB5KmQ8Eo5TrbJa8b/Px3I1wPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nclt/saGae5cMhjxw7bsJwfx3z/zUMXd2DBJ4hRFdhhWJnTaIQu+3zIYTcVYu1VgPynbgAuywaZ4zMW6xkdzyJsl8N7DPOYeBHC5fe5yrn9HWMQB6aD1u2QEtvk9/9aXtxe1OhiTwvFY8XQwc+XlrV5S1uF0DB7YNX9G1ZUqCuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNy1yzEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNy1yzEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69A41F000FF;
	Thu, 17 Sep 2026 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668762;
	bh=sxS/xNL061QNYvVHxIEBAfj1psFrXiHqlraT5XhbyBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNy1yzEp5s2uPRtc78xsSkIoo2Xyq16qioRe7ZTiY1E1H5r4gHzRgJgMDTsPMmD49
	 Kw/IFeEcAjja2AdNqWubx2nBCxFyuHAn8lJ2xqLlIpao5wuxqMt+kNTCUn/NtnexzR
	 gDKQubKXCuNWeCSDMw97cniCEeaN3SZbIoYXbzcg=
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
Subject: [PATCH 6.12 0533/1102] raw: annotate disconnect-side IPv4 match writers
Date: Thu, 17 Sep 2026 16:07:56 +0100
Message-ID: <20260917151553.184517314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 39c6a4033aeda..1a2383c773146 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -689,7 +689,8 @@ static inline void ip_ipgre_mc_map(__be32 naddr, const unsigned char *broadcast,
 
 static __inline__ void inet_reset_saddr(struct sock *sk)
 {
-	inet_sk(sk)->inet_rcv_saddr = inet_sk(sk)->inet_saddr = 0;
+	inet_sk(sk)->inet_saddr = 0;
+	WRITE_ONCE(inet_sk(sk)->inet_rcv_saddr, 0);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a891504a96524..69e6897337417 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2006,10 +2006,10 @@ int __udp_disconnect(struct sock *sk, int flags)
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



