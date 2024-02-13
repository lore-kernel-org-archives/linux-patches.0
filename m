Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD45F54E;
	Tue, 13 Feb 2024 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845154; cv=none; b=KbH93iEXhPS8ixp/RGr9HhmihgP8KvqV8zyF/OapFAwdI/jhaj22tCyVaR42C1CAmgmSGionPHiG7nuGMRl+Jncm7RId2JPXPC4W1BQAuOSziZPBQ45XsJEsANOPTrLPLr0XjeZTfLweOWMpPW8kgvUb2cb0QVPyaD1X8saE6xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845154; c=relaxed/simple;
	bh=tAM511Lr5zFymWyC4g61QBvwpzfwpkznC9sYHzSU8JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj4zhtVyr8cQDk4sJkB1y+p6xRu7B7J6gCIaR2IxQdU+2u58R7eqU+OU9J85k4owLgnF6J6YwG9BUd6oM6fHYc0YUKdt3C1gT7bRX2WxZHgpK63QfCPe8ssAJifZb6W+2GemuYHgVjlO2CTM6odN4Oi4MkOdbvfnuu5BDALbXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWG2bxFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWG2bxFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C957EC433C7;
	Tue, 13 Feb 2024 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845154;
	bh=tAM511Lr5zFymWyC4g61QBvwpzfwpkznC9sYHzSU8JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWG2bxFAmM0r180xM2dzgoizvbfPv5IsCWIpnDz+4XozVbtcAQs7gVPOoR2EPzuup
	 b2zVt/8nTNXhC2XLlDrjhTiBBnryASSTEagUFAwwn/GDcc2/mMNRVsJ5akKkunub0E
	 JefOrSMhVQpzpDX9M+5mlke2k6M4OFjY5+y18Wyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/64] inet: read sk->sk_family once in inet_recv_error()
Date: Tue, 13 Feb 2024 18:21:11 +0100
Message-ID: <20240213171845.550712437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f646335d218..9408dc3bb42d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1637,10 +1637,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
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



