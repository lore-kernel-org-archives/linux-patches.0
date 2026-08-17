Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A933DFC6B;
	Mon, 17 Aug 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974804; cv=none; b=nhBzEpNyzh0gBGN2irr/xGeQnQlaNHMtpMShijfTiFA5zqhpMOeyPBEumxQ2SCeAf7OnJVP1fF/6MJ48mvushbfCt9HE6BoFKDIt9YwZnrdEKdj7M4ssiLkxs4Lqa3YmbWzcSysHH5C03vOW2pciaSa8660TNOS5SifLhCjsyJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974804; c=relaxed/simple;
	bh=6Iv5vQAnWQ3BXROrZLU5ROs083kcce6vjCdoSSxoyKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OneF5vxsY5fALEWjErtVZ7A4HdT2z1NUi5SWrJiO3RFjggsWgnGEIo1yQJ04Pod/qD63TC1jP1p9QIzc1lHcOrEx9FWeogT7Cec3gEnwpw/cC4JDcgF5NztReLNHCyHi3Og3pGMRm2xm/aX/4MGYYYr+uupdU5tWkUzlM3rE97U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLr/bS++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLr/bS++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8591F00A3A;
	Mon, 17 Aug 2026 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974798;
	bh=g2gK1DHMLmkZBEz1mEnSETProKlCnzKp6QxGGRIz23s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLr/bS++UylPTrcYcacccBvrv++3DzXYnffunlRNZiWk9S9xZaguHVSlvHPhFYiQy
	 Svx9X8dwforeC0K/vuhWv5JqSzpTe3pyCIW0/gbiGXSbdvBPPynVDZu3+QWUK+GEtY
	 3Sc5TSvwnwUoU2DoJodAiGah4Il3cBqzOSdMApl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Gao <zcgao@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/250] tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()
Date: Mon, 17 Aug 2026 15:30:18 +0200
Message-ID: <20260817132538.768439173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 8c74fbeb771d5..c1769031a9e93 100644
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



