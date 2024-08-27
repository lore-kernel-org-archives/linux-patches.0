Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592681C8FD8;
	Tue, 27 Aug 2024 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770571; cv=none; b=Vl/Q1X+g1xRtn+6D0HLVG4PjfrlRk2FZ9wzmvPudQb5RjxMK+Yai6UHh703j9r0OMIsjHvr2dFGgnfdlzl+a1KumM1HKvXv0aPUnK2uC0roWKm+goe910HbC62RpfrKSF7zE686iccm7sDI8Wxc86PiwIii/nSFxHvZz9qpXNOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770571; c=relaxed/simple;
	bh=QI8CaOqZl4juXikLPrlLfAgmSKL3Ts+rlrShzAI3qsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkvJg1dK4AJa/ITkd4PNVOCrJlb9kWR5aVjV+TWCww5c+3GxkBZjlSESKJkmEZuFc8YXfpnw5ae8keNLdwFzWw43hZyexF9u01pOWVfb/gVZ9xjfO0/sg6Ra1yPtk1uSTKwLxKkEDk4xapmwwqVmmXGHD56FHcTkjyLWl8jrWxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4gDU3YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4gDU3YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C045CC4E699;
	Tue, 27 Aug 2024 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770571;
	bh=QI8CaOqZl4juXikLPrlLfAgmSKL3Ts+rlrShzAI3qsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4gDU3YArGaQmgNoi09bDJK3mDE7UYUoJodkCXFNNARe0p5GFZAu2OVcYP6ev6dqq
	 o761g7SLu1ohYSclHo2mF974pCDqT3Z6q5kpQaKPJNAR36+X+TE3gtgUx4UehKKde4
	 q8eC86MuGKgIh0vEps51iZn1m0sPbtIV/PZR59i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/341] ipv6: fix possible UAF in ip6_finish_output2()
Date: Tue, 27 Aug 2024 16:38:20 +0200
Message-ID: <20240827143853.638732036@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit da273b377ae0d9bd255281ed3c2adb228321687b ]

If skb_expand_head() returns NULL, skb has been freed
and associated dst/idev could also have been freed.

We need to hold rcu_read_lock() to make sure the dst and
associated idev are alive.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8d4aaa4029b3e..9cff86c01abca 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -70,11 +70,15 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOMEM;
 		}
+		rcu_read_unlock();
 	}
 
 	hdr = ipv6_hdr(skb);
-- 
2.43.0



