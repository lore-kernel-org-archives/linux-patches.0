Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79511AF0AF;
	Mon,  9 Feb 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647624; cv=none; b=g5Z8ZUUEB5QhvUl1Eflv/5tGKwWbax5qQMk39LFZY0Jm49L95vKVbowhVadgYMD7GCxr6+CZuG1du576fw2K2KwUiRYmwDSdG+vtc/27m/d27cQh45/4CsmussgM+ZplA9oDhgM0Huggsh+RVgdI2vdcEzn4TN93tYkv9QMIa+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647624; c=relaxed/simple;
	bh=+ay1AvA4TogwB2pnuk+mZXvQbJ/SOh2hVRQZLBEPiN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFOaD7X68BD4EoKD8UWwJ7mMq7kyG3rM39OUzEuyfGe9k9JF4YKt8bwAM78HGwYnkIbskRJpny4PF6A6/ZEHzR9fwB/IlurRiWB4ljXQPbGBQzuVWRS1DYdBcvPQMZ8hwwh3hJRkuom/LHoehGPB7T8SVmScWL7wIJ0ruxqJQho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2unqeNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2unqeNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABACC116C6;
	Mon,  9 Feb 2026 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647624;
	bh=+ay1AvA4TogwB2pnuk+mZXvQbJ/SOh2hVRQZLBEPiN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2unqeNryX7sZJe8dHkcK85iuvZZwK/Z96RKn+uDbxlVvHTAHdJKtEfO+qfYv9BOQ
	 UrFYwCOTaCp5qStVIBNhtePHBSDkRD5fjYbEhTxUJQzaJVmn/aR+lTddlwdH4gAyPH
	 Z5rMhL4mbpcWcIq1Rs2nLSE3JviE/dCG5mhQGw2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Fasano <andrew.fasano@nist.gov>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/175] netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()
Date: Mon,  9 Feb 2026 15:23:47 +0100
Message-ID: <20260209142326.036670828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Andrew Fasano <andrew.fasano@nist.gov>

[ Upstream commit f41c5d151078c5348271ffaf8e7410d96f2d82f8 ]

nft_map_catchall_activate() has an inverted element activity check
compared to its non-catchall counterpart nft_mapelem_activate() and
compared to what is logically required.

nft_map_catchall_activate() is called from the abort path to re-activate
catchall map elements that were deactivated during a failed transaction.
It should skip elements that are already active (they don't need
re-activation) and process elements that are inactive (they need to be
restored). Instead, the current code does the opposite: it skips inactive
elements and processes active ones.

Compare the non-catchall activate callback, which is correct:

  nft_mapelem_activate():
    if (nft_set_elem_active(ext, iter->genmask))
        return 0;   /* skip active, process inactive */

With the buggy catchall version:

  nft_map_catchall_activate():
    if (!nft_set_elem_active(ext, genmask))
        continue;   /* skip inactive, process active */

The consequence is that when a DELSET operation is aborted,
nft_setelem_data_activate() is never called for the catchall element.
For NFT_GOTO verdict elements, this means nft_data_hold() is never
called to restore the chain->use reference count. Each abort cycle
permanently decrements chain->use. Once chain->use reaches zero,
DELCHAIN succeeds and frees the chain while catchall verdict elements
still reference it, resulting in a use-after-free.

This is exploitable for local privilege escalation from an unprivileged
user via user namespaces + nftables on distributions that enable
CONFIG_USER_NS and CONFIG_NF_TABLES.

Fix by removing the negation so the check matches nft_mapelem_activate():
skip active elements, process inactive ones.

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Andrew Fasano <andrew.fasano@nist.gov>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3cbf2573b9e90..6059a299004d4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5917,7 +5917,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_set_elem_active(ext, genmask))
+		if (nft_set_elem_active(ext, genmask))
 			continue;
 
 		nft_clear(ctx->net, ext);
-- 
2.51.0



