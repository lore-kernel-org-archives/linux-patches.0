Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033357;
	b=bP4sOyhjU+N21YV5zRwDQH8TYQo6oAsmFGUzUaQj65SK8ix9Cg8cZUf4MXlZOqrXdRtT
	 jhoGnIEm7J0ja71LafLGIPOlMYrv3KrI93TWCTekngMHfo1U+FdAWLXkItO8P/adGNEF2
	 DdC7j1pLCjcM0FNmJU4T9dzSMwLqUX0MLPj9wcxYB4ZeKrXOcheqBkdliPgozWLzWo9+J
	 +mm6eyRXnPejgInsLLsDsWkqBHHtrROLRTbmOiXsK0TZl1Ixo2rfMgixZuitz0PkD5nv6
	 ndvi+tz2XXh+IivZ839Jz9/3dbf+8RwgQJajnVwdDaIhq6OMBPnxjnb8+8YbrAI+qEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3uwYR0QVMo8d+4hudvIwNsTBVWCaaS7FvhSx7JjUcE=;
	b=E7ahz117GlnvaJLRjk5aP5P2UPAAfsQQW+7bA7PGc1xz9hJzarQsKYW66S7oz9uLM+rS
	 k/d1kjmG08hs3BDzBNVZVoUXloC9Z5+OyTL46Ase0xwBALAH1o69hgIOvynQR+50dpKr/
	 OayvqI1ceThWqm21Bnza7c19IYMiHdbMF9p86KlO49PiJ1t9sCsk4GsD2V+RjTi7gy+Xs
	 1sp6Uegbw4MX1HXlYNPIl1aEBlkOdnSYE+eddFMVPBXv0R0HhtnrlyNrFIOBfKWCXPXmh
	 H0fkEzQiQ+zNEse/fawDHzejvAMnB+kYRUlME5hLv98jOF/GAIXeKM8fsPBMnUDisEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVo7QUKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A05606A320;
	Wed, 18 Nov 2026 20:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVo7QUKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554721F000C4;
	Wed, 18 Nov 2026 20:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033356;
	bh=v3uwYR0QVMo8d+4hudvIwNsTBVWCaaS7FvhSx7JjUcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVo7QUKpyY60O5XR+0/8O+e2n3FSGuWLYel/GWbERD9Usy/G8X3FB0ucJ+z5NGh1+
	 GapKw7nGwDtgHfru9oX3PMAuKhHnOXW7qKvPlaIOEaaW1OggEbdHJI0L/CPF2A9vBV
	 soVsYdjv5KLQ6CJCOy5sfrSbXsZmd9o8Dny88Src=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1697/1756] eth: bnxt: hand XDP frags over to the copybreak skb
Date: Wed, 18 Nov 2026 16:03:44 +0100
Message-ID: <20261118150117.216181069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 364b88b54fc260d22ee318bae862c2d7d8c31dc6 ]

With a multi-buffer XDP program attached, a packet only has agg
buffers if it filled its head buffer, which in page mode holds most
of a page. The program can still move the start of the packet forward
with bpf_xdp_adjust_head() and leave at most rx_copybreak bytes in the
head. bnxt_rx_pkt() then copies the head into a new skb, puts the head
page back on the ring, and calls bnxt_xdp_build_skb() on the copy.
bnxt_xdp_build_skb() only sets nr_frags and the skb's length
accounting, because it expects an skb built around the head page,
sharing its shinfo with the xdp_buff. The copy ends up with nr_frags
set but no frag descriptors, and the stack later reads and releases
whatever its frags array happens to contain. The real frags leak.

Copy the frag descriptors to the new skb in bnxt_copy_xdp(), so that
bnxt_xdp_build_skb() finds the frags where it expects them. The frags
now belong to the skb, and the head page goes back on the ring as
before.

Pointed out in LLM review of the first patch of the series.
Confirmed by reading the code, the unfixed kernel was not run with
the reproducer below.
Tested on a BCM57504 at MTU 9000 with rx-copybreak raised to 1024
and a frags-capable XDP program moving the start of multi-buffer
frames 3000B forward with bpf_xdp_adjust_head(), receiving 8000B
ICMPv6 echo requests (a head and two agg buffers each). All 60k
frames took the copybreak path with frags attached, the sampled skbs
reached GRO with len=4998 data_len=4492 nr_frags=2, and were freed by
the stack with the page pools' inflight count staying flat, no KASAN
or DEBUG_PAGEALLOC splats.

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dc2bc7a2de0e3..f30777268a59a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1378,6 +1378,14 @@ static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
 		__skb_pull(skb, metasize);
 	}
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		memcpy(skb_shinfo(skb)->frags, sinfo->frags,
+		       sinfo->nr_frags * sizeof(skb_frag_t));
+	}
+
 	return skb;
 }
 
-- 
2.53.0



