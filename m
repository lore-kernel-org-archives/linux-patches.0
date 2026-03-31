Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0D425CC6;
	Tue, 31 Mar 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975793; cv=none; b=fQHdbZrDkl3yrS9q0YQZvKXZiVTTgJpmC2vMQrWRRqbRPr4PUVszlcRrHM3Ld+oMC7RVYqP58cHJasjzL5bYZnMEtZ6CHzFtgNOA3WhL6PemDusMOqcxC/ibaWFrYyTwN9MgPlb8phIX9EcuuEwra/+/4nyu9V+FIfT5Kusse7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975793; c=relaxed/simple;
	bh=kg7A+l9JHztVIrSj0NxTzVvzow75AK7T5/atiD0veEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/PMNFpSfbaJz5EvCmP5TiRVRlV7kihtJAq/zg8uqsCV3FGs1Z/2mds/TWrnpUInPEwgmttYJSrqJLgEBRE2f14is44tP5TOK8hnwjuD+TlA8iHCds/RfyZV6dPiBXHDZYVV5R3qC39zuuh2OrAub/8EXSOr4b/h7JRtbdAuz4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9y/4k9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9y/4k9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A942C19424;
	Tue, 31 Mar 2026 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975792;
	bh=kg7A+l9JHztVIrSj0NxTzVvzow75AK7T5/atiD0veEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9y/4k9uRSiTF4SFFu/QeWrkX3/EmvnSRvpQ+ejS6mNqAOl/6iiYV/5+95UwfEL90
	 JUtkPUgA5EimHrlLU9DGS7YJHOnTsnoRs1tWxBWB/Wc/g3yVi+LnknYqqCouLxLU9X
	 Fflr7H56g4BrtjqqXOILJvICBG+gASBDOkyO1Yt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/244] tcp: optimize inet_use_bhash2_on_bind()
Date: Tue, 31 Mar 2026 18:20:38 +0200
Message-ID: <20260331161744.928564556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ca79d80b0b9f42362a893f06413a9fe91811158a ]

There is no reason to call ipv6_addr_type().

Instead, use highly optimized ipv6_addr_any() and ipv6_addr_v4mapped().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250302124237.3913746-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e537dd15d0d4 ("udp: Fix wildcard bind conflict check when using hash2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fe7947f774062..72049d04a2b7d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -157,12 +157,10 @@ static bool inet_use_bhash2_on_bind(const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6) {
-		int addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
-
-		if (addr_type == IPV6_ADDR_ANY)
+		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 			return false;
 
-		if (addr_type != IPV6_ADDR_MAPPED)
+		if (!ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
 			return true;
 	}
 #endif
-- 
2.51.0



