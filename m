Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF3E44E025;
	Tue, 16 Jun 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625474; cv=none; b=JXjwxHA+L8W1IMZu/TdwAW2rITYKD8POhIlkfDiRIDdne4ZbRtdl917AemSA2iYXyUFB765Uw3jhaoCzCei/Tfb/MwmW5ZuQy3lQ2TnBowdoxzWbudP/9ztCfo41y46pdKbqd3SVJkdEe1shSCjaHxYVI3wCIAuS7zgmN6y39A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625474; c=relaxed/simple;
	bh=uXV0m8L06y7udZsKNSLHWJ4yQ3+WOv5S8wG7hWva1BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWKud0sKgXBcszxsTr4QkR7uBuGC6yqR7FrhWRV3coBi5FnUMR3H7HojgtXyEApRVVdjFXujVX7kYqaBdSVozHCwnt4gpvnLLa+NufvxWIZROELLRORBL4wRtQIZsyJsFeLEtSgUCDH19XKIfDKonSHScmL2YejLHhSyQ5gHstE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ys7X0do; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ys7X0do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FF1F000E9;
	Tue, 16 Jun 2026 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625473;
	bh=lPKm3HDwhsxZwFmv9gyhKrSM6dqGmhTBFAxM1RnlXuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ys7X0doqFeuOwfFpiFe5oep7EG+AJWd+lpZ0tmmGZGAdX5/7o3GtarIymtJUg26j
	 c3mG+AhBdSOGM+Yr0i1f2pj6qyNezxImad5ovSKCX4cZv4u00GfaGJElbrNfhVt3cl
	 3Ab8jnPKZ5uMprfWHrLy18kpYGHojz7IDhrOhHKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 148/325] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
Date: Tue, 16 Jun 2026 20:29:04 +0530
Message-ID: <20260616145105.092681738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ornaghi <d.ornaghi97@gmail.com>

commit c7d573551f9286100a055ef696cde6af54549677 upstream.

NFT_META_BRI_IIFHWADDR declares its destination register with
len = ETH_ALEN (6 bytes), which the register-init tracking rounds up to
two 32-bit registers (8 bytes). nft_meta_bridge_get_eval() then does
memcpy(dest, br_dev->dev_addr, ETH_ALEN), writing only 6 bytes and
leaving the upper 2 bytes of the second register as uninitialised
nft_do_chain() stack. A downstream load of that register span leaks
those stale bytes to userspace.

Zero the second register before the memcpy so the full declared span is
written.

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 7763e78abb00..219c40680260 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -64,6 +64,8 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev)
 			goto err;
 
+		/* ETH_ALEN (6) is shorter than the destination register span (8) */
+		dest[1] = 0;
 		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
 		return;
 	default:
-- 
2.54.0



