Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C330C345;
	Tue, 31 Mar 2026 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974369; cv=none; b=A1FIiLYPEFQ2M0JbdL9TjIMTkldLCDqjmo/x0EkPkQtdabOiwXps0eEp2RaFk/uzMVKJDr0MWbf2BIVFPAUtpbwPluHoMymgXNeYfhbMJqPN2iiuVQwdQGCFVYGKTftrNEyAui7c5+leTgL8LwTItmIKBgNeDs6YUpS335K554g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974369; c=relaxed/simple;
	bh=1dcxLP0PSYy458UrjfjwjOKI6QKspn+xcVlyzPISKcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCJoczF9MthYe3tJ7GTKi3880T8/9uIcciiZpGWa0dNqyhOON+FnjVBwmWdc86rx1Y7T6X9DYKXCxY2lVL4mV4k4/8bp3vnKjXvXkT56QK/ZySsJWUDsRaPNNjFdQZK4d/zolz7dEOoNqeJQyv7JaGBC1V2Jknj7fRKu3ZCFvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es6/tJZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es6/tJZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFE6C19423;
	Tue, 31 Mar 2026 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974369;
	bh=1dcxLP0PSYy458UrjfjwjOKI6QKspn+xcVlyzPISKcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es6/tJZmPW0wEKZtFDzAR4yfdzCfHPpqfplpJbBPuD9KsQO9dypgUi6180FFWlj8W
	 1zV4jF6pQExRm0TEjvIIn+mTKfQb1MhsbEujY5GdOZMlLyhTcSElFGBA3FFTcVZP5E
	 rQQjepJjrzRDbNwUwGAB1M+fhZwmh8rZV98m1rEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/175] tcp: optimize inet_use_bhash2_on_bind()
Date: Tue, 31 Mar 2026 18:20:42 +0200
Message-ID: <20260331161731.917468152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index e7751bfab92bb..2274ac267c41a 100644
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



