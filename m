Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B626A8D6;
	Wed, 21 Feb 2024 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525540; cv=none; b=LY9DDYGalniChHdm1lJp5IDS7Qa6m0Qhj7Nu5zALcQvnat+rKWV/JtDRozXl6n8L0hg5gB8UZEjU9XXBExzUUx2gRNtz3IKCeA51nhJYvZdnRtrHL/WuFUOisBUyI24s00ooemqIEpS7ApnnyzqBw3DM24bsUVeDbSwneUh7ix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525540; c=relaxed/simple;
	bh=PYKVGFIeQrofqW6qQMLSVY/tyxd4uC1iqYWuEsS4WK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWXhJk/wMmsr4EZUCn9BPdBX1acpoKXv3m59LuD8PEVpUNkGkx4EqvuXkJcBeeTTZyyiQZkysxj3BOKH1lTZE6lrQDTdLWmQ1ydjf15GD0CI/JXOUPj6yEdqIKfTSBfKoeomaiBpkdfC95C6mem8jVW0Cxm0rabTOz74ZRjTg+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJDSEnmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJDSEnmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A53C433F1;
	Wed, 21 Feb 2024 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525540;
	bh=PYKVGFIeQrofqW6qQMLSVY/tyxd4uC1iqYWuEsS4WK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJDSEnmn73JFh778B1rGO7u8DR14bnxEPVjdZQBKb9PT7JzwunIyUoHZ21ONJAgbY
	 fjb6pGf9LfejMNLxCKCD4rYEwJCb5xpHNEXyCa9bcEQaS8i20AsgzmH2XKbijWkmh9
	 WwkLw3NhSiz4BosN5uB7hI7dZ2GGl7yMyYFtvSlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/267] inet: read sk->sk_family once in inet_recv_error()
Date: Wed, 21 Feb 2024 14:08:48 +0100
Message-ID: <20240221125946.002940473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a3f77ac173b5..e05cdc608850 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1572,10 +1572,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
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



