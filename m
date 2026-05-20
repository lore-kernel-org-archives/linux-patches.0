Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2E343880;
	Wed, 20 May 2026 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301902; cv=none; b=gV8L28mXFOIyPCHyA07O5sXI0o2kYceGVhMoUM1hmeKSRas1dzve2vvW179e/kJqnRchmCiTYB9A+ORFOcwa7+SRRSREk8/V6C1uhvbVOTyIY5OTKPxr3bWr6RN7obBh41OLjRd6gYqwulfuJ7hAdtBonQhbbIVYJu3n6tLtp18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301902; c=relaxed/simple;
	bh=0nbZ9XSFOFNpet022DvFvf6iyl6D76I1BNHr/5FwEkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msnU/CnjkgwZ/bYY2xEkjgtfli70lUC2tLSeKvVybmalMiaYCXeOxfWha4dboBzgMvRygESW1/jmY4xvxt99qAge0uOs1AEu6Iddgb5gDtw0tm0MA3R/hJ3X4yeciqgBIPMy8E3ZRge3d6u5+9efzH5utQtIDzyG48VfNxygWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgHYmBrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgHYmBrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9341F000E9;
	Wed, 20 May 2026 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301901;
	bh=tlcp4Bob/gk8bLzKcX5Uuskm1tOYoiYgL0/Q15TAjFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgHYmBrcOPlAch5dr7AIEPj3SxxtKkqbEiSdC8NbhH+EFtoPMXJg0DtDgNIG/vKtC
	 hh1EmI8gXGJq/u9/nNskutFUmIEtUXu/N4Zm52myy52XIVq+YuhXr5YbbvMO/UiOZv
	 Tr29gLzdfqqBbJAqeGZvtCLhu9KBbxo3HNlYRdMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/508] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
Date: Wed, 20 May 2026 18:18:05 +0200
Message-ID: <20260520162059.944554349@linuxfoundation.org>
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
index 42ba31dfc0359..1223bdea1f00d 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -116,6 +116,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
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
@@ -132,6 +137,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
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



