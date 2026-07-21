Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889BA39A7FD;
	Tue, 21 Jul 2026 19:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661096; cv=none; b=YM4KXTPHMQhU9kbpPrbbQ1riLC2rMhcq2jpG/jEN8gvlOwWk42Kb9WNboZU89q2HzjQ40qAyEVdVAePXuDSut2Vx5N6+yCfo9WIG/pA/Tp4XHSF9s35ZYKzSMLvsmkxOSws/QTxnZ/+G+DpAgI72pMUM6rtCahZy7/AaW32ZBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661096; c=relaxed/simple;
	bh=eq29pSejq/S92rB1qWf0QZ4BXiT8U9jvnoNvMAGet4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOM0s8r96GQ3y1HIGaOkgggE0/rQ3ueudhfjmctElU/tGbLeZdxmMizCnrYpJ5Gyt+5nveV6rFxGYFmQxFp6xi0OPwdk8Q9cuirUllYJEAjaCV5Y4b5IUMb3fI/jM4YEDqTkDzB6MZu/rRsNV5wWpc59gZ3iF9CokiBr1MaID+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKyZxmjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKyZxmjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E81F000E9;
	Tue, 21 Jul 2026 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661095;
	bh=OsMJlJux8o6tsb+OcmOpiXPiDeUAIvJNJxcb/f1UYAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKyZxmjlVHeNlPdKtH1MkTY9pQMmMORTIvGEgklbwhHzudvXZkRl7nco5ue2Fkqun
	 UMTqpi5fDDixB7dVl36kgWlPsDRXDXMDMUMfFC0oZocLinZh9p5duHZICs3iCtwkqH
	 JVFpreZoP6RBmcYkEp2T26quoDcAFD2Jd+14niGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1228/2077] netfilter: flowtable: Validate iph->ihl in nf_flow_ip4_tunnel_proto()
Date: Tue, 21 Jul 2026 17:15:01 +0200
Message-ID: <20260721152621.777426713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 84460b644329e25809b4a6d9279d6359d7fd8ebc ]

Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto() before
using it to compute the header size, avoiding out-of-bounds access with
malformed IP headers.
While at it, use iph->protocol instead of the hardcoded IPPROTO_IPIP
constant when setting ctx->tun.proto and reference ctx->tun.hdr_size
when updating ctx->offset.

Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e7a3fb2b2d9466..29e93ac1e2e400 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -326,8 +326,10 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
-	size = iph->ihl << 2;
+	if (iph->ihl < 5)
+		return false;
 
+	size = iph->ihl << 2;
 	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
 		return false;
 
@@ -335,9 +337,9 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = IPPROTO_IPIP;
+		ctx->tun.proto = iph->protocol;
 		ctx->tun.hdr_size = size;
-		ctx->offset += size;
+		ctx->offset += ctx->tun.hdr_size;
 	}
 
 	return true;
-- 
2.53.0



