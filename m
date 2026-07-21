Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0693F46D2B3;
	Tue, 21 Jul 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653725; cv=none; b=jIcbRZOjXtMEgKLUiJAzhYCSnHEo1315mq0bpBn3G8hkOITOE5+fnlJOzCfYM2AYGZ+QW/YlLoIIwWfcG5ALbfq2ESuyo+dklt2loQlZwfF4a0xuMyEh70BNxnC2K4/aNsx5A7saUzGzE207V34kUcrWjkDnpZKxevfTWiX8WDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653725; c=relaxed/simple;
	bh=dO/jgrh6aI+GB1986o2T8ROM6kzM99ZjllkjE/4EN2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IugbhqnMJxfPG5szBdaFdjlhW5a3fqCEXax8fHmDsa+6V3e4nD+NTDPTUEHeRIWH/mbDooUalUEm0i6226Qfyj06sf74tYrh6hWA6Yks2d7ZNhjGZzp+cslw7M6U7g0Ri3aCbxsQlKVU74O+uBnhVd6Tqj+ZhV9HTQHlq55aTGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNoHh9XN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNoHh9XN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE3A1F000E9;
	Tue, 21 Jul 2026 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653723;
	bh=HJ3tLecn584ky64KaA/q9Cv5q5bCkPF7b6VOUbqNZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNoHh9XNBSmfS9VMTa/S8oO2HmazABcDF5jW5ubg1xmR7bu7irGqvAbm5tq8P0gFI
	 /2hrFarQSZbeo1Aa3yfP6bh/SuxB2KJAacOhCAoRJjYnKdgXqi7/+rcvNvsqxl+Q6Z
	 gUjU7owp0et3CQLz4TXxSRTHJpRozwDN5ma/vfhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1428/2077] netfilter: nft_set_rbtree: get command skips end element with open interval
Date: Tue, 21 Jul 2026 17:18:21 +0200
Message-ID: <20260721152626.489679492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d63611cbe8af99dd61b118ee6e5b5e3e518250b2 ]

The get command on intervals provide partial matches such as subranges
for usability reasons. However, an open interval has no closing end
element. If the closing element matches within the range of the open
internal, ie. its closest match is the start element of the open range,
then, return 0 but offer no matching element to userspace through
netlink as a special case. Userspace provides at least a matching start
element in this case and the closing end element matching the open
interal is ignored.

Another possibility is to report the matching start element of the open
interval for this end interval. However, this results in duplicated
matching being listed in userspace because userspace does not expect a
start element as response to a end element.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c  | 3 +++
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87387adbca655f..e1db3e678656da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6559,6 +6559,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (!elem.priv)
+		return 0;
+
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 560fbe6e3f7502..b4b67f48ad64e2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -184,10 +184,14 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (!interval || nft_set_elem_expired(interval->from))
 		return ERR_PTR(-ENOENT);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+		if (!interval->to)
+			return NULL;
+
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
-	else
+	} else {
 		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+	}
 
 	return &rbe->priv;
 }
-- 
2.53.0



