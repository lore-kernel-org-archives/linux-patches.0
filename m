Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32127347517;
	Wed,  8 Apr 2026 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671851; cv=none; b=gRYnSftLpcwweGQs3sv6tMlEQ2knLX4rTwD/QrD8plDG+oFXe1uzvAQ6BAkiGPufHElWTSRmmeWpGVDRN/t8ouG3CtCQ6nO0JhOj571B3BAX4Mq41qCOc/IJgg59WYHrghgTKqscBSPIRxxCcD4QIg+R32cBkuqU/h4g6ewWoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671851; c=relaxed/simple;
	bh=7F9W0YFqImvKzjR+3uaOhRZtjNHrStEg469KoBGPVJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN8DMB67AOhNP+DjbYF6ZumP3bAQodjpVQlNInpwuKLrsdeHg3UwZy1jc3iN79kQwzUE6LJb7RQHVGOsvIMczAXNkpvnJYy+8Iy5GhyMQEhxYWqf4fv3KJ2qxQXgcnQRPKtcNGxWI6M9JF5lr0hQkdpBegYpLWmqeNwBIDE+iVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0AJnGxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0AJnGxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BD3C19421;
	Wed,  8 Apr 2026 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671850;
	bh=7F9W0YFqImvKzjR+3uaOhRZtjNHrStEg469KoBGPVJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0AJnGxUr9IUHKS2n0PuNTcdvSL9ISVoinVWqY8zkLZXcJYBekal+CJiaPFx8QVtn
	 z1mnbEXN8VKU8yfooXPaO5SXctVs9JTanCYxvUmNFUQpU/9rTudCbDhGU6TZGwabJu
	 wuqKwz27v67L3HrisqNFgWImLzBeJBROQuZYGRYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/312] tcp: optimize inet_use_bhash2_on_bind()
Date: Wed,  8 Apr 2026 19:59:26 +0200
Message-ID: <20260408175935.567796049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abec5206a8d17..fd3bbcffce5e6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -155,12 +155,10 @@ static bool inet_use_bhash2_on_bind(const struct sock *sk)
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



