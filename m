Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0E531F9AE;
	Wed, 20 May 2026 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294804; cv=none; b=d+MI2r66VpMqThukvwfeDpteOLql39Dsyg62rhxCQ2DO3R/6X/n+GfzaFiox+u/j6JQ++U875ZxxbgePgvOTg/jYIE0/khDsnW1v3w4rq9eR6q1X40CbSA5NtbEEMWp/U0U43MbleEgZxk8XfsE+5ZvfVUe4H5GesbrVV5WNzQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294804; c=relaxed/simple;
	bh=8FOeMiciDDkHM/oMlL+OEKFvWXAzAoQADOv267TrkLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sacmEt5OySxpF7T5XhrzT8F7W1lo6uoPaPpBMu3upUrzWqf2pFQXGJ61QzWMNo5xtnzsQpLFotpJFyZC70+62zkeHIBNsis5ju75dPAIWjHbkq6mpi5bB4CbZxzjSKnujG+BTyDHSNmQd/bb7GoBK3kC5fZKQwk5aTQfgJIPZ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG210Vy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG210Vy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A8B1F000E9;
	Wed, 20 May 2026 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294803;
	bh=92vqLonM1jXBsjvbAwS9oFfwNIzKeqYNGM8/tacsQFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BG210Vy7miwITcqjkUWuoEDpFNU49OmLYFfr2ItLYh2PZ0DCHsjOSsxpm1skVZe3q
	 gWmG7A9FOWm6uWN5xEvdGBVFz3BwOG4mVYbLPF0GGZL4xBgqDJ7GL0t5OIbqxoY++3
	 ORGjZJuM1xFuhsoBqBHeenKi51NeyIqU4ctIkqm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0179/1146] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
Date: Wed, 20 May 2026 18:07:09 +0200
Message-ID: <20260520162152.332128419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



