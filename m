Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7891422B8;
	Wed, 19 Jun 2024 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802792; cv=none; b=rZhEYpkxCXOUJ8fK1w6UOkDt4GD33MWD2AAmrUJblRkGtJ9VH+L2ddhG746qXZw+ufr7FlXJ64sC/64WJ9Ek04StaXj/c0K6BHGlmI6e7Z+0W2zz58/gjR8+0OHcRZH+3fbv/izR8SxZka+hHUaxsPmEz3T+yJqE/k9lBoJOKWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802792; c=relaxed/simple;
	bh=ix2UFgJ/vzbJUbiB9G2g7L06zmV8U69UgdUpuAiOq1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cshzN5+jNWf4o99saCq8EuM4bng7ZVaVoGHcmAu9/i6GqvPIV9dirEebi84UssfeUqEJzHbOMvASBDbfSt4K8/+CgKIG8X8PQwdIC0eTaOSFH3rzp8IIQwbZtz5LQsWxVF/b4Y9oLKw34f9rqp2I6HDaPMpR4JELJAois1jSmWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah9gE4Uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah9gE4Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD13C2BBFC;
	Wed, 19 Jun 2024 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802792;
	bh=ix2UFgJ/vzbJUbiB9G2g7L06zmV8U69UgdUpuAiOq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ah9gE4Uh/64tkjYVqN9iwl8Gc91mpK1den1eM+D+AgLT5jeSmIqIuWFGprTMSyQJC
	 3B2G8wdRM08pezGSry+yxjpWcZQNbR4suDTS6cKTdX/d8KY9OOs/mZi5ayf8idZ9SO
	 ydXqrNCIqN/leRDMiiIfGyggae+9Nc4/uUDhWRus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 041/281] tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB
Date: Wed, 19 Jun 2024 14:53:20 +0200
Message-ID: <20240619125611.430770651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5c79836e4c9e7..77ee1eda3fd86 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2640,6 +2640,10 @@ void tcp_set_state(struct sock *sk, int state)
 		if (oldstate != TCP_ESTABLISHED)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 		break;
+	case TCP_CLOSE_WAIT:
+		if (oldstate == TCP_SYN_RECV)
+			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
+		break;
 
 	case TCP_CLOSE:
 		if (oldstate == TCP_CLOSE_WAIT || oldstate == TCP_ESTABLISHED)
@@ -2651,7 +2655,7 @@ void tcp_set_state(struct sock *sk, int state)
 			inet_put_port(sk);
 		fallthrough;
 	default:
-		if (oldstate == TCP_ESTABLISHED)
+		if (oldstate == TCP_ESTABLISHED || oldstate == TCP_CLOSE_WAIT)
 			TCP_DEC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
 	}
 
-- 
2.43.0



