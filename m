Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9077A03;
	Wed, 21 Feb 2024 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523002; cv=none; b=cE+dMZkiwdU/0aSXUFLmc1BzzDiA+kMaPenFg2tp2o4zis1F+rAOpsgdJfNXqt7cdsfrL2XfFpF3/HCEBG6/BQmQHQUfQpzybFDcRe/9b0oTkE4PbmR4BmiJ9psG7fyijhqtCZoxaqr9PqRpAKlT77Y8/IKsBSM+XnJaVraZoxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523002; c=relaxed/simple;
	bh=Cwt1Hdn0+pMh8ic+XOZmdZWdtiA6YHKcIbroZmtlN10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1AxXQvoGyQaLuiL5WTUEt0RBZ7lrD15W2M2YQht61pE4B0hsg/G1KjbmnGkwwP5dzlBm3Vf3c9kgWsT/XBMoPCQT6FH7fX0vOPPnI+vyfICGMVTC0hlWX4mbhZtKNtsemrnouDZwBWEyE/sBPS54wwVc6bj6yokOR/qXdEaRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfWqj+m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfWqj+m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA755C433F1;
	Wed, 21 Feb 2024 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523002;
	bh=Cwt1Hdn0+pMh8ic+XOZmdZWdtiA6YHKcIbroZmtlN10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfWqj+m6Q3bkbQCpauCeGl8QBL4P6O3GeG0AtAfXdb2jCIl68SkIGBfXjgQN2MdVT
	 STHsG+YDl4F0RVcXzT9vjI3X2swUC40pJ8pDM+vau3lu95ZmgT1y3JK3hlR4N9oEwL
	 hvVn7t12khasDTQGbRCPLHAjxtPZRLPzcD3xvcSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/476] inet: read sk->sk_family once in inet_recv_error()
Date: Wed, 21 Feb 2024 14:06:04 +0100
Message-ID: <20240221130019.598548907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f6c05f198da..487f75993bf4 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1605,10 +1605,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
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



