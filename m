Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C17C081;
	Wed, 21 Feb 2024 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521586; cv=none; b=B86UN69jtuW85LZu1qXmtLfihxvvGhspH9HNccsSNVeJ/KpCNbCLTPhg354Wn5SI1OwlosJsbUd7vJ2Sm3nhFtTGPFZe6KIFP0CZeb7Gw17FImjkdvQ/dZbEJ1ttee4ogdZuVZhOLXAWrF31ZfBF7Ku/k4IIt9O6PQkqmhxgAZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521586; c=relaxed/simple;
	bh=uw5ZCN0Z0v40JdxPGXvVyc57BlnaV7ikTVtpBY9Q/VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkQaDIaWTW2ESDQTbKQFldX+ddJ4HIO97Xl99yOwGHx7Djqt+WS3J0JWioMPPc36SOMYJFGfZE/M1h6pnH6c5ewvuXEZBiC7rtF1GLpSGX7Z7GepGr0TeN8C+7IsIyKWhQQYX3AH6O6zXb/naB8uk/nY81fAeu1Us1nZR3EuNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR6GNXZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR6GNXZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F21C433C7;
	Wed, 21 Feb 2024 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521585;
	bh=uw5ZCN0Z0v40JdxPGXvVyc57BlnaV7ikTVtpBY9Q/VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR6GNXZIeCoMWTP2ZfV7SuDEstF+TF1z4cI2cbWt8hwqGZHyrGWJz5vn2ESD0TBX6
	 MsEla6icsJ/jluNIZtz3nc1kKK8Tal4XriLRQU8A1SOKECAXfDDnrW3NIXdVxtbaT7
	 Xf74SmnIsn8eBohGdcMVyXGVHB0Vh6c8VYv/pu0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/202] inet: read sk->sk_family once in inet_recv_error()
Date: Wed, 21 Feb 2024 14:07:33 +0100
Message-ID: <20240221125936.605127957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit eef00a82c568944f113f2de738156ac591bbd5cd ]

inet_recv_error() is called without holding the socket lock.

IPv6 socket could mutate to IPv4 with IPV6_ADDRFORM
socket option and trigger a KCSAN warning.

Fixes: f4713a3dfad0 ("net-timestamp: make tcp_recvmsg call ipv6_recv_error for AF_INET6 socks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7c902a1efbbf..01952a520d6f 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1552,10 +1552,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
 int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
-	if (sk->sk_family == AF_INET)
+	unsigned int family = READ_ONCE(sk->sk_family);
+
+	if (family == AF_INET)
 		return ip_recv_error(sk, msg, len, addr_len);
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6)
+	if (family == AF_INET6)
 		return pingv6_ops.ipv6_recv_error(sk, msg, len, addr_len);
 #endif
 	return -EINVAL;
-- 
2.43.0



