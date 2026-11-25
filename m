Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622697;
	b=inYR4oHXd7xk0QIkIzib9tqajAY+7RmwFeRh3M6CzgiWVTr/Osx91BXRTjbxfrmHfvJ8
	 LsrbyUxT9F4R0Be0h36GAa+ZKaHM1kPjdNWf1haKMiCB/hXWBphbCfBUjtDgJY0Z9QsgU
	 q1oxg4PVRzxeIe8ARwTCcXCxtCz2GTqyk7OWe42S6E2KQWxRDZ+3NCN13WC8bB7ylU0YU
	 1o6gyRTlminXsMgWvz4dNw6GyNixKP0oMxah7s0GUUskxYHS4w1hDARpamXO0wYF0aseU
	 YrSZd8FG+5cGDW3TUaX5NHQTWkkZqoHE4NnVSlQ07Ccrka0FVPpbUt6pX/J9Ayo8tmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+QV0vgPPWLnAgHIrd8Fq5o4VbPIZS7wszZua1EXiW40=;
	b=lLYeaOrIrpN/LZH7PtWq51xX38AtGIsouIctuvR3/qfkewmihRzg+1S09/S9n5BRxdym
	 p9kv1YFNR6xKxQvdc4UkmkhlQHVrJLn+jHD3xFIF8IJcwYuQk28KfBsdgFyX6mZRBuT71
	 7Nsr184MXzjv9pRkGFs2pipwcDCkawNzVd/AGNGanJsndOml4fqx672bpks6U+DI3UFi0
	 UB8+9pYc+R6FGyo3i7ZD880gXMvZ8jdtz2y5VF8ThvDQnEudal2gd9i7oi79FujkvJzOl
	 uX1UIUwmUFbhvBvBo0vZ9/Ryf+gN9Pj9Z8G4yYV61BTSYm3dwfngxPC+7ZarxTZho8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZwaXQlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AF4606A323;
	Wed, 25 Nov 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZwaXQlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477371F000CA;
	Wed, 25 Nov 2026 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622696;
	bh=+QV0vgPPWLnAgHIrd8Fq5o4VbPIZS7wszZua1EXiW40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZwaXQlvfIVMXjjWhHIaYB7JSCQTunZdoEh/9tCsbq13qolIiTElNzhj15FsbMJYC
	 f7KCOn594B15lyWMjsy4pAwQF0UKTPp7bdHKoxOQ5/LJR+Y/qO5LgwnUcQFXMCUkIW
	 IrbXZLZDXzWej8syRIRm5yTfNx4LCuOOWls/LLMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 619/990] ip6mr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 25 Nov 2026 15:33:06 +0100
Message-ID: <20261125143836.599064004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 238164201431a425e48dfcb8e9a59de63caf175b ]

reg_vif_xmit() hands the skb to ip6mr_cache_report() as an
MRT6MSG_WHOLEPKT report. skb_realloc_headroom() copies skb->cb[]
into the report, which is queued to the mroute socket, where
rawv6_recvmsg() reads it as IP6CB.

By the time the pim6reg device transmits the packet, skb->cb[] is
not IP6CB anymore: qdisc_pkt_len_init() overwrites iif and ra,
and any qdisc installed on the device (fq, fq_codel, pie, cake...)
or a tc BPF program writing skb->cb[] fills the area holding
dst0, srcrt, dst1, lastopt and flags.

Since commit dd433671fef3 ("ipv6: validate extension header length
before copying to cmsg") these stale offsets can no longer cause
out-of-bounds reads, but the mroute socket can still receive bogus
IPV6_PKTINFO ifindex and extension header ancillary data.

Clear IP6CB before building the report. The skb is freed right
after, so nothing else depends on its control block.

Fixes: 14fb64e1f449 ("[IPV6] MROUTE: Support PIM-SM (SSM).")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Kept the branch's rcu_read_lock(); line as context and inserted the upstream memset and comment after it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 53837248498a6..5a49fb4ae4513 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -629,6 +629,13 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
 	rcu_read_lock();
+
+	/* skb->cb[] holds qdisc/tc state at this point, not IP6CB.
+	 * ip6mr_cache_report() copies it to the report delivered to
+	 * the mroute socket, where it is read as IP6CB.
+	 */
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
 	ip6mr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
 			   MRT6MSG_WHOLEPKT);
 	rcu_read_unlock();
-- 
2.53.0



