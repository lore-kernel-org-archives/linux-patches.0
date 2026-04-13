Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0CD313298;
	Mon, 13 Apr 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098835; cv=none; b=qAOEM9/K/Npg+K+i+BzLTPIDKG86xP07Bt6/6aT2bwZS49GY9DPzL1DLZgkVcRAvrJ/X0coH91FmVBj5+pnOKhoG3WrQjBBO4HrYUzdP3xtfqBrEpVa1tAs4/dsPMQSR7/Hd+ruh9Q85sH7GdDFLoDvUDNq5QuKVbDNCoebVMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098835; c=relaxed/simple;
	bh=8vAHkTGCLJWRTIU4iMqwwJLPH1ek5DuSoNk0zrKtG0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXYqoQSl0H4rszjew4uC7ALFt9dgpvMN3LPfKAvLo1b1m9Zz1v/BhCn48qU7QShioVvwHe73rFomt71bMGuoWt7f74/ujF1DJon5iiZsxGGJfHCn4Ilf26JFbI7fE1kRU4M9LFsBhovAjMcy9J2WsjahQrp2ry/hXGo86hpoWSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adD0WTEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adD0WTEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C70C2BCAF;
	Mon, 13 Apr 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098835;
	bh=8vAHkTGCLJWRTIU4iMqwwJLPH1ek5DuSoNk0zrKtG0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adD0WTEvs6hIMoygTowpQeg59SZ3ySo2VRCi84+/8Uplx5hc9XKeF6BWzVJ6GISPl
	 JM6Sv+5gV8ZXTYHntTp2+ubpBIixLQkUhUGpVMcs4J3OwJXbSc3swX9RpIGp6nmu8/
	 hx9eRwP28dLh4l/WeSgMQjcbYq7RyFkxNIFYG38w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/491] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
Date: Mon, 13 Apr 2026 17:55:20 +0200
Message-ID: <20260413155821.854486636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a4fdd1587bb3b..07a8369a9f02f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1539,6 +1539,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 	int i;
 
 	nft_pipapo_for_each_field(f, i, m) {
+		bool last = i == m->field_count - 1;
 		int g;
 
 		for (g = 0; g < f->groups; g++) {
@@ -1558,7 +1559,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 		}
 
 		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
-			     rulemap[i + 1].n, i == m->field_count - 1);
+			     last ? 0 : rulemap[i + 1].n, last);
 		if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
 			/* We can ignore this, a failure to shrink tables down
 			 * doesn't make tables invalid.
-- 
2.51.0



