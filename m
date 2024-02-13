Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53C75FF0D;
	Tue, 13 Feb 2024 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845384; cv=none; b=pKrakAqgSFucISCHqMsd9UZ8w2PteUmOHqsfCCMN4DxgvWckJfP4lXFFdTpWmS9ZKpKeTJwbxRtNA6l5azOn8E/oCRrXoxrVq1QfpR1h06bcCvCNAZoVCNS9fv1g9HrRo8pCuzruLtUnkOlB5loJ2YR62n5ugQSbRR4AGxbKDJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845384; c=relaxed/simple;
	bh=XYdfyY0EAnhhE8ALp9OawTBKP3iyj888BXK3JAFC0Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hETomJdgIOwDmkOzcH6HkryHD826vhC5MBOnnQnTIkm9/ukWwYHctllxV2R5ETiJHVmtFmwvyIxgN43S73SpRhRZOD5KlCn8uClMOpiHciU3uJwZnqGk3DEhmXe97MPo1eI5C1m1esqGT4u4wAm14ArK1yBzGqNI4QFe+X14XxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpgkCvzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpgkCvzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49845C433F1;
	Tue, 13 Feb 2024 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845383;
	bh=XYdfyY0EAnhhE8ALp9OawTBKP3iyj888BXK3JAFC0Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpgkCvzEmOnv6yJfeW8DBl/cV7uU2uTDwjt5F0ZFlw+v35CmYpnxCGiK5bZa8WUh8
	 ZZZ0KeuCBTgqNRKU5Zzfx6/oKsNeQrafdYCGlPXfO+QfivsdoqUAjDrGdkGNvkUqZe
	 584mtEOu2b4RNjepL/ZdD6AfGFByaLfVI9KOpmVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/121] inet: read sk->sk_family once in inet_recv_error()
Date: Tue, 13 Feb 2024 18:21:12 +0100
Message-ID: <20240213171854.834922510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



