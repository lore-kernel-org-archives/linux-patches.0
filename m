Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AFE22301;
	Mon,  9 Feb 2026 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648276; cv=none; b=hRy8LFTQQ8MGicE+Xoxsp72jTHITl15bofu+JUho//dgBMTERDVi88FIY5yqfPaLKw3YENHZcNZKzP5fYtHRvx9y46TorylJYCOF20DkkTnfrFwSSO3WyXCbS66sfbeWu3q/RB34HuGf5354gvAuMwCPzZVGKGKaXQ1UaZcW4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648276; c=relaxed/simple;
	bh=DzjOcv3FPJO2KNWsbipDrl0u+FiEP7T2ob5y99MpzKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqv2AAAjKxfdOgn+Af2a0663pumYseL0k3gxzmoISiDPn2laGr/ivSPh/JoBFxjovgYN2DJ+qxBW9OW87uF1MO3NeDuIdMETTT2V+fs1EzOE2FWv+hozAUi3pYnhjHn6FVvOWB5H6W31pl4ioBWaCtmNeA1RM1oiBRpA0p+nnGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NCxhg9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NCxhg9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593AEC116C6;
	Mon,  9 Feb 2026 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648275;
	bh=DzjOcv3FPJO2KNWsbipDrl0u+FiEP7T2ob5y99MpzKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NCxhg9WA0lUPPjAbyPXz6EGgx043SaeMSsG/V74p4Nbm4BRNkYOYpeXkyMUJ8D1G
	 eCHdAP/RY3GtRpzErXh+1G0CtFfj81Rf39WlxnVjWnfRrHo3U4uKltwErk6SfKTAaj
	 6Nm2BKNsi2vVlRXaWfyxH0/cNtNhU6eJ+TUoLog0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Fasano <andrew.fasano@nist.gov>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/69] netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()
Date: Mon,  9 Feb 2026 15:24:26 +0100
Message-ID: <20260209142304.012181189@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d154e3e0c9803..67729d7c913a4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5211,7 +5211,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_set_elem_active(ext, genmask))
+		if (nft_set_elem_active(ext, genmask))
 			continue;
 
 		elem.priv = catchall->elem;
-- 
2.51.0



