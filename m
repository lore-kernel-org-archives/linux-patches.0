Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FE93EEAD8;
	Wed, 20 May 2026 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302605; cv=none; b=O9pVi9NOeX6C9kg5Bnny6aQI2gLjMoz9zKaejClmryz8UgLgmtLmQe3osynLD2FPmF/NvSR0uRkJilyke0DfucBClyTDId45QACAq1PHaszehMjeLSY5Y/Eeo1zLzIVsZd0Uwvg36ddy3geSkYp39qwPJkX9ADFgo58p3DsFIOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302605; c=relaxed/simple;
	bh=Jgmw+15yFXFuHUA4SycnRh99EHW+WxCVaMDdh/GVdnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0qqrtq59yfPA3cOjO4Ct4DBTdKOKPKKj/LSaKoCg1ZaMHu7XIEz3A0OwT7DDdCMEMmdEr6/lLm91Xp5sljQiAWbdQUuSDWARbSex33tPlOnlT+sNDcBzVTuMKl94D7Ebq+1UYv+ctf9PDsf8p+/wc0IafIiMlW765Z8YXthzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjaODJvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjaODJvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF6F1F000E9;
	Wed, 20 May 2026 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302604;
	bh=CTCh/L4hqYXZSbkXNyTlDvaiGtsHyULNz1eESWRB3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjaODJvJ7NeI5f5VgYKXO0ngWyxQlxuf5k6+zStgQB4gWbzMnws6dimKWO6X1Gn5M
	 wlO7ESgtwvaU5SqsoyedBPt6j3FX+JDnahh88KdgS9Tv8DYd4VCKDyHFBBAw9IgJoy
	 IMbX7DT9xRzKrx876ZPGeMyYofnwGvbx3qu137m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/508] netfilter: nft_osf: restrict it to ipv4
Date: Wed, 20 May 2026 18:22:32 +0200
Message-ID: <20260520162105.762126173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b336fdbb7103fb1484e1dcb6741151d4b5a41e35 ]

This expression only supports for ipv4, restrict it.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 123b4f47ccef4..23ec9b397f1eb 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
+	if (nft_pf(pkt) != NFPROTO_IPV4) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (pkt->tprot != IPPROTO_TCP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
@@ -119,7 +124,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
 	case NFPROTO_INET:
 		hooks = (1 << NF_INET_LOCAL_IN) |
 			(1 << NF_INET_PRE_ROUTING) |
-- 
2.53.0



