Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A03D9045;
	Wed,  8 Apr 2026 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674389; cv=none; b=k9UKYLaVq8xzjg6pZCVF06lmpQffUV6Rb2ABRe4f87Zomg1FKi0NH5D7mm8GRFVuZydH9DJ/IAYGQ+bBEfr0UZ2p2G4sZT8bMh/V2TiF7WiPw6tALfaPIUKJmkMXq32tZ6LQVJHXFsi/HmUfiZfhdOMi+t7WXDerdAtGQYJUdnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674389; c=relaxed/simple;
	bh=dv8H4e3CUbIE+t7vyxYnQw+vPpdkCxGH/i34FOOCmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdkRZ6iyBO1x+vBrAPFQys53q96HADw5xy3Bi6dC75cyTITRtv1b871jLGaSwyA1h6FzJSkDUxGBQnuEwroNWzxe79eR2GZLywRPRh0grrggqjsi6RDJNcqts5Ie8uqBP0My2plMHBqRSef45ljN8BEnzLiVtGR1zi2BTOCKuQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9npMfGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9npMfGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14046C2BC87;
	Wed,  8 Apr 2026 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674389;
	bh=dv8H4e3CUbIE+t7vyxYnQw+vPpdkCxGH/i34FOOCmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9npMfGcIu3L2/ybV3yXJB6CsRB4HmhySj2Bmpnk5Jqs8j1N5ONoGlnDhR9+IItOA
	 3T3Vhe0RWFY79y9cSdIRQe5Pya5MUzBjmBDtEkCkTjsga75zfqPUhYkTf6J4t7ek9A
	 E93yyEHoCowlRXfG0H7PuXGqcvLUNF3n9drpfCqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 079/311] mptcp: add eat_recv_skb helper
Date: Wed,  8 Apr 2026 20:01:19 +0200
Message-ID: <20260408175942.363741192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 436510df0cafb1bc36f12e92e0e76599be28d8f4 ]

This patch extracts the free skb related code in __mptcp_recvmsg_mskq()
into a new helper mptcp_eat_recv_skb().

This new helper will be used in the next patch.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260130-net-next-mptcp-splice-v2-1-31332ba70d7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5dd8025a49c2 ("mptcp: fix soft lockup in mptcp_recvmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index bad9fc0f27d9c..a29f959b123a4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1989,6 +1989,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
 
+static void mptcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	/* avoid the indirect call, we know the destructor is sock_rfree */
+	skb->destructor = NULL;
+	skb->sk = NULL;
+	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+	sk_mem_uncharge(sk, skb->truesize);
+	__skb_unlink(skb, &sk->sk_receive_queue);
+	skb_attempt_defer_free(skb);
+}
+
 static int __mptcp_recvmsg_mskq(struct sock *sk, struct msghdr *msg,
 				size_t len, int flags, int copied_total,
 				struct scm_timestamping_internal *tss,
@@ -2043,13 +2054,7 @@ static int __mptcp_recvmsg_mskq(struct sock *sk, struct msghdr *msg,
 				break;
 			}
 
-			/* avoid the indirect call, we know the destructor is sock_rfree */
-			skb->destructor = NULL;
-			skb->sk = NULL;
-			atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
-			sk_mem_uncharge(sk, skb->truesize);
-			__skb_unlink(skb, &sk->sk_receive_queue);
-			skb_attempt_defer_free(skb);
+			mptcp_eat_recv_skb(sk, skb);
 		}
 
 		if (copied >= len)
-- 
2.53.0



