Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D97E105;
	Wed, 21 Feb 2024 14:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524491; cv=none; b=DWo7P+l4oZwBEgCQXBDBmmTc3bSBYkpciPjgw6BuIbKg9iMTgKg/T/kXrMKIIQL196A59WeWwLcHchzWM5N2s9RAA1b+DRL0EZj3tvLIsc6p+jWgADuHQFBQqNv1UJ05oYXcOAZw7QmoJLggkY1DimdiUWlfp8/0igDFUStZj2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524491; c=relaxed/simple;
	bh=Bd6CecjJNsJBYOXBAjjmvJggb5bkiFj8U5PJingsx8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G15eFZ/l/zdC9AZ/ptOU7wu0/cQSra6BHR+y0JT/KqtORQJiBjcRO3R/OSGb7e0LLAp+H7gN948AlaYVL8I5JuDorePVn+hW89tzMG+6Wr8+fjfu5pzPg/Ga6xeYQ664cvSAgugGbn217NtYXDOJ8YRUtBgVoAeBOH+eLj2G4SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4Jx+CCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4Jx+CCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6023AC433F1;
	Wed, 21 Feb 2024 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524490;
	bh=Bd6CecjJNsJBYOXBAjjmvJggb5bkiFj8U5PJingsx8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4Jx+CCaDPWAfE+gRj6KUsvE8MQMqX0+mUFUXUyf3ucv5IueR4keVeBxjIPsNCMWm
	 HiZNfLmkPM6UxGb/UXNBT/NZYAZmdvK8xXkBMuP7gcP/wDJmtUN6/mQZ6dviOUGB+8
	 WqoplyvNC2PYdc8yjmg1f4mnytGsCjkGuk8vxfK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/379] inet: read sk->sk_family once in inet_recv_error()
Date: Wed, 21 Feb 2024 14:07:20 +0100
Message-ID: <20240221130002.636449943@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 27c433eedea1..5f1b334e64b3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1600,10 +1600,12 @@ EXPORT_SYMBOL(inet_current_timestamp);
 
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



