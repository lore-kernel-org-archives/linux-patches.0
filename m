Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C575B13D61B;
	Wed,  3 Jul 2024 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003749; cv=none; b=t9xOGly/Ib20yZX0HTZu0WPnEnBN3WxjjS9pCUlkyGKVO+T3CiNeF+mJLkm88VGTNvBW/XFl+Z9bjrPjWwbOCeortT2FppCtp+kEHhzDyo/xCIWA8gMbjjwM7WNnJ8xXXltPNRTLifZ1m5YHkwJlZDDLYqwhZraVZdGHH7E/Tsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003749; c=relaxed/simple;
	bh=DkK9vtBLuK1sr2aG20oQRm/9ZvIj2+7curhUCq5xO7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5TbrFgvKu6vfiLxRd2W/9W4QKJQKcTVMhFcMWUzGhv3vu1gwCCEmOnE5Kkd0KoH/7u/EM85QbniUNKKMIZfrbuktD1ZKnxCs1nlVjX6mfJE0WPq6pkyC5miJ/Nc4UHv+d1T3NTejc76hOMEPZILf6MxbbGa9JF8sGhxpj0IG4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLPC0iI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLPC0iI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D0C2BD10;
	Wed,  3 Jul 2024 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003749;
	bh=DkK9vtBLuK1sr2aG20oQRm/9ZvIj2+7curhUCq5xO7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLPC0iI/zNXvV5AANBC+r1FvvezEECOXsH1LgU7TOPjdDLxU1I/PjdOqaTaoVS4KW
	 yNbS70ln5BhuOW8npgAoJZKV6fpkcVE9tjzVZK3HiX4XBXsMToZvlRDJip6Ip2nBfa
	 /JIjHaPXMy0YeukKXIKHENtXydTWdKz7RaF+O5q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/189] tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB
Date: Wed,  3 Jul 2024 12:37:51 +0200
Message-ID: <20240703102841.891950262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit a46d0ea5c94205f40ecf912d1bb7806a8a64704f ]

According to RFC 1213, we should also take CLOSE-WAIT sockets into
consideration:

  "tcpCurrEstab OBJECT-TYPE
   ...
   The number of TCP connections for which the current state
   is either ESTABLISHED or CLOSE- WAIT."

After this, CurrEstab counter will display the total number of
ESTABLISHED and CLOSE-WAIT sockets.

The logic of counting
When we increment the counter?
a) if we change the state to ESTABLISHED.
b) if we change the state from SYN-RECEIVED to CLOSE-WAIT.

When we decrement the counter?
a) if the socket leaves ESTABLISHED and will never go into CLOSE-WAIT,
say, on the client side, changing from ESTABLISHED to FIN-WAIT-1.
b) if the socket leaves CLOSE-WAIT, say, on the server side, changing
from CLOSE-WAIT to LAST-ACK.

Please note: there are two chances that old state of socket can be changed
to CLOSE-WAIT in tcp_fin(). One is SYN-RECV, the other is ESTABLISHED.
So we have to take care of the former case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9a4a3f6d9cb06..a181eb7d6d438 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2258,6 +2258,10 @@ void tcp_set_state(struct sock *sk, int state)
 		if (oldstate != TCP_ESTABLISHED)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 		break;
+	case TCP_CLOSE_WAIT:
+		if (oldstate == TCP_SYN_RECV)
+			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
+		break;
 
 	case TCP_CLOSE:
 		if (oldstate == TCP_CLOSE_WAIT || oldstate == TCP_ESTABLISHED)
@@ -2269,7 +2273,7 @@ void tcp_set_state(struct sock *sk, int state)
 			inet_put_port(sk);
 		/* fall through */
 	default:
-		if (oldstate == TCP_ESTABLISHED)
+		if (oldstate == TCP_ESTABLISHED || oldstate == TCP_CLOSE_WAIT)
 			TCP_DEC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 	}
 
-- 
2.43.0



