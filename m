Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DCE143C43;
	Wed, 19 Jun 2024 13:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802824; cv=none; b=bmrJMBaj7rOWJTlSu9elOjqTyQoi7GT3oYMe8HsrVzbbOLnWubVU6tbe4+WLEA0UO/vsmLaqx+KJhw74GrkXAno5A96Wy5DH5wuIQh2FENuSnP4IabpT7225V/zePVKpz8CWEliYUbcqscQche3k4uqqod04vfb7hw0zhNHnico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802824; c=relaxed/simple;
	bh=X0ITvkp09mwsQdM8lj1Z7XMjrLa0z1LkyFsfNXMAecU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF2wBf0dxIJu9NObutXbzgt1Bvr4/0Wt99GNyzQorUnn+6ANx7Rv3SXjEWBXgxVGXBFVcSdhU6vmAzH1UNqJGgRNS407kY9yjLLqFv+VfWVmpXhHQqQ4IrIYB35fxiSVfbUgl0Qqy37H2Thkq7ulqTX5foICXeONotj3TpfW+5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vi1Bw1rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi1Bw1rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DFAC2BBFC;
	Wed, 19 Jun 2024 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802824;
	bh=X0ITvkp09mwsQdM8lj1Z7XMjrLa0z1LkyFsfNXMAecU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi1Bw1rlo9xLO6Rywj23U9WF7uXt88b47+LbJELKj9paAa0ns07DOcr5wm4UNv1eB
	 LyGmBCIuzo6o9vb35OoJuDB8GpviE/wiT45nmHsnm9NO3B04DpHKmPbDQ11kW3OeKr
	 04aeR9JBoPYeyj6IpCIIuk2Gk9U8iDS+wVbl3vTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 042/281] mptcp: count CLOSE-WAIT sockets for MPTCP_MIB_CURRESTAB
Date: Wed, 19 Jun 2024 14:53:21 +0200
Message-ID: <20240619125611.469095866@linuxfoundation.org>
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

[ Upstream commit 9633e9377e6af0244f7381e86b9aac5276f5be97 ]

Like previous patch does in TCP, we need to adhere to RFC 1213:

  "tcpCurrEstab OBJECT-TYPE
   ...
   The number of TCP connections for which the current state
   is either ESTABLISHED or CLOSE- WAIT."

So let's consider CLOSE-WAIT sockets.

The logic of counting
When we increment the counter?
a) Only if we change the state to ESTABLISHED.

When we decrement the counter?
a) if the socket leaves ESTABLISHED and will never go into CLOSE-WAIT,
say, on the client side, changing from ESTABLISHED to FIN-WAIT-1.
b) if the socket leaves CLOSE-WAIT, say, on the server side, changing
from CLOSE-WAIT to LAST-ACK.

Fixes: d9cd27b8cd19 ("mptcp: add CurrEstab MIB counter support")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 965eb69dc5de3..327dcf06edd47 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2907,9 +2907,14 @@ void mptcp_set_state(struct sock *sk, int state)
 		if (oldstate != TCP_ESTABLISHED)
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_CURRESTAB);
 		break;
-
+	case TCP_CLOSE_WAIT:
+		/* Unlike TCP, MPTCP sk would not have the TCP_SYN_RECV state:
+		 * MPTCP "accepted" sockets will be created later on. So no
+		 * transition from TCP_SYN_RECV to TCP_CLOSE_WAIT.
+		 */
+		break;
 	default:
-		if (oldstate == TCP_ESTABLISHED)
+		if (oldstate == TCP_ESTABLISHED || oldstate == TCP_CLOSE_WAIT)
 			MPTCP_DEC_STATS(sock_net(sk), MPTCP_MIB_CURRESTAB);
 	}
 
-- 
2.43.0



