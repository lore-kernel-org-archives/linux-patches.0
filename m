Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A486E51D524;
	Wed, 30 Sep 2026 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793345; cv=none; b=BYOo+zIiMbDlblO6SJmpf29Ge4te0Xswby7g+yGyTg2wLyaJ67uGqjbRMVmIXluwtocvacjhTN90JDXo6pAJh8od7hcNADrTgIu9y6Y3AGPXVJgGjCxf4IjC4RRdouU7cUlV3nQSzmG4WgWrcY4OKW5tU87rv2enTZ/lTtsRav0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793345; c=relaxed/simple;
	bh=8GNnfbRtoUDNhMtuPQGR191fAptQd765RkIn9/pIDTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP65N4xrUc3M4Y7mo1MUQEYDwwZvnAfwx3hH0eRDn4+rfHmdI2GGWXULyOyRMORw50aYumOwan3DU1s9KVPsWAngHpJVAdg4AP4/TAzmFd9Kts/EpMaqoa0YJjBVE+eTxoxGQuKSCpOOL9YY5kXKDeQgC9wcgF/c/2s5pFwavdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7s7kFDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7s7kFDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1BF1F000FF;
	Wed, 30 Sep 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793344;
	bh=r4b3otQMxq08He+QI6DyfnUtlOsdI99cRQAJ2Tn4bg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7s7kFDDRkmze2bXVqLk29S4WCjKPfN5tOiu+STaPdwPCRoWfuaj8uPoYCWOqK/u1
	 4rFNJmY2HhePuMz9/dwftyvAr/ZCuzw3eLYAy0GG2ZgI2GiYoxNhmmEgdj2ujF+qR7
	 Kd9Hc97B032NWrVoTAdMm0AtGJUJ4GRniduNZZts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Weiming Shi <shiweiming@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/395] tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()
Date: Wed, 30 Sep 2026 17:27:19 +0200
Message-ID: <20260930152344.489563452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Zhang <yilinzhang@moonshot.ai>

[ Upstream commit fe99bbeee5c5dbd3abc30721a8079ced59649d97 ]

When tcp_send_synack() replaces the cloned SYN skb at the head of the
retransmit queue with a copy, it frees the original with
tcp_rtx_queue_unlink_and_free() and only repairs tp->highest_sack.
tp->retransmit_skb_hint keeps pointing at the freed
skbuff_fclone_cache object.

The dangling hint is read in tcp_verify_retransmit_hint() and used as
the root of the rbtree walk in tcp_xmit_retransmit_queue().  An
unprivileged TFO client (sendmsg(MSG_FASTOPEN)) can arm the hint with
an attacker-supplied ICMP fragmentation-needed message, after which a
simultaneous open frees the armed SYN skb:

  BUG: KASAN: slab-use-after-free in tcp_mark_skb_lost (net/ipv4/tcp_input.c:1316)
  Read of size 4 at addr ffff88800604d928 by task swapper/1/0
  Call Trace:
   tcp_mark_skb_lost (net/ipv4/tcp_input.c:1316)
   tcp_simple_retransmit (net/ipv4/tcp_input.c:3158)
   tcp_v4_err (net/ipv4/tcp_ipv4.c:587)

Sync the hint to the copy.

Fixes: c31b70c9968f ("tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit")
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Tested-by: Weiming Shi <shiweiming@moonshot.ai>
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/8a9dff4063a2745653b7e88ceb745d75efa16e68.1790224474.git.yilinzhang@moonshot.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0cd46896e7983..3f9e11a43f35f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3821,6 +3821,7 @@ void tcp_send_active_reset(struct sock *sk, enum sk_rst_reason reason)
  */
 int tcp_send_synack(struct sock *sk)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
 
 	skb = tcp_rtx_queue_head(sk);
@@ -3838,6 +3839,8 @@ int tcp_send_synack(struct sock *sk)
 			if (!nskb)
 				return -ENOMEM;
 			INIT_LIST_HEAD(&nskb->tcp_tsorted_anchor);
+			if (skb == tp->retransmit_skb_hint)
+				tp->retransmit_skb_hint = nskb;
 			tcp_highest_sack_replace(sk, skb, nskb);
 			tcp_rtx_queue_unlink_and_free(skb, sk);
 			__skb_header_release(nskb);
-- 
2.53.0



