Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22857320CAD;
	Sat, 30 May 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163968; cv=none; b=XCYYT7b+l7+sdGpmxWNqdGLVmOrpZhIh3s8tXrWHb9FT9dFHvgt0Iuw14UTjedPBoCHHkDMV7YjpEbORBl0GRQx4aiuE1LVcbfsMOTLPz/qCGl16E+l3GjIrINVvNvpIBpmBi2dw+X9liq55I/lpCgGu2hvDoCvfR1RlL1mr8Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163968; c=relaxed/simple;
	bh=YlelWltdBvgpM47l8K0wV8oazfcGYaTegfnOlEbSMg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO4+EKAKmhpQLU5KliImCVPqJhNJvoxbAKuiE00mqcSxEvt4gVZleltGUGP64ouoWDjUEy97mxFJi0pYk7WWS6IK3axxIoL/k+5GGGbsbToszmZXE8VWDWmhNGZj9Z+S+jj5aWrrnWAeyk5ZHmb8gg9TcPtDTwIUIgy29fOnMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAE0rO26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAE0rO26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677121F00893;
	Sat, 30 May 2026 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163967;
	bh=nkzcDhs+zu8hukBu2APrOArs1ZM1IMsUd6Ob5kkKg4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAE0rO26sFDfrDI2yPtdU8mYYUGBt9KlwpYPkDnPvxY8LzzU5cAh2/wYZtUfX7F+q
	 MwcV9z3l1e1im/e50h0NvwSIeMkx8sii/b0oomfTM3WmWrPcn+Kb201VhVmp6PlvZB
	 Enm749TCojuoIKWKOu2lNSs2mb/Qnv7jEnYOByZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 415/776] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
Date: Sat, 30 May 2026 18:02:09 +0200
Message-ID: <20260530160251.202959824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1dfd95bdf4d18d263aa8fad06bfb9f4d9c992b18 ]

Drop packets if their ttl/hl is too small for forwarding.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fwd_netdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7730409f6f091..09aff403884b5 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -113,6 +113,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		iph = ip_hdr(skb);
+		if (iph->ttl <= 1) {
+			verdict = NF_DROP;
+			goto out;
+		}
+
 		ip_decrease_ttl(iph);
 		neigh_table = NEIGH_ARP_TABLE;
 		break;
@@ -129,6 +134,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		ip6h = ipv6_hdr(skb);
+		if (ip6h->hop_limit <= 1) {
+			verdict = NF_DROP;
+			goto out;
+		}
+
 		ip6h->hop_limit--;
 		neigh_table = NEIGH_ND_TABLE;
 		break;
-- 
2.53.0



