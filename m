Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC00172798;
	Wed,  3 Jul 2024 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003364; cv=none; b=DZ7KWeNOk7W91y37/RDjdruU6KaBVY4wdhuzM120xPzDmWQ83VRQKrHSb8Ue3gawLOYW2qcKYWg6oAijj2lYz8aiNS8KMLZDFhssosuLyT/1U5q21f4HjLi2nmCUglu89ykYyFF5nN8WUCm07UNejjBxUMnhHMIkCgZG2UAXRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003364; c=relaxed/simple;
	bh=hWvNuHTn1sdQNKV1EoIG053vkxlSMFGEyk6YMYXpDQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksrpObdKTP3jnSbzuWWMiBITvwDeyXvEyLpSIShkaWSgnUxpLmXFDSknE+maurdZZ99oYuRbGzko87N4oFc7ZvW9OaPg42WRC5m0ajOPcaee7fxX9bHrgb0xcVnD6GHtSVQZ8Quq1LxzKiopsPoVxhd++0BdlhJ7Puzja4mE1Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWCgRII8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWCgRII8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF781C2BD10;
	Wed,  3 Jul 2024 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003364;
	bh=hWvNuHTn1sdQNKV1EoIG053vkxlSMFGEyk6YMYXpDQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWCgRII8MwwtiEXeu03FD1DevUCKw4sHqLntyLgxpDrfdX7NLA91kQ30kQ21iYD0J
	 zi/Sp1B+I6C8CoGJx0Rr6NLoAESpQMSXSqbSHYaXJDG329v6y+9gi5ms963d06Ovmt
	 J97GiwB3CBxiVZrnwTm1i7S2FD1ZV2iKuebBDcsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/139] tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB
Date: Wed,  3 Jul 2024 12:38:24 +0200
Message-ID: <20240703102830.713841952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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
index e3475f833f8fe..0cbfb57de0f07 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2242,6 +2242,10 @@ void tcp_set_state(struct sock *sk, int state)
 		if (oldstate != TCP_ESTABLISHED)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 		break;
+	case TCP_CLOSE_WAIT:
+		if (oldstate == TCP_SYN_RECV)
+			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
+		break;
 
 	case TCP_CLOSE:
 		if (oldstate == TCP_CLOSE_WAIT || oldstate == TCP_ESTABLISHED)
@@ -2253,7 +2257,7 @@ void tcp_set_state(struct sock *sk, int state)
 			inet_put_port(sk);
 		/* fall through */
 	default:
-		if (oldstate == TCP_ESTABLISHED)
+		if (oldstate == TCP_ESTABLISHED || oldstate == TCP_CLOSE_WAIT)
 			TCP_DEC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 	}
 
-- 
2.43.0



