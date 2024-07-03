Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4513C8F4;
	Wed,  3 Jul 2024 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005677; cv=none; b=IeNn9rNER9RWf0ejp+ZbGnhiCI7NdznUwJOD3tlqRzgsrZV19nHxNpfJ8iGyHVxQFVVW/sYy3/48tWtNi8IelFYmAfs9ArnncqMiHOSw+hk3WkK61IYKXnpf4h9hod+jmf18lOPCjgAqkRUzD3Xf1D5s1WYtzww8rIMhWkJY9O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005677; c=relaxed/simple;
	bh=jRsJ+B6QECw2JZJTcjedl8tY/g4TrkiZvMrWDr2CaBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFhzAxQv6tYkBFjOZfFcmnUE5RwkbTCsZNwqiFqX5da2u1fysSDil4ofFrPAoSNsvUu0wmBNMtRk9ig55A8KIgGvPMS6/VJAY9pxQ7SbBAXmizeBXDo0dNBAwi5tvS+HEWDudpoH4QVuqnl/ykzw6a7ekVS18Gp0USfA8KKzvYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6O2TL8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6O2TL8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7A6C2BD10;
	Wed,  3 Jul 2024 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005677;
	bh=jRsJ+B6QECw2JZJTcjedl8tY/g4TrkiZvMrWDr2CaBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6O2TL8I/zM+eSHNAmZ0G25nehQVlWixr9NvY2rEmbQ3o5J+mCYXgQ8Eiw224qcp1
	 LDDgkgDNRZ9t6+MZj4PdEDNXGjmYSGIJhKpr30jPTQ9jYbjWW0LbQ6wVTGAWY3ivEK
	 6bZjQESThp2+ssbQDpV6cjeGg0JqaDKE/tjTaEr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/356] af_packet: avoid a false positive warning in packet_setsockopt()
Date: Wed,  3 Jul 2024 12:38:16 +0200
Message-ID: <20240703102919.157923358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

[ Upstream commit 86d43e2bf93ccac88ef71cee36a23282ebd9e427 ]

Although the code is correct, the following line

	copy_from_sockptr(&req_u.req, optval, len));

triggers this warning :

memcpy: detected field-spanning write (size 28) of single field "dst" at include/linux/sockptr.h:49 (size 16)

Refactor the code to be more explicit.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4f920502f92fe..8d0feb9ad5a52 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3757,28 +3757,30 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	case PACKET_TX_RING:
 	{
 		union tpacket_req_u req_u;
-		int len;
 
+		ret = -EINVAL;
 		lock_sock(sk);
 		switch (po->tp_version) {
 		case TPACKET_V1:
 		case TPACKET_V2:
-			len = sizeof(req_u.req);
+			if (optlen < sizeof(req_u.req))
+				break;
+			ret = copy_from_sockptr(&req_u.req, optval,
+						sizeof(req_u.req)) ?
+						-EINVAL : 0;
 			break;
 		case TPACKET_V3:
 		default:
-			len = sizeof(req_u.req3);
+			if (optlen < sizeof(req_u.req3))
+				break;
+			ret = copy_from_sockptr(&req_u.req3, optval,
+						sizeof(req_u.req3)) ?
+						-EINVAL : 0;
 			break;
 		}
-		if (optlen < len) {
-			ret = -EINVAL;
-		} else {
-			if (copy_from_sockptr(&req_u.req, optval, len))
-				ret = -EFAULT;
-			else
-				ret = packet_set_ring(sk, &req_u, 0,
-						    optname == PACKET_TX_RING);
-		}
+		if (!ret)
+			ret = packet_set_ring(sk, &req_u, 0,
+					      optname == PACKET_TX_RING);
 		release_sock(sk);
 		return ret;
 	}
-- 
2.43.0



