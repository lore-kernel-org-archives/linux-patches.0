Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC173563E1;
	Sat, 17 Oct 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256487; cv=none; b=T0gre3iMm68DJiIAgaZO5q6LFSbA2fBAEJ067VxV1YHwXW0HGiV2grQzcpfQ/az04C20wc9OlQr7JY4oe4hlUYZLxG7UTZ1d6NwLxxGT6QKVzyjTDi25n2ey4gVx3WRuh0Lya5fKHlSqZKM/hwpRaSNruoHJtCvSTPKQpEUtVNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256487; c=relaxed/simple;
	bh=rq6wxYHb2ft9mQmen7+x7jcYQ4FQEsZ2hL6ykWbb+Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywkri8Aq0NFoOhCsg9e9OEyRA1SxbSON++IOzLv2TY+rCkrluZZzVtF/Um15exeWwkQQdBLv1wAdqmxfBjZ47DyQEVlM51SZU1Ji05hNO7qocz2tJRtFkQ16zmi+pQCrt2dTnu3UsULqK4yQwLjz8XtimuzRO82mvQ/+imvw4uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fnyhaet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fnyhaet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1D81F000C4;
	Sat, 17 Oct 2026 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256486;
	bh=HWOUALv8KYycaV9PBgnRlMhtWcvQ937j2HDg/R0HyGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fnyhaetll9gtczilvp7cIxeRIoWaC+UJ1PI1TkVkVTYEPBAsUDGmgrHLiEaI9Fd6
	 v70aTehWKI4M2RfM5tSgI5XUPExnzK2ipxg2ikgHyk2kyQTwLQfVxQ6ytrjuJA33Lt
	 otZp/HOMMPIxQmXef8zTxeVzrPw9W5lt2EipClbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0209/1674] netfilter: ipset: do not update comments from kernel-side adds
Date: Sat, 17 Oct 2026 17:41:21 +0200
Message-ID: <20261017160436.514223010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit a442c8a89fb9c531f9d6ab86120c31decd778d51 ]

'Fixes' commit stopped calling ip_set_init_comment() for hash types
from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:

   "The kadt functions don't use the comment extensions in any way."

But bitmap set type calls the function from kadt cb too.

While this appears to be safe (serialized via the set spinlock), it seems
better to not call the init function either, least of all to keep
behaviour consistent.

ip_set_list calls ip_set_init_comment() only from uadt cb, it can be
kept as-is.

This was triggered by yet another LLM review, hinting that the existing
rcu_dereference_protected() cannot be downgraded to only check if the
nfnl mutex is held.

Fixes: f30415929be8 ("netfilter: ipset: do not update comments from kernel-side hash adds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 605d54d2bd7e6..3dc2ebbe4800c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -157,7 +157,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
-- 
2.53.0



