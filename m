Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B760265;
	Tue, 13 Feb 2024 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845749; cv=none; b=KALGk6pKywgwR6W7f8bZDhxmA55X1EPRbfVcyGos8qhpJIAb5OFOubOv2o9WtOJ6ePEsb0rGwXE+wswBJOHjCVNqulI+wAyWUUQigqyG9Yzi7hpjdceVgixLKaDRSStCvt0r/gwi5wt+vEASTI+xlCnh960TMB8A66UDA+KhXGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845749; c=relaxed/simple;
	bh=nrUiDywq7zh6vITPUJMX2iIB8GYLWmGw/l7A+KmaRZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO/NTbMjDMY/7qYfCfVpIDqlgBzM5BDcRheEjlBUuHp+HiEqovTeHGr7QMJSYaHNPLxutqDMYjngmZ1xfFj6dsNDZBvBqUdgL0lmX06EtYuTXU/PvjNFcp2yqE1SD0rjIiN/FOd5jMLH82FlwOR3R8yTzjcVZSvtPaRqNFfn2lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VM71hAs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VM71hAs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D513C43394;
	Tue, 13 Feb 2024 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845749;
	bh=nrUiDywq7zh6vITPUJMX2iIB8GYLWmGw/l7A+KmaRZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VM71hAs3AZRj7chYbmg0iOqbZrMBibxm873uOqGC3wzy9JY1Jy3D6Ur4zWZQNc5yc
	 oTTXg86D+Un7YJND5ImToCiOhZMyTLJsXh3zsWhMhh0LVhRVYp8PPBzQvMjT5qVe0F
	 xNrIMCYVAroEBIywUupL2OdlKhMftPyCRidF8tk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 046/124] inet: read sk->sk_family once in inet_recv_error()
Date: Tue, 13 Feb 2024 18:21:08 +0100
Message-ID: <20240213171855.081723871@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1c58bd72e124..e59962f34caa 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1628,10 +1628,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
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



