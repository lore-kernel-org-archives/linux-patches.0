Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015111304AD;
	Wed, 19 Jun 2024 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801972; cv=none; b=b5Y7IBs8ra2cYs09v+yvebbYm51yzIvxZpwrE2I++RRNvGkmcP5fdhj5+wBWfe3GRgrByBsTAHfy/Z+6F6twmPa8AI0Ql21S7xZ2h/4mWD9t/BIuDdJejAbx1wJx6baVYiu3JEf8S+g3iMs34qJsn/KJFZGYwdN4ingrj+1qono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801972; c=relaxed/simple;
	bh=q+L+fF48qE448ZMrd6NvaI81gyYalx5S55WdFVAjNUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUWMKSY+4+cS2T5QlTGTbscXva/pjiQtJE263GiMfb9ligilk6ZWYxFO/pxNLi6JXpsgu0csJcANwKEYjGTo4kGACQ+Bgfu1g3o8WGtHWSrnTN/i0t9Sy3Khnk2oMzhwi4lLZb3SblJ4qwFORwcE8OizT8FywHE8yPhdzr3GAho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q69r6i0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q69r6i0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD04C2BBFC;
	Wed, 19 Jun 2024 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801971;
	bh=q+L+fF48qE448ZMrd6NvaI81gyYalx5S55WdFVAjNUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q69r6i0pCmd4XwM2oW3BGq97Xc5UDkS0pdeNsdYYv2Lm4C/B7K+Gm9PbCzdCfgf3J
	 SvwQMIdDtvbEyfZ89E78JTh3ca59Qi0X8Na+EVrYxZZdEQm5gobxJSdfYH1kqkvxit
	 W+hHzgd8RgIDT/sPCom9VuatdLtBP6Fgcdlxkrf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/267] mptcp: count CLOSE-WAIT sockets for MPTCP_MIB_CURRESTAB
Date: Wed, 19 Jun 2024 14:53:09 +0200
Message-ID: <20240619125607.830760885@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 618d80112d1e2..4ace52e4211ad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2873,9 +2873,14 @@ void mptcp_set_state(struct sock *sk, int state)
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



