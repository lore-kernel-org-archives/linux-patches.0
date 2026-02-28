Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2676633F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301226; cv=none; b=Fs8qBH5mDGESRB6FC+IAS3FueQmDtO7itnZCukMWeQWpSzxy06YPWkXU/Q6qozGT2aRhmQZbbiHSAZ4iE2zR7YsRRZVzmEhGC1EH4/cD3JW0x5DpufF2JlnnFN5DXpbmhaRF5E1YLZRC99OPs6gW9xMytaq6Et0oiTkH8od+uCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301226; c=relaxed/simple;
	bh=ahClua513v1BYBOWnQsG51rWQCshabuM8q6GobUxhG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq94t+FHbncpA2EIthWnc3wahKDduA1chQ+4jMB+mpPjwC+CWiSIHJVhE+gBS8MU0H1aepRQF83EMclvqXNnIgznwoEtPPpaQ6AHWibp1rgNvgdJ6D8RCtzAuGnymdUHyim3qp6v/0VHZhi9PX9CA7NcsYfqLdOrHGhZTiSjLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1QFvuR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1QFvuR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CE7C116D0;
	Sat, 28 Feb 2026 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301226;
	bh=ahClua513v1BYBOWnQsG51rWQCshabuM8q6GobUxhG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1QFvuR0mgTnJX/raomP27caxCbeUjmOcsSYcdsqiQlFj+ovHYYy1Bs3w/JeU7U9Z
	 deIDz0Xx/58xqdhug5X1JDVxXsHW22yZTIQg0pUm8uktbEt+dFMkTaBEFI12tKi/WA
	 EhkbkfXu5eq0J1NZdteG4FsS6AnB1/+awt9mrCyML70J1f1owpFle0KS66RRXjpqVt
	 fgTpGAzZHgQ/aiMb59cVu+xoTYomcADZMipurYDDiZrDalLs4Ac8w46mmPLM+iep5g
	 yK9HaxKlb0c9sIKKs4Q0Mhmns8jsZDSBigrTUQ56T9ghnmx4VxGX1kiKVdU5e0ffwX
	 mONsRkCirVEww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/752] psp: use sk->sk_hash in psp_write_headers()
Date: Sat, 28 Feb 2026 12:41:54 -0500
Message-ID: <20260228174750.1542406-403-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f891007ab1c77436950d10e09eae54507f1865ff ]

udp_flow_src_port() is indirectly using sk->sk_txhash as a base,
because __tcp_transmit_skb() uses skb_set_hash_from_sk().

This is problematic because this field can change over the
lifetime of a TCP flow, thanks to calls to sk_rethink_txhash().

Problem is that some NIC might (ab)use the PSP UDP source port in their
RSS computation, and PSP packets for a given flow could jump
from one queue to another.

In order to avoid surprises, it is safer to let Protective Load
Balancing (PLB) get its entropy from the IPv6 flowlabel,
and change psp_write_headers() to use sk->sk_hash which
does not change for the duration of the flow.

We might add a sysctl to select the behavior, if there
is a need for it.

Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-By: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260218141337.999945-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psp/psp_main.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 481aaf0fc9fcf..53c0313633689 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -165,9 +165,46 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 {
 	struct udphdr *uh = udp_hdr(skb);
 	struct psphdr *psph = (struct psphdr *)(uh + 1);
+	const struct sock *sk = skb->sk;
 
 	uh->dest = htons(PSP_DEFAULT_UDP_PORT);
-	uh->source = udp_flow_src_port(net, skb, 0, 0, false);
+
+	/* A bit of theory: Selection of the source port.
+	 *
+	 * We need some entropy, so that multiple flows use different
+	 * source ports for better RSS spreading at the receiver.
+	 *
+	 * We also need that all packets belonging to one TCP flow
+	 * use the same source port through their duration,
+	 * so that all these packets land in the same receive queue.
+	 *
+	 * udp_flow_src_port() is using sk_txhash, inherited from
+	 * skb_set_hash_from_sk() call in __tcp_transmit_skb().
+	 * This field is subject to reshuffling, thanks to
+	 * sk_rethink_txhash() calls in various TCP functions.
+	 *
+	 * Instead, use sk->sk_hash which is constant through
+	 * the whole flow duration.
+	 */
+	if (likely(sk)) {
+		u32 hash = sk->sk_hash;
+		int min, max;
+
+		/* These operations are cheap, no need to cache the result
+		 * in another socket field.
+		 */
+		inet_get_local_port_range(net, &min, &max);
+		/* Since this is being sent on the wire obfuscate hash a bit
+		 * to minimize possibility that any useful information to an
+		 * attacker is leaked. Only upper 16 bits are relevant in the
+		 * computation for 16 bit port value because we use a
+		 * reciprocal divide.
+		 */
+		hash ^= hash << 16;
+		uh->source = htons((((u64)hash * (max - min)) >> 32) + min);
+	} else {
+		uh->source = udp_flow_src_port(net, skb, 0, 0, false);
+	}
 	uh->check = 0;
 	uh->len = htons(udp_len);
 
-- 
2.51.0

