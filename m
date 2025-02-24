Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFC18A6C5;
	Mon, 24 Feb 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408037; cv=none; b=h+qLfCb2MHG6i+I3PChtzyImtEXFmBay+22WkehSCBX9XvOU9XVHKAgo140NxI/c2nI1rNAOv4SEnhfMZq+PZiBqrNsVAwFh/Gk9+PsMDyM5ldA7yv2S64QNPLE2Tu0sP/w4a1Woikg7HFwGzWyySIDmqpKCvNaQ+k2ma6jDE6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408037; c=relaxed/simple;
	bh=g54cXedRW49VRZLoHk2YxrN7yAaZei3PlruOTAPtivc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtpUANBmxyS5mV8KOthylvfPC+N0NGzeYlTchp/vmPT8SMnCamEcYKZeD9COdEX95X4WBR5/34FRkm+uLrhoMKw/LGG26w3wdDT7qbL30bbr8YSJx4+dYhs14jLYeouvOzOWKYUicsKPUFkWEmm2hKQ4XNgK6dZkacFKwTqy/ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GweNvWrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GweNvWrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D79C4CED6;
	Mon, 24 Feb 2025 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408037;
	bh=g54cXedRW49VRZLoHk2YxrN7yAaZei3PlruOTAPtivc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GweNvWrG5xjzHUhBcTiWeaXmd/gd0Fv11KbY6Up4u9ZM0pQidJI/ZPYVU/TYObLJB
	 MBk9I/6WXpMbsKvYI/nBoX+8W4ce8L2qx1QspGyYcC8QmSUutydxvtZJSOTQQiwNNE
	 6aXHybPHIaWkEqtyYVzVY56pzezc90wZF1ndqH7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/140] tcp: adjust rcvq_space after updating scaling ratio
Date: Mon, 24 Feb 2025 15:34:40 +0100
Message-ID: <20250224142606.194567095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f5da7c45188eea71394bf445655cae2df88a7788 ]

Since commit under Fixes we set the window clamp in accordance
to newly measured rcvbuf scaling_ratio. If the scaling_ratio
decreased significantly we may put ourselves in a situation
where windows become smaller than rcvq_space, preventing
tcp_rcv_space_adjust() from increasing rcvbuf.

The significant decrease of scaling_ratio is far more likely
since commit 697a6c8cec03 ("tcp: increase the default TCP scaling ratio"),
which increased the "default" scaling ratio from ~30% to 50%.

Hitting the bad condition depends a lot on TCP tuning, and
drivers at play. One of Meta's workloads hits it reliably
under following conditions:
 - default rcvbuf of 125k
 - sender MTU 1500, receiver MTU 5000
 - driver settles on scaling_ratio of 78 for the config above.
Initial rcvq_space gets calculated as TCP_INIT_CWND * tp->advmss
(10 * 5k = 50k). Once we find out the true scaling ratio and
MSS we clamp the windows to 38k. Triggering the condition also
depends on the message sequence of this workload. I can't repro
the problem with simple iperf or TCP_RR-style tests.

Fixes: a2cbb1603943 ("tcp: Update window clamping condition")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20250217232905.3162187-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f6a213bae5ccc..6074b4c3ab940 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -248,9 +248,15 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
 			do_div(val, skb->truesize);
 			tcp_sk(sk)->scaling_ratio = val ? val : 1;
 
-			if (old_ratio != tcp_sk(sk)->scaling_ratio)
-				WRITE_ONCE(tcp_sk(sk)->window_clamp,
-					   tcp_win_from_space(sk, sk->sk_rcvbuf));
+			if (old_ratio != tcp_sk(sk)->scaling_ratio) {
+				struct tcp_sock *tp = tcp_sk(sk);
+
+				val = tcp_win_from_space(sk, sk->sk_rcvbuf);
+				tcp_set_window_clamp(sk, val);
+
+				if (tp->window_clamp < tp->rcvq_space.space)
+					tp->rcvq_space.space = tp->window_clamp;
+			}
 		}
 		icsk->icsk_ack.rcv_mss = min_t(unsigned int, len,
 					       tcp_sk(sk)->advmss);
-- 
2.39.5



