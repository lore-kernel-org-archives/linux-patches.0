Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A93168C4;
	Mon, 27 May 2024 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837970; cv=none; b=UP2vZ/Qe19qrUojVGGYJ8/FNtwCwASwoTo6Nz3pzx7BgLUN/xBqfiiTr6Psf0eHPm9sNxPBTZytZ9XDANalFOZN7wa0sd7o9bHD6ZWAvM5FoxHeo6cBMk0hhoyStbXL4Q7YYe97K3tOGs5jb8R6mEEdwc8LCW94AIytDlOLUJ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837970; c=relaxed/simple;
	bh=2rpxb1BDFmcfg5DThzTNm/HOvqhqDeOJMJeXja+vGGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4An8SHsO06mlDUucOfnGtL0NMsdUE1KMG1YUb9IMhG8trNH9oUBeYKRjRdApICAlGsHCdp5azeMA0/pGt2xYO7vqzhKtoxh2apSILhC0coqEx0zu/4TBAyAQRIhmGc5KXWvk9ylE04Tyxd1Fy4OPvqIs4kN6jc8pccmKLgn+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj+pRr14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj+pRr14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA0C2BBFC;
	Mon, 27 May 2024 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837970;
	bh=2rpxb1BDFmcfg5DThzTNm/HOvqhqDeOJMJeXja+vGGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj+pRr14mEKK8MoI/hO+WNPteciSFEeHCEPvs2g5JSQ1LGHbDZp9d4vjqGGK1fCVE
	 tYhPVrEzkreJsKTf6OmaUJcV4XlhR5qCAEYixs6rEo/nioee3nzlgJeFCP6zfrua4u
	 0seq3EPficVO8ZGJ/X9Oc9gMe9rck5UK/ovtsyHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hechao Li <hli@netflix.com>,
	Tycho Andersen <tycho@tycho.pizza>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 214/493] tcp: increase the default TCP scaling ratio
Date: Mon, 27 May 2024 20:53:36 +0200
Message-ID: <20240527185637.319062086@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hechao Li <hli@netflix.com>

[ Upstream commit 697a6c8cec03c2299f850fa50322641a8bf6b915 ]

After commit dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale"),
we noticed an application-level timeout due to reduced throughput.

Before the commit, for a client that sets SO_RCVBUF to 65k, it takes
around 22 seconds to transfer 10M data. After the commit, it takes 40
seconds. Because our application has a 30-second timeout, this
regression broke the application.

The reason that it takes longer to transfer data is that
tp->scaling_ratio is initialized to a value that results in ~0.25 of
rcvbuf. In our case, SO_RCVBUF is set to 65536 by the application, which
translates to 2 * 65536 = 131,072 bytes in rcvbuf and hence a ~28k
initial receive window.

Later, even though the scaling_ratio is updated to a more accurate
skb->len/skb->truesize, which is ~0.66 in our environment, the window
stays at ~0.25 * rcvbuf. This is because tp->window_clamp does not
change together with the tp->scaling_ratio update when autotuning is
disabled due to SO_RCVBUF. As a result, the window size is capped at the
initial window_clamp, which is also ~0.25 * rcvbuf, and never grows
bigger.

Most modern applications let the kernel do autotuning, and benefit from
the increased scaling_ratio. But there are applications such as kafka
that has a default setting of SO_RCVBUF=64k.

This patch increases the initial scaling_ratio from ~25% to 50% in order
to make it backward compatible with the original default
sysctl_tcp_adv_win_scale for applications setting SO_RCVBUF.

Fixes: dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
Signed-off-by: Hechao Li <hli@netflix.com>
Reviewed-by: Tycho Andersen <tycho@tycho.pizza>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20240402215405.432863-1-hli@netflix.com/
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f6eba9652d010..ab62e53f187c5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1494,11 +1494,10 @@ static inline int tcp_space_from_win(const struct sock *sk, int win)
 	return __tcp_space_from_win(tcp_sk(sk)->scaling_ratio, win);
 }
 
-/* Assume a conservative default of 1200 bytes of payload per 4K page.
+/* Assume a 50% default for skb->len/skb->truesize ratio.
  * This may be adjusted later in tcp_measure_rcv_mss().
  */
-#define TCP_DEFAULT_SCALING_RATIO ((1200 << TCP_RMEM_TO_WIN_SCALE) / \
-				   SKB_TRUESIZE(4096))
+#define TCP_DEFAULT_SCALING_RATIO (1 << (TCP_RMEM_TO_WIN_SCALE - 1))
 
 static inline void tcp_scaling_ratio_init(struct sock *sk)
 {
-- 
2.43.0



