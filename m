Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D9F248BD1;
	Wed, 15 Jan 2025 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938670; cv=none; b=iSfohj/6fcPEbGHeMMhGfhotWycX9AOBEjdAiCAd4YzcchU2pxfiQMVt+vNkoQSP5IAxVJ3zphr2p2YzWJOmtoIL5cJSypLKbBZ36UdUbsCCvAg2mzih8XAHH4HfEjrl1zYG6CWE1ihz1cz8/fWxpkjwpJ783o4qqzpxWP4479M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938670; c=relaxed/simple;
	bh=hKvbN5MIvKKmPEN9c+cJHxZxSFrEcAfTK29P16C6UdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu2Odr8WdAdPWgOx2GX/lxGIrQf0vRlWtrG1vuz00vgyepho1CbPlol+oSsWUKFrXgqODOIffBg2aNjWAEdOyLBdJkRrUtNS9zdIkNJGzNEfdlmUry8G2dkaMVqECTGlRI0irm5ZbFaaUQt5r8GmVA7FyjLZhgybpOah3H3OXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap7I9zhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap7I9zhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816EEC4CEDF;
	Wed, 15 Jan 2025 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938670;
	bh=hKvbN5MIvKKmPEN9c+cJHxZxSFrEcAfTK29P16C6UdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap7I9zhDE3MnPJOzpNvq9L9YgSEnSiE8+rgA7Fh59UukzV92dhzFytaXOcQowD8cx
	 oYLCb7Q1rkS3xaUy0oa4eF/9DFwz4zrjFWYuH6YJiJc5neRnv97HAKQHfNU+iYrU/p
	 PT+aDCmoBsUKQlD1WEs/RViD/ufK41UFZqet3kww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/129] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
Date: Wed, 15 Jan 2025 11:36:58 +0100
Message-ID: <20250115103556.092986178@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b541ba7d1f5a5b7b3e2e22dc9e40e18a7d6dbc13 ]

Use INT_MAX as maximum size for the conntrack hashtable. Otherwise, it
is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof() when
resizing hashtable because __GFP_NOWARN is unset. See:

  0708a0afe291 ("mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls")

Note: hashtable resize is only possible from init_netns.

Fixes: 9cc1c73ad666 ("netfilter: conntrack: avoid integer overflow when resizing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e4ae2a08da6a..34ad5975fbf3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2568,12 +2568,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	struct hlist_nulls_head *hash;
 	unsigned int nr_slots, i;
 
-	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
+	if (*sizep > (INT_MAX / sizeof(struct hlist_nulls_head)))
 		return NULL;
 
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
+	if (nr_slots > (INT_MAX / sizeof(struct hlist_nulls_head)))
+		return NULL;
+
 	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
 
 	if (hash && nulls)
-- 
2.39.5



