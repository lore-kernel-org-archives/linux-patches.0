Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB4B3FB05A;
	Wed, 20 May 2026 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300302; cv=none; b=HRSqxTo+Q1xzbJQ+IKbaiIYy9cICJKUAwiFhgQF8nqdmWTV/aiujySrLkY4IyWor/EOFCw+v+8+tsz5vwOEYABtvYFJuE3PuxgQ6B72Nk7q58AKiG24XyEA2U773lORQ18paF6WdVdQWpeoUftZLUQwzaWrUHTQqRNz4m1M+cJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300302; c=relaxed/simple;
	bh=FFCp6D53JdbuySBbgaBvNH8LJRQzuXRJhAT3RKqnnTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrghvLHiyARzL+V1RHaoh976iUcdb83U35Vb3rQVdaOO87pvzJA+eSp9dKulkqK4olrAm1wUIiG/TLTZF6uB5KEtThoZUKkPLo+hZvEtbmyoBo0Wn/ndCCy87BVAYH5N1vpOdoKiDd6SX6OBxCoVi/MsIS+xLgYxysnwjLqtBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2kHAra5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2kHAra5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FAF1F000E9;
	Wed, 20 May 2026 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300301;
	bh=jvu8TUcAgh5seokudOG8tzppI0TQYdcC95gKPg3UVOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2kHAra5lk2iPw6yM1aK0Ix7VddNU8ug6kNA1aXgmeGcBYl9mbB8E9WlQ/l+J6USG
	 lImsOxwXoQTd5vBvhifBO+GqZyw2oIs4L4yJnI+YFbwdk03jSJEXe+Df1ARwHng6HC
	 XCNgU25x+N/6WrOlySn0Yhfg2gTO2DL4teLhmYns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/666] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
Date: Wed, 20 May 2026 18:14:52 +0200
Message-ID: <20260520162112.987419077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 152a9fb4d23af..256e832f1bb99 100644
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



