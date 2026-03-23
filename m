Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A0E344D99;
	Mon, 23 Mar 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282496; cv=none; b=fsVP6yRnG7QZPH3XDCOiFibeD1kuoEtCoaypbzD7vX80LbuWSgLdwES75nTI3s3fuUPeMRHTe8qNSp47I62M7qrvJTAV7I3zfsJRNtKiDFFiFiW2Rcjas29cGufKkNCBn3SEJnNc4zTtaeMR0v7XTZA71QbzrDaVLwQyhq45pEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282496; c=relaxed/simple;
	bh=plqNyhSxwjZz3NRwU4nZiQDYu2TtCtfm5JXuCiWB5f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y18AkzjZpZfFp7mKJbglOU8e/1y97Jnkx2WRf8b3fqvGREv2VSvXai3gNNUhKT1+tyXXRFf4ZT7moM+uITet2ojHo7vg0eY15HlKBvG9LB/+APcmIRhub497YxWEBaTQWF7To7t5H3xMXT3u6qMBfSSmWa5+/MefTk5wrUXMb2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epOtG6Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epOtG6Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5AFC4CEF7;
	Mon, 23 Mar 2026 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282496;
	bh=plqNyhSxwjZz3NRwU4nZiQDYu2TtCtfm5JXuCiWB5f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epOtG6DtKco2ULxWwdpmdqHiOswPSrxJizQO9ayQNsBia89rKxM6XB+plNefv1Hxy
	 CAYz8pJjrjtd1YZWTBxvGGyqJz6lnAp1S7H25EdwBsSV6L3XR8AhukDF9k2iY5sW/+
	 wLG816QP2AUDSDSUomgB+ogsKVFtyfYKtAWyxbjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/481] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
Date: Mon, 23 Mar 2026 14:42:38 +0100
Message-ID: <20260323134529.504588680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit d6d8cd2db236a9dd13dbc2d05843b3445cc964b5 ]

pipapo_drop() passes rulemap[i + 1].n to pipapo_unmap() as the
to_offset argument on every iteration, including the last one where
i == m->field_count - 1. This reads one element past the end of the
stack-allocated rulemap array (declared as rulemap[NFT_PIPAPO_MAX_FIELDS]
with NFT_PIPAPO_MAX_FIELDS == 16).

Although pipapo_unmap() returns early when is_last is true without
using the to_offset value, the argument is evaluated at the call site
before the function body executes, making this a genuine out-of-bounds
stack read confirmed by KASAN:

  BUG: KASAN: stack-out-of-bounds in pipapo_drop+0x50c/0x57c [nf_tables]
  Read of size 4 at addr ffff8000810e71a4

  This frame has 1 object:
   [32, 160) 'rulemap'

  The buggy address is at offset 164 -- exactly 4 bytes past the end
  of the rulemap array.

Pass 0 instead of rulemap[i + 1].n on the last iteration to avoid
the out-of-bounds read.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 863162c823306..c8a5618742381 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1541,6 +1541,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 	int i;
 
 	nft_pipapo_for_each_field(f, i, m) {
+		bool last = i == m->field_count - 1;
 		int g;
 
 		for (g = 0; g < f->groups; g++) {
@@ -1560,7 +1561,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 		}
 
 		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
-			     rulemap[i + 1].n, i == m->field_count - 1);
+			     last ? 0 : rulemap[i + 1].n, last);
 		if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
 			/* We can ignore this, a failure to shrink tables down
 			 * doesn't make tables invalid.
-- 
2.51.0



