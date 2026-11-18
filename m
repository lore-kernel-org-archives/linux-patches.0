Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021322;
	b=WqQn7zevvizq8pPpyl70lSTdS5sd7cKV3iJqm91nR8YU4WdOILEGehtpCqXXODQJ7Bt6
	 TlKh+9v50e7814dehqMGlTIkUOFI7ovQkJolEkr+l114AU59POpnm/zff3bkWHsz2Baac
	 PtrsNRNalHuhDIilj9hmjRIUSjaEu9DIhlCNqFXdZguZIZF+i+GOJjhYPVKV4e4DvrLJH
	 0uthxj21XX61bDeBmloWvtajcosNIK9GtfCQWW3jll3b23nhx9rJTI2v8L0bi3pghjt4c
	 dUVicWyQSX9nwzuIYIlJUgcwN5gtgrfPXDuVaJAVKQjmKLM6w64dV5EFhud2jHs7BKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXyT+2tnmVDplOULH4s156LlRYBCsVTVHpoKYJuR6r4=;
	b=oqB+dxWa//5WRxT/YmyAWJBqAHNDEc327U3OUzwqtwM36r06KL/uyMKfj9ClybEWj1LI
	 4ZqbB8iPmPhlJAseSuup+QFAItmq97aBLDAysQ0m4YXUn+e4MuT2lZ4gpyzyNpnnVgDHQ
	 n5O+G8PrL9Cx6m1MBRQoY+yxeyqklP5Ptv9mDQhvwbxfyob5wdD6kyUzrBEBFIpv4m9Ae
	 trefHc21EOJDYG2O+6sC2UX+nuQVBvlIX5WEls0TiywCF1DYGyYdBE0+Kuk4KhQzn7eT7
	 b2mHsjCencepR9ch60FYGNxb2WGOsy6gl5eDlaUWR3qYlII0h1w6k276apuBJchO2Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HADwgFn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061E606A320;
	Wed, 18 Nov 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HADwgFn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB751F000C4;
	Wed, 18 Nov 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021322;
	bh=eXyT+2tnmVDplOULH4s156LlRYBCsVTVHpoKYJuR6r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HADwgFn4dYVYqgIM/4lcKPa9GYWP0PXxSUEKs44mlQc3NVsuJvRqDL/+0ya99+o2K
	 PCH3FSY07NEKNSu1dRpD/kqvMr8/QdRE7O2MDYEyJNVdtx+//0IX1UptJVKzH9xAis
	 bJhtgRibqVCnBGYhpNE00jocopaZbCmhu4LISkyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2265/2651] ip6mr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150406.930741232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index ed9d786f1a423..8e647213ade1b 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -652,6 +652,12 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
 
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



