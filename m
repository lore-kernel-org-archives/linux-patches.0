Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6F514770;
	Wed, 30 Sep 2026 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786572; cv=none; b=OIebUtQJpwPUtZ9dBDq3xnWLCM4fYZA7vtfH3+pNU/lrhduxLv9znSmFvMGuQplvZP/I0s61TMNeCVpRXVr8VIMzJ67kyVTBSSp3SOpPf24hDZ1YhaCbVf2KyoJ7c6fCyr1hr19NBgc2dsvqz2qGswArTkqxndJicnmyawT3ZQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786572; c=relaxed/simple;
	bh=Yc67m/HjDQJXL1WKhJX/GxFSfnyz09/Gxk/XI9yck8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSkPz4h/Ji+lXOzcWH1ax1M3PxCpMvy2Tdft6+DYhu2/fDIsFkoBYWS/F1qnIqveM9M3MygWTr3OFusKBCrTxHne6bfe/kRhlPUwRu0heuP2xp6Ef6CJPjroXwNibikHbIwS/LCSrM2TbmCxY9CNQjWsRoe8+xK7YXTKTu3Qwfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRdBK1gM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRdBK1gM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAEF1F00898;
	Wed, 30 Sep 2026 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786571;
	bh=VpEaFLs3YiC6helhyaZuVdEGHRfAuY7f0JwFc+p/qNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRdBK1gMzfx+zzTtqao5qFpRScqgAJhF9aALubiR7e+SaEYWJSuMOsvCD52j2CbwP
	 RYu6HUb9VdZbLjQZlOeci/ZfMhqEYBNlyxm+KEPWMjngrsrmLzh5hqcsQJSoQAk1ty
	 u0DNV7TvXg9Ke8pJql+oulo35dpPbH/uYnGIoGrU=
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
Subject: [PATCH 6.1 908/982] tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()
Date: Wed, 30 Sep 2026 17:27:24 +0200
Message-ID: <20260930152436.243819861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 256e0a755d544..39f25b886678c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3551,6 +3551,7 @@ void tcp_send_active_reset(struct sock *sk, gfp_t priority)
  */
 int tcp_send_synack(struct sock *sk)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
 
 	skb = tcp_rtx_queue_head(sk);
@@ -3568,6 +3569,8 @@ int tcp_send_synack(struct sock *sk)
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



