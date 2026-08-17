Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5443CE64;
	Mon, 17 Aug 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978418; cv=none; b=jimqFg4agL1tmZsUWB0Dm3CVU6PSw+252xfWr5WIR09sXbV5WaLoWMgKJUxLfieBu7ZQZ75SRpHQTEbIDDargGIZ9tSRI4xuaV9yO2hPjMAzYD3z3b2P9yMmxYCDhj1RreqgCShfPhDRXa5wDAx6R+qeqfzc5ym4rm3hY8R2XDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978418; c=relaxed/simple;
	bh=8jcLbmraapeTGNQSIS0dfRCZUMyfahzjlHImapZB7Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml5oWLj+UJWtkpY4+jZIAurFNToj950DQdQY+bJIGNzwlY6ygiG7+RRRZMQ0a/QLQSf8EoUwPKHUdokysh6LoS5MV6satRHnyfT7mjOIws9vi7hLloIDou2ES2RvhWuHTFdLskUFEUY8X6AeFAQi2gfOnjNsfGh7O5HQzaRSuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkMBDrta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkMBDrta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D071F000E9;
	Mon, 17 Aug 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978416;
	bh=xUIDqPsosNx2DE8+c/QEkGLKu+/+d+okIEz+4EuZZVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkMBDrtaRSKAdTZlk2n5GXy92jm5RGfrWAjR1o6ss1PU3wwEx9fzzxDLDHZAP8T1f
	 xuLIpxmC8VlVHNkR+PTt19+5Tp0Z7pBAKogqF8vKcaYMDJZuMCfSstHgT3ozsiQaFp
	 FbLSHFtygyG+nMvJI50PjrxOZ8G/Sp+7MCXmMnmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Gao <zcgao@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/156] tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()
Date: Mon, 17 Aug 2026 15:32:43 +0200
Message-ID: <20260817132535.764217508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Gao <zcgao@amazon.com>

[ Upstream commit 0e125ecfe20c077625cf0be8d750d5c3abc0dce9 ]

Commit f5da7c45188e ("tcp: adjust rcvq_space after updating scaling
ratio") replaced the direct window_clamp update in tcp_measure_rcv_mss()
with a call to tcp_set_window_clamp(), a helper that implements the
TCP_WINDOW_CLAMP setsockopt. As a side effect, the helper also shrinks
rcv_ssthresh via __tcp_adjust_rcv_ssthresh().

As a result, each scaling_ratio decrease detected by
tcp_measure_rcv_mss() also cuts rcv_ssthresh. Elsewhere in TCP,
rcv_ssthresh is usually cut under memory pressure and grows via
tcp_grow_window().

Flows whose segment sizes vary keep scaling_ratio oscillating, which
leads to an unstable rcv_ssthresh: a dip of rcv_ssthresh only recovers
via tcp_grow_window(), keeping the advertised window at a relatively
low level even after the ratio itself has recovered, and can even stall
the sender.

Observed on a customer's proxy gateway after upgrading from kernel 6.1
to 6.12: in the worst case, rcv_ssthresh was cut in half by a
scaling_ratio dip. P99 latency jumped from <10ms on 6.1 to ~100ms on
6.12, and almost returned to the 6.1 level with this patch applied.

Restore the plain WRITE_ONCE() update of window_clamp, as introduced
in commit a2cbb1603943 ("tcp: Update window clamping condition"), and
keep the rcvq_space.space adjustment. Now rcv_ssthresh is decoupled from
scaling_ratio changes in tcp_measure_rcv_mss().

Fixes: f5da7c45188e ("tcp: adjust rcvq_space after updating scaling ratio")
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Link: https://patch.msgid.link/20260725030806.28135-1-zcgao@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eb1bf58634741..9efb84658a82d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -252,7 +252,7 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
 				struct tcp_sock *tp = tcp_sk(sk);
 
 				val = tcp_win_from_space(sk, sk->sk_rcvbuf);
-				tcp_set_window_clamp(sk, val);
+				WRITE_ONCE(tp->window_clamp, val);
 
 				if (tp->window_clamp < tp->rcvq_space.space)
 					tp->rcvq_space.space = tp->window_clamp;
-- 
2.53.0



